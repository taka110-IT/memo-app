require 'sinatra'
require 'sinatra/reloader'

get '/top' do
  erb :top
end

get '/new' do
  erb :new
end

get '/show' do
  erb :show
end

get '/edit' do
  erb :edit
end
