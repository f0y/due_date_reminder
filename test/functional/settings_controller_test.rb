require File.dirname(__FILE__) + '/../test_helper'
require 'settings_controller'

# Re-raise errors caught by the controller.
class SettingsController;
  def rescue_action(e)
    raise e
  end
end

class SettingsControllerTest < ActionController::TestCase
  fixtures :users
  include Redmine::I18n

  context "settings controller" do

    setup do
      @controller = SettingsController.new
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      @request.session[:user_id] = 1 # admin
    end

    should "render settings view" do
      get :plugin, :id => 'redmine_reminder'
      assert :success
      assert_template 'plugin'
    end

    should "render notification settings" do
      Setting.plugin_redmine_reminder = {'reminder_notification' => '1,2,3'}
      get :plugin, :id => 'redmine_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_notification]", :value => '1,2,3'}
    end

    should "render default notification settings" do
      get :plugin, :id => 'redmine_reminder'
      assert_tag :input, :attributes => {:name => "settings[reminder_notification]", :value => '1,3,5'}
    end

    should "save new value" do
      Setting.plugin_redmine_reminder = {'reminder_notification' => '1,2,3'}
      post :plugin, :id => 'redmine_reminder', :settings => {:reminder_notification => '1'}
      assert_equal '1', Setting.plugin_redmine_reminder['reminder_notification']
    end

    context "incorrect user input" do

      setup do
        Setting.plugin_redmine_reminder = {'reminder_notification' => '1,2,3'}
        post :plugin, :id => 'redmine_reminder', :settings => {:reminder_notification => 'invalid'}
      end

      should "send error message to view" do
        assert_equal l(:error_reminder_notification_input), flash[:error]
      end

      should "not save new value" do
        assert_equal '1,2,3', Setting.plugin_redmine_reminder['reminder_notification']
      end
    end
  end

end