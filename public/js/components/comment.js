
Vue.component('comment', {
  template: "#comment-template",
  props: ['comment'],
  data: function () {
    return {
      upvoted: false,
      downvoted: false
    };
  },

  methods: {
      upvote: function () {
      var commentComponent = this;
      $.post("/comment_upvote", {comment_id: this.comment._id})
      .success(function(response){
        commentComponent.upvoted = !commentComponent.upvoted;
        commentComponent.downvoted = false;
        commentComponent.comment.votes = response.count;
        console.log("#############" + response.count);
      })
    },

    downvote: function () {
      var commentComponent = this;
      $.post("/comment_downvote", {comment_id: this.comment._id})
      .success(function(response){
        commentComponent.downvoted =!commentComponent.downvoted;
        commentComponent.upvoted = false;
        commentComponent.comment.votes = response.count;
      })
    },
    // upvote: function () {
    //   this.upvoted = !this.upvoted;
    //   this.downvoted = false;
    // },
    // downvote: function () {
    //   this.downvoted = !this.downvoted;
    //   this.upvoted = false;
    // }
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