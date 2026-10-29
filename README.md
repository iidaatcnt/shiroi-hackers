# 白いハッカース（shiroi-hackers.com）

千葉県白井市のプログラミング教室「白いハッカース」のサイトです。
EmDash（Astro ベースの CMS）で作り、Cloudflare Workers で動かします。

## ページ構成

| URL | 中身 | 管理画面での場所 |
| --- | --- | --- |
| `/` | トップ（名前の由来・教室について・校長・関連サイト＋新着お知らせ） | 固定ページ「トップページ」（スラッグ `home`） |
| `/about` | 教室について（対象年齢・コース・料金・日時・場所は準備中） | 固定ページ「教室について」 |
| `/news` | お知らせ一覧 | お知らせ |
| `/contact` | お問い合わせ（準備中） | 固定ページ「お問い合わせ」 |

文章はすべて管理画面（`/_emdash/admin`）から書き換えられます。

## ローカルで動かす

```bash
npm install
npx emdash secrets generate      # 出力された emdash_enc_v1_... をコピー
echo "EMDASH_ENCRYPTION_KEY=<コピーした値>" > .env
npm run dev
```

http://localhost:4321/_emdash/admin を開き、「Sample content」を選んでセットアップします。

## Cloudflare にデプロイ（今の shiroi-hackers.com はまだ置き換えません）

```bash
npx wrangler login
npm run deploy                              # D1「shiroi-hackers」と R2「shiroi-hackers-media」が自動で作られます
npx wrangler secret put EMDASH_ENCRYPTION_KEY   # .env と同じ値を貼り付け
bash scripts/migrate-production.sh          # サイトを開く前に、データベースの準備を最後まで流す
```

そのあと `https://shiroi-hackers.<サブドメイン>.workers.dev/_emdash/admin` でセットアップします。

ドメイン shiroi-hackers.com への付け替えは、新しいサイトを確認してから行います。
