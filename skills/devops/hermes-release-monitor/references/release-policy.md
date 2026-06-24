# Release Policy — 判定規則與可調閾值

這個檔案定義了 hermes-release-monitor 判定是否要主動通知使用者的規則。預設行為為保守（只在高風險或重大變更時通知）。你可以修改或擴充下面的項目。

# 預設觸發關鍵字（大小寫不敏感）
TRIGGERS = [
  "security",
  "cve",
  "p0",
  "p1",
  "critical",
  "breaking",
  "incompatible",
  "migration",
  "revert",
  "urgent"
]

# 觸發條件（任一成立即通知）
- release.prerelease == false 且 (release tag 與本地版本差 >= major jump)
- release body 含任一 TRIGGERS
- 相關 PR 標記 severity=P0 或 P1（若 API 可得）
- commit 數或 files changed 超過高變更閾值（預設 200 commits 或 500 files）

# 可調閾值（修改後儲存此文件並通知助理）
- MIN_COMMITS_FOR_NOTIFICATION: 200
- MIN_FILES_CHANGED_FOR_NOTIFICATION: 500
- ONLY_SECURITY: false   # 若 true，則只有包含 security/CVE 的 release 才通知
- IGNORE_PATCH: false    # 若 true，則 minor/patch release 不會通知

# 行為
- 當通知被觸發：產生一個短摘要（3–8 行）和一個詳細區塊（包含 changelog 連結、重要 PR/list、推薦的 preflight 指令）。
- 永不自動執行 "hermes update"。在建議更新時，提供選項：1) preflight 檢查 2) 升級 3) 稍後提醒。

# 使用者覆寫
使用者可以在此檔案中修改 `ONLY_SECURITY`、`MIN_COMMITS_FOR_NOTIFICATION` 等變數。修改後我會遵循新設定。
