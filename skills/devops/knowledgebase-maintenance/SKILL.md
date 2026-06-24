---
name: knowledgebase-maintenance
description: 維護多個 Logseq 知識庫（home_work/office_work/fund13/robot_tech）—triage、ingest、lint 修正、profile 對應。
triggers:
  - 知識庫 lint 失敗
  - 新增 ingest 來源
  - 建立或更新 profile
  - 知識庫規範審查
---

# knowledgebase-maintenance

## 知識庫路徑一覽

| 知識庫 | 路徑 | 工作區 | 對應 profile |
|--------|------|--------|-------------|
| home_work | D:\\_oneDrive\\OneDrive_Mirle\\_kb\\home_work | _workspaces\\home_work | secretary |
| office_work | D:\\_oneDrive\\OneDrive_Mirle\\_kb\\office_work | _workspaces\\office_work | secretary |
| fund13 | D:\\_oneDrive\\OneDrive_Mirle\\_kb\\fund13 | _workspaces\\fund13 | fund13-manager/analyst/trader/quant/developer |
| robot_tech | D:\\_oneDrive\\OneDrive_Mirle\\_kb\\robot_tech | _workspaces\\robot_tech | secretary |

判斷規則：相關檔案在 D:\\_oneDrive\\OneDrive_Mirle\\900 下 → office_work；否則 → home_work（或對應知識庫）。

## 規範原則（知識庫通用建構規範）
- **triage-first**：所有 ingest 前先產出 triage 計畫，取得使用者批准
- **append-only**：只在頁面末端 append，不覆蓋既有內容
- **approvals.mode: manual**：寫入前需使用者授權
- **cross-ref minimum**：每個 Wiki___ 正式頁至少 1 個 outgoing `[[link]]`
- **credential-stop**：遇 `token::` / `secret::` / `api-key::` / `password::` 立即停止並通報
- **max 15 pages per ingest**

## 必備頁面結構
每個知識庫 pages/ 下至少需有：
- `Wiki___Schema.md`（type:: schema）
- `Wiki___Index.md`（type:: index）
- `Wiki___Log.md`（type:: log，append-only）
- `Home - <graph>.md`（type:: home）
- `MOC - <graph>.md`（type:: moc）
- `contents.md`（type:: contents）

## Lint 流程（Python / execute_code）

```python
from hermes_tools import read_file, search_files
import re

def lint_graph(base):
    r = search_files("*.md", target="files", path=base + "\\pages")
    pages = [f.split("pages\\")[-1].split("pages/")[-1] for f in r.get("files", [])]
    fails = []
    for p in pages:
        rc = read_file(base + "\\pages\\" + p, limit=60)
        content = rc.get("content", "")
        lines = [l.split("|",1)[1] if "|" in l and l.split("|")[0].strip().isdigit() else l for l in content.split("\n")]
        clean = "\n".join(lines)
        links = re.findall(r'\[\[.*?\]\]', clean)
        if p.startswith("Wiki___") and len(links) == 0:
            fails.append(p)
    return fails
```

### Lint 修正方式
- outgoing link 缺失 → append `相關：[[Home - <graph>]]` 到頁面尾端（patch）
- type:: 缺失 → 在頁面頂端 prepend `type:: <適當type>\nupdated:: YYYY-MM-DD`

## Ingest 標準流程
1. 掃描 raw/ 目錄，讀取來源文件（credential-stop 檢查）
2. 產出 triage 計畫（≤15 頁，列出 target page、來源摘錄、建議 links）
3. 等待使用者批准（approvals.mode: manual）
4. 依序寫入 pages/（append-only）
5. 更新 Wiki___Index.md（append 新頁到末端）
6. 更新 Wiki___Log.md（append 操作紀錄）
7. 執行 lint 驗證

## Profile 建立標準流程
```bash
hermes profile create <name> --clone-from secretary --description "<角色說明>"
```
然後：
1. 編輯 config.yaml，加入 `workdir` 與 `knowledgebase` 路徑
2. 編輯 SOUL.md，定義角色職責、行為準則、共用知識庫路徑
3. 更新記憶（memory tool）記錄新 profile

## fund13 團隊組織
```
hermes-admin
    └── fund13-manager（協調長）
          ├── fund13-analyst（研究分析師）
          ├── fund13-trader（交易執行者）
          ├── fund13-quant（量化策略師）
          └── fund13-developer（開發維護）
```
共用知識庫：D:\\_oneDrive\\OneDrive_Mirle\\_kb\\fund13
共用工作區：D:\\_oneDrive\\OneDrive_Mirle\\_workspaces\\fund13
ALLOW_REAL_TRADING 預設 false，需 hermes-admin 書面授權才可變更。

## Pitfalls
- tab 縮排的 `[[link]]` 可能被 regex 誤判為缺失 → 補加裸 `[[link]]` 確保可靠
- 初建 profile 時 clone-from secretary 可繼承 copilot provider 設定
- workdir/knowledgebase 需手動加入 config.yaml（hermes profile create 不支援直接設定）
- 不可在文件或 registry 存放 secrets；live .env 不可 redact
