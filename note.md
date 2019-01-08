# メモ

## 6章


### ルーティング
URLによってヘルパーメソッドが作られる

/task -> task_path get,postも判断してくれる

リンクを正しく設定するためにもヘルパーを使う

#### RESTful
リソースは複数形でいい

POST /tasks タスク全体に対して新しいタスクを登録する
GET  /tasks/3 タスク全体に中で3番のものを取ってくる

config/route.rb
resource :tasks で一覧・詳細・登録・更新・削除のルーティングが設定される
cf p235

### locale
config.i18n.default.locale でデフォルト設定
翻訳は I18n.locale で都度設定できる

### log
環境によって書き出されるファイルが変わるようになってる
logger.レベル "もじ"
レベルは debug, unknown, fatal, error とかあってそれを呼び出す
logger.debug "あああ"

マスキング
config/initializer/filter\_parameter\_loggingに設定を書くと[FILTERED]と出るようになる

### セキュリティ
#### Strong Parameters
リクエストパラメータを受け取る際に、想定通りのパラメータかホワイトリストでチェックする。
params.require(:task).permit(:name, :descriptioj)
リクエストに:taskがあるか？ :name,:descriptionだけ通していい、このどちらかが欠けていても構わない

#### CSRF
リクエストの偽造、ログイン状態でないとできない操作を全く別のサイトから実行させる
ex: 買ってもない商品が買ってることになったりとか

だから同じアプリケーションからのリクエストであることを証明させる必要がある。
cf: [【6】CSRF（クロスサイトリクエストフォージェリ：リクエスト強要）って一体何？ どう対策すればいいの？](https://www.scutum.jp/information/web_security_primer/csrf.html)

トークンを発行してリクエストに含めさせることで対策している
POSTする時に使う

form_with で自動的に埋め込まれる

Ajaxの時は csrf_meta_tag で発行し、X-CSRF-Token というヘッダに含めて送る
Rails.csrfToken() で埋め込める

#### インジェクション
ユーザー入力による攻撃

##### XSS
クロスサイトスクリプティング
jsでいたずらする

ブラウザも「同一オリジンポリシー」で気をつけている
あるオリジン（プロトコル+ホスト+ポートの組み合わせ）から他のオリジンへAjax通信ができない

`<script>alert('yo')</script>` のようなjsがフォームから実行できてしまうとまずい。
そのためにHTMKを無害化する
例: `& -> &amp;`

タグをそのまま許可したい時は raw, html_safe などを用いる
sanitize を使えば大体カバーできる

##### SQLインジェクション
例: 
ログインフォームで `' OR '1' ) --` という入力を受け取ってSQLを実行してしまうと
`SELECT * FROM 'user' WHERE (id = '' OR '1') --')` これで全てのIDが抜け出されたりする。

ActiveRecordでは where(hash) でハッシュをわ炊いておけば安全に検索されるようになっている

##### Rubyコードインジェクション
Object#send でRubyのメソッドを呼び出せるが、入力をそのままsendするのは良くない、という話

ホワイトリストでsendに渡していいメソッドを限定しておく

##### コマンドラインインジェクション
Rubyは `` でコマンド実行できるが、 ; rm -rf * とかされるとあかん
Kernel#system, Kernel#spawn, Open3メソッドとかを使うといい

##### CSP(Content Security Policy)を設定する
ブラウザ側でXSS, パケット盗聴などを防ぐ

スクリプト実行を許すドメインを決めたりしておく
レスポンスヘッダにContent-Security-Policyを組み込んでおく

config/initializer/content_security_policy.rb で設定できる

#### アセットパイプライン
js,css,imgを便利に使える仕組み

js,cssは1つに連結されてからhtmlに埋め込まれる

#### 本番環境準備
アセットプリコンパイル Yarnが必要
静的ファイルの設置
DBの用意 database, username, password
config/master.key を確認する rails new したものであれば作られている

#### Credential
production用の秘密情報
APIのキーなどを保存しておく

bin/rails credentials:show,edit で読み書き
元のファイルをいじってもいい事ない

master.keyを使って暗号化しているので書き換えないようにする
