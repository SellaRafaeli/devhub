$users = $mongo.collection('users')

namespace '/api/users' do

  post '/register' do
    require_fields(['email','name'])
    halt(401, {msg: 'User exists'}) if $users.exists(email: params[:email])
    $users.add(email: params[:email], token: guid, name: params[:name])
  end

end # end /users