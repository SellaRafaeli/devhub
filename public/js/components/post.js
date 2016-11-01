Vue.component('post-component', {
  template: "#post-template",
  props: ['postdata'],  
  data: function () {
    return {
      upvoted: false,
      downvoted: false,
    };
  },
  methods: {
    upvote: function () {
      console.log("this one", this)
      var postComponent = this;
      $.post("/post_upvote", {post_id: this.postdata._id})
      .success(function(response){
        postComponent.upvoted = !postComponent.upvoted;
        postComponent.downvoted = false;
        postComponent.postdata.votes = response.count;
      })
    },

    downvote: function () {
      console.log("this one", this)
      var postComponent = this;
      $.post("/post_downvote", {post_id: this.postdata._id})
      .success(function(response){
        postComponent.downvoted =!postComponent.downvoted;
        postComponent.upvoted = false;
        postComponent.postdata.votes = response.count;
      })
    },
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