def send_entry_link_email(user)
  subj = 'your entry link to devhub '+Time.now.to_s
  token= user['token']
  return if !token
  link = $client_url+"/#posts?token=#{token}"
  body = "hello here is your entry link: #{link}"
  send_email(user['email'], subj, body)
end
 
get '/emails.rb' do 'ok' end