require 'sinatra'

# A simple dynamic route
get '/hello/:name' do
  @name = params[:name].capitalize
  erb :hello
end
