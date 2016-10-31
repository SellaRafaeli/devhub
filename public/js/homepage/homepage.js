var homepage = new Vue({
  el: "#app",
  data: {
  	foo: 'bla',
    postsList: [],
  }
});

$.get('/posts/homepage').success(function(res) {
  homepage.postsList = res.postsArray;
})  
