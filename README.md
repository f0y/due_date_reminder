# Due Date Reminder plugin for Redmine [![Build Status](https://travis-ci.org/f0y/due_date_reminder.png?branch=redmine-2.x)](https://travis-ci.org/f0y/due_date_reminder)

Plugin for Redmine project that sends notification to assignee if due date is coming.

Users can choose on which days before due date they want to be notified.
This setting is located at the user account page.
![User settings](https://github.com/f0y/due_date_reminder/raw/redmine-2.x/doc/user_settings.png)

Moreover, administrator can set default notification settings for new users.
![Default settings](https://github.com/f0y/due_date_reminder/raw/redmine-2.x/doc/default_settings.png)

Plugin also sends info about issues behind a schedule.
Users cannot change this behavior.

http://www.redmine.org/plugins/due_date_reminder

## Compatibility

There are a few versions of the plugin:
* redmine-1.3 for Redmine 1.3.x
* redmine-1.4 for Redmine 1.4.x
* redmine-2.x for Redmine 2.0 and higher

## Installation

    cd /home/user/path_to_you_app/
    git clone git://github.com/f0y/due_date_reminder.git plugins/due_date_reminder
    cd plugins/due_date_reminder; git checkout <YOUR BRANCH HERE - see above>

For Redmine 1.3.x and Redmine 1.4.x

    bundle exec rake db:migrate_plugins RAILS_ENV=production

For Redmine 2.x and higher

    bundle exec rake redmine:plugins:migrate RAILS_ENV=production

Also you can read instructions on http://www.redmine.org/projects/redmine/wiki/Plugins

## Sending notifications
You can send notifications manually:

    cd /home/user/path_to_you_app
    bundle exec rake redmine:reminder_plugin:send_notifications RAILS_ENV=production

It is good idea to add the task to cron:

    crontab -e
    0 5 * * * cd /home/user/path_to_you_app && bundle exec rake redmine:reminder_plugin:send_notifications RAILS_ENV=production &> /tmp/redmine_due_date_reminder.log

Learn more about cron at http://en.wikipedia.org/wiki/Cron

You should run this task *only* *once* *a* *day*.

## License

This plugin is licensed under the GPLv2 license.
