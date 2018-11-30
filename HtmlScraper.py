#!/home/ops_worker/work/python/venv2/bin/python
import sys, json, csv, urllib2, datetime
from bs4 import BeautifulSoup as BS


# generalized Time-Warner scraper for grabbing a CSV file of schedule data
# from the Time-Warner website. Takes a network name as an argument.


def build_output_path(station, print_day):
    base_path = '/net/netapp1.pdx.rentrak.com/vol/vol_na1_secureshared_cifs/shares/linear ops/'
    base_path += 'schedule tracking/Direct Customer Distribution/Web Scraped Schedules/'    # for PRODUCTION
    # base_path += 'bdl/schedule-scrape/'                  # for TEST
    base_path += station
    if station == 'willow' or station == 'fido' or station == 'life-ok':
        base_path += '-tv'
    base_path += '/'
    outname = base_path + print_day + '_' + station + '_' + datetime.datetime.today().strftime('%H%M') + '.csv'
    return outname


def get_page_source(url):
    try:
        req = urllib2.Request(url)
        res = urllib2.urlopen(req)
        return res.read()
    except:
        print "Unable to make page-request/return results."
        return 0


def build_url(station, delay=None):
    base_url = 'http://tv.twcc.com/listings/'
    url = base_url + station
    if station == 'willow' or station == 'fido':
        url += '-tv'
    elif station == 'life-ok':
        url = url[:-7]
        url += 'star-one-us'
    if delay:
        url += ('?offset=' + str(delay))
    return url


def scrape_schedule(station, day_offset=None):
    start_times = []
    titles = []
    episodes = []
    descriptions = []
    header = ['date','airtime','series/show','episode','description']

    print_day = datetime.datetime.today().strftime('%Y%m%d')
    out_fname = build_output_path(station, print_day)     # for PRODUCTION
    out = open(out_fname, 'w')                            # for PRODUCTION
    # out = sys.stdout                                      # for TEST
    wrt = csv.writer(out, delimiter=',',quoting=csv.QUOTE_ALL)
    wrt.writerow(header)

    previous_row = header

    # put this in a loop so 2 days of schedule can be written
    for x in range(day_offset, day_offset + 2):
        del start_times[:]
        del titles[:]
        del episodes[:]
        del descriptions[:]

        url = build_url(station, x)
        contents = get_page_source(url)
        if not contents:
            return 0

        soup = BS(contents, 'html.parser')

        sched_date = soup.find_all('b', { 'class' : 'scheduleDate' })[0].string
        timestamps = soup.find_all('div', { 'class' : 'time-col' })
        title_divs = soup.find_all('div', { 'class' : 'title-synopsis-col' })

        # build date
        day = datetime.datetime.strptime(sched_date, '%A, %B %d, %Y')

        # get time-stamps
        for item in timestamps:
            time = item.contents[0].strip('\n').strip()
            start_times.append(time)

        # get title, episode/description
        for item in title_divs:
            if len(item) == 1:
                t = item.contents[0]
                episodes.append('-')
                descriptions.append('-')
            else:
                t = item.contents[1].string.encode('utf-8')
                ep = item.contents[2].string.strip('\n').encode('utf-8')
                if len(item) > 3:
                    description = item.contents[3].string.strip('\n').encode('utf-8')
                    if description:
                        descriptions.append(description)
                        episodes.append(ep)
                    else:
                        episodes.append('--')
                        descriptions.append(ep)
                else:
                    episodes.append('---')
                    descriptions.append(ep)
            titles.append(t)

        # write to csv: date, air_time, title, episode/description
        if len(start_times) == len(titles) and len(titles) == len(episodes):
            for i in range(1, len(start_times)):
                if start_times[i] == 'Time':
                    day = day + datetime.timedelta(days=1)
                    continue
                row = [str(day)[:10], start_times[i], titles[i], episodes[i], descriptions[i]]

                if row[0] == previous_row[0] and row[1] == previous_row[1]:
                    continue            # don't print duplicates

                previous_row = row
                wrt.writerow(row)
                # print row

    out.close()                                         # for PRODUCTION
    return out_fname                                    # for PRODUCTION
    # return 1


def get_schedules(argv):
    delay = 1
    if len(argv) > 1:
        stations = argv[1:]
    else:
        # TEST with these stations
        # stations = ['willow-tv', 'fido-tv', 'star-one-us']
        stations = ['willow-tv', 'boomerang']
    for station in stations:
        outputs = scrape_schedule(station, delay)

        # for PRODUCTION
        if outputs:
            print outputs + ' written.'
        else:
            print 'Unable to write schedule for ' + station



def main(argv):
    get_schedules(argv)


if __name__ == '__main__':
    main(sys.argv)
