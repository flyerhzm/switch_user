# TODO can this be writting once so that it is rails3 and rails4 compatible?
if Rails.version =~ /^3/
  Rails.application.routes.draw do
    match 'switch_user' => 'switch_user#set_current_user'
    match 'switch_user/remember_user' => 'switch_user#remember_user'
  end
elsif Rails.version =~ /^4/
  Rails.application.routes.draw do
    get :switch_user, :to => 'switch_user#set_current_user'
    get 'switch_user/remember_user', :to => 'switch_user#remember_user'
  end
end
