Rails.application.routes.draw do
  get :switch_user, :to => 'switch_user#set_current_user'
  get 'switch_user/remember_user', :to => 'switch_user#remember_user'
end
