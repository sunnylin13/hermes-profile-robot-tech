---
name: obsidian
description: Read, search, create, and edit notes in the Obsidian vault.
platforms: [linux, macos, windows]
---

# Obsidian Vault

Use this skill for filesystem-first Obsidian vault work: reading notes, listing notes, searching note files, creating notes, appending content, and adding wikilinks.

## Vault path

Use a known or resolved vault path before calling file tools.

The documented vault-path convention is the `OBSIDIAN_VAULT_PATH` environment variable, for example from `~/.hermes/.env`. If it is unset, use `~/Documents/Obsidian Vault`.

File tools do not expand shell variables. Do not pass paths containing `$OBSIDIAN_VAULT_PATH` to `read_file`, `write_file`, `patch`, or `search_files`; resolve the vault path first and pass a concrete absolute path. Vault paths may contain spaces, which is another reason to prefer file tools over shell commands.

If the vault path is unknown, `terminal` is acceptable for resolving `OBSIDIAN_VAULT_PATH` or checking whether the fallback path exists. Once the path is known, switch back to file tools.

## Read a note

Use `read_file` with the resolved absolute path to the note. Prefer this over `cat` because it provides line numbers and pagination.

## List notes

Use `search_files` with `target: "files"` and the resolved vault path. Prefer this over `find` or `ls`.

- To list all markdown notes, use `pattern: "*.md"` under the vault path.
- To list a subfolder, search under that subfolder's absolute path.

## Search

Use `search_files` for both filename and content searches. Prefer this over `grep`, `find`, or `ls`.

- For filenames, use `search_files` with `target: "files"` and a filename `pattern`.
- For note contents, use `search_files` with `target: "content"`, the content regex as `pattern`, and `file_glob: "*.md"` when you want to restrict matches to markdown notes.

## Create a note

Use `write_file` with the resolved absolute path and the full markdown content. Prefer this over shell heredocs or `echo` because it avoids shell quoting issues and returns structured results.

## Append to a note

Prefer a native file-tool workflow when it is not awkward:

- Read the target note with `read_file`.
- Use `patch` for an anchored append when there is stable context, such as adding a section after an existing heading or appending before a known trailing block.
- Use `write_file` when rewriting the whole note is clearer than constructing a fragile patch.

For an anchored append with `patch`, replace the anchor with the anchor plus the new content.

For a simple append with no stable context, `terminal` is acceptable if it is the clearest safe option.

## Targeted edits

Use `patch` for focused note changes when the current content gives you stable context. Prefer this over shell text rewriting.

## Wikilinks

Obsidian links notes with `[[Note Name]]` syntax. When creating notes, use these to link related content.

## Session: home_work ingest (2026-05-23)

- Learned conventions (2026-05-23): triage-first, append-only, approvals.mode: manual are enforced for the user's home_work graph. Prior to any write, produce a triage plan and obtain explicit user approval. Limit ingests to a maximum of 15 pages per session. Immediately halt and notify if any credential-like strings are detected (token:: / password:: / secret:: / api-key::) — do not proceed with ingest.

- User preferences discovered: assistant name preference saved as 「杉杉」; primary graph path: D:\_oneDrive\OneDrive_Mirle\_kb\home_work. These should be referenced by default when working on this user's vault.

- Recommended workflow (embedded as a pitfall + template pointer):
  1) Triage: read source(s), produce a triage plan listing target pages (<=15), proposed splits, and link suggestions. Attach the triage to the user for approval.
  2) On approval: append new pages or sections (never overwrite) using append-oriented patches; update contents.md; append an entry to Wiki___Log.md recording the ingest and links added.
  3) Lint: ensure every 'Wiki___' page has at least one outgoing [[link]]. If missing, suggest sensible outgoing links (prefer [[Home - home_work]] or relevant Wiki___ pages) and add them only after user approval (this session the user allowed automatic link insertion).

- Support files added for reproducibility: references/session-2026-05-23-home_work-ingest.md and templates/contents-template.md

- See references/ and templates/ below for files created in this session.

## Session: office_work ingest & reconciliation (2026-05-23)

- Action taken: created an office_work pages/ scaffold to conform to the same knowledgebase rules (schema, index, log, home, MOC, sources). Scanned existing logseq/bak/ and templates/ and used them as sources for triage.

- New conventions / mapping rules learned (persist into skill guidance):
  • office_work graph path: D:\_oneDrive\OneDrive_Mirle\_kb\office_work (saved to memory as well).
  • Routing rule: any user task whose related files live under D:\_oneDrive\OneDrive_Mirle\900 is considered 'office' — use office_work graph for knowledge organization; otherwise use home_work.
  • Apply the same L1 rules to office_work: triage-first, append-only, approvals.mode: manual, cross-ref minimum, credential-stop, max 15 pages per ingest.

- Recommended office_work workflow (differences & tips):
  1) Detect routing automatically by file path (D:\_oneDrive\OneDrive_Mirle\900 => office_work). If ambiguous, ask.
  2) Prefer reusing existing templates in office_work/templates/ and the logseq/bak/ pages as source material — convert only up to 15 top-level pages per ingest.
  3) When creating index/contents, include clear pointers back to Home - office_work and MOC. Ensure each Wiki___ page has at least one outgoing [[link]]; if none are obvious, default to [[Home - office_work]] as the safe fallback.
  4) Record every automated modification in Wiki___Log.md with date, actor (杉杉), and brief rationale.

- Support files added: references/session-2026-05-23-office_work.md (see references/). Templates: reuse templates/* already present in the office_work repo (daily-task-template.md, wiki-skill-template.md, new-graph-checklist.md).

- Pitfalls & style notes to include in future runs:
  • Do not register new Hermes profiles automatically for a graph; confirm with user first.
  • When many 'bak' pages exist, craft a short triage that groups similar pages to keep the ingest ≤15 pages.
  • Sensitive content detection: if a source page contains credential-like patterns, stop and notify — do not attempt redaction automatically without explicit user instruction.
