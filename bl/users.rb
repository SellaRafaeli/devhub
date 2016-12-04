$users = $mongo.collection('users')

$sella = $users.get(email: 'sella.rafaeli@gmail.com')

get '/set_sella_token' do 
  $users.update_id($sella['_id'], {token: params[:token]})
end

get '/sella' do
  {user: $users.get(email: 'sella.rafaeli@gmail.com')}
end
namespace '/users' do

  post '/register' do
    require_fields(['email','name'])
    name, email = params[:name], params[:email]
    #halt(401, {msg: 'User exists. Try login.'}) if $users.exists?(email: email)
    user = $users.get(email: email)
    if !user
      user = $users.add(email: email, name: name, token: guid)    
    end
    send_entry_link_email(user)
    {msg: 'ok'}
  end

  post '/request_signin_link' do 
    require_fields(['email'])
    bp
    user = $users.get(email: params[:email])
    halt(401, {msg: 'No such user'}) if !user
    user = $users.update_id(user['_id'], {token: guid}) #new token
    send_entry_link_email(user)
    {msg: 'ok'}
  end

  post '/login' do 
    require_fields(['token'])
    user      = $users.get(token: params[:token])
    new_token = guid
    if (user)
      $users.update_id(user['_id'], {token: new_token})
      {user: map_user(user), token: new_token}
    else 
      halt(401,{msg: 'No such user'})
    end
  end

  # post '/force_login' do 
  #   email = params[:email]  
  #   if (user = $users.get(email: email))
  #     $users.update_id(user[:_id],{token: guid})
  #     {user: user}
  #   else 
  #     user = $users.add(email: email, token: guid)
  #     {user: user}
  #   end
  # end

end # end /users

def map_user(u)
  u ||= {}
  u = u.just(:_id, :name, :email)
  u
end