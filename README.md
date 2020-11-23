## 今回ご提案するのはRubyとSeleniumを使った、ブラウザ操作を伴うスクレイピングプログラムです!

毎日、決まった時間になると、いつものwebサイトに行って、いつもの操作をして、いつものデータを確認してるなんてことはありませんか？  
熟練するとブラウザの画面が変わるより速くマウスカーソルを次のクリック位置へ待機させ、ブラウザの反応が遅いと舌打ちなんかしたりして…

そんな作業からあなたを開放するプログラムです。

## 具体的になにができるの？

プログラムが起動すると、事前に作成した訪問リスト（csvファイル）と、挙動を記したプログラム(Rubyというプログラミング言語)に従って、動作します。
具体的には、ログイン制御を伴うwebブラウザを操作を行い、その時点での最新情報を取得して記録、関係者へメール配信し作業ログも残します。

以下、サンプルプログラムからの実行結果です。

1件目でログインしているWEBサイトは、私が Ruby on Rails で作成したwebアプリですが、内容を見るためにはログイン操作が必要となります。つまり、この情報が見られているということは、プログラミングで、対象Webサイトへのログインが成功したということです。
2件目のYahoo!へのアクセスは、特にログインなど不要ですが、接続時点で一番流行っているニュースを取り出しています。

`MacBook-Pro-A:scraping_with_selenium atsushi$ ruby main.rb`

```
--------------------
訪問リスト読み込み中
--------------------
1件目 Taskleaf からデータ取得中… 完了
2020-11-23 23:00:07,Taskleaf,1面を揃える 2020-11-23 07:45:54 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,中段の色を揃える 2020-11-23 07:48:19 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,上面クロスを作る 2020-11-23 07:50:29 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,上面を揃える 2020-11-23 07:51:06 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,6面完成 2020-11-23 07:53:24 +0900 編集削除
--------------------
2件目 yahoo!japan からデータ取得中… 完了
2020-11-23 23:00:11,yahoo!japan,重症331人「第1波」超え最多,3062
2020-11-23 23:00:11,yahoo!japan,武漢に在外公館の開設を検討,390
2020-11-23 23:00:11,yahoo!japan,河野氏 首相になって政策実現,3134
2020-11-23 23:00:11,yahoo!japan,車と衝突 阪急1両目が脱線,NEW
2020-11-23 23:00:11,yahoo!japan,荒む人心 電話相談員の胸中,NEW,166
2020-11-23 23:00:11,yahoo!japan,競馬史に残る 夢の3強対決,1117
2020-11-23 23:00:11,yahoo!japan,横審 白鵬と鶴竜に注意を決議,2109
2020-11-23 23:00:11,yahoo!japan,神尾楓珠 林田真尋と交際報道,2555
--------------------
ログファイル書き込み中… 成功
MacBook-Pro-A:scraping_with_selenium atsushi$ 
MacBook-Pro-A:scraping_with_selenium atsushi$ 
MacBook-Pro-A:scraping_with_selenium atsushi$ cat logfile.txt 
2020-11-23 23:00:07,Taskleaf,1面を揃える 2020-11-23 07:45:54 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,中段の色を揃える 2020-11-23 07:48:19 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,上面クロスを作る 2020-11-23 07:50:29 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,上面を揃える 2020-11-23 07:51:06 +0900 編集削除
2020-11-23 23:00:07,Taskleaf,6面完成 2020-11-23 07:53:24 +0900 編集削除
2020-11-23 23:00:11,yahoo!japan,重症331人「第1波」超え最多,3062
2020-11-23 23:00:11,yahoo!japan,武漢に在外公館の開設を検討,390
2020-11-23 23:00:11,yahoo!japan,河野氏 首相になって政策実現,3134
2020-11-23 23:00:11,yahoo!japan,車と衝突 阪急1両目が脱線,NEW
2020-11-23 23:00:11,yahoo!japan,荒む人心 電話相談員の胸中,NEW,166
2020-11-23 23:00:11,yahoo!japan,競馬史に残る 夢の3強対決,1117
2020-11-23 23:00:11,yahoo!japan,横審 白鵬と鶴竜に注意を決議,2109
2020-11-23 23:00:11,yahoo!japan,神尾楓珠 林田真尋と交際報道,2555
```

## 必要なものは？

 このプログラムを動かすために必要なものを下記に示します。
 (バージョンについては必ず合っていなくても、ある程度近ければ大丈夫だと思います。)

 * ruby 2.6.6
 * selenium-webdriver (3.142.7)

## インストール方法

Rubyのインストール方法については、沢山の素晴らしい記事がありますので、`ruby インストール`などで検索して、そちらを参考になさって下さい。
seleniumのインストールについては、苦い経験のもと、Qiitaへ記事を投稿しましたので、下記リンクの記事にてインストールをしてみて下さい。

[[Ruby]ハマりを最小限に抑えるseleniumの導入方法](https://qiita.com/atsushi0919/items/5502e7cdbdb878947cc9)

## 使い方

事前に`visiting_.csv`というファイルへ訪問先の情報を登録します。（初期状態ではサンプルで id: 2件目まで入っていますが、1行目（タイトル）だけ残して削除して頂いて構いません。）
- id: 基本的に通し番号です。深い意味はないですが重複禁止です。
- name: お好きなお名前で大丈夫です。「○○社 発注情報」 など
- url: 最初にアクセスする場所です。
- userid: 対象URLへ訪問する際の固有のお名前です。webサイトによっては「ID」とか「メルアド」などの場合があります。
- password: 本当に・本当に慎重に。違ってはいけません。あと何回間違ったらアカウントロック等のメッセージがない場合もありますのでご注意を。

一通りの設定が済んだら、下記を実行しましょう。
`ruby main.rb`

## 注意点

webスクレイピングは権利を保証されいてる一方、悪用すると大変なことにもなります。下記の記事を心に刻みましょう。

[- Webスクレイピングの注意事項一覧](https://qiita.com/nezuq/items/c5e827e1827e7cb29011)
[- WEBスクレイピングの技術と懸念事項](https://qiita.com/tetsukick/items/6b4322199d4702047ced)

## ライセンスについて

ライセンスを気にする様なレベルが高いことをしているわけので、特に言うことはありません。
でも、もし誰かの役に立ったのであれば嬉しいので「イイネ」的なものとか批評を頂ければ嬉しいです。

- ツイッター： https://mobile.twitter.com/home?lang=ja
- FB：　https://m.facebook.com/atsushi.hatakeyama?ref=bookmarks
- Qiita： https://qiita.com/atsushi0919
