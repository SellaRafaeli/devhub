namespace '/api/:type' do
  
  before {
    @coll = $mongo.collection(params[:type])
  }

  get '/' do
    {data: @coll.all}
  end

  get '/:_id' do
    {data: @coll.get(params[:_id])}
  end
end