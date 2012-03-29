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