$posts = $mongo.collection('posts')

get '/submit' do
  to_page :'posts/submit'
end

post '/submit' do
  require_user
  data = params.just(:url, :title)
  data[:user_id] = cuid
  data[:slug]    = get_unique_slug($posts, :slug, data[:title])
  post = $posts.add(data)
  redirect "/p/#{post[:slug]}"
end

get '/p/:post_slug' do
  post = $posts.get(slug: params[:post_slug])
  to_page :'posts/single_post', locals: {post: post}
end

