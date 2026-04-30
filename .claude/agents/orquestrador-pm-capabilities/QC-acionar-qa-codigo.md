# Capability QC — Acionar QA-Código (Iuri)

**Quando usar**: story em `review` (Eduardo concluiu implementação); é hora de code review pós-Dev em contexto fresco.

**Skill invocada**: delegação via Task tool para `@qa-de-codigo` (persona Iuri) — capability `RV` default, ou `VD`/`TR` para usos específicos.

---

## Pré-condições

- `artifacts/stories/{story_key}.md` existe com `Status: review`.
- File List da story não vazio.
- Código referenciado por File List existe no working tree.

---

## Ações Resumidas

1. **Determinar sub-capability**:
   - **RV**: Revisar Código (default — review completo com 8 steps).
   - **VD**: Validar DoD (sanity check rápido — útil antes de RV completo).
   - **TR**: Revisar Testes (análise específica: traceability, smells, flakiness).

2. **Disparar Iuri via Task tool** (exemplo RV):
   ```typescript
   Task({
     subagent_type: "general-purpose",
     description: "Revisar código (Iuri)",
     prompt: `
       Você é Iuri (QA de Código). Leia
       .claude/agents/qa-de-codigo-core.md e
       .claude/agents/qa-de-codigo-capabilities/RV-revisar-codigo.md.

       Parâmetros:
       - project_name: "${project_name}"
       - capability: "RV"
       - story_key: "${story_key}"

       Execute Steps 1-8 em contexto FRESCO e reporte veredito
       (Approve/Changes Requested/Blocked) ao final.

       ATENÇÃO: Iuri NÃO lê SOFTWARE_ARCHITECTURE nem FRONTEND_ARCHI-
       TECTURE diretamente — confia em Dev Notes da story. Iuri NÃO
       modifica código; só injeta "Senior Developer Review (AI)" no
       story file.
     `
   })
   ```

3. **Aguardar retorno de Iuri** com:
   - Veredito: Approve / Changes Requested / Blocked.
   - Counts de findings por severity (HIGH/MED/LOW).
   - Story file atualizado com "Senior Developer Review (AI)".
   - Status transition aplicada.

4. **Próximo passo**:
   - **Approve** → story `done`; próxima iteração: **SM CS** (próxima story) OU **RP** (reportar progresso).
   - **Changes Requested** → **DV** (sub-capability RV de Eduardo) para implementar follow-ups.
   - **Blocked** → investigar natureza do bloqueio e escalar apropriadamente.

---

## Handoff Cenários

### Cenário 1 — Veredito Approve (happy path)

Orquestrador:
```
Iuri aprovou story {story_key}. Status: done.
Findings: {H} HIGH, {M} MED, {L} LOW (todos acima do threshold de Approve).

Próximos passos sugeridos:
1. SM CS (criar próxima story do backlog)
2. RP (reportar progresso ao stakeholder)
3. git commit (com a message sugerida pelo Eduardo — Iuri não executa)
```

### Cenário 2 — Veredito Changes Requested

Orquestrador:
```
Iuri solicitou mudanças na story {story_key}.
- {H} findings HIGH
- {M} findings MED
- {L} findings LOW

Story retransicionada: review → in-progress.
Subseção "Review Follow-ups (AI)" injetada em Tasks/Subtasks.

Próximo passo: DV (Eduardo) capability RV — implementar follow-ups.
```

### Cenário 3 — Veredito Blocked

Possíveis causas:
- **Divergência spec↔código** detectada: Orquestrador aciona `qa-de-specs` para validar specs OU Arthur AM para realinhar IMPLEMENTATION_MAP.
- **Contexto contaminado** (Iuri detectou que ajudou a gerar o código): escalar para outro reviewer (humano OU Iuri em sessão completamente limpa).
- **File List >50% ausente**: story file corrompido — escalar ao Bento para refazer via CS ou ao Eduardo para completar File List.
- **Ambiente quebrado** (suite não roda): escalar para investigação de infra.

Para cada, Orquestrador apresenta opção clara ao usuário.

---

## Delimitação vs. `qa-de-specs` (já existente)

| Agente | Fase | Valida | Output |
|--------|------|--------|--------|
| **`qa-de-specs`** (existente) | pré-implementação | PRD.md ↔ spec_*.json | QA_REPORT.md (APROVADO/REPROVADO) |
| **`qa-de-codigo`** (Iuri v3.2.0) | pós-implementação | story file ↔ código + testes | "Senior Developer Review (AI)" no story file (Approve/Changes/Blocked) |

Zero sobreposição. Quando Iuri detecta divergência spec↔código, emite **Blocked** e escala ao Orquestrador — que decide se aciona qa-de-specs (validar spec) ou Arthur AM (realinhar IMPLEMENTATION_MAP) ou outra ação corretiva.

---

## Sub-capabilities

### VD — Validar Definition of Done (sanity check rápido)

Orquestrador pode invocar VD **antes** de RV, especialmente se suspeitar que DoD está parcial (economiza tempo de RV completo).

### TR — Revisar Testes (análise específica)

Útil para:
- Stories focadas em refactor (quer confirmar testes continuam bons).
- Follow-up específico sobre coverage após resolver finding de RV.
- Debug de flakiness reportada em CI.

---

## Output Esperado

- Story file atualizado com:
  - Seção "Senior Developer Review (AI)" injetada.
  - Subseção "Review Follow-ups (AI)" em Tasks/Subtasks (se Changes Requested).
  - Change Log com entry de review.
  - Status transition.
- `sprint-status.yaml` atualizado.

---

## Detalhes Completos

Ver `.claude/agents/qa-de-codigo-core.md` e pasta `.claude/agents/qa-de-codigo-capabilities/`.
