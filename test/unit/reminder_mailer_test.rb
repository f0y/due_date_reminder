require File.dirname(__FILE__) + '/../test_helper'

class ReminderMailerTest < ActiveSupport::TestCase
  fixtures :users, :issues, :projects, :issue_statuses

  setup do
    issue = Issue.find(6)
    issue.assigned_to = User.find(1)
    issue.save
  end

  should "not remind if issue has no assignee" do
    assert !ReminderMailer.remind?(Issue.find(1))
  end

  should "remind in given day" do
    Reminder::SettingPatch.default_reminder_notification = '1,3,5'
    assert ReminderMailer.remind?(Issue.find(6))
  end

  should "not remind in other days" do
    Reminder::SettingPatch.default_reminder_notification = '3'
    assert !ReminderMailer.remind?(Issue.find(6))
  end

  should "return active users" do
    mail_data = ReminderMailer.eval_mail_data
  end
end