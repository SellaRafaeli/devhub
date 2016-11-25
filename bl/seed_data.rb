get '/seed_data' do 
  return if $prod
  $users.delete_many
  $posts.delete_many
  $sella = $users.add(name: 'Sella Rafaeli', email: 'sella@rafaeli.net')
  $joe   = $users.add(name: 'Joe The Mole', email: 'joe@roach.com')
  $posts.add(user_id: $sella['_id'], title: 'Google is great', url: 'http://google.com', slug: 'google-is-great')
  session[:user_id] = $sella['_id']
  redirect back
end

