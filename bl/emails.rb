def send_entry_link_mail(email)
  subj = 'your entry link to devhub'
  body = 'hello here is your entry link'
  send_email(email, subj, body)
end