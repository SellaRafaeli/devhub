def get_or_post(url,&block)
  get(url,&block)
  post(url,&block)
end

def ns(url,&block)
  get_or_post("api/:type/#{url}",&block)
end

namespace '/api' do    
  
  get '' do {msg: 'Hi from /api. See /api/users, /api/posts, etc.'} end
  get '/' do redirect '/api' end 

  namespace '/:type' do
    #read
    get '' do 
      set_api_fields
      total = @coll.count
      items, done = api_get_items(params)
      {total: total, items: items, done: done}
    end

    # get '/' do     
    #   set_api_fields
    #   redirect "/api/#{@cn}/all"
    # end

    # get '/all' do 
    #   set_api_fields 
    #   items = @coll.all
    #   {num: items.count, items: items}
    # end

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
    post '' do
      set_api_fields 
      halt_forbidden if @cn == 'users' #can't create other users
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
  end # end /:type
end

def set_api_fields
  @coll = $mongo.collection(params[:type])
  @cn   = @coll.name
  @id   = params[:_id] 
  @data = coll_fields(@cn)
  set_random_fields
  if @id 
    @item = @coll.get(@id)      
    halt_no_item if !@item
    if request.request_method == 'POST'
      require_user 
      require_owner(@item) 
      params[:user_id] = cuid unless @cn == 'users'
    end
  end
end

def require_owner(item)
  i = item
  halt_forbidden if !(cuid.in?[i['_id'], i['user_id']])
end

COLL_SETTABLE_FIELDS = {
  users: ['name', 'email'],
  posts: ['title', 'url', 'user_id'],
  comments: ['text', 'user_id', 'post_id']
}.hwia

COLL_FILTERABLE_FIELDS = {
  users: ['name'],
  posts: ['user_id','title','url'],
  comments: ['user_id','post_id']
}.hwia

def coll_fields(cn_name = nil)
  white_fields = COLL_SETTABLE_FIELDS[cn_name] 
  white_fields ? params.just(white_fields) : halt(401, {msg: 'Unsupported Resource.'})
end

def set_random_fields
  params.each {|k,v| 
    params[k] = rand_str if v == 'rand_str'
    params[k] = rand(1000) if v == 'rand'
  }
end

def api_get_items(opts = {})
  crit = opts.just(COLL_FILTERABLE_FIELDS[@cn] || [])
  opts[:sort] ||= [{created_at: -1}]
  page_mongo(@coll, crit, opts)
end

# route :post, :get, ['/ping2', '/ping3'] do
#   {ping23: true}
# end

# get '/ping5', '/ping6' do
#   {ping6: 'ok'}
# end