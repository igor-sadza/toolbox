---
name: architecture
description: Use when analyzing, reviewing, or documenting system architecture, components, dependencies, data flows, network paths, or significant technical decisions with repository-backed evidence and short ADRs.
---

# Architecture and Decisions

Load `documentation` for writing and routing: design belongs under
`docs/architecture/`, with topic subdirectories only when useful. Link to reference
and playbooks instead of duplicating settings catalogues or procedures.
Analysis-only requests do not require creating documents or ADRs.

- Read relevant source and configuration, not the entire repository. Link to evidence.
- Describe components, dependencies, data flows, network paths, and trust boundaries only as evidenced.
- Separate implemented or configured behavior from verified operation and proposals; mark unknowns.
- Explain meaningful trade-offs without inventing historical rationale.
- Use concise Mermaid diagrams only when useful; keep labels and relationships consistent with source.

## Decisions

When recording significant decisions, follow existing ADR conventions, or use
the next unused identifier under `docs/architecture/decisions/`
(`0001-topic.md` for the first ADR). Create the directory only with an ADR.
Each short ADR has **Context**, **Decision**, **Consequences**, and **Date**.
State unknown dates and label proposals; never invent approval.
Preserve accepted history: record changed decisions in a new ADR and link both records.

Verify source links, claims, decision status, and diagram syntax; report rendering
or runtime checks that were not performed.
