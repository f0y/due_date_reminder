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
  include Redmine::I18n

  context "my controller" do
    setup do
      @controller = MyController.new
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = 10
      @response = ActionController::TestResponse.new
    end

    should "save reminder notification settings" do
      post :account, :user => {
               :reminder_notification => '1,2,3,4'
           }
      user = User.find(10)
      assert_equal user, assigns(:user)
      assert_equal '1,2,3,4', user.reminder_notification
    end

    should "render input field for reminder notification setting" do
      get :account
      assert_tag :input, :attributes => {:name => 'user[reminder_notification]', :value => '1,3,5'}
    end

    context "incorrect user input" do

      setup do
        post :account, :user => {
                 :firstname => 'new_name',
                 :reminder_notification => 'invalid'}
      end

      should "send error message to view" do
        assert_equal l(:error_reminder_notification_input), flash[:error]
      end

      should "not save new user attributes" do
        user = User.find(10)
        assert_equal 'Ivan', user.firstname
      end
    end

  end
end