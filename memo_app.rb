# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do # XSS対策→postとpatchでHTMLをエスケープする
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

conn = PG.connect(dbname: 'dbmemo')

def load_memo(conn)
  @hash = {}
  @hash['memos'] = []
  conn.exec('SELECT * FROM memos') do |result|
    result.each do |row|
      memo = { 'id': row['id'], 'title': row['title'], 'body': row['body'] }
      @hash['memos'].push(memo)
    end
  end
end

get '/memo' do # top画面呼び出し
  load_memo(conn)
  @page_title = 'top'
  erb :top
end

post '/memo' do # 新規メモ保存
  @title = h(params[:title]) # メモのタイトルと内容を取得
  @body = h(params[:body])
  conn.prepare('top', 'INSERT INTO memos (title, body) VALUES ($1,$2)')
  conn.exec_prepared('top', [@title, @body])
  conn.exec('DEALLOCATE top')
  redirect '/memo'
end

get '/memo/new' do # new画面表示
  @page_title = 'new'
  erb :new
end

get '/memo/:id' do # show画面表示
  load_memo(conn)
  item = @hash['memos'].find { |memo| memo[:id] == params['id'] } # idで特定する
  @id = item[:id] # 特定したメモ内容を代入
  @title = item[:title]
  @body = item[:body]
  @page_title = 'show'
  erb :show
end

delete '/memo/:id' do # メモ削除
  conn.prepare('delete', 'DELETE FROM memos WHERE id=$1')
  conn.exec_prepared('delete', [params['id']])
  conn.exec('DEALLOCATE delete')
  redirect '/memo'
end

patch '/memo/:id' do # メモ修正
  @title = h(params[:title]) # メモのタイトルと内容を取得
  @body = h(params[:body])
  conn.prepare('update', 'UPDATE memos SET title=$2, body=$3 WHERE id=$1')
  conn.exec_prepared('update', [params['id'], @title, @body])
  conn.exec('DEALLOCATE update')
  redirect '/memo'
end

get '/memo/:id/edit' do # edit画面表示
  load_memo(conn)
  item = @hash['memos'].find { |memo| memo[:id] == params['id'] } # idで特定する
  @id = item[:id] # 特定したメモ内容を代入
  @title = item[:title]
  @body = item[:body]
  @page_title = 'edit'
  erb :edit
end
