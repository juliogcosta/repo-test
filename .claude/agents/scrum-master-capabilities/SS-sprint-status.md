# Capability SS — Sprint Status

**Quando usar**:
- Usuário pede sumário do sprint ("onde estamos?").
- Orquestrador precisa decidir próxima ação (modo `data`).
- Validar integridade do `sprint-status.yaml` antes de capabilities downstream.

**Duração**: 1-3 minutos.

**3 Modos**:
- **interactive**: relatório humano-legível com counts, riscos e recomendação.
- **data**: retorna variáveis estruturadas (`next_workflow_id`, `next_story_id`, counts) — para Orquestrador.
- **validate**: verifica integridade estrutural do arquivo.

---

## Pré-condições

- `{ARTIFACTS_DIR}/sprint-status.yaml` existe.
- Se ausente → HALT + sugerir `SP` para inicializar.

---

## Modo Interactive

### Step 1 — Parse

1. Ler `sprint-status.yaml` integralmente.
2. Extrair `development_status` — todas as entries.
3. Classificar cada entry:
   - Pattern `epic-N` (apenas) → Epic.
   - Pattern `epic-N-retrospective` → Retrospective.
   - Pattern `N-M-slug` → Story.

### Step 2 — Counts por Status

Produzir tabela:

| Tipo | backlog | ready-for-dev | in-progress | review | done | optional |
|------|---------|---------------|-------------|--------|------|----------|
| Epics | 3 | — | 1 | — | 0 | — |
| Stories | 8 | 2 | 1 | 1 | 3 | — |
| Retrospectives | — | — | — | — | 0 | 4 |

### Step 3 — Detectar Riscos

- **Story stale**: `ready-for-dev` há > 7 dias sem transição → flag.
- **Story órfã**: status ≠ `backlog` mas key não aparece em `epics.md`.
- **Story in-progress sem ready-for-dev predecessor**: anormalidade de workflow.
- **Epic in-progress sem stories com status > backlog**: epic aberto sem trabalho.
- **Dependência violada** (campo `depends_on`): story `ready-for-dev` depende de outra ainda `backlog`.

### Step 4 — Recomendar Próxima Ação

Prioridade (maior → menor):

1. Se há story em `review` → `@qa-de-codigo RV` (revisar)
2. Se há story em `in-progress` → aguardar Dev (nada a fazer no SM)
3. Se há story em `ready-for-dev` → `@desenvolvedor IS` (implementar)
4. Se há story em `backlog` e sem blockers → `@scrum-master CS` (criar próxima)
5. Se epic todo `done` e retrospective `optional` → `@orquestrador-pm` para retrospective
6. Se todos em `done` → celebrar + `RP` (reportar progresso)

### Step 5 — Output

```
Sprint Status — {project_name}

Progresso geral: {X}/{N} stories concluídas ({pct}%)

Epics:
  1. {Nome Epic 1} — in-progress (2/4 stories ready-for-dev)
  2. {Nome Epic 2} — backlog
  ...

Stories por status:
  backlog:        8
  ready-for-dev:  2
  in-progress:    1
  review:         1
  done:           3
  Total:          15

Riscos detectados:
  ⚠️ Story 1-3-feature-c em ready-for-dev há 9 dias (stale)

Próximo passo sugerido:
  Story em review: `2-1-feature-d` — acionar @qa-de-codigo RV
```

---

## Modo Data

Retorna estruturado (não escreve em disco):

```yaml
next_workflow_id: "code-review"  # ou "dev-story", "create-story", "retrospective", "done"
next_story_id: "2-1-feature-d"
counts:
  epics: {backlog: 2, in-progress: 1, done: 0}
  stories: {backlog: 8, ready-for-dev: 2, in-progress: 1, review: 1, done: 3}
risks:
  - {type: "stale", story: "1-3-feature-c", days: 9}
progress_pct: 20.0
```

Útil para o Orquestrador rotear sem mostrar sumário ao usuário.

---

## Modo Validate

Verifica integridade estrutural:

- [ ] `sprint-status.yaml` parse como YAML válido.
- [ ] Campo `development_status` existe e não é vazio.
- [ ] Todos os valores de status ∈ `{backlog, contexted, in-progress, ready-for-dev, review, done, optional}`.
- [ ] Metadados obrigatórios presentes: `generated`, `last_updated`, `project`.
- [ ] Campos `depends_on` (se presentes) apontam para chaves existentes.

Retorna:

```yaml
is_valid: true | false
errors:
  - "development_status is empty"
  - "invalid status 'wip' in key 1-2-feature-a"
suggestions:
  - "Run SP to regenerate"
```

---

## Halt Conditions

- `sprint-status.yaml` ausente → HALT + sugerir SP.
- Parse YAML falha → HALT + reportar linha do erro.
- Em validate: `is_valid: false` com 3+ erros → sugerir SP com `--regenerate`.

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md §5 SS`.
- `bmad/agents/bmad-sprint-status/workflow.md` V6 (3 modos).
