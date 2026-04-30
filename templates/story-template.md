# Story {{epic_num}}.{{story_num}}: {{story_title}}

Status: ready-for-dev

<!-- Ownership (ver SPEC_scrum-master.md §8.1):
  Seções 1-6: Scrum Master (Bento) — owner
  Seção 7: Dev Agent (Eduardo) — exclusivo
  Seção 8: QA-código (Iuri) — exclusivo

  Editores permitidos:
  - Status: Bento (correção), Dev (ready-for-dev → in-progress → review)
  - Story / AC / Dev Notes: Bento (exclusivo)
  - Tasks/Subtasks: Bento (refinamento), Dev (apenas marcar [x])
  - Change Log: Bento, Dev (append), QA-código (append)
  - Dev Agent Record: Dev (exclusivo)
  - QA Results: QA-código (exclusivo)
-->

## Story

As a {{role}},
I want {{action}},
so that {{benefit}}.

## Acceptance Criteria

1. **Given** {{contexto}}, **when** {{ação}}, **then** {{resultado}}.
2. **Given** {{contexto}}, **when** {{ação}}, **then** {{resultado}}.

## Tasks / Subtasks

- [ ] Task 1 (AC: 1)
  - [ ] Subtask 1.1
- [ ] Task 2 (AC: 2)
  - [ ] Subtask 2.1

## Dev Notes

<!--
Regra de ouro (V4 BMAD sm.md / create-next-story.md):
"The dev agent should NEVER need to read the architecture documents."
Cada bloco técnico abaixo DEVE ter [Source: ...]. Se uma categoria não tem
fonte encontrada, declarar explicitamente:
"No specific guidance found in architecture docs for {categoria}. Dev to
confirm with user during implementation."
-->

### Previous Story Insights
{{previous_story_learnings}} <!-- se story_num > 1, senão remover subseção -->

### Data Models
{{data_models_snippet}}
[Source: ANEXO_B_DataModels.md §{{x.y}} DOC-{{nome}}]
[Source: IMPLEMENTATION_MAP.yaml categories.domain_entities where business_term="{{termo}}"]

### API Specifications
{{api_specs_snippet}}
[Source: SOFTWARE_ARCHITECTURE.md §6 REST API Spec]

### Component Specifications
<!-- Só se story é frontend-aware; remover se backend-only -->
{{component_specs}}
[Source: FRONTEND_ARCHITECTURE.md §4 Component Standards]

### File Locations
{{file_paths_new_and_modified}}
[Source: SOFTWARE_ARCHITECTURE.md §8 Source Tree]
[Source: IMPLEMENTATION_MAP.yaml]

### Testing Requirements
{{test_framework_location_coverage}}
[Source: SOFTWARE_ARCHITECTURE.md §12 Test Strategy]
<!-- [Source: FRONTEND_ARCHITECTURE.md §9 Testing Requirements] (se frontend) -->

### Technical Constraints
{{nfrs_aplicaveis}}
[Source: PRD.md §9 NFR-{{xxx}}]
[Source: SOFTWARE_ARCHITECTURE.md §13 Security]

### Git Intelligence
<!-- Best-effort — remover se não há git ou story 1.1 -->
{{ultimos_5_commits_relevantes}}

### Project Structure Notes
- Alinhamento com Source Tree canônico: {{ok|divergências explícitas com justificativa}}

### References
- [Source: PRD.md §{{X}}]
- [Source: ANEXO_{{A|B|C}}.md §{{Y}}]
- [Source: SOFTWARE_ARCHITECTURE.md §{{Z}}]
<!-- Adicionar quantas forem necessárias -->

## Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|

## Dev Agent Record

### Agent Model Used

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List

## QA Results

<!-- Preenchido pelo QA-código (Iuri) capability RV -->
