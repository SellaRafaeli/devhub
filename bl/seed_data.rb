get '/seed_data' do 
  return 'disabled on prod' if $prod
  seed_data
  
  #session[:user_id] = $sella['_id']
  redirect '/api/users/'
end

def seed_data
  $users.delete_many
  $posts.delete_many
  $comments.delete_many

  add_users
  add_posts
  add_comments
  $sella = $users.add(name: 'Sella Rafaeli', email: 'sella@rafaeli.net', token: '123')
  $eyal  = $users.add(name: 'Eyal Arubas', email: 'eyal@arubas.com', token: '456')
end

def add_users
  (0..10).each {|i| 
    data = {
      name: ['Albert', 'Bob', 'Carol', 'Dave', 'Ernie', 'Frank', 'George'].sample+' '+rand(1000).to_s,
      email: rand_str+rand(1000).to_s+'@gmail.com',
      token: guid
    }
    $users.add(data)
  }
end

def add_posts
  $users.all.each {|u| 
    $posts.add(title: "#{rand_str.capitalize} #{rand_str}", url: "#{rand_url}", user_id: u['_id'])
  }
end

def add_comments 
  $posts.all.each {|p|
    5.times {
      $comments.add(text: Faker::Lorem.sentences(3).join(' '), user_id: $users.random['_id'], post_id: p['_id'])
    }    
  }
end

