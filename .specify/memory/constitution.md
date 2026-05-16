<!--
Sync Impact Report
Version change: 1.0.0 -> 2.0.0
Modified principles:
- II. Testable Feature Boundaries -> II. Verification Without Mandatory Tests
- Development Workflow And Review Gates updated to remove required test work
Added sections:
- None
Removed sections:
- None
Templates requiring updates:
- .specify/templates/plan-template.md: updated
- .specify/templates/spec-template.md: updated
- .specify/templates/tasks-template.md: updated
- .specify/templates/constitution-template.md: updated
- .specify/templates/commands/*.md: not present in this repository
Runtime guidance reviewed:
- README.md: no principle references to update
- AGENTS.md: no principle references to update
Follow-up TODOs:
- None
-->

# VietNam-Map-Flutter Constitution

## Core Principles

### I. Code Quality Is Enforced
Dart and Flutter code MUST be formatted, analyzer-clean, null-safe, and readable
before it is considered complete. Business rules, data parsing, map logic, and
state transitions MUST live in focused units instead of being buried inside
large widget build methods. New abstractions MUST remove real duplication,
clarify ownership, or isolate platform and data concerns; speculative layers are
not allowed.

Rationale: the app depends on accurate map behavior and fast iteration, both of
which require code that can be understood, reviewed, and changed without hidden
side effects.

### II. Verification Without Mandatory Tests
Automated tests are not required for this project. Every feature MUST still
define an independently verifiable user journey, clear state boundaries, and
explicit failure states before implementation begins. Acceptance MAY rely on
manual walkthroughs, screenshots, recorded demos, profiling output, reviewer
inspection, or other lightweight evidence appropriate to the change. Reviewers
MUST NOT block a change solely because automated tests are absent.

Rationale: this project prioritizes fast delivery and visual product iteration,
while still requiring enough verification evidence to avoid unclear acceptance.

### III. Consistent User Experience
New screens, flows, controls, and messages MUST reuse the project theme,
navigation patterns, interaction feedback, typography scale, spacing rhythm, and
component behavior unless the specification documents a deliberate product
reason for variation. Loading, empty, error, offline, permission, and success
states MUST be designed as part of the feature, not added after implementation.
User-visible language MUST be concise, consistent, and appropriate for the map
context.

Rationale: consistent interaction patterns let users focus on geography and
tasks instead of relearning the interface screen by screen.

### IV. Beautiful, Purposeful UI
Each user-facing change MUST demonstrate deliberate visual hierarchy, balanced
spacing, legible typography, appropriate iconography, and polished motion or
transitions where motion improves comprehension. Map content, province or
location details, controls, and supporting panels MUST be composed so the main
geographic task remains visually clear. Decorative choices MUST support the
product purpose and MUST not reduce readability, accessibility, or performance.

Rationale: a map app earns trust through clarity and craft; visual quality is a
functional requirement when users inspect spatial information.

### V. Performance Is A Requirement
Every feature plan MUST define measurable performance budgets for the user
journey it changes, including first meaningful render, interaction feedback,
animation or map gesture frame rate, data loading, memory growth, and offline or
poor-network behavior when relevant. Work that can block the UI isolate MUST be
moved, chunked, cached, or deferred. Releases MUST not knowingly introduce
janky gestures, unbounded rebuilds, oversized assets, or synchronous data work
on critical paths.

Rationale: smooth exploration is core to a map experience, and performance
problems quickly become usability problems.

## Product Quality Standards

- Accessibility MUST be part of the acceptance criteria for user-facing work:
  text scaling, color contrast, screen-reader labels, keyboard or assistive
  navigation where supported, and touch targets of at least 48 logical pixels
  for primary controls.
- Responsive behavior MUST cover compact phones, larger phones, tablets where
  supported, orientation changes, safe areas, and dynamic text sizes.
- Visual implementation MUST use theme tokens and shared components for colors,
  typography, spacing, shape, elevation, and controls. One-off styling requires
  a documented product reason in the plan.
- Map and geographic data presentation MUST be accurate, consistently formatted,
  and resilient to missing, partial, stale, or slow-loading data.
- Errors MUST provide clear recovery paths. Silent failures, indefinite loading
  states, and dead-end empty states are not acceptable.

## Development Workflow And Review Gates

- Specifications MUST include user journeys, UX and visual requirements,
  accessibility expectations, edge cases, and measurable performance outcomes.
- Implementation plans MUST pass the Constitution Check before Phase 0 research
  and again after Phase 1 design. Any violation MUST be documented with a
  simpler rejected alternative and an owner for mitigation.
- Task lists MUST include code quality gates, manual verification steps, UX
  consistency checks, visual polish checks, accessibility checks, and
  performance validation for every affected user journey.
- Code review MUST block changes that fail analyzer or formatting checks, hide
  business logic in widgets, introduce inconsistent UI behavior, omit required
  screen states, or lack a credible performance validation path.
- Code review MUST NOT require automated tests as a condition of approval.
- Release readiness MUST include evidence that the primary journeys still meet
  their acceptance criteria and performance budgets.

## Governance

This constitution supersedes conflicting project practices. Feature specs,
plans, tasks, reviews, and release decisions MUST comply with these principles.

Amendments MUST include the proposed text, rationale, affected templates or
runtime guidance, migration impact for active work, and an explicit semantic
version change. The constitution versioning policy is:

- MAJOR: Removes or redefines a core principle, weakens a mandatory gate, or
  creates backward-incompatible governance for active specs.
- MINOR: Adds a principle or materially expands mandatory quality, UX, visual,
  accessibility, or performance requirements.
- PATCH: Clarifies wording, fixes errors, or updates examples without changing
  obligations.

Compliance is reviewed during every plan Constitution Check and every code
review. When a feature cannot satisfy a principle immediately, the plan MUST
record the violation, reason, simpler alternative considered, mitigation owner,
and target resolution date.

**Version**: 2.0.0 | **Ratified**: 2026-05-16 | **Last Amended**: 2026-05-16
