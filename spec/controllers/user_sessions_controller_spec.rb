require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  include MockUserHelper
  fixtures :users
  
  def mock_user_session(stubs={})
    @mock_user_session ||= mock('UserSession')
  end
  
  setup :activate_authlogic

  it "should create a new user session" do
    UserSession.stubs(:new).returns(mock_user_session)
    get :new
    assigns[:user_session].should equal(mock_user_session)
  end

  it "should authenticate a valid user" do
    ben = users(:ben)
    assert_nil session["user_credentials"]
    post :create, :login => 'ben', :password => 'test'
    session["user_credentials"].should == ben.persistence_token
    response.should redirect_to(root_url)
  end

  it "should refuse an user with an invalid login" do
    post :create, :login => 'ben2', :password => 'test'
    session[:user_credentials].should be nil
    response.should_not be_redirect
    response.should render_template("new")
  end

  it "should refuse an user with an invalid password" do
    post :create, :login => 'ben', :password => 'wrong'
    session[:user_credentials].should be nil
    response.should_not be_redirect
    response.should render_template("new")
  end

  it "should refuse an user with not in active state" do
    post :create, :login => 'marc', :password => 'test'
    session[:user_credentials].should be nil
    response.should_not be_redirect
    response.should render_template("new")
  end

  it "should destroy the user session" do
    mock_session = mock('UserSession')
    UserSession.stubs(:find).returns(mock_session)
    mock_session.expects(:destroy)
    delete :destroy
    response.should redirect_to(new_user_session_url)
  end


end

