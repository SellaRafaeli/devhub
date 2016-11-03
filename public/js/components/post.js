Vue.component('post-component', {
  // $.get('/post_upvoted?'{post_id: this.postdata._id})
  // .success(function(res) {
  //   postComponent.upvoted = res.upvote;
  //   });

  template: "#post-template",
  props: ['postdata'],  
  data: function () {
    return {
      upvoted: this.postdata.i_upvoted,
      downvoted: false,
    };
  },
  methods: {

    upvote: function () {
      var postComponent = this;
      if (!this.upvoted) { 
      $.post("/post_upvote", {post_id: this.postdata._id})
      .success(function(response){
        postComponent.upvoted = !postComponent.upvoted;
        postComponent.downvoted = false;
        postComponent.postdata.votes = response.count;
      });
    }

    else {
      $.post("/post_unupvote", {post_id: this.postdata._id})
      .success(function(response){
        postComponent.upvoted = !postComponent.upvoted;
        postComponent.downvoted = false;
        postComponent.postdata.votes = response.count;
      });
    }


    },

    downvote: function () {
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