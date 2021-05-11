require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

get '/memo' do
  if FileTest.exist?('memos.json')
    File.open("memos.json") do |file|
      @hash = JSON.load(file)
    end
    erb :top
  else
    erb :new
  end
  # erb :top
end

post '/memo' do
  @title = params[:title]
  @body = params[:body]
  new_memo = { "id": SecureRandom.uuid, "title": @title, "body": @body }
  if FileTest.exist?('memos.json')
    File.open("memos.json") do |file|
      @hash = JSON.load(file)
      @hash["memos"].push(new_memo)
    end
    File.open("memos.json", "w") do |file|
      JSON.dump(@hash, file)
    end
  else
    File.open("memos.json", "w") do |file|
      @hash = { "memos": [new_memo]}
      JSON.dump(@hash, file)
    end
  end
  redirect '/memo'
end

get '/memo/new' do
  erb :new
end

get '/memo/:id' do
  File.open("memos.json") do |file|
    @hash = JSON.load(file)
    item = @hash["memos"].select{ |memo| memo["id"] == params['id'] }
    @id = item[0]["id"]
    @title = item[0]["title"]
    @body = item[0]["body"]
  end
  erb :show
end

delete '/memo/:id' do
  File.open("memos.json") do |file|
    @hash = JSON.load(file)
    item = @hash["memos"].select{ |memo| memo["id"] == params['id'] }
    @hash["memos"].delete(item[0])
  end
  File.open("memos.json", "w") do |file|
    JSON.dump(@hash, file)
  end
  redirect '/memo'
end

patch '/memo/:id' do
  @title = params[:title]
  @body = params[:body]
  edit_memo = { "id": params[:id], "title": @title, "body": @body }
  File.open("memos.json") do |file|
    @hash = JSON.load(file)
    item = @hash["memos"].select{ |memo| memo["id"] == params['id'] }
    @hash["memos"].delete(item[0])
    @hash["memos"].push(edit_memo)
  end
  File.open("memos.json", "w") do |file|
    JSON.dump(@hash, file)
  end
  redirect '/memo'
end

get '/memo/:id/edit' do
  File.open("memos.json") do |file|
    @hash = JSON.load(file)
    item = @hash["memos"].select{ |memo| memo["id"] == params['id'] }
    @id = item[0]["id"]
    @title = item[0]["title"]
    @body = item[0]["body"]
  end
  erb :edit
end
