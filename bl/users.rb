$users = $mongo.collection('users')

namespace '/users' do

  get '/' do
    $users.all
  end

  get '/me' do
    user
  end

  get '/:_id' do
    $users.get(params[:_id])
  end  

  post '/login' do
    user = $users.get(login_token: params[:login_token])
    user = $users.get(params[:_id]) if params[:_id]
    user
  end  

end # end /users


# get '/register' do 
#   to_page(:'users/register')
# end

# get '/login' do 
#   to_page(:'users/login')
# end

# get '/logout' do
#   session.clear
#   redirect '/'
# end

# get '/random_user' do
#   session[:user_id] = $users.random['_id']
#   redirect back
# end

# get '/me' do
#   to_page(:'users/me')
# end

# post '/update_user' do
# 	user_params = params.just(:email, :first_name, :last_name, :desc, :username)
# 	user = $users.update_id(cuid, user_params)
# 	{user: user}
# end

# post '/register' do 
#   return false #should be available only for admin 
#   user_params = params.just(:email, :first_name, :last_name, :desc)
#   user_params[:username] =  get_unique_slug($users, :username, params[:email].split("@").first)
#   user = $users.add(user_params)
#   session[:user_id] = user['_id']
#   {user: user}
# end
