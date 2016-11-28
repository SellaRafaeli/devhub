def get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

def ns(url,&block)
  get_or_post("api/:type/#{url}",&block)
end


namespace '/api/:type' do    
  #read
  get '' do 
    set_api_fields
    redirect "/api/#{@cn}/"
  end

  get '/' do     
    set_api_fields 
    {num: @coll.count, example: @coll.random}
  end

  get '/all' do 
    set_api_fields 
    {items: @coll.all}
  end

  get '/random/?:num?' do 
    set_api_fields 
    return {items: @coll.random(params[:num].to_i)} if params[:num]
    return @coll.random
  end
  
  get '/:_id' do 
    set_api_fields 
    @coll.get(@id)
  end

  #create
  post '/' do
    set_api_fields 
    @coll.add(@data)
  end
  
  #update
  post '/:_id/update' do
    set_api_fields 
    @coll.update_id(@id, @data) 
  end  

  #delete
  post '/:_id/delete' do
    set_api_fields 
    @coll.delete_one(@id)
    {msg: 'ok'}
  end

  post '/delete_all' do
    set_api_fields
    {msg: 'ok', num_deleted: @coll.delete_many.n}
  end
end

def set_api_fields
  @coll = $mongo.collection(params[:type])
  @cn   = @coll.name
  @id   = params[:_id] 
  @data = allowed_fields(@cn)
  set_random_fields
  if @id 
    @item = @coll.get(@id)      
    halt_no_item if !@item
    require_owner(@item) if request.request_method == 'POST'
  end
end

def require_owner(item)
  i = item
  halt_no_permissions if !(cuid.in?[i['_id'], i['user_id']])
end

ALLOWED_COLL_FIELDS = {
  users: ['name',  'email','password'],
  posts: ['title', 'url']
}.hwia

def allowed_fields(cn_name = nil)
  white_fields = ALLOWED_COLL_FIELDS[cn_name] 
  white_fields ? params.just(white_fields) : {}
end

def set_random_fields
  params.each {|k,v| 
    params[k] = rand_str if v == 'rand_str'
    params[k] = rand(1000) if v == 'rand'
  }
end
# route :post, :get, ['/ping2', '/ping3'] do
#   {ping23: true}
# end

# get '/ping5', '/ping6' do
#   {ping6: 'ok'}
# end

