require 'mechanize'
require 'icalendar'
require 'yaml'

def login(mechanize, username, password)
  login_url = 'https://comiru.jp/IM_09/login'
  page = mechanize.get(login_url)
  form = page.form(:action=>login_url)
  form.field_with(:name=>'student_no').value = username
  form.field_with(:name=>'password').value = password
  form.submit
end


def get_lessons(mechanize, page)
  page.search('table')[1].search('tbody tr').map do |row|
    date = row.search('td')[0].text
    year, month, day = date.scan(/(\d{4})-(\d{2})-(\d{2})/).first.map(&:to_i)

    time = row.search('td')[1].text
    start_hour, start_min, end_hour, end_min = time.scan(/(\d\d):(\d\d) - (\d\d):(\d\d)/).first.map(&:to_i)

    {
      start_time: DateTime.new(year, month, day, start_hour, start_min),
      end_time:   DateTime.new(year, month, day, end_hour, end_min)
    }
  end
end

mechanize = Mechanize.new

kids = YAML.load_file('comiru.yaml')['kids']

cal = Icalendar::Calendar.new
cal.x_wr_calname = 'Comiru'

kids.each do |kid|
  page = login(mechanize, kid['username'], kid['password'])
  get_lessons(mechanize, page).each do |lesson|
    cal.event do |e|
      e.summary     = "#{kid['name']} Lego School"
      e.dtstart     = lesson[:start_time]
      e.dtend       = lesson[:end_time]
    end
  end
end

cal.publish

cal_string = cal.to_ical
puts cal_string
