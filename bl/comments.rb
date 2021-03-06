$comments = $mongo.collection('comments')

post '/comments' do 
  require_user
  params[:user_id] = cuid
  comment = $comments.add(params.just(:post_id, :text, :user_id, :parent_id))
end

get '/comments' do 
  crit        = params.just(:user_id)
  items, done = page_mongo($comments, crit, params)
  items       = items.mapf(:map_comment)
  {comments: items, done: done}
end

def add_sons_to_comment(c)
  c[:children] = $comments.get_many({parent_id: c[:_id]}, sort: [{created_at: 1}]).mapf(:map_comment)
end

def map_comment(c) #map_single_comment
  c = c.hwia
  c[:user] = map_user($users.get(c[:user_id]))
  add_sons_to_comment(c)
  c = c.just(:_id,:post_id,:text,:user,:created_at,:children)
end

# post '/comments/submit' do
#   require_user
#   data = params.just(:text, :post_id, :parent_id)
#   data[:user_id] = cuid
#   data[:votes]   = 1
#   comment        = $comments.add(data)
#   post           = $posts.get(comment['post_id'])
#   comment_html   = erb :'comments/single_comment', locals: {comment: comment, post: post}
#   {comment: comment, html: comment_html}
# end

# def comments_count(post)
#   comments = $comments.find(post_id: post[:_id]) 
#   comments = comments.count if comments
# end

# get '/c/:_id' do
#   post_id = $comments.get(_id: params[:_id])[:post_id]
#   post = $posts.get(_id: post_id)
#   to_page :'posts/single_post_page', locals: {post: post}
# end

# get '/my_comments' do 
#   comments = $comments.find(user_id:params[:user_id]).sort({created_at: -1}).to_a
#   {comments: comments}
# end