#!/bin/bash
# 本番データベース（D1）の準備（EmDashのマイグレーション）を、Macから最後まで流すスクリプト。
# - 初回デプロイの直後、サイトを開く前に1回実行しておくと、途中で止まるのを防げます。
# - もし途中で止まってロックが残ったときは、表示されたロックIDを付けて実行します:
#     bash scripts/migrate-production.sh <ロックID>
set -euo pipefail
cd "$(dirname "$0")/.."

# wrangler login 済みの認証情報を、この実行の間だけ使う（画面には表示しない）
CLOUDFLARE_API_TOKEN="$(npx wrangler auth token --json 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>console.log(JSON.parse(s).token))')"
CLOUDFLARE_ACCOUNT_ID="$(npx wrangler whoami --json 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>console.log(JSON.parse(s).accounts[0].id))')"
export CLOUDFLARE_API_TOKEN CLOUDFLARE_ACCOUNT_ID

# 本番のD1（wrangler.jsonc の database_id と同じ）
D1_ID="460ed69e-7ed4-44b8-bc4d-3c2fc8a22638"

if [ -n "${1:-}" ]; then
	npx emdash migrate --from-config --d1="$D1_ID" --take-over-lock="$1"
else
	npx emdash migrate --from-config --d1="$D1_ID" --status || true
	npx emdash migrate --from-config --d1="$D1_ID"
fi
