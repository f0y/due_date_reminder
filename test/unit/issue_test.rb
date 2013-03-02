require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveRecord::TestCase
  fixtures :trackers, :projects, :projects_trackers
  include FactoryGirl::Syntax::Methods

  context "issue" do
    setup do
      ActionMailer::Base.perform_deliveries = false
      @user = create(:user, :reminder_notification => '1,3')
      @issue = create(:issue, :assigned_to => @user, :due_date => 1.day.from_now)
    end

    should "calculate days before due date" do
      assert_equal 1, @issue.days_before_due_date
    end

    should "not remind if issue has no assignee" do
      @issue.update_attributes!(:assigned_to => nil)
      assert !@issue.remind?
    end

    should "remind in given day" do
      assert @issue.remind?
    end

    should "not remind in other days" do
      # Seems to be an issue with time zone
      @issue.update_attributes!(:due_date => 5.days.from_now.to_date.to_s(:db))
      assert !@issue.remind?
    end

    should "not remind if assignee is a group" do
      @issue.assigned_to = Group.create!(:lastname => "group")
      assert !@issue.remind?
    end

  end


end