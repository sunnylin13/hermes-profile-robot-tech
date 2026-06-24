Session notes: home_work ingest (2026-05-23)

Context:
- Graph path: D:\_oneDrive\OneDrive_Mirle\_kb\home_work
- User assistant name preference: 「杉杉」
- L1 rules enforced: append-only, triage-first, approvals.mode: manual, cross-ref minimum, credential-stop, max 15 pages per ingest.

Actions performed:
1) Read source: 知識庫通用建構規範.md
2) Produced triage plan (split into source page + 4 formal Wiki pages + index updates).
3) After user approval, wrote 5 pages and patched index + log.
4) Generated contents.md draft and, per user instruction, wrote it to pages/ and auto-inserted suggested outgoing links to satisfy lint.

Pitfalls / reminders:
- Always confirm user approval before writing; this user's profile uses approvals.mode: manual.
- Do not register new Hermes profiles for the graph without explicit consent.
- If credential-like strings appear in sources, abort and notify immediately.

Files changed:
- pages/contents.md (written)
- pages/Wiki___Sources___sunnylin-知識庫通用建構規範.md (appended link suggestions)
- pages/Wiki___Index.md (appended link suggestion)
- pages/Home - home_work.md (appended source link)
- pages/MOC - home_work.md (replaced contents.md with source page in MOC list)
- pages/Wiki___Log.md (appended operation entry)

Suggested follow-ups:
- Optionally run a full lint to ensure every Wiki___ page has outgoing links and update updated:: properties consistently.
- Provide a template for contents.md (stored in templates/) to standardize future auto-generation.
