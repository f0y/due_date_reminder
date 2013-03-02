require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/models/reminder_mailer'

class ReminderMailerTest < ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods

  context "reminder mailer" do

    setup do
      ActionMailer::Base.perform_deliveries = false
      user = create(:user, :reminder_notification => '1,3')
      user2 = create(:user, :reminder_notification => '5,9')
      inactive_user = create(:user, :status => User::STATUS_LOCKED)
      project = create(:project)
      project2 = create(:project)
      archived_project = create(:project)
      archived_project.archive

      # ---- These issues should not be included in result ----

      # Active project, overdue issue but INACTIVE USER
      test = create(:issue, :assigned_to => inactive_user, :subject => 'subject10', :project => project,
             :author => user, :due_date => 1.day.ago)

      # Active user, overdue issue but ARCHIVED PROJECT
      create(:issue, :assigned_to => user, :subject => 'subject11', :project => archived_project,
             :due_date => 1.day.ago)

      # Active user, active project but CLOSED ISSUE
      closed_issue = create(:issue, :assigned_to => user, :subject => 'subject12', :project => project,
                            :due_date => 1.day.ago, :status => create(:issue_status, :is_closed => true))

      # Active user, active project but NO DUE DATE
      create(:issue, :assigned_to => user, :subject => 'subject13', :project => project,)

      # Active user, active project but NOT NOTIFICATION DAY
      create(:issue, :assigned_to => user, :subject => 'subject14', :project => project,
             :due_date => 2.days.from_now)

      # Active user, active project but DUE DATE IS TODAY
      create(:issue, :assigned_to => user, :subject => 'subject15', :project => project,
             :due_date => Date.today)
      # Active project, overdue date but NO ASSIGNEE
      create(:issue, :subject => 'subject16', :project => project,
             :due_date => 2.days.ago)


      # ---- These issues should be included in result ----

      # Issues for first user
      create(:issue, :assigned_to => user, :subject => 'subject4', :project => project,
             :due_date => 1.day.from_now)

      create(:issue, :assigned_to => user, :subject => 'subject5', :project => project,
             :due_date => 3.day.from_now)

      create(:issue, :assigned_to => user, :subject => 'subject3', :project => project,
             :due_date => 1.day.ago)

      create(:issue, :assigned_to => user, :subject => 'subject1', :project => project2,
             :due_date => 3.day.ago)

      #Issues for second user
      create(:issue, :assigned_to => user2, :subject => 'subject7', :project => project2,
             :due_date => 9.days.from_now)

      create(:issue, :assigned_to => user2, :subject => 'subject6', :project => project2,
             :due_date => 5.days.from_now)

      create(:issue, :assigned_to => user2, :subject => 'subject0', :project => project2,
             :due_date => 5.day.ago)

      create(:issue, :assigned_to => user2, :subject => 'subject2', :project => project2,
             :due_date => 2.day.ago)
    end

    should "return issues" do

      issues = ReminderMailer.find_issues
      issues.each { |issue| assert_match /^subject\d$/, issue.subject }
      assert_equal 8, issues.count
    end

    should "return issues in valid order" do
      issues = ReminderMailer.find_issues
      issues.each_with_index { |issue, index| assert_match /^subject#{index}$/, issue.subject }
    end

    should "send mails to users" do
      #Test fails because of invalid e-mail configuration

      ActionMailer::Base.deliveries.clear
      ActionMailer::Base.perform_deliveries = true
      ReminderMailer.due_date_notifications
      assert_equal 2, ActionMailer::Base.deliveries.size
    end

    should "raise exception if e-mail delivery is not configured" do
      ActionMailer::Base.perform_deliveries = false
      assert_raise NoMailConfiguration do
        ReminderMailer.due_date_notifications
      end
    end

  end
end