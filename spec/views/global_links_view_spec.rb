require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../mock_user_helper')

describe "Global links" do
  include MockUserHelper
  
  def derived_controller_name(*args)
    "dashboard"
  end

  def derived_action_name(*args)
    "index"
  end
  
  before(:each) do
    template.stubs(:logged_in?).returns(true)
    template.stubs(:display_avatar).returns("")
  end
  
  describe "with normal user" do
  
    before(:each) do
      template.stubs(:current_user).returns(mock_normal_user)
    end
  
    it "should show the current user name" do   
      render 'shared/_global_links'
      response.should have_tag('strong','testuser')
    end
    
    it "should NOT show a link to the administration area" do   
      render 'shared/_global_links'
      response.should_not have_tag('a','Administration')
    end
    
    it "should show a dashboard link" do
      render 'shared/_global_links'
      response.should have_tag('a','Dashboard')
    end
    
    it "should show a logout link" do
      render 'shared/_global_links'
      response.should have_tag('a','Log out')
    end

  end
  
  describe "with admin user" do
  
    before(:each) do
      template.stubs(:current_user).returns(mock_admin_user)
    end
  
    it "should show a link to the administration area" do   
      render 'shared/_global_links'
      response.should have_tag('a','Administration')
    end
    
    it "should require an authenticated user for all actions"

  end
  
end
