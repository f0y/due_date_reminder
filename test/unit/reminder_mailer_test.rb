require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/models/reminder_mailer'

class ReminderMailerTest < ActiveSupport::TestCase

  include FactoryGirl::Syntax::Methods

  context "reminder mailer" do

    setup do
      ActionMailer::Base.perform_deliveries = false
      user = create(:user, :reminder_notification => '1,3', :reminder_author_notification => false)
      user2 = create(:user, :reminder_notification => '5,9', :reminder_author_notification => false)
      user_author = create(:user, :reminder_notification => '1,4', :reminder_author_notification => true)
      inactive_user = create(:user, :status => User::STATUS_LOCKED)
      project = create(:project)
      project2 = create(:project)
      archived_project = create(:project)
      archived_project.archive

      # ---- These issues should not be included in result ----

      # Active user, overdue issue but ARCHIVED PROJECT
      create(:issue, :assigned_to => user, :subject => 'subject11', :project => archived_project,
             :author => user, :due_date => 1.day.ago)

      # Active user, active project but CLOSED ISSUE
      create(:issue, :assigned_to => user, :subject => 'subject12', :project => project,
             :author => user, :due_date => 1.day.ago, :status => create(:issue_status, :is_closed => true))

      # Active user, active project but NO DUE DATE
      create(:issue, :assigned_to => user, :subject => 'subject13', :project => project,)

      # Active user, active project but NOT NOTIFICATION DAY
      create(:issue, :assigned_to => user, :subject => 'subject14', :project => project,
             :author => user, :due_date => 2.days.from_now)

      # Active user, active project but DUE DATE IS TODAY
      create(:issue, :assigned_to => user, :subject => 'subject15', :project => project,
             :author => user, :due_date => Date.today)

      # Active project, overdue date, no assignee, BUT NOTIFICATIONS DISABLED
      create(:issue, :subject => 'subject16', :project => project,
             :author => user, :due_date => 2.days.ago)


      # ---- These issues should be included in result ----

      # Issues for first user
      create(:issue, :assigned_to => user, :subject => 'subject4', :project => project,
             :author => user, :due_date => 1.day.from_now)

      create(:issue, :assigned_to => user, :subject => 'subject5', :project => project,
             :author => user, :due_date => 3.days.from_now)

      create(:issue, :assigned_to => user, :subject => 'subject3', :project => project,
             :author => user, :due_date => 1.day.ago)

      create(:issue, :assigned_to => user, :subject => 'subject1', :project => project2,
             :author => user, :due_date => 3.days.ago)

      #Issues for second user
      create(:issue, :assigned_to => user2, :subject => 'subject7', :project => project2,
             :author => user, :due_date => 9.days.from_now)

      create(:issue, :assigned_to => user2, :subject => 'subject6', :project => project2,
             :author => user, :due_date => 5.days.from_now)

      create(:issue, :assigned_to => user2, :subject => 'subject0', :project => project2,
             :author => user, :due_date => 5.days.ago)

      create(:issue, :assigned_to => user2, :subject => 'subject2', :project => project2,
             :author => user, :due_date => 2.days.ago)

      #Issues for third user
      # Active project, overdue date, no assignee but AUTHOR PRESENT
      create(:issue, :subject => 'subject9', :project => project,
             :author => user_author, :due_date => 4.days.from_now)

      # Active project, overdue issue, inactive assignee, but AUTHOR ACTIVE
      create(:issue, :assigned_to => inactive_user, :subject => 'subject10', :project => project,
             :author => user_author, :due_date => 1.day.ago)

      # Active project, overdue issue, AUTHOR AND ASSIGNEE PRESENT
      create(:issue, :assigned_to => user, :subject => 'subject99', :project => project,
             :author => user_author, :due_date => 1.day.ago)

    end

    should "return issues" do
      data = ReminderMailer.build_issues
      #puts data
    end

    should "send mails to users" do
      ActionMailer::Base.deliveries.clear
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.raise_delivery_errors = false
      ReminderMailer.due_date_notifications
      #Mailer.deliveries.each do |mail|
      #  puts mail
      #end
      assert_equal 3, ActionMailer::Base.deliveries.size
    end

    should "raise exception if e-mail delivery is not configured" do
      ActionMailer::Base.perform_deliveries = false
      assert_raise NoMailConfiguration do
        ReminderMailer.due_date_notifications
      end
    end

  end
end