# メモアプリ

Sinatraで作成した簡単なメモアプリです。Bundlerを使用しています。

## DEMO

<img width="623" alt="top" src="https://user-images.githubusercontent.com/70277776/119724511-c5126680-bea9-11eb-9069-f73889cc2f57.png">

<img width="622" alt="new" src="https://user-images.githubusercontent.com/70277776/119724542-ccd20b00-bea9-11eb-82fa-dc2022912398.png">

<img width="621" alt="show" src="https://user-images.githubusercontent.com/70277776/119724578-d78ca000-bea9-11eb-84db-0719d7f16c97.png">

<img width="618" alt="edit" src="https://user-images.githubusercontent.com/70277776/119724652-f68b3200-bea9-11eb-8795-33b01edd55b0.png">

## Features

- メモ一覧の表示、詳細表示、編集、削除ができます。
- 初回起動時に実行ファイルと同階層に`memos.json`を作成し、メモ内容が記録されます。

## Requirement

* ruby 2.7.2
* Bundler 2.1.4
* sinatra 2.1.0

## Installation

1. インストールするディレクトリに`https://github.com/taka110-IT/memo-app`からcloneする。
2. `bundle init`を実行しGemfileを作成する。
3. Gemfileに`sinatra`を記載する。

```
$ git clone https://github.com/taka110-IT/memo-app <インストールするディレクトリ>

$ bundle init
```

```
# Gemfile

gem 'sinatra'
```

## Usage

1. ターミナルでインストールしたディレクトリに移動し`bundle exec ruby memo_app.rb`を実行する。
2. ブラウザで`http://localhost:4567/memo`に接続する。

## Note

- 初回起動時は新規投稿画面を表示します。
- タイトルの入力は必須です。

## Author

* taka110
* フィヨルドブートキャンプ
