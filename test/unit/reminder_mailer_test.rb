require File.dirname(__FILE__) + '/../test_helper'

class ReminderMailerTest < ActiveSupport::TestCase
  fixtures :users

  def test_redmine_fixtures
    assert_raise ActiveRecord::RecordNotFound do
      User.find(1)
    end
  end

  def test_plugin_fixtures
    User.find(10)
  end

  def test_get_user_settings
    assert_equal '1,3,5', User.find(10).reminder_notification
    assert_equal [1,3,5], User.find(10).reminder_notification_array
  end

  def test_get_default_settings
    Reminder::SettingPatch.default_reminder_notification = '1,2,3,4'
    assert_equal '1,2,3,4', Setting.reminder_notification
  end

  def test_get_default_user_settings
    Reminder::SettingPatch.default_reminder_notification = '1,2,3,4'
    assert_equal '1,2,3,4', User.find(11).reminder_notification
  end


  def test_simple
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