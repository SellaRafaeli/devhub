$( document ).ready(function() {
	$.material.init(); //init material design
	console.log('done on-document-ready')
}); 

function suggestLogin() {
  if (!cu && confirm('You are not logged in. Go to log in page?')){
    document.location='/login'      
  }      
}

function upvote(voteCountID) {
  $.post('/upvotes')
}

function submitComment(form) {
  var data = $(form).serializeObject();
  var commentID = data.comment_id;
  $.post('/comments/submit',data).success(function(res){
    debugger
    newComment = $.parseHTML(res.html);
    parent     = $(".sons_of_comment_"+res.comment.parent_id);
  });
}