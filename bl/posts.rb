$posts = $mongo.collection('posts')

get '/posts' do 
  crit        = params.just(:user_id)
  items, done = page_mongo($posts, crit)
  items       = items.mapf(:map_post)
  {total: items.count, posts: items, done: done}
end



get '/posts/:id' do
  post_id = params[:id] 
  p = ($posts.get(post_id))
  require_item(p, msg: 'No such post.')
  p = map_post(p, comments: true)
end

post '/posts' do 
  require_user
  data           = params.just(:title, :url)
  data[:user_id] = cuid
  p              = $posts.add(data)
  p              = map_post(p)
end

def map_post(p, opts = {})
  p = p.just(:_id, :title, :url, :user_id, :created_at)
  
  p_id = p['_id']
  
  p[:user] = map_user($users.get(p[:user_id]))
  p[:num_comments] = $comments.find(post_id: p_id, parent_id: {'$exists': false}).count
  
  if opts[:comments]
    p[:comments] = $comments.all(post_id: p_id, parent_id: {'$exists': false}).mapf(:map_comment)
  end
  
  
  p
end

# namespace '/posts' do 

#   get '/' do
#     {posts: posts.all}
#   end

#   get '/:_id' do
#     {post: $posts.get(params[:_id])}
#   end

#   post '/' do 
#     data           = params
#     data[:user_id] = cuid
#     post           = $posts.add(data)
#     {post: post}
#   end

#   post '/:_id' do
#     {post: $posts.update_id(params[:_id],params)}
#   end 
# end

# # def mapped_post(post)
# #   post[:comments_count] = comments_count(post)
# #   post[:votes]          =  votes_count(post);
# #   post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
# #   user = $users.get(_id: post[:user_id]) || {}
# #   post[:username] ||= 'anonymous'
# #   post[:name]     ||= 'anonymous name'
# #   post 
# # end

# # def homepage_posts
# #   posts = $posts.find.sort({created_at: -1}).limit(100).to_a
# #   posts.map! {|post| mapped_post(post) }
# # end

# # get '/submit' do
# #   to_page :'posts/submit'
# # end

# # post '/submit' do
# #   require_user
# #   data = params.just(:url, :title)
# #   data[:user_id] = cuid
# #   data[:slug]    = get_unique_slug($posts, :slug, data[:title])
# #   post = 
# #   {post:post, redirect: "/p/#{post[:slug]}"}
# # end

# # get '/p/:post_slug' do
# #   post = $posts.get(slug: params[:post_slug])
# #   to_page :'posts/post_page', locals: {post: post}
# # end

# # # get '/my_posts' do 
# # #   posts = $posts.find(user_id:params[:user_id]).sort({created_at: -1}).limit(10).to_a
# # #   posts.map! {|post| post[:comments_count] = comments_count(post)
# # #     post[:votes] =  votes_count(post);
# # #     post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
# # #     post[:username] = $users.get(_id:post[:user_id])[:username]
# # #     post}
# # #   {postsArray: posts}
# # # end

# # # get '/posts/homepage' do
# # #   # return flag if cu upvoted post
# # #   {postsArray: homepage_posts}
# # # end
