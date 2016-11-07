$users = $mongo.collection('users')

get '/u/:username' do
  post = $posts.get(username: params[:username])
  to_page :'users/user_page', locals: {cu: cu}
end


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

post '/update_user' do
	user_params = params.just(:email, :first_name, :last_name, :desc, :username)
	user = $users.update_id(cuid, user_params)
	{user: user}
end

post '/register' do 
  return false #should be just for admin 
  user_params = params.just(:email, :first_name, :last_name, :desc)
  user_params[:username] =  get_unique_slug($users, :username, params[:email].split("@").first)
  user = $users.add(user_params)
  session[:user_id] = user['_id']
  {user: user}
end
