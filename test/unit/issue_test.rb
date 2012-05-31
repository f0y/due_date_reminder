require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveRecord::TestCase
  fixtures :trackers, :projects, :projects_trackers

  context "issue" do
    setup do
      @user = User.new(:firstname => 'Ivan', :lastname => 'Ivanov', :mail => 'ivan@example.net',
                       :status => User::STATUS_ACTIVE, :reminder_notification => '1,3')
      @user.login = 'ivan'
      @user.save!
      @issue = Issue.create!(:assigned_to => @user, :subject => 'test', :project => Project.find(1),
                             :tracker => Tracker.find(1), :author => @user,
                             :due_date => 1.day.from_now.to_date.to_s(:db))
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
      @issue.update_attributes!(:due_date => 2.days.from_now.to_date.to_s(:db))
      assert !@issue.remind?
    end

    should "not remind if assignee is a group" do
      @issue.assigned_to = Group.create!(:lastname => "group")
      assert !@issue.remind?
    end

  end


end