#http://www.sinatrarb.com/contrib/multi_route.html
# require 'sinatra/multi_route'

# def get_post(*args, &block)
#   route :get, :post, Array(args) { block } #does not work yet...
# end

# # get_post '/ping4' do 
# #   {ping4: 'rocks'}
# # end

# set(:method) do |method|
#   method = method.to_s.upcase
#   condition { request.request_method == method }
# end

# before :method => :post do
#   #code that runs before 'post' requests
# end 