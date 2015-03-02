require 'sinatra'
require "sinatra/activerecord"
require_relative "models/accident"

set :database, {adapter: "sqlite3", database: "hunt.db"}

get '/' do
  @accidents = Accident.order("date ASC")
  erb :index
end

get '/show/:id' do
  # find a specific accident with Accident.find(params[:id])
  erb :show
end