require File.dirname(__FILE__) + '/../test_helper'

class ReminderMailerTest < ActiveSupport::TestCase

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