require File.dirname(__FILE__) + '/../test_helper'

class IssueTest < ActiveRecord::TestCase
  fixtures  :issues

  should "calculate days before due date" do
    assert_equal 1, Issue.find(6).days_before_due_date
  end

end