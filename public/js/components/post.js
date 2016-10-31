Vue.component('post-component', {
  template: "#post-template",
  props: ['postdata'],  
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
    link: function() {
      return '/p/'+this.postdata.slug;
    },
    votes: function () {
      this.postdata.votes = this.postdata.votes || 0;
      if (this.upvoted) {
        return this.postdata.votes + 1;
      } else if (this.downvoted) {
        return this.postdata.votes - 1;
      } else {
        return this.postdata.votes;
      }
    }
  }
});