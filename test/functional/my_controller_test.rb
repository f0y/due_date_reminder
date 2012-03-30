require File.dirname(__FILE__) + '/../test_helper'
require 'my_controller'

# Re-raise errors caught by the controller.
class MyController;
  def rescue_action(e)
    raise e
  end
end

class MyControllerTest < ActionController::TestCase
  fixtures :users

  context "my controller" do
    setup do
      @controller = MyController.new
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 10
      @response = ActionController::TestResponse.new
    end

    should "save reminder notification settings" do
      post :account,
           :user => {
               :reminder_notification => 'test'
           }
      user = User.find(10)
      assert_equal user, assigns(:user)
      assert_equal "test", user.reminder_notification
    end
  end

end