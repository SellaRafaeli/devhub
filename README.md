devForum
======== 
Tasks
=====
Phase 1:
========



me.erb:
-- if ANY ERROR, WRITE: UPDATE DETAILS (OR ALL THE TIME ANYWAY)


  - allow submitting only if all fields are filled, and allow only passwords of 3 characters or more. Show appropriate error messages. 
  - make the 'submit' method send it by AJAX (use jquery's $), and show some success message or error message (not by alert, but by some <div> that will be hidden or shown with a v-show). 

submit post page:
  - allow only submissions of things that are actually URLs (just check that it starts with http), and a title of at least 6 characters. Show appropriate error messages. 

Phase 2: 
========
- we'll build a user page. 
  - let each user choose their username. By default (on registration), set it to their email's login (the part before the @), but verify it exists. You can do this using 'get_unique_slug' from mongo.rb which is designed to do just this. It should also be editable via the '/me' route. 
  - for each post/comment, show the submitter username. 
  - From each comment (in a single_post page) and from each post (in the homepage) we should link the submitter username of the post/comment to his/her user page.
  - make /u/:username lead to a user.erb page. 
  - serve this page from users/user.erb. Display the user's name, and display a list of all the posts he wrote as well as all the comments he ever wrote. (Note this should be reusing the techniques we saw in homepage.erb and single_post.erb, and should be rendering the posts and comments as variables of a VueJS VM, and not by server-side rendering.) Each post should link to the related post page, each comment should lead to the page of that comment's post. 


In the future:
==============
* Turbolinks 
* Set up email sending, email a sign-in link for forgot password 


done


homepage:
list of posts: for each post, show submitter (user_id), number of comments and creation time

  - make upvote send ajax to server which will:
    - a) create an 'upvotes' item in a mongo collection ($post_upvotes), e.g. {post_id: 123, user_id: abc}.
    -  Then count then new number of upvotes and update the post accordingly (so we can display it in the view)
    b) hide the downvote button for now. I want just upvotes. 

  - display the number of upvotes on the post 

  - note homepage.erb is technically an 'erb' page (so we could embed ruby in it) but we're not embedding any ruby - this page could be served just the same from some CDN; it's a minimal SPA. In general this app is a bunch of 'SPA's; it's a Multi-page app. ;) 

single_post:

  - for each comment, similarly as for posts, make the upvote send an ajax (in $comment_upvotes) and then count and update the number of upvotes this comment has.
  - display the number of upvotes. 

  - when adding a new comment, instead of refreshing the page, send it with an AJAX (via a method call from the Vue VM) and then push it into the data.comments. 
