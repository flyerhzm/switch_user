shared_examples_for "a provider" do
  let(:user) { stub(:user) }
  let(:other_user) { stub(:other_user, :id => 101) }

  it "can log a user in" do
    provider.login(user)

    provider.current_user.should == user
  end

  it "can log a user out" do
    provider.login(user)

    provider.logout

    provider.current_user.should == nil
  end

  it "responds to login_exclusive" do
    provider.should respond_to(:login_exclusive)
  end

  it "responds to login_exclusive" do
    provider.should respond_to(:login_inclusive)
  end

  it "knows if there are any users logged in" do
    provider.login(user)

    provider.current_users_without_scope.should == [user]
  end

  it "can lock the original user, allowing us to change current_user" do
    provider.login(user)
    provider.remember_current_user(true)
    provider.login(other_user)

    provider.original_user.should == user
    provider.current_user.should == other_user
  end

  it "can forget the original_user" do
    provider.login(user)
    provider.remember_current_user(true)

    provider.original_user.should == user
    provider.remember_current_user(false)

    provider.original_user.should == nil
  end
end
