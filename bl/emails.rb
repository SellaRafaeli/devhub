root_url = "http://localhost:9090/"

get '/test' do 
  redirect "/"
end

def send_entry_link_mail(email, token)
	#if no such user, return smth 
  	subj = 'Your entry link to devhub'
  	link = "http://localhost:9090/" + "login?email=#{email}&token=#{token} "
  	body = "To log into DevHub, please click on the following link #{link}"
  	send_email(email, subj, body)
  	return true
end


$postmark_client = Postmark::ApiClient.new(ENV['POSTMARK_TOKEN'])

def send_email(to, subj, html_body)
	return true # will work only in production
  $postmark_client.deliver(
    from: 'sella@rafaeli.net',
    to: to,
    subject: subj,
    html_body: html_body,
    track_opens: true
  )
end

def send_default_email #for testing
  subj = "test subject #{Time.now}"
  send_email('sella.rafaeli@gmail.com', subj, '<strong>Hello</strong> dear Postmark user.')
end

