# -*- encoding: utf-8 -*-
require File.expand_path("../lib/switch_user/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "switch_user"
  s.version     = SwitchUser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Richard Huang", "Luke Cowell"]
  s.email       = ["flyerhzm@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/switch_user"
  s.summary     = "Easily switch current user to speed up development"
  s.description = "Easily switch current user to speed up development"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "switch_user"

  s.add_development_dependency "activesupport"
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "actionpack"
  s.add_development_dependency "railties"
  s.add_development_dependency "rspec-rails", "~> 2.11.0"
  s.add_development_dependency "tzinfo"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
