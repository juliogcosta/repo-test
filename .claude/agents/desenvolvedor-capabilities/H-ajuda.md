# Capability H — Ajuda (Desenvolvedor)

**Quando usar**: usuário pede instruções completas ou quer entender quando invocar cada capability do Eduardo.

---

## Menu de Capabilities (expandido)

| Código | Capability | Quando invocar | Pré-condições | Output | Duração |
|--------|-----------|----------------|---------------|--------|---------|
| **IS** | Implementar Story | Story em ready-for-dev; entry-point padrão | Story file + sprint-status.yaml | Código + testes + story em Status=review | 1-3 dias |
| **RV** | Revisar Follow-up QA | QA emitiu Changes Requested; follow-ups pendentes | Story file com Senior Developer Review (AI) | Correções + follow-ups [x] + Status=review | 30min-2h |
| **ET** | Executar Testes | Rodar suite sem disparar IS | Test framework no repo | Relatório passes/fails/skipped | 1-10 min |
| **ER** | Explicar Requisito | Clarificar AC/task (pré OU pós impl) | Story file | Explicação tailored, read-only | 2-10 min |
| **H** | Ajuda | Usuário pede instruções | — | Este arquivo | instantâneo |

---

## Exemplos de Invocação

### Pelo usuário diretamente

```
@desenvolvedor IS          # implementar próxima story
@desenvolvedor IS 1-2-auth # implementar story específica
@desenvolvedor RV          # retornar à story pós-QA
@desenvolvedor ET          # só rodar testes
@desenvolvedor ER AC-3     # explicar AC-3 da story atual
@desenvolvedor H
```

### Pelo Orquestrador (Giovanna) via capability `DV`

```typescript
Task({
  subagent_type: "general-purpose",
  description: "Implementar story (Eduardo)",
  prompt: `
    Execute capability IS do desenvolvedor.
    Leia .claude/agents/desenvolvedor-core.md e
    .claude/agents/desenvolvedor-capabilities/IS-implementar-story.md.
    Reporte quando Status=review OU halt ativo.
  `
})
```

---

## Regra de Ouro (relembrar)

**Eduardo NUNCA lê PRD.md, ANEXO_*.md, SOFTWARE_ARCHITECTURE.md, FRONTEND_ARCHITECTURE.md.**

Todo contexto técnico DEVE estar em Dev Notes da story (responsabilidade do Bento/SM no CS).
Se Dev Notes for insuficiente → HALT, escalar ao SM.

---

## Fluxo Típico com Outros Agentes

```
Bento CS → story file (ready-for-dev)
   ↓
Eduardo IS → código + testes + Status=review
   ↓
Iuri RV → Senior Developer Review (AI)
   ↓
   ├── Approve → Status=done
   └── Changes Requested
       ↓
   Eduardo RV → corrige follow-ups → Status=review (re-loop)
```

---

## Arquivos Relacionados

- **Core**: `.claude/agents/desenvolvedor-core.md`
- **Capabilities** (Layer 2 — lazy-loaded):
  - `IS-implementar-story.md` (core operacional, TDD red-green-refactor)
  - `RV-revisar-followup.md` (pós-QA)
  - `ET-executar-testes.md` (utility)
  - `ER-explicar-requisito.md` (read-only)
  - `H-ajuda.md` (este)

---

## Fontes

- `bmad/investigacao/SPEC_desenvolvedor.md` (661 linhas).
- V6 `bmad-dev-story/workflow.md` + `checklist.md`.
- V4 `V4_LITERAL_QUOTES.md §3` (James V4).
- V6 `bmad-agent-dev/SKILL.md` (Amelia).
