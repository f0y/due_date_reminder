require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/models/reminder_mailer'

class ReminderMailerTest < ActiveSupport::TestCase

  context "reminder mailer" do

    setup do
      Mailer.perform_deliveries = false
      begin
        Issue.find(3).delete
      rescue
      end
      user = User.new(:firstname => 'Ivan', :lastname => 'Ivanov', :mail => 'ivan@example.net',
                      :status => User::STATUS_ACTIVE, :reminder_notification => '1,3')
      user.login = 'ivan'
      user.save!
      user2 = User.new(:firstname => 'Petr', :lastname => 'Petrovich', :mail => 'petr@example.net',
                       :status => User::STATUS_ACTIVE, :reminder_notification => '5,9')
      user2.login = 'petr'
      user2.save!

      inactive_user = User.new(:firstname => 'Alex', :lastname => 'Alexandrov', :mail => 'alex@example.net',
                               :status => User::STATUS_LOCKED)
      inactive_user.login = 'alex'
      inactive_user.save!

      project = Project.create!(:identifier => 'firstproject', :name => 'First Project')
      project2 = Project.create!(:identifier => 'secondproject', :name => 'Second Project')
      archived_project = Project.create!(:identifier => 'archivedproject', :name => 'Archived Project')
      archived_project.archive

      # ---- These issues should not be included in result ----

      # Active project, overdue issue but INACTIVE USER
      Issue.create!(:assigned_to => inactive_user, :subject => 'subject10', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 1.day.ago)

      # Active user, overdue issue but ARCHIVED PROJECT
      Issue.create!(:assigned_to => user, :subject => 'subject11', :project => archived_project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 1.day.ago)

      # Active user, active project but CLOSED ISSUE
      closed_issue = Issue.new(:assigned_to => user, :subject => 'subject12', :project => project,
                               :tracker => Tracker.find(1), :author => user, :due_date => 1.day.ago)
      closed_issue.status = IssueStatus.find(5)
      closed_issue.save!

      # Active user, active project but NO DUE DATE
      Issue.create!(:assigned_to => user, :subject => 'subject13', :project => project,
                    :tracker => Tracker.find(1), :author => user)

      # Active user, active project but NOT NOTIFICATION DAY
      Issue.create!(:assigned_to => user, :subject => 'subject14', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 2.days.from_now)

      # Active user, active project but DUE DATE IS TODAY
      Issue.create!(:assigned_to => user, :subject => 'subject15', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => Date.today)
      # Active project, overdue date but NO ASSIGNEE
      Issue.create!(:subject => 'subject16', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 2.days.ago)


      # ---- These issues should be included in result ----

      # Issues for first user
      Issue.create!(:assigned_to => user, :subject => 'subject4', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 1.day.from_now)

      Issue.create!(:assigned_to => user, :subject => 'subject5', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 3.day.from_now)

      Issue.create!(:assigned_to => user, :subject => 'subject3', :project => project,
                    :tracker => Tracker.find(1), :author => user, :due_date => 1.day.ago)

      Issue.create!(:assigned_to => user, :subject => 'subject1', :project => project2,
                    :tracker => Tracker.find(1), :author => user, :due_date => 3.day.ago)

      #Issues for second user
      Issue.create!(:assigned_to => user2, :subject => 'subject7', :project => project2,
                    :tracker => Tracker.find(1), :author => user2, :due_date => 9.days.from_now)

      Issue.create!(:assigned_to => user2, :subject => 'subject6', :project => project2,
                    :tracker => Tracker.find(1), :author => user2, :due_date => 5.days.from_now)

      Issue.create!(:assigned_to => user2, :subject => 'subject0', :project => project2,
                    :tracker => Tracker.find(1), :author => user2, :due_date => 5.day.ago)

      Issue.create!(:assigned_to => user2, :subject => 'subject2', :project => project2,
                    :tracker => Tracker.find(1), :author => user2, :due_date => 2.day.ago)

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
      Mailer.perform_deliveries = true
      Mailer.deliveries = []
      ReminderMailer.send_due_date_notifications
      assert_equal 2, Mailer.deliveries.size

    end

    should "raise exception if no e-mail configuration presented" do
      Mailer.perform_deliveries = false
      assert_raise NoMailConfiguration do
        ReminderMailer.send_due_date_notifications
      end
    end

  end
end