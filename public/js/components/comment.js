Vue.component('comment', {
  template: "#comment-template",
  props: ['comment'],
  data: function () {
    return {
      upvoted: this.comment.i_upvoted,
      downvoted: false
    };
  },

  methods: {

      upvote: function () {
      var commentComponent = this;

      if (!this.upvoted) { 
      $.post("/comment_upvote", {comment_id: this.comment._id})
      .success(function(response){
        commentComponent.upvoted = !commentComponent.upvoted;
        commentComponent.downvoted = false;
        commentComponent.comment.votes = response.count;
      });
    }

    else {
      $.post("/comment_unupvote", {comment_id: this.comment._id})
      .success(function(response){
        commentComponent.upvoted = !commentComponent.upvoted;
        commentComponent.downvoted = false;
        commentComponent.comment.votes = response.count;
      });
    }

    },

    downvote: function () {
      var postComponent = this;
      $.post("/post_downvote", {post_id: this.comment._id})
      .success(function(response){
        postComponent.downvoted =!postComponent.downvoted;
        postComponent.upvoted = false;
        postComponent.comment.votes = response.count;
      })
    },
  },
  computed: {
    votes: function () {
      this.comment.votes = this.comment.votes || 0;
      if (this.upvoted) {
        return this.comment.votes + 1;
      } else if (this.downvoted) {
        return this.comment.votes - 1;
      } else {
        return this.comment.votes;
      }
    }
  }
});