require 'spec_helper'

describe User do
  fixtures :roles, :users
  
  before(:each) do
    @valid_attributes = {
      :login => 'testuser',
      :email => 'testmail@example.com',
      :password => 'test21',
      :password_confirmation => 'test21'
    }

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  it "should be in passive state after creation" do
    user = User.new(:login => 'test')
    user.state.should == "passive"
  end

  it "should receive a notification email after registration" do
    user = User.new(@valid_attributes)
    user.register!
    user.state.should == "pending"
    user.perishable_token.should_not be_empty
    @emails.size.should == 1
    mail = @emails.first
    mail.to[0].should == 'testmail@example.com'
    mail.subject.should == '[BaseApp] Please activate your new account'
    mail.body.should =~ /baseapp.local\/activate\/#{user.perishable_token}/
  end
  
  it "should have got a default role and empty profile after registration" do
    user = User.new(@valid_attributes)
    user.register!
    user.profile.should_not be_nil
    user.roles.collect(&:name).include?(DEFAULT_USER_ROLE).should be_true
  end
  
  it "should receive a notification email after activation" do
    user = users(:marc)
    user.activate!
    user.state.should == "active"
    @emails.size.should == 1
    mail = @emails.first
    mail.to[0].should == user.email
    mail.subject.should == '[BaseApp] Your account has been activated!'
  end
  
  describe "display name" do
    
    before(:each) do
      @user = User.new(@valid_attributes)
      @user.register!
    end
    
    it "should be the login name if the profile is empty" do
      @user.display_name.should == 'testuser'
    end
    
    it "should be the realname if no nickname is set" do
      @user.profile.real_name = 'Test User'
      @user.display_name.should == 'Test User'
    end
    
    it "should be the nickname if at least the nickname is set" do
      @user.profile.nick_name = 'nick'
      @user.profile.real_name = 'Test User'
      @user.display_name.should == 'nick'
    end
        
  end
  
end
