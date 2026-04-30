# Capability H — Ajuda (Scrum Master)

**Quando usar**: usuário pede instruções completas ou quer entender quando invocar cada capability do Bento.

---

## Menu de Capabilities (expandido)

| Código | Capability | Quando invocar | Pré-condições | Output | Duração |
|--------|-----------|----------------|---------------|--------|---------|
| **SD** | Shard Docs | Antes de EP/CS, para fragmentar docs longos (>2000 linhas) | `npx` disponível; doc markdown existe | `{dirname}/{basename}/` com `index.md` + 1 arquivo por H2 | 2-5 min |
| **EP** | Criar Epics e Stories | Arthur IR = PASS; usuário quer gerar backlog | PRD + ANEXOS + arquiteturas + READINESS_REPORT | `epics.md` com N epics + M stories BDD | 20-60 min |
| **CS** | Criar Story | Preparar próxima story para Dev agent | sprint-status.yaml + epics + arquiteturas + maps | `stories/{epic}-{story}-{slug}.md` status `ready-for-dev` | 15-45 min |
| **SP** | Sprint Planning | Após EP, antes da primeira CS | `epics.md` approved | `sprint-status.yaml` inicial | 5-10 min |
| **SS** | Sprint Status | Sumário / triagem / validação | `sprint-status.yaml` existe | Relatório humano / variáveis estruturadas / integrity report | 1-3 min |
| **H** | Ajuda | Usuário pede instruções | — | Este arquivo | instantâneo |

---

## Exemplos de Invocação

### Pelo usuário diretamente

```
@scrum-master SD           # shardar um doc
@scrum-master EP           # criar epics.md
@scrum-master CS           # criar próxima story do backlog
@scrum-master SP           # inicializar sprint
@scrum-master SS           # ver sumário
@scrum-master H            # ajuda
```

### Pelo Orquestrador (Giovanna) via capability `SM`

```typescript
Task({
  subagent_type: "general-purpose",
  description: "Criar próxima story (Bento)",
  prompt: `
    Execute capability CS do scrum-master.
    Leia .claude/agents/scrum-master-core.md e
    .claude/agents/scrum-master-capabilities/CS-criar-story.md.
    Reporte quando story file estiver em ready-for-dev.
  `
})
```

---

## Ordem típica de execução

```
Arthur CA completa → Arthur IR = PASS
   ↓
Bento SD (shardar se necessário)
   ↓
Bento EP (gera epics.md)
   ↓
Bento SP (inicializa sprint-status.yaml)
   ↓
Bento CS (story-por-story, iterativo)
   ↓
Dev IS (implementa) → QA RV (revisa) → done
   ↓
Bento SS (sumário) e próxima CS
```

---

## Arquivos Relacionados

- **Core**: `.claude/agents/scrum-master-core.md`
- **Capabilities** (Layer 2 — lazy-loaded):
  - `SD-shard-docs.md`
  - `EP-criar-epics-e-stories.md`
  - `CS-criar-story.md` (core operacional)
  - `SP-sprint-planning.md`
  - `SS-sprint-status.md`
  - `H-ajuda.md` (este)
- **Templates produzidos**:
  - `templates/epics-template.md`
  - `templates/story-template.md`
  - `templates/sprint-status-template.yaml`

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md` (696 linhas).
- `bmad/agents/bmad-create-story/` V6 (workflow CS core).
- `bmad/agents/bmad-shard-doc/` V6 (sharding tool).
- `bmad/agents/bmad-sprint-planning/` V6 + `bmad-sprint-status/` V6.
- `V4_LITERAL_QUOTES.md §4 + §6` (Bob V4, story-tmpl ownership).
