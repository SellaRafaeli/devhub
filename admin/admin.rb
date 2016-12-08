MANAGEABLE_COLLECTIONS = [:users,:emails,:posts,:comments, :upvotes]
#MANAGEABLE_COLLECTIONS+=[:requests]
MANAGEABLE_COLLECTIONS.map! {|n| $mongo.collection(n) }

get '/admin/dashboard' do
  full_page_card(:"admin/admin_dashboard")  
end

get '/admin/add_fake_users' do
  add_fake_users
  {add: "added faker users"}
end

get '/admin/remove_fake_users' do
  remove_fake_users
  {msg: "removed faker users"}
end

get '/set_admin' do
  session[:is_admin] if params[:foo] = 'bar'
  {is_admin: is_admin}
end

def is_admin(user = cu)
  session[:is_admin]
rescue 
  false
end

get '/admin' do
  #to_page(:"admin/dashboard")
  redirect '/admin/manage/users'
end

get "/admin/manage/:coll" do 
  erb :"admin/items", default_layout
end 

before '/admin*' do
  protected!
end

def verify_admin_val(collection, field, val)
  # if you want to verify admin value, you can do it by collection
  # and/or field 
  # mock-code
  # if collection == 'something'
  #   if field == 'something'
  #     halt_bad_input(msg: 'Bad input')

  val
end

post '/admin/create_item' do
  require_fields(['coll'])
  coll = $mongo.collection(params[:coll])
  fields = mongo_coll_keys(coll)
  data   = params.just(fields)
  coll.add(data)
  redirect back
end

post '/admin/update_item' do
  require_fields(['id','field','coll'])
  coll, field, val = params[:coll], params[:field], params[:val]
  verified_val = verify_admin_val(coll, field, val)
  res = $mongo.collection(params[:coll]).update_id(params[:id],{field => verified_val})
  {msg: "ok", new_item: res}
end

post '/admin/delete_item' do
  require_fields(['id','coll'])
  $mongo.collection(params[:coll]).delete_one({_id: params[:id]})
  {msg: "ok"}
end


