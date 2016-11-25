$posts = $mongo.collection('posts')

def mapped_post(post)
  post[:comments_count] = comments_count(post)
  post[:votes]          =  votes_count(post);
  post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
  user = $users.get(_id: post[:user_id]) || {}
  post[:username] ||= 'anonymous'
  post[:name]     ||= 'anonymous name'
  post 
end

def homepage_posts
  posts = $posts.find.sort({created_at: -1}).limit(100).to_a
  posts.map! {|post| mapped_post(post) }
end

get '/submit' do
  to_page :'posts/submit'
end

post '/submit' do
  require_user
  data = params.just(:url, :title)
  data[:user_id] = cuid
  data[:slug]    = get_unique_slug($posts, :slug, data[:title])
  post = $posts.add(data)
  {post:post, redirect: "/p/#{post[:slug]}"}
end

get '/p/:post_slug' do
  post = $posts.get(slug: params[:post_slug])
  to_page :'posts/post_page', locals: {post: post}
end

# get '/my_posts' do 
#   posts = $posts.find(user_id:params[:user_id]).sort({created_at: -1}).limit(10).to_a
#   posts.map! {|post| post[:comments_count] = comments_count(post)
#     post[:votes] =  votes_count(post);
#     post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
#     post[:username] = $users.get(_id:post[:user_id])[:username]
#     post}
#   {postsArray: posts}
# end

# get '/posts/homepage' do
#   # return flag if cu upvoted post
#   {postsArray: homepage_posts}
# end
