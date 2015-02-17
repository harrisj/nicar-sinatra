require 'sinatra'

# Register a method for the /hi route
get '/hi' do
  'Hello world!'
end

# Uncomment me to redirect
# get '/' do
#   redirect to('/hi')
# end

# A simple dynamic route
get '/hello/:name' do
  "Hello <strong>#{params[:name].capitalize}</strong>!"
end