---
name: hermes-release-monitor
description: "自動檢查 Hermes 正式 release 與 changelog，基於可設定的判定規則決定是否通知使用者並提供升級建議。"
version: 0.1.0
author: 依杉（Hermes 助手）
license: MIT
tags: [hermes, release, monitoring, update, changelog, automation]
---

# Hermes Release Monitor

這個技能（skill）幫你自動檢查 NousResearch/hermes-agent 的正式 release 與 changelog，並依使用者偏好判斷是否需要通知與建議升級步驟。設計上強調：**主動檢查 + 非破壞性**，在任何會改動系統（如執行 hermes update）之前都會要求使用者確認。

用途
- 定期或在 detect 到新 release 時抓取 release notes
- 自動分析變更點（安全修補、P0/P1、breaking changes、major/minor、重要新功能）
- 當判定「有更新必要」時，主動通知使用者並列出原因、風險與建議步驟
- 當判定「非必要」時，安靜忽略（不打擾使用者）

核心行為（預設邏輯）
1. 檢查來源：GitHub Releases API（https://api.github.com/repos/NousResearch/hermes-agent/releases）
2. 解析 release notes：尋找關鍵字（security, CVE, P0, P1, breaking, incompatible, revert, critical）與版本跳號（major）
3. 判定規則（預設）— 若任一為真則標記為「需要通知」：
   - Release notes 含 "security"、"CVE"、"P0"、"P1"、"critical" 等字眼
   - Release 標記為 prerelease=false 且為 major 版本跳躍（例如 x.0.0）
   - Release body 明示 breaking change / incompatible / migration
   - Release 關聯的 PR 或 issue 包含關鍵性修復（可選：commit 數量或 files changed 超過閾值）
4. 如果沒有命中上述規則，則視為「非必要」，不通知使用者（除非使用者要求詳細摘要）

安全與使用者控制
- 絕不在未經使用者同意下執行 hermes update
- 在建議更新時會提供：備份步驟（備份 HERMES_HOME、snapshot settings）、升級前的 preflight 指令（hermes update --check、git fetch origin --tags、hermes doctor），以及回滾建議
- 使用者可在 references/release-policy.md 裡修改判定閾值或關鍵字

Integration（如何使用）
- 用於自動化：把 scripts/check_releases.sh 加到 cronjob 或 Hermes 的 cronjob（skill）中
- 互動式：當我偵測到新 release 且判定為需要通知時，我會發送摘要並附上選項：
  1) 顯示完整 changelog 摘要與相關 commit/PR，或
  2) 執行 preflight 檢查（hermes update --check）並回報，或
  3) 立刻執行 hermes update（需使用者再次確認）

References & 支援檔案
- references/release-policy.md — 使用者偏好與可調式判定規則（本 skill 的配置檔）
- scripts/check_releases.sh — 範例抓取與摘要腳本（可放入系統 cron 或 Hermes cronjob）
- templates/cronjob.yaml — 範例 cronjob 設定與 prompt

---

If you want the default thresholds changed (e.g. only notify on security/P0/P1 or only on major-version bumps), tell me and I'll update the references/release-policy.md accordingly.
