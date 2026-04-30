# Capability H — Ajuda

**Quando usar**: Usuário pede instruções completas ou quer entender quando invocar cada capability do Arthur.

**Ação**: Apresentar menu expandido com exemplos de invocação.

---

## Menu de Capabilities (expandido)

| Código | Capability | Quando invocar | Pré-condições | Output | Duração |
|--------|-----------|----------------|---------------|--------|---------|
| **CA** | Criar Arquitetura | Primeira vez produzindo arquitetura OU retomada | PRD aprovado + ANEXOS A/B/C + glossários | SOFTWARE_ARCHITECTURE.md + FRONTEND_ARCHITECTURE.md + IMPLEMENTATION_MAP.yaml (v1.0) | 45-120 min |
| **IR** | Prontidão para Implementação | Após CA completa, antes de chamar SM | Todos os artefatos CA existem | READINESS_REPORT.md (PASS/WARN/FAIL) | 10-25 min |
| **AM** | Alimentar Implementation Map | ANEXO mudou OU HALT de SM/Dev/QA apontando gap | IMPLEMENTATION_MAP.yaml existe | IMPLEMENTATION_MAP.yaml atualizado (bump SemVer + changelog) | 5-20 min |
| **H** | Ajuda | Usuário pede instruções | — | Este arquivo | instantâneo |

---

## Exemplos de Invocação

### Pelo usuário diretamente

```
@arquiteto-de-software CA
@arquiteto-de-software IR
@arquiteto-de-software AM
@arquiteto-de-software H
```

### Pelo Orquestrador (Giovanna) via Task tool

```typescript
Task({
  subagent_type: "general-purpose",
  description: "Criar arquitetura (Arthur)",
  prompt: `
    Execute capability CA do arquiteto-de-software.
    Leia .claude/agents/arquiteto-de-software-core.md e
    .claude/agents/arquiteto-de-software-capabilities/CA-criar-arquitetura.md.
    Reporte quando concluído.
  `
})
```

---

## Arquivos Relacionados

- **Core**: `.claude/agents/arquiteto-de-software-core.md` (persona, princípios, menu).
- **Detalhes por capability** (Layer 2 — lazy-loaded):
  - `CA-criar-arquitetura.md`
  - `IR-prontidao-implementacao.md`
  - `AM-alimentar-implementation-map.md`
  - `H-ajuda.md` (este)
- **Templates produzidos pelas capabilities**:
  - `templates/SOFTWARE_ARCHITECTURE-template.md`
  - `templates/FRONTEND_ARCHITECTURE-template.md`
  - `templates/IMPLEMENTATION_MAP-template.yaml`

---

## Fontes de Referência

- `bmad/investigacao/SPEC_arquiteto-de-software.md` (spec consolidada, 626 linhas).
- `bmad/investigacao/V4_LITERAL_QUOTES.md` §1 (Winston V4 como inspiração de persona).
- `bmad/investigacao/AUDITORIA_COMPLETUDE_PRD_ANEXOS.md` (cobertura PRD/ANEXOS × template V4).
