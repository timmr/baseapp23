require 'spec_helper'


describe User do
  fixtures :roles
  
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

  it "should send a notification email after registration" do
    user = User.new(@valid_attributes)
    user.valid?.should be true
    user.register!
    user.state.should == "pending"
    @emails.size.should == 1
    mail = @emails.first
    mail.to[0].should == 'testmail@example.com'
    mail.subject.should == '[BaseApp] Please activate your new account'
  end
  
end
