require File.dirname(__FILE__) + '/../test_helper'

class ReminderMailerTest < ActiveSupport::TestCase
  fixtures :users, :issues, :projects, :issue_statuses

  should "return active users" do
    #mail_data = ReminderMailer.eval_mail_data
  end
end