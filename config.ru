require './app'

configure(:development){ 
  puts "hello in dev".red
  set :environment, :development
  set :run, true
  set :port, 9494 
}

run Sinatra::Application
puts "#{$app_name} is now running."