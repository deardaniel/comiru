require 'mechanize'
require 'icalendar'
require 'yaml'

def login(mechanize, username, password)
  login_url = 'https://loginc.benesse.ne.jp/ce/login'
  page = mechanize.get(login_url)
  form = page.form(:name=>'login')
  form.field_with(:name=>'usr_name').value = username
  form.field_with(:name=>'usr_password').value = password
  form.submit
end


def get_lessons(mechanize, page)
  dates = page.search('.dataList dt')
  times = page.search('.dataList dd')
  dates.map.with_index do |date, i|
    month, day = date.text.scan(/(\d\d)\/(\d\d)/).first
    start_hour, start_min, end_hour, end_min = times[i].text.scan(/(\d\d):(\d\d)～(\d\d):(\d\d)/).first

    {
      start_time: DateTime.new(Date.today.year, month.to_i, day.to_i, start_hour.to_i, start_min.to_i),
      end_time:   DateTime.new(Date.today.year, month.to_i, day.to_i, end_hour.to_i, end_min.to_i)
    }
  end
end

mechanize = Mechanize.new

kids = YAML.load_file('ce.yaml')['kids']

cal = Icalendar::Calendar.new
cal.x_wr_calname = 'Challenge English'

kids.each do |kid|
  page = login(mechanize, kid['username'], kid['password'])
  get_lessons(mechanize, page).each do |lesson|
    cal.event do |e|
      e.summary     = "#{kid['name']} Challenge English"
      e.dtstart     = lesson[:start_time]
      e.dtend       = lesson[:end_time]
    end
  end
end

cal.publish

cal_string = cal.to_ical
puts cal_string
