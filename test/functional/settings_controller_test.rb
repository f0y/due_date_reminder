require File.dirname(__FILE__) + '/../test_helper'
require 'settings_controller'

# Re-raise errors caught by the controller.
class SettingsController;
  def rescue_action(e)
    raise e
  end
end

class SettingsControllerTest < ActionController::TestCase
  include Redmine::I18n

  context "settings controller" do

    setup do
      @user = User.new(:firstname => 'Ivan', :lastname => 'Ivanov', :mail => 'ivan@example.net',
                       :status => User::STATUS_ACTIVE, :reminder_notification => '1,3,5')
      @user.login = 'ivan'
      @user.admin = true
      @user.save!
      @controller = SettingsController.new
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      @request.session[:user_id] = @user.id
      Setting.clear_cache
    end

    should "render settings view" do
      get :plugin, :id => 'due_date_reminder'
      assert :success
      assert_template 'plugin'
    end


    should "render notification settings" do
      Setting.plugin_due_date_reminder = {'reminder_notification' => '1,2,3'}
      get :plugin, :id => 'due_date_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_notification]", :value => '1,2,3'}
    end

    should "render author notification" do
      Setting.plugin_due_date_reminder = {'reminder_author_notification' => true}
      get :plugin, :id => 'due_date_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_author_notification]", :value => true}
    end


    should "render default notification settings" do
      get :plugin, :id => 'due_date_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_notification]", :value => '1,3,5'}
    end

    should "render default author notification settings" do
      get :plugin, :id => 'due_date_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_author_notification]", :value => true}
    end

    should "save new notification value" do
      Setting.plugin_due_date_reminder = {'reminder_notification' => '1,2,3'}
      post :plugin, :id => 'due_date_reminder', :settings => {:reminder_notification => '1'}
      assert_equal '1', Setting.plugin_due_date_reminder['reminder_notification']
    end

    should "not be an error if reminder_notification does not present" do
      post :plugin, :id => 'due_date_reminder', :settings => {:reminder_author_notification => false}
      assert_nil flash[:error]
    end

    should "save new author notification value" do
      Setting.plugin_due_date_reminder = {'reminder_author_notification' => true}
      post :plugin, :id => 'due_date_reminder', :settings => {:reminder_author_notification => false}
      assert_equal false, Setting.plugin_due_date_reminder['reminder_author_notification']
    end

    context "incorrect user input" do

      setup do
        Setting.plugin_due_date_reminder = {'reminder_notification' => '1,2,3'}
        post :plugin, :id => 'due_date_reminder', :settings => {:reminder_notification => 'invalid'}
      end

      should "send error message to view" do
        assert_equal l(:error_reminder_notification_input), flash[:error]
      end

      should "not save new value" do
        assert_equal '1,2,3', Setting.plugin_due_date_reminder['reminder_notification']
      end
    end
  end

end