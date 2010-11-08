switch_user
===========

Inspired from hobo, switch_user provides a convenient way to switch current user that speed up your development, without logout, login and input login or passowrd.

switch_user promises that it only be activated in the development environment.

It supports only devise now, but it will support authlogic in the future.

Example
-------

Visit here: [http://switch-user-example.heroku.com/][0], switch the current user in the select box.

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

But if you want to use different scope users in devise or you want to customize the users that can be switched, you should do like this

    SwitchUser.setup do |config|
      # provider may be :devise or :authologic, but now we only support devise
      config.provider = :devise
      # avaliable_users is a hash, key is the scope of devise user, value is the proc that return the users that can be switched.
      config.available_users = { :user => lambda { User.all }, :admin => lambda { Admin.all } }
      # what field should be displayed on select box
      config.display_field = :email
    end


Copyright © 2010 Richard Huang (flyerhzm@gmail.com), released under the MIT license

[0]: http://switch-user-example.heroku.com/

