require File.dirname(__FILE__) + '/../test_helper'
# Get fixtures from plugin directory
Fixtures.create_fixtures(File.dirname(__FILE__) + '/../fixtures', 'users')

class FixturesTest < ActiveSupport::TestCase
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
end