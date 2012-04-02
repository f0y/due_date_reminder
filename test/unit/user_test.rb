require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

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
