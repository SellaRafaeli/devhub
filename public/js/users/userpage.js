  var userpage = new Vue({
    el: "#userpage",
    data: {
      username: user["username"],
      user_id: user["_id"],
      postsList: [],
      commentsList: [,]
    }
  });

  $.get('/my_posts?user_id=' + userpage.user_id).success(function(res) {
  // userpage.postsList = res.user;
  userpage.postsList = res.postsArray;
})  

  $.get('/my_comments?user_id=' + userpage.user_id).success(function(res) {
  // userpage.postsList = res.user;
  userpage.commentsList = res.comments;
}) 

