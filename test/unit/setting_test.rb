require File.dirname(__FILE__) + '/../test_helper'
# Get fixtures from plugin directory
Fixtures.create_fixtures(File.dirname(__FILE__) + '/../fixtures', 'users')

class SettingTest < ActiveSupport::TestCase
  fixtures :users

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
end