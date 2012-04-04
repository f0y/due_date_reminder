require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveRecord::TestCase
  fixtures  :issues, :users

  setup do
    issue = Issue.find(6)
    issue.assigned_to = User.find(1)
    issue.save
    Setting.clear_cache
  end

  should "calculate days before due date" do
    assert_equal 1, Issue.find(6).days_before_due_date
  end

  should "not remind if issue has no assignee" do
    assert !Issue.find(1).remind?
  end

  should "remind in given day" do
    Setting.plugin_redmine_reminder = {'reminder_notification' => '1,3,5'}
    assert Issue.find(6).remind?
  end

  should "not remind in other days" do
    Setting.plugin_redmine_reminder = {'reminder_notification' => '3'}
    assert !Issue.find(6).remind?
  end

end