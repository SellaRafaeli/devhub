$comments = $mongo.collection('comments')

post '/comments/submit' do
  require_user
  data = params.just(:text, :post_id)
  data[:user_id] = cuid
  comment = $comments.add(data)

  redirect back
end