var homepage = new Vue({
  el: "#app",
  data: {
    posts: [],
  }
});

$.get('/posts/homepage').success(function(res) {
  homepage.posts = res.posts;
})  
