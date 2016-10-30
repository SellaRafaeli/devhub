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
      this.upvoted = !this.upvoted;
      this.downvoted = false;
    },
    downvote: function () {
      this.downvoted = !this.downvoted;
      this.upvoted = false;
    }
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