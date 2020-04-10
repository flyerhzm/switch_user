# switch_user

[![Build Status](https://secure.travis-ci.org/flyerhzm/switch_user.svg)](http://travis-ci.org/flyerhzm/switch_user)
[![AwesomeCode Status for flyerhzm/switch_user](https://awesomecode.io/projects/5f029f36-047b-4332-8405-9c7913b195bc/status)](https://awesomecode.io/repos/flyerhzm/switch_user)

Inspired from [hobo][0], switch_user provides a convenient way to switch current user without needing to log out and log in manually.

## Use Case

switch_user is very useful in such use cases

1. switch current users in development so that you don't waste your time to logout, login and input email (login) or password any more.

2. reproduce the user specified error on production. Sometimes the error is only raised for specified user, which is difficult to reproduce for developers, switch_user can help you reproduce it by login as that user.

## Example

Visit here: <http://switch-user-example.herokuapp.com/admin>, switch the current user in the select box.

And source code here: <https://github.com/flyerhzm/switch_user_example>

## Install

Add in Gemfile.
```ruby
gem "switch_user"
```

If you get the following error: **undefined method `before_action' for SwitchUserController:Class**, you are probably using an older version of Rails (<4). You can use this gem: https://github.com/pschambacher/rails3-before_action

## Usage

Add following code into your layout page.

erb

    <%= switch_user_select %>

or haml

    = switch_user_select

If you want to add a class or styles

    <%= switch_user_select class: 'special-select', styles: 'width: 220px' %>

    = switch_user_select class: 'special-select', styles: 'width: 220px'

If there are too many users (on production), the switch_user_select is not a good choice, you should call the switch user request by yourself.

    <%= link_to user.login, "/switch_user?scope_identifier=user_#{user.id}" %>
    <%= link_to admin.login, "/switch_user?scope_identifier=admin_#{admin.id}" %>

    = link_to user.login, "/switch_user?scope_identifier=user_#{user.id}"
    = link_to admin.login, "/switch_user?scope_identifier=admin_#{admin.id}"

If you have a wildcard route in your project, add a route before the wildcard route.
```ruby
# config/routes.rb
get 'switch_user', to: 'switch_user#set_current_user'
get 'switch_user/remember_user', to: 'switch_user#remember_user'
# wildcard route that will get
get ':id' => 'pages#show'
```
## Configuration

By default, you can switch between Guest and all users in users table, you don't need to do anything. The following is some of the more commonly used configuration options.
```ruby
SwitchUser.setup do |config|
  # provider may be :devise, :authlogic, :clearance, :restful_authentication, :sorcery, or {name: :devise, store_sign_in: true}
  config.provider = :devise

  # available_users is a hash,
  # key is the model name of user (:user, :admin, or any name you use),
  # value is a block that return the users that can be switched.
  config.available_users = { user: -> { User.all } } # use User.scoped instead for rails 3.2

  # available_users_identifiers is a hash,
  # keys in this hash should match a key in the available_users hash
  # value is the name of the identifying column to find by,
  # defaults to id
  # this hash is to allow you to specify a different column to
  # expose for instance a username on a User model instead of id
  config.available_users_identifiers = { user: :id }

  # available_users_names is a hash,
  # keys in this hash should match a key in the available_users hash
  # value is the column name which will be displayed in select box
  config.available_users_names = { user: :email }

  # controller_guard is a block,
  # if it returns true, the request will continue,
  # else the request will be refused and returns "Permission Denied"
  # if you switch from "admin" to user, the current_user param is "admin"
  config.controller_guard = ->(current_user, request) { Rails.env.development? }

  # view_guard is a block,
  # if it returns true, the switch user select box will be shown,
  # else the select box will not be shown
  # if you switch from admin to "user", the current_user param is "user"
  config.view_guard = ->(current_user, request)  { Rails.env.development? }

  # redirect_path is a block, it returns which page will be redirected
  # after switching a user.
  config.redirect_path = ->(request, params) { '/' }
end
```
If you need to override the default configuration, run <code>rails g switch_user:install</code> and a copy of the configuration file will be copied to <code>config/initializers/switch_user.rb</code> in your project.

If you want to switch both available users and available admins
```ruby
config.available_users = { :user => -> { User.available }, :admin => -> { Admin.available } }
```
If you want to use name column as the user identifier
```ruby
config.available_users_identifiers => { user: :name }
```
If you want to display the login field in switch user select box
```ruby
config.available_users_names = { user: :login }
```
If you only allow switching from admin to user in production environment
```ruby
config.controller_guard = ->(current_user, request) { Rails.env.production? && current_user.admin? }
```
If you only want to display switch user select box for admins in production environment
```ruby
config.view_guard = ->(current_user, request) { Rails.env.production? && current_user && current_user.admin? }
```
If you want to redirect user to "/dashboard" page
```ruby
config.redirect_path = ->(request, params) { "/dashboard" }
```
If you want to hide a 'Guest' item in the helper dropdown list
```ruby
config.helper_with_guest = false
```
## Switch Back
Sometimes you'll want to be able to switch to an unprivileged user and then back again. This can be especially useful in production when trying to reproduce a problem a user is having. The problem is that once you switch to that unprivileged user, you don't have a way to safely switch_back without knowing who the original user was. That's what this feature is for.

You will need to make the following modifications to your configuration:
```ruby
config.switch_back = true
config.controller_guard = ->(current_user, request, original_user) { current_user && current_user.admin? || original_user && original_user.super_admin? }
# Do something similar for the view_guard as well.
```
This example would allow an admin user to user switch_user, but would only let you switch back to another user if the original user was a super admin.

## Using SwitchUser with RSpec and Capybara

Add the following code to spec/support/switch_user.rb or spec/spec_helper.rb:

```ruby
require 'switch_user/rspec'
```

You can now write your specs like so :

```ruby
feature "Your feature", type: :feature do
  background do
    @user = User.make(email: 'user@example.com', password: 'password')
  end

  scenario "Your scenario" do
    switch_user @user
    # or
    # switch_user :user, @user.id

    visit '/'
  end
end
```

### How it works

Click the checkbox next to switch_user_select menu to remember that user for this session. Once this
has been checked, that user is passed in as the 3rd option to the view and controller guards.
This allows you to check against current_user as well as that original_user to see if the
switch_user action should be allowed.

### Warning

This feature should be used with extreme caution because of the security implications. This is especially true in a production environment.

## Contributing

#### Run tests

`bundle exec rspec spec`

## Credit

Copyright © 2010 - 2017 Richard Huang (flyerhzm@gmail.com), released under the MIT license

[0]: https://github.com/tablatom/hobo
