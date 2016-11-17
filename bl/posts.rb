$posts = $mongo.collection('posts')

def single_post_page_data(post)
  comments = $comments.find(post_id: post[:_id]).to_a || []
  if comments.length > 1 
    comments.map! {|comment| comment[:votes] = comment_votes_count(comment)
    comment[:i_upvoted] = cuid && user_upvoted_comment?(cuid, comment[:_id])
    comment[:username] =  $users.get(_id:comment[:user_id])[:username]
    comment} 
  end
  {cu:cu, post: post, comments: comments}
end

get '/my_posts' do 
  posts = $posts.find(user_id:params[:user_id]).sort({created_at: -1}).limit(10).to_a
  posts.map! {|post| post[:comments_count] = comments_count(post)
    post[:votes] =  votes_count(post);
    post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
    post[:username] = $users.get(_id:post[:user_id])[:username]
    post}
  {postsArray: posts}
end

get '/posts/homepage' do
  # return flag if cu upvoted post
  posts = $posts.find.sort({created_at: -1}).limit(100).to_a
  posts.map! {|post| post[:comments_count] = comments_count(post)
    post[:votes] =  votes_count(post);
    post[:i_upvoted] = cuid && user_upvoted_post?(cuid, post[:_id])
    post[:username]  = $users.get(_id: post[:user_id])[:username] rescue nil
    post[:username] ||= 'anonymous'
    post 
  }
  {postsArray: posts}
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
  to_page :'posts/single_post', locals: {post: post}
end
