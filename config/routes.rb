if Rails.version =~ /^3/
  Rails.application.routes.draw do
    match 'switch_user' => 'switch_user#set_current_user'
    match 'switch_back' => 'switch_user#set_original_user'
  end
end