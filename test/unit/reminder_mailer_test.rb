require File.dirname(__FILE__) + '/../test_helper'

class ReminderMailerTest < ActiveSupport::TestCase
  fixtures :users

  context "custom fixtures" do

    should "not found an user defined in redmine fixture" do
      assert_raise ActiveRecord::RecordNotFound do
        User.find(1)
      end
    end

    should "find an user defined in plugin fixtures" do
      assert_equal 'Ivan', User.find(10).firstname
    end

  end

  context "reminder settings" do
    setup do
      Reminder::SettingPatch.default_reminder_notification = '1,2,3,4'
    end

    should "return setting explicitly defined for user" do
      assert_equal '1,3,5', User.find(10).reminder_notification
    end

    should "convert settings to integer array" do
      assert_equal [1, 3, 5], User.find(10).reminder_notification_array
    end

    should "return default settings" do
      assert_equal '1,2,3,4', Setting.reminder_notification
    end

    should "return default settings for user" do
      assert_equal '1,2,3,4', User.find(11).reminder_notification
    end

  end

  context "user" do
    should "include reminder notification to user safe attributes" do
      assert_contains User.find(10).safe_attribute_names, 'reminder_notification'
    end

    context "validation of reminder notification" do

      should "not be valid" do
        assert !(User.valid_reminder_notification? "test")
      end

      should "be valid" do
        assert User.valid_reminder_notification? "1,2,33, 2,1  , 23"
      end
    end

  end

  should "perform simple test" do
    expected =
        [
            {
                :user => 'admin',
                :projects => [
                    {
                        :project => 2,
                        :issues => [1, 2, 3]
                    },
                    {
                        :project => 3,
                        :issues => [5, 6, 7]
                    }

                ]
            }
        ]
    assert_equal(expected, ReminderMailer.eval_mail_data)
  end
end