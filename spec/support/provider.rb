shared_examples_for "a provider" do
  let(:user) { stub(:user) }

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

  it "knows if there are any users logged in" do
    provider.login(user)

    provider.current_users_without_scope.should == [user]
  end
end
