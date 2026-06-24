#!/bin/bash
# check_releases.sh — 範例腳本：抓取最近一個 release 的 tag 與發布時間，並輸出簡短摘要到 stdout

REPO="NousResearch/hermes-agent"
PER_PAGE=1

curl -s "https://api.github.com/repos/${REPO}/releases?per_page=${PER_PAGE}" | \
  jq -r '.[0] | "tag: \(.tag_name)\nname: \(.name)\npublished_at: \(.published_at)\nurl: \(.html_url)\n\nsummary:\n\(.body | .[0:1000])"'
