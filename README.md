# データベース版メモアプリ

Sinatraで作成した簡単なメモアプリです。Bundlerを使用しています。

PostgrSQLを使用しメモを保存します。

## DEMO

<img width="623" alt="top" src="https://user-images.githubusercontent.com/70277776/119724511-c5126680-bea9-11eb-9069-f73889cc2f57.png">

<img width="622" alt="new" src="https://user-images.githubusercontent.com/70277776/119724542-ccd20b00-bea9-11eb-82fa-dc2022912398.png">

<img width="621" alt="show" src="https://user-images.githubusercontent.com/70277776/119724578-d78ca000-bea9-11eb-84db-0719d7f16c97.png">

<img width="618" alt="edit" src="https://user-images.githubusercontent.com/70277776/119724652-f68b3200-bea9-11eb-8795-33b01edd55b0.png">


## Features

- メモ一覧の表示、詳細表示、編集、削除ができます。
- PostgreSQLにメモを保存します。

## Requirement

* ruby 2.7.2
* PostgreSQL 13.2
* Bundler 2.1.4
* sinatra 2.1.0
* pg 1.2.3

## Installation

1. インストールするディレクトリに`https://github.com/taka110-IT/memo-app`からcloneする。
2. `bundle install`を実行しGemをインストールする。

```
$ git clone https://github.com/taka110-IT/memo-app <インストールするディレクトリ>

$ bundle install
```

3. インストールしたディレクトリに移動する
4. PostgreSQLにログインし、メモアプリ用データベース`dbmemo`とテーブル`memos`を作成する。以下の通り入力する。

```
$ psql -U <username>

データベース作成
# create database dbmemo

データベースに接続
# \c dbmemo

テーブル作成
dbmemo=# CREATE TABLE memos (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT
);
```

## Usage

1. ターミナルでインストールしたディレクトリに移動し`bundle exec ruby memo_app.rb`を実行する。
2. ブラウザで`http://localhost:4567/memo`に接続する。

## Note

- PostgreSQLのサーバーを起動してください

```
ex)
$ pg_ctl -D /usr/local/var/postgres start
```

- タイトルの入力は必須です。

## Author

* taka110
* フィヨルドブートキャンプ
