---
name: onboarding
description: Use when explicitly asked for repository onboarding, documentation-gap assessment, or documentation standardization with selective context and evidence-based status; not for routine exploration during coding tasks.
---

# Repository Onboarding

Discover only what the task needs. Discovery does not authorize documentation
restructuring; load `documentation` when assessing or changing documentation.

1. Inspect structure, instructions, and documentation. Identify technologies from manifests and configuration; skip generated content.
2. Follow the task map to relevant topics and source. Expand only when evidence is missing; do not ingest the entire repository.
3. Identify relevant knowledge gaps, outdated content, and duplication without cataloguing every implementation detail. Distinguish imported originals, conversions, historical drafts, and maintained analysis; do not infer authority from file type or recency. Briefly propose the smallest useful change when relevant.
4. Stop before editing for discovery-only or analysis requests. Make documentation changes only when requested or necessary for the scoped task; migrate layouts only when standardization is explicitly requested. Follow `documentation` for optional top-level documents, optional purpose-based areas, and the generic README entry point. Preserve local AGENTS rules and add selective navigation only when useful.
5. Split independently useful topics without losing facts. Before moves, check incoming and outgoing links plus generator and workflow paths; update affected references within task scope. Preserve source provenance and existing material locations unless migration is requested. Load `architecture` or `runbook` only for relevant topics.
6. Validate consistency and links; report changes, verification limits, and unknowns.

Do not rewrite implementation code. Analysis-only requests stop before editing.
Configuration or CI definitions never prove successful deployment.
Use `notes/` only for valuable developing knowledge, not leftover content; follow
the linked-note rules in `documentation` without creating a separate knowledge system.

| Status | Evidence |
| --- | --- |
| Implemented | Behavior exists in source; operation may be unverified. |
| Configured | Settings exist; provisioning or operation may be unverified. |
| Verified | An observed check confirms the claim within a stated scope and environment. |
| Planned | Explicit future work, not established behavior. |
| Unknown | Insufficient evidence; identify what is missing. |

These distinctions can overlap; they are not lifecycle stages. For verification,
record the check and its date when known, without implying broader success.
