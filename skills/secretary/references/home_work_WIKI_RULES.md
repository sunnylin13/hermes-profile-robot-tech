WIKI_RULES.md — graph copy for D:\_oneDrive\OneDrive_Mirle\_kb\home_work

Summary:
- append-only: never overwrite or delete existing pages; new content must be appended or new page created.
- triage-first: produce a triage plan listing which pages will be created/updated and wait for user approval before writing.
- approvals.mode: manual: all writes that modify the graph require explicit user approval.
- max 15 pages per ingest: chunk large sources into <=15 page batches.
- cross-ref minimum: each ingested page should include at least one outgoing [[link]] to existing pages; if none possible, mark page as 'exempt' in the triage plan.
- credential-stop: abort ingest when source contains token/password/secret/api-key patterns.

Created-by: Assistant (session)
Source-path: D:\_oneDrive\OneDrive_Mirle\_kb\home_work
Copied-on: 2026-05-23