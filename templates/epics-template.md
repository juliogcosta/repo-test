---
template_version: "1.0"
stepsCompleted: []
currentStatus: draft  # draft | in_elicitation | approved
lastUpdated: "{{iso_date}}"
totalEpics: 0
totalStories: 0
references:
  prd: "artifacts/PRD.md"
  anexo_a: "artifacts/ANEXO_A_ProcessDetails.md"
  anexo_b: "artifacts/ANEXO_B_DataModels.md"
  anexo_c: "artifacts/ANEXO_C_Integrations.md"
  software_architecture: "artifacts/SOFTWARE_ARCHITECTURE.md"
  frontend_architecture: "artifacts/FRONTEND_ARCHITECTURE.md"
  implementation_map: "IMPLEMENTATION_MAP.yaml"
  readiness_report: "artifacts/READINESS_REPORT.md"
---

# Epics — {{project_name}}

**Gerado por**: Bento (scrum-master) capability EP
**Data**: {{iso_date}}
**Fontes**: PRD.md + ANEXO_A/B/C.md + SOFTWARE_ARCHITECTURE.md + FRONTEND_ARCHITECTURE.md + IMPLEMENTATION_MAP.yaml

---

## Sumário

| # | Epic | Jornadas | FRs | Stories | Status |
|---|------|----------|-----|---------|--------|
| 1 | {{Nome Epic 1}} | J-01, J-03 | FR-001..005 | 4 | backlog |
| 2 | {{Nome Epic 2}} | J-02 | FR-006..010 | 3 | backlog |

---

## Epic 1: {{Nome do Epic 1}}

**Valor**: {{descrição curta do valor entregue pelo epic}}
**Jornadas cobertas**: J-01, J-03
**FRs cobertos**: FR-001, FR-002, FR-003, FR-004, FR-005
**Fontes**: [Source: PRD.md §4 J-01], [Source: PRD.md §4 J-03], [Source: PRD.md §8 FR-001..005]

### Story 1.1: {{Título da Story 1.1}}

**Como** {{role}},
**quero** {{action}},
**para que** {{benefit}}.

**Acceptance Criteria**:
1. **Given** {{contexto}}, **when** {{ação}}, **then** {{resultado}}.
2. **Given** {{contexto}}, **when** {{ação}}, **then** {{resultado}}.

**Source Hints** (Bento usará ao criar story file via CS):
- [Source: PRD.md §8 FR-001]
- [Source: ANEXO_B_DataModels.md §2.3 DOC-{{nome}}]
- [Source: SOFTWARE_ARCHITECTURE.md §4 Components → {{ComponentName}}]
- [Source: IMPLEMENTATION_MAP.yaml categories.domain_entities where business_term="{{termo}}"]

**Frontend-aware**: não  <!-- sim|não — Bento usa heurística para decidir se lê FRONTEND_ARCHITECTURE na CS -->

**Dependências**: nenhuma  <!-- ou: "Requer story 1.0 concluída" -->

**Estimativa**: 1-2 dias (Dev agent com TDD).

---

### Story 1.2: {{Título da Story 1.2}}

**Como** {{role}},
**quero** {{action}},
**para que** {{benefit}}.

**Acceptance Criteria**:
1. **Given** {{contexto}}, **when** {{ação}}, **then** {{resultado}}.

**Source Hints**:
- [Source: PRD.md §8 FR-002]
- [Source: SOFTWARE_ARCHITECTURE.md §6 REST API Spec]

**Frontend-aware**: sim  <!-- exige leitura de FRONTEND_ARCHITECTURE pelo Bento -->

**Dependências**: Requer story 1.1 concluída.

**Estimativa**: 2-3 dias.

---

## Epic 2: {{Nome do Epic 2}}

<!-- Replicar estrutura -->

---

## Inventário de Cobertura

### FRs do PRD §8 cobertos

| FR | Epic.Story | Status |
|----|-----------|--------|
| FR-001 | 1.1 | coberto |
| FR-002 | 1.2 | coberto |
| FR-006 | 2.1 | coberto |
| ... | ... | ... |

### Jornadas do PRD §4 cobertas

| Jornada | Epic(s) | Stories |
|---------|---------|---------|
| J-01 | 1 | 1.1, 1.2 |
| J-02 | 2 | 2.1, 2.2 |
| J-03 | 1 | 1.3, 1.4 |

### Stories órfãs (sem FR/Jornada mapeada)

Nenhuma.  <!-- Ideal: vazio. Se houver, Bento HALT + pedir correção. -->

---

## Notas de Design

<!-- Bento registra aqui decisões que informaram a decomposição: agrupamento por valor vs por camada, granularidade de stories, tratamento de NFRs transversais, etc. -->

- Granularidade de story: 1-3 dias de Dev agent.
- Agrupamento por **valor de usuário** (journey-oriented), não por camada técnica.
- Stories frontend-aware explicitamente flaggadas para Bento consumir FRONTEND_ARCHITECTURE no CS.
