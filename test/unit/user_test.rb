require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context "user" do

    setup do
      @user = User.new(:firstname => 'Ivan', :lastname => 'Ivanov', :mail => 'ivan@example.net',
                       :status => User::STATUS_ACTIVE, :reminder_notification => '1,3,5')
      @user.login = 'ivan'
      @user.save!
    end


    should "include reminder notification to user safe attributes" do
      assert_contains @user.safe_attribute_names, 'reminder_notification'
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

      should "return setting explicitly defined for user" do
        assert_equal '1,3,5', @user.reminder_notification
      end

      should "convert settings to integer array" do
        assert_equal [1, 3, 5], @user.reminder_notification_array
      end

      should "return default settings for user" do
        @user.update_attributes(:reminder_notification => nil)
        Setting.plugin_redmine_reminder = {'reminder_notification' => '1,2,3,4,5'}
        assert_equal '1,2,3,4,5', @user.reminder_notification
      end
    end

  end
end
