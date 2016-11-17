  var vm = new Vue({
    el: "#single_post_page",
    data: {
      cu: postData.cu,
      post: postData.post,
      comments: postData.comments,
      new_comment_text: "",
    },
    methods: {
      addComment: function (argument) {
        var single_post = this;
        $.post("/comments/submit", {post_id: this.post._id, text: this.new_comment_text})
        .success(function(response){
          single_post.comments.push(response.comment);
          return
        })
        
      }
    },
    computed: {
      link: function() {
        return '/u/'+ this.cu.username;
      },
    }
  });