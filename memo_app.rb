# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
# require 'json'
# require 'securerandom'

helpers do # XSS対策→postとpatchでHTMLをエスケープする
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

class Memo
  def self.load_memo
    conn = PG.connect( dbname: 'dbmemo' )
    conn.exec( "SELECT * FROM memos" )
    # File.open('memos.json') do |file|
    #   JSON.parse(file.read)
    # end
  end

  def self.save_memo(memo)
    File.open('memos.json', 'w') do |file| # wオプションで一旦削除して丸ごと書き込み
      JSON.dump(memo, file)
    end
  end
end

get '/memo' do # top画面呼び出し
  # if FileTest.exist?('memos.json') # memos.jsonが存在すればロードしてハッシュに入れる
    # @hash = Memo.load_memo

    conn = PG.connect( dbname: 'dbmemo' )
    @hash = {}
    @hash['memos'] = []
    conn.exec( "SELECT * FROM memos" ) do |result|
      result.each do |row|
        memo = { 'id': row['id'], 'title': row['title'], 'body': row['body']}
        @hash['memos'].push(memo)
      end
    end
    @page_title = 'top'
    erb :top

  # else # memos.jsonが存在しない時はmemos.jsonを作成して強制的に新規投稿画面に行く
  #   Memo.save_memo({ 'memos': [] })
  #   @page_title = 'new'
  #   erb :new
  # end
end

post '/memo' do # 新規メモ保存
  @title = h(params[:title]) # メモのタイトルと内容を取得
  @body = h(params[:body])
  # new_memo = { 'id': SecureRandom.uuid, 'title': @title, 'body': @body } # メモ内容をハッシュに入れる
  # @hash = Memo.load_memo
  # @hash['memos'].push(new_memo)
  # Memo.save_memo(@hash)

  conn = PG.connect( dbname: 'dbmemo' )
  conn.exec( "INSERT INTO memos (title, body) VALUES ('#{@title}','#{@body}')" )
  redirect '/memo'
end

get '/memo/new' do # new画面表示
  @page_title = 'new'
  erb :new
end

get '/memo/:id' do # show画面表示
  # @hash = Memo.load_memo

  conn = PG.connect( dbname: 'dbmemo' )
  @hash = {}
  @hash['memos'] = []
  conn.exec( "SELECT * FROM memos" ) do |result|
    result.each do |row|
      memo = { 'id': row['id'], 'title': row['title'], 'body': row['body']}
      @hash['memos'].push(memo)
    end
  end

  item = @hash['memos'].find { |memo| memo[:id] == params['id'] } # idで特定する
  @id = item[:id] # 特定したメモ内容を代入
  @title = item[:title]
  @body = item[:body]
  @page_title = 'show'
  erb :show
end

delete '/memo/:id' do # メモ削除
  # @hash = Memo.load_memo
  # item = @hash['memos'].find { |memo| memo['id'] == params['id'] } # idで特定する
  # @hash['memos'].delete(item) # 配列から削除
  # Memo.save_memo(@hash)

  conn = PG.connect( dbname: 'dbmemo' )
  conn.exec( "DELETE FROM memos WHERE id=#{params['id']}" )
  redirect '/memo'
end

patch '/memo/:id' do # メモ修正
  @title = h(params[:title]) # メモのタイトルと内容を取得
  @body = h(params[:body])
  # edit_memo = { 'id': params[:id], 'title': @title, 'body': @body } # 修正したメモ内容をハッシュに入れる
  # @hash = Memo.load_memo
  # item = @hash['memos'].find { |memo| memo['id'] == params['id'] } # idで特定する
  # @hash['memos'].delete(item) # 配列から削除
  # @hash['memos'].push(edit_memo) # 修正したメモ内容を代入
  # Memo.save_memo(@hash)

  conn = PG.connect( dbname: 'dbmemo' )
  conn.exec( "UPDATE memos SET title=#{@title}, body=#{@body} WHERE id=#{params['id']}" )
  redirect '/memo'
end

get '/memo/:id/edit' do # edit画面表示
  # @hash = Memo.load_memo
  # item = @hash['memos'].find { |memo| memo['id'] == params['id'] } # idで特定する
  # @id = item['id'] # 特定したメモ内容を代入
  # @title = item['title']
  # @body = item['body']

  conn = PG.connect( dbname: 'dbmemo' )
  @hash = {}
  @hash['memos'] = []
  conn.exec( "SELECT * FROM memos" ) do |result|
    result.each do |row|
      memo = { 'id': row['id'], 'title': row['title'], 'body': row['body']}
      @hash['memos'].push(memo)
    end
  end

  item = @hash['memos'].find { |memo| memo[:id] == params['id'] } # idで特定する
  @id = item[:id] # 特定したメモ内容を代入
  @title = item[:title]
  @body = item[:body]
  @page_title = 'edit'
  erb :edit
end
