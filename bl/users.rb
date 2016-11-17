$users = $mongo.collection('users')

LOGIN_ERRORS = {NOT_REGISTERED_ERROR: "sorry, you have not registered with us yet. we got your email and we'll get in touch with you to register.
In the meanwhile, you can look at this adorable kitten, leave us more info at Contact Us  or email sella@rafaeli.net",
EMAIL_NOT_SENT: "couldn't send email, please try again", 
NO_EMAIL: "didnt find user with that email, request again",
NO_TOKEN: "token has expired, request again",
}

#<a href='http://localhost:9090/contact'>contact us page</a>


get '/u/:username' do
  post = $posts.get(username: params[:username])
  user = $users.get(username: params[:username])
  to_page :'users/userpage', locals: {user: user}
end

get '/register' do 
  to_page(:'users/register')
end

#http://localhost:9090/login_from_link?email=lily.matveyeva@gmail.com&token=0b22e797-39e4-4473-9026-4fd2957e0021
get "/login_from_link" do
#require_params email and token
	require_fields(['email', 'token'])
	user = $users.get(email: params[:email])
	if !user
		redirect "/login?error=#{LOGIN_ERRORS[:NO_EMAIL]}"
		return {error: LOGIN_ERRORS[:NO_EMAIL]} 
	end
	if user[:token] == params[:token]
		session[:user_id] = user['_id']
		redirect "/"
	else
	 	redirect "/login?error=#{LOGIN_ERRORS[:NO_TOKEN]}"
	 	# return {error: LOGIN_ERRORS[:NO_TOKEN]}
	end 

end




post '/login' do 
	email =  params[:email]
	user = $users.get(email: email)
	return {error: LOGIN_ERRORS[:NOT_REGISTERED_ERROR]} if !user
	token = SecureRandom.uuid 
	# TODO - SAVE IT IN REDIS
	#BCrypt::Password.new() possibly later - compare
	#BCrypt::Password.create possibly later - create 
	# create a token for user, and send him email with this token. return success.
	return {error: LOGIN_ERRORS[:EMAIL_NOT_SENT]}  if !send_entry_link_mail(email, token)
	user = $users.update_id(user[:_id], {token: token})
	{success: true}
end

get '/login' do 
  to_page(:'users/login')
end


get '/logout' do
  session.clear
  redirect '/'
end



get '/me' do
	require_user
  to_page(:'users/me')
end

post '/update_user' do
	user_params = params.just(:email, :first_name, :last_name, :desc, :username)
	user = $users.update_id(cuid, user_params)
	{user: user}
end

post '/register' do 
  #return false #should be available only for admin 
  user_params = params.just(:email, :first_name, :last_name, :desc)
  user_params[:username] =  get_unique_slug($users, :username, params[:email].split("@").first)
  user = $users.add(user_params)
  session[:user_id] = user['_id']
  {user: user}
end
