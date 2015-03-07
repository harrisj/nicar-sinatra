require 'sinatra'

# Register a method for the /hi route
get '/hi' do
  'Hello world!'
end

# A simple dynamic route
get '/hello/:name' do
  "Hello #{params[:name]}!"
end