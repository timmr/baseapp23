module MockUserHelper
  def mock_normal_user
    user = mock('User')
    
    user.stubs(:have_access? => true, :display_name => 'testuser')
    # not admin user
    user.stubs(:has_role?).with(:admin).returns(false)
    # but user
    user.stubs(:has_role?).with(:user).returns(true)
    
    return user
  end

  def mock_admin_user
    user = mock('User')
    # admin user has all roles
    user.stubs(:has_role? => true, :have_access? => true, :display_name => 'adminuser')
    return user
  end
end
