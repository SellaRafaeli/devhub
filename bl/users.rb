$users = $mongo.collection('users')

get '/register' do 
  to_page(:'users/register')
end

get '/login' do 
  to_page(:'users/login')
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/me' do
  to_page(:'users/me')
end

post '/register' do
  user = params.just(:email, :password, :first_name, :last_name, :desc)
  user = $users.add(user)
  session[:user_id] = user['_id']
  # redirect '/'
end

