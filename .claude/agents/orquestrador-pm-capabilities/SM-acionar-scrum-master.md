# Capability SM — Acionar Scrum Master (Bento)

**Quando usar**: arquitetura aprovada (AR IR = PASS); é hora de fragmentar em stories executáveis.

**Skill invocada**: delegação via Task tool para `@scrum-master` (persona Bento) — capability `SM` única que roteia para sub-capabilities SD/EP/CS/SP/SS.

---

## Pré-condições

- `artifacts/SOFTWARE_ARCHITECTURE.md` + `artifacts/FRONTEND_ARCHITECTURE.md` existem e completos.
- `IMPLEMENTATION_MAP.yaml` v ≥ 1.0.
- `artifacts/READINESS_REPORT.md` = PASS (ou WARN com confirmação).

**Se pré-condição falhar**: Orquestrador aciona Arthur (AR) antes.

---

## Ações Resumidas

1. **Determinar sub-capability**:
   - **SD**: shard de documentos longos (antes de EP se PRD/arquiteturas > 2000 linhas).
   - **EP**: criar `epics.md` (primeira execução).
   - **SP**: inicializar `sprint-status.yaml` (após EP).
   - **CS**: criar próxima story (iterativo após SP — essa é a invocação mais frequente).
   - **SS**: sumário de sprint (status / triagem / integridade).

2. **Disparar Bento via Task tool** (exemplo CS):
   ```typescript
   Task({
     subagent_type: "general-purpose",
     description: "Criar próxima story (Bento)",
     prompt: `
       Você é Bento (Scrum Master). Leia
       .claude/agents/scrum-master-core.md e
       .claude/agents/scrum-master-capabilities/CS-criar-story.md.

       Parâmetros:
       - project_name: "${project_name}"
       - capability: "CS"
       - story_path: null  # auto-discover do sprint-status.yaml

       Execute Steps 1-8 e reporte quando story file estiver em
       ready-for-dev OU quando houver HALT ativo.
     `
   })
   ```

3. **Aguardar retorno de Bento** com:
   - Story file criado em `artifacts/stories/{epic}-{story}-{slug}.md`.
   - Status atualizado no `sprint-status.yaml`.
   - Próximo passo sugerido (`@desenvolvedor IS` ou `SS` para sumário).

4. **Próximo passo comum**: **DV** (acionar Eduardo) para implementar a story criada.

---

## Ordem Típica de Execução (sessão nova de implementação)

```
1. Orquestrador SM → Bento SD (shard de SOFTWARE_ARCHITECTURE + FRONTEND_ARCHITECTURE + PRD)
2. Orquestrador SM → Bento EP (gera epics.md)
3. Orquestrador SM → Bento SP (inicializa sprint-status.yaml)
4. Orquestrador SM → Bento CS (cria primeira story)
5. Orquestrador DV → Eduardo IS (implementa)
6. Orquestrador QC → Iuri RV (revisa)
7. (se Approve) → Orquestrador SM → Bento CS (próxima story) — loop
   (se Changes Requested) → Orquestrador DV → Eduardo RV (follow-up)
```

---

## Handoff Cenários

### Cenário 1 — Bento conclui CS (happy path)

Orquestrador sugere ao usuário:
```
Bento criou story {epic}.{story} ({slug}). Próximo passo:
1. DV (implementar com Eduardo)
2. SS (ver sumário do sprint antes)
```

### Cenário 2 — Bento escala para Arthur (arquitetura insuficiente)

Bento pede: `@arquiteto-de-software Preciso que complete SOFTWARE_ARCHITECTURE §X`.

Orquestrador:
1. Recebe escala.
2. Aciona AR (sub-capability apropriada — provavelmente CA para refinar seção, ou AM para atualizar IMPLEMENTATION_MAP).
3. Após Arthur retornar: retoma SM CS.

### Cenário 3 — Bento escala para Sofia (lacuna em PRD/ANEXO)

Similar — aciona Sofia via capability da Analista, depois retoma SM.

### Cenário 4 — Bento escala para Lexicon (termo técnico novo)

Aciona Lexicon para registrar termo em TERMINOLOGY_MAP, depois retoma SM CS.

### Cenário 5 — sprint-status.yaml corrompido

Bento reporta "sprint-status.yaml corrompido". Orquestrador:
1. Aciona `@assistente-de-projeto` (Sam) para diagnóstico.
2. Se possível restaurar, retoma SM CS.
3. Se precisar regenerar, SM SP com `--regenerate`.

---

## Output Esperado por Sub-capability

| Sub-capability | Output principal |
|----------------|------------------|
| SD | `artifacts/{prd,software-architecture,frontend-architecture}/{index,*}.md` |
| EP | `artifacts/epics.md` com epics + stories BDD |
| SP | `artifacts/sprint-status.yaml` inicializado |
| CS | `artifacts/stories/{epic}-{story}-{slug}.md` status `ready-for-dev` |
| SS | Relatório humano (interactive) OU variáveis estruturadas (data) OU integrity check (validate) |

---

## Detalhes Completos

Ver `.claude/agents/scrum-master-core.md` e pasta `.claude/agents/scrum-master-capabilities/`.
