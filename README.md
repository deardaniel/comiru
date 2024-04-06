# Challenge English calendar

If you have a few children using Benesse's Challenge English, it's a pain to have to login for each to check when the next lessons are. This script scrapes the upcoming lesson schedules for each child's account, and creates iCalendar output. You can set up a cron job to save to a web-accessible file, and subscribe to that file's URL from your calendar to keep live updates.

# Installing

* Check out this repository.
* Create a configuration file (`cp ce.yaml.sample ce.yaml`) and add your login information.
* Run `bundle install` to install dependencies.
* Run `ruby ce.rb` to generate iCalendar data.
* You can invoke `ce.sh` from cron (`crontab -e`) if you want to save the output to a web-accessible directory. Make to change the directory in `ce.sh` to the correct one. By default it assumes you are running from a directory in your home directory, and that a `public_html` directory exists in the home directory.
* If using iOS or macOS, you can subscribe to the URL of your iCalendar file to see live updates in your calendar. Only upcoming lessons are shown and past ones will not appear.
