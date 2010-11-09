switch_user
===========

Inspired from [hobo][0], switch_user provides a convenient way to switch current user that speeds up your development, you don't waste your time to logout, login and input login or passowrd any more.

switch_user promises that it only be activated in the development environment.

It supports only devise now, but it will support authlogic in the future.

Example
-------

Visit here: [http://switch-user-example.heroku.com/][1], switch the current user in the select box.

Install
-------

Add in Gemfile.

    gem "switch_user"

Usage
-----

Add following code into your layout page.

erb

    <%= switch_user_select %>

haml

    = switch_user_select

Configuration
-------------

By default, you can switch between Guest and all users in users table.

But if you want to use different scope users in devise or you want to customize the users that can be switched, The following is the default configuration.

    # config/initializers/switch_user.rb
    SwitchUser.setup do |config|
      # provider may be :devise or :authologic
      config.provider = :devise

      # avaliable_users is a hash, 
      # key is the model name of user (:user, :admin, or any name you use), 
      # value is a block that return the users that can be switched.
      config.available_users = { :user => lambda { User.all } }

      # what field should be displayed on select box
      config.display_field = :email

      # controller_guard is a block, 
      # if it returns true, the request will continue, 
      # else the request will be refused and returns "Permission Denied"
      config.controller_guard = lambda { |current_user, request| Rails_env == "development" }

      # view_guard is a block, 
      # if it returns true, the switch user select box will be shown, 
      # else the select box will not be shown
      config.view_guard == lambda { |current_user, request| Rails.env == "development" }

      # redirect_path is a block, it returns which page will be redirected 
      # after switching a user.
      config.redirect_path = lambda { |request, params| '/' }
    end


Copyright © 2010 Richard Huang (flyerhzm@gmail.com), released under the MIT license

[0]: https://github.com/tablatom/hobo
[1]: http://switch-user-example.heroku.com/

