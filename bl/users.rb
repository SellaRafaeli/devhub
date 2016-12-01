$users = $mongo.collection('users')

namespace '/api/users' do

  post '/register' do
    require_fields(['email','name'])
    halt(401, {msg: 'User exists'}) if $users.exists(email: params[:email])
    $users.add(email: params[:email], token: guid, name: params[:name])
  end

  post '/force_login' do 
    email = params[:email]  
    if (user = $users.get(email: email))
      $users.update_id(user[:_id],{token: guid})
      {user: user}
    else 
      user = $users.add(email: email, token: guid)
      {user: user}
    end
  end

end # end /users