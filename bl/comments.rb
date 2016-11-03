$comments = $mongo.collection('comments')

post '/comments/submit' do
  require_user
  data = params.just(:text, :post_id)
  data[:user_id] = cuid
  data[:votes] = 1
  comment = $comments.add(data)
  {comment: comment}
  #redirect back
end

def comments_count(post)
  $comments.find(post_id: post[:_id]).count
end


get '/c/:_id' do
  post = $comments.get(_id: params[:_id])
end