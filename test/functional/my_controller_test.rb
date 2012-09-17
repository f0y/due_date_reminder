require File.dirname(__FILE__) + '/../test_helper'
require 'my_controller'

# Re-raise errors caught by the controller.
class MyController;
  def rescue_action(e)
    raise e
  end
end

class MyControllerTest < ActionController::TestCase
  include Redmine::I18n

  context "my controller" do
    setup do
      @user = User.new(:firstname => 'Ivan', :lastname => 'Ivanov', :mail => 'ivan@example.net',
                       :status => User::STATUS_ACTIVE, :reminder_notification => '1,3,5')
      @user.login = 'ivan'
      @user.admin = true
      @user.save!
      @controller = MyController.new
      @request = ActionController::TestRequest.new
      @request.session[:user_id] = @user.id
      @response = ActionController::TestResponse.new
    end

    should "save reminder notification settings" do
      post :account, :user => {
          :reminder_notification => '1,2,3,4'
      }
      assert_equal User.find(@user.id), assigns(:user)
      assert_equal '1,2,3,4', User.find(@user.id).reminder_notification
    end

    should "render input field for default notification setting" do
      @user.update_attributes!(:reminder_notification => nil)
      Setting.plugin_due_date_reminder = {'reminder_notification' => '1,2,9'}
      get :account
      assert_tag :input, :attributes => {:name => 'user[reminder_notification]', :value => '1,2,9'}
    end

    should "render input field for user notification setting" do
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
        assert_equal 'Ivan', @user.firstname
      end
    end

    should "internationalize text_comma_separated" do
      get :account
      assert_tag :tag => "label", :attributes => {:for => 'text_comma_separated'}, :content => l(:text_comma_separated)
    end

  end
end