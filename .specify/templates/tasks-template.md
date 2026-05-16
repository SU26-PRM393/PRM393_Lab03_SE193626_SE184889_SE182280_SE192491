---
description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`

**Prerequisites**: plan.md (required), spec.md (required for user stories),
research.md, data-model.md, contracts/

**Quality Gates**: Every generated task list MUST include constitution checks for
code quality, manual verification, UX consistency, visual polish,
accessibility, and performance validation. Automated tests are not required for
this project and MUST NOT be generated as mandatory tasks.

**Organization**: Tasks are grouped by user story to enable independent
implementation and manual verification of each story. Each user story group
MUST include implementation tasks and validation tasks for the affected journey.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions
- Include the validation method for analyzer/format, UI states, accessibility,
  and performance budgets when applicable

## Path Conventions

- **Single project**: `src/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Flutter app**: `lib/`, platform folders, and asset folders as needed
- **Mobile + API**: `api/src/`, app source under the selected mobile framework
- Paths shown below are samples. Adjust generated tasks to match plan.md.

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration only.

  The /speckit-tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md, ordered by priority
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints or contracts from contracts/
  - Constitution gates for code quality, manual verification, UX, visual
    quality, accessibility, and performance

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and quality tooling

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language/framework] dependencies
- [ ] T003 [P] Configure analyzer, formatting, and linting tools
- [ ] T004 [P] Configure baseline performance profiling command or workflow

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before any user story can
be implemented

**CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks:

- [ ] T005 Setup database schema and migrations framework
- [ ] T006 [P] Implement authentication/authorization framework
- [ ] T007 [P] Setup API routing, client, or platform service boundaries
- [ ] T008 Create base models/entities that all stories depend on
- [ ] T009 Configure recoverable error handling and logging infrastructure
- [ ] T010 Establish shared theme tokens, reusable UI primitives, and accessibility foundations
- [ ] T011 Setup asset budget, data-loading strategy, and performance guardrails
- [ ] T012 Setup environment configuration management

**Checkpoint**: Foundation ready - user story implementation can now begin in
parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) MVP

**Goal**: [Brief description of what this story delivers]

**Independent Validation**: [How to verify this story works on its own]

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create [Entity1] model in lib/models/[entity1].dart
- [ ] T014 [P] [US1] Create [Entity2] model in lib/models/[entity2].dart
- [ ] T015 [US1] Implement [Service] in lib/services/[service].dart (depends on T013, T014)
- [ ] T016 [US1] Implement [feature] in lib/features/[feature]/[file].dart
- [ ] T017 [US1] Add validation and recoverable error handling
- [ ] T018 [US1] Add required loading, empty, error, offline, permission, and success states

### Manual Validation for User Story 1

- [ ] T019 [US1] Run analyzer/format checks for changed Dart files
- [ ] T020 [US1] Verify [journey] manually using [steps/device/browser]
- [ ] T021 [US1] Capture visual evidence for loading, empty, error, offline, permission, and success states
- [ ] T022 [US1] Validate accessibility, responsive layout, and visual polish for [journey]
- [ ] T023 [US1] Profile [journey] against the plan's performance budget

**Checkpoint**: User Story 1 is fully functional and manually verified

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Validation**: [How to verify this story works on its own]

### Implementation for User Story 2

- [ ] T024 [P] [US2] Create [Entity] model in lib/models/[entity].dart
- [ ] T025 [US2] Implement [Service] in lib/services/[service].dart
- [ ] T026 [US2] Implement [feature] in lib/features/[feature]/[file].dart
- [ ] T027 [US2] Integrate with User Story 1 components when needed

### Manual Validation for User Story 2

- [ ] T028 [US2] Run analyzer/format checks for changed Dart files
- [ ] T029 [US2] Verify [journey] manually using [steps/device/browser]
- [ ] T030 [US2] Validate accessibility, responsive layout, visual polish, and performance budget for [journey]

**Checkpoint**: User Stories 1 and 2 work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Validation**: [How to verify this story works on its own]

### Implementation for User Story 3

- [ ] T031 [P] [US3] Create [Entity] model in lib/models/[entity].dart
- [ ] T032 [US3] Implement [Service] in lib/services/[service].dart
- [ ] T033 [US3] Implement [feature] in lib/features/[feature]/[file].dart

### Manual Validation for User Story 3

- [ ] T034 [US3] Run analyzer/format checks for changed Dart files
- [ ] T035 [US3] Verify [journey] manually using [steps/device/browser]
- [ ] T036 [US3] Validate accessibility, responsive layout, visual polish, and performance budget for [journey]

**Checkpoint**: All selected user stories work independently

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring after analyzer/format checks
- [ ] TXXX Visual consistency and polish pass across all affected screens
- [ ] TXXX Accessibility pass across all affected journeys
- [ ] TXXX Performance profiling and optimization across all stories
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - no dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational - may integrate with US1 but remains independently verifiable
- **User Story 3 (P3)**: Can start after Foundational - may integrate with US1/US2 but remains independently verifiable

### Within Each User Story

- Models before services
- Services before endpoints or UI integration
- Core implementation before UX state completion
- Manual verification before story checkpoint
- Accessibility and performance validation before story checkpoint
- Story complete before moving to the next priority when working sequentially

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel within Phase 2
- Once Foundational is done, user stories can run in parallel if staffed
- Different user stories can be assigned to different developers

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and validate User Story 1 manually
5. Demo or release when quality gates pass

### Incremental Delivery

1. Complete Setup and Foundational work
2. Add User Story 1, validate manually, then demo or release
3. Add User Story 2, validate manually, then demo or release
4. Add User Story 3, validate manually, then demo or release
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

1. Team completes Setup and Foundational work together
2. After Foundational completion, assign separate user stories to developers
3. Stories complete, validate, and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a specific user story for traceability
- Each user story must be independently completable and verifiable
- Commit after each task or logical group
- Stop at each checkpoint to validate story quality gates
- Avoid vague tasks, same-file conflicts, and cross-story dependencies that
  prevent independent validation
