devForum
========

Architecture
============

FE is a MPA - multi-page app. This means we have several different pages, each is a SPA. Most of those are VueJS but we will also add Angular later (probably Angular1). 

App is powered by Turbolinks - this is a JS library that makes links load with JS; turbolinks wraps links so that when a user clicks them, it makes an AJAX request to the second page and then swaps it in. (It also saves a cached version of each page.)

- homepage
- userpage
- register, login
- add post 
- post page 

Tasks
=====
- register screen: add fields for first name, last name, and password. Make sure the form is submittable only if all fields are properly entered. 