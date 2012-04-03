require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  should "include reminder notification to user safe attributes" do
    assert_contains User.find(1).safe_attribute_names, 'reminder_notification'
  end

  context "validation of reminder notification" do

    should "not be valid" do
      assert !(User.valid_reminder_notification? "test")
    end

    should "be valid" do
      assert User.valid_reminder_notification? "1,2,33, 2,1  , 23"
    end
  end

  context "reminder settings" do
    setup do
      user = User.find(1)
      user.reminder_notification='1,3,5'
      user.save!
    end

    should "return setting explicitly defined for user" do
      assert_equal '1,3,5', User.find(1).reminder_notification
    end

    should "convert settings to integer array" do
      assert_equal [1, 3, 5], User.find(1).reminder_notification_array
    end

    should "return default settings for user" do
      Setting.plugin_redmine_reminder  = {'reminder_notification' => '1,2,3,4,5'}
      assert_equal '1,2,3,4,5', User.find(2).reminder_notification
    end
  end
end
