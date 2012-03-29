require 'redmine'

Redmine::Plugin.register :redmine_reminder do
  name 'Redmine Reminder plugin'
  author 'Oleg Kandaurov'
  description 'Sends notifications about due date'
  version '0.0.1'
  url 'https://github.com/f0y/redmine_reminder'
  author_url 'http://okandaurov.info'
end
