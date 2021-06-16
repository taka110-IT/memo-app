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

def load_memos(conn)
  @hash = { 'memos' => [] }
  conn.exec('SELECT * FROM memos ORDER BY id ASC') do |result|
    result.each do |row|
      memo = { 'id': row['id'], 'title': row['title'], 'body': row['body'] }
      @hash['memos'].push(memo)
    end
  end
end

def load_one_memo(conn, memo_id)
  conn.prepare('load', 'SELECT * FROM memos WHERE id=$1')
  conn.exec_prepared('load', [memo_id]) do |result|
    result.each do |row|
      @id = row['id']
      @title = row['title']
      @body = row['body']
    end
  end
  conn.exec('DEALLOCATE load')
end

get '/memo' do # top画面呼び出し
  load_memos(conn)
  @page_title = 'top'
  erb :top
end

post '/memo' do # 新規メモ保存
  conn.prepare('top', 'INSERT INTO memos (title, body) VALUES ($1,$2)')
  conn.exec_prepared('top', [h(params[:title]), h(params[:body])])
  conn.exec('DEALLOCATE top')
  redirect '/memo'
end

get '/memo/new' do # new画面表示
  @page_title = 'new'
  erb :new
end

get '/memo/:id' do # show画面表示
  load_one_memo(conn, params['id'])
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
  conn.prepare('update', 'UPDATE memos SET title=$2, body=$3 WHERE id=$1')
  conn.exec_prepared('update', [params['id'], h(params[:title]), h(params[:body])])
  conn.exec('DEALLOCATE update')
  redirect '/memo'
end

get '/memo/:id/edit' do # edit画面表示
  load_one_memo(conn, params['id'])
  @page_title = 'edit'
  erb :edit
end
