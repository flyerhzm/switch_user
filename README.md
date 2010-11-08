switch_user
===========

Inspired from hobo, switch_user provides a convenient way to switch current user that speed up your development.

switch_user promises that it only be activated in the development environment.

It supports only devise now, but it will support authlogic in the future.

Example
-------

Visit here: [http://switch-user-example.heroku.com/][0], switch the current user in the select box.

Install
-------

Add in Gemfile.

    gem "switch_user", "~> 0.1.0"

Usage
-----

Add following code into your layout page.

    = switch_user_select


Copyright © 2010 Richard Huang (flyerhzm@gmail.com), released under the MIT license

[0]: http://switch-user-example.heroku.com/

