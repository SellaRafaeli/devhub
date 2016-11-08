$comments = $mongo.collection('comments')

post '/comments/submit' do
  require_user
  data = params.just(:text, :post_id)
  data[:user_id] = cuid
  data[:votes] = 1
  comment = $comments.add(data)
  {comment: comment}
end

def comments_count(post)
  comments = $comments.find(post_id: post[:_id]) 
  comments = comments.count if comments
end


get '/c/:_id' do
  post_id = $comments.get(_id: params[:_id])[:post_id]
  post = $posts.get(_id: post_id)
  to_page :'posts/single_post', locals: {post: post}
end

get '/my_comments' do 
  comments = $comments.find(user_id:params[:user_id]).sort({created_at: -1}).to_a
  {comments: comments}
end