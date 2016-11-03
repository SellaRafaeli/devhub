
$post_upvotes = $mongo.collection('post_upvotes')
$post_downvotes = $mongo.collection('post_downvotes')
$comment_upvotes = $mongo.collection('comment_upvotes')
$comment_downvotes = $mongo.collection('comment_downvotes')

def user_upvoted_post?(user_id, post_id)
	$post_upvotes.exists?(user_id:user_id, post_id:post_id)
	#return true if upvote
end

# def upvotes_count(post)
#   $post_upvotes.find(post_id: post[:_id]).count
# end

post '/post_upvote' do
  require_user
  $post_upvotes.add(post_id: params[:post_id], user_id:cuid)
  count = votes_count_id()
  {count:count}
end

post '/post_unupvote' do
  require_user
  $post_upvotes.delete_one(post_id: params[:post_id], user_id:cuid)
  count = votes_count_id()

  {count:count}
end

post '/comment_upvote' do
  require_user
  $comment_upvotes.add(comment_id: params[:comment_id], user_id:cuid)
  count = comment_votes_count_id()
  {count:count}
end


post '/post_downvote' do
  require_user
  $post_downvotes.add(post_id: params[:post_id], user_id:cuid)
  # data = params.just(:post_id,)
  count = votes_count_id()
  {count:count}
end




def votes_count(post)
  upvotes = $post_upvotes.find(post_id: post[:_id]).count
  downvotes = $post_downvotes.find(post_id: post[:_id]).count
  vote = upvotes - downvotes
end

def comment_votes_count(comment)
  upvotes = $comment_upvotes.find(comment_id: comment[:_id]).count
  downvotes = $comment_downvotes.find(comment_id: comment[:_id]).count
  vote = upvotes
end

def comment_votes_count_id()
	count = $comment_upvotes.find(comment_id: params[:comment_id]).count
	count
  #downvotes = $comment_downvotes.find(comment_id: params[:comment_id]).count
end


def votes_count_id()
  upvotes = $post_upvotes.find(post_id: params[:post_id]).count
  downvotes = $post_downvotes.find(post_id: params[:post_id]).count
  vote = upvotes - downvotes
end