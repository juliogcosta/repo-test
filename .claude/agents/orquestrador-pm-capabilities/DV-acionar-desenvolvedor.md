# Capability DV — Acionar Desenvolvedor (Eduardo)

**Quando usar**: story em `ready-for-dev`; é hora de implementar.

**Skill invocada**: delegação via Task tool para `@desenvolvedor` (persona Eduardo) — capability `IS` default, ou `RV` para follow-up pós-QA, ou `ET`/`ER` utility.

---

## Pré-condições

- `artifacts/stories/{story_key}.md` existe com `Status: ready-for-dev` (ou `in-progress` para retomada; ou `review` com `Senior Developer Review (AI)` presente para RV).
- `artifacts/sprint-status.yaml` existe.

---

## Ações Resumidas

1. **Determinar sub-capability**:
   - **IS**: Implementar Story (default — ciclo principal).
   - **RV**: Revisar Follow-up QA (se story veio com Senior Developer Review Changes Requested).
   - **ET**: Executar Testes (utility — debug/regressão).
   - **ER**: Explicar Requisito (utility — clarificar AC sem implementar).

2. **Confirmar escolha da story**:
   - Se usuário passou `story_path`: usar direto.
   - Senão: Orquestrador lê sprint-status.yaml e sugere primeira em `ready-for-dev` (no caso de IS) ou em `review` com follow-ups (no caso de RV).

3. **Disparar Eduardo via Task tool** (exemplo IS):
   ```typescript
   Task({
     subagent_type: "general-purpose",
     description: "Implementar story (Eduardo)",
     prompt: `
       Você é Eduardo (Desenvolvedor). Leia
       .claude/agents/desenvolvedor-core.md e
       .claude/agents/desenvolvedor-capabilities/IS-implementar-story.md.

       Parâmetros:
       - project_name: "${project_name}"
       - capability: "IS"
       - story_path: null  # auto-discover de sprint-status.yaml

       Execute Steps 1-10 (ciclo red-green-refactor) e reporte quando
       Status=review OU quando houver HALT ativo.

       ATENÇÃO: Eduardo NÃO usa Forger/MCP e NÃO lê PRD/ANEXOS/arqui-
       teturas diretamente. Contexto técnico vem de Dev Notes da story.
     `
   })
   ```

4. **Aguardar retorno de Eduardo** com:
   - Story key + ACs satisfeitos + File List + tests added.
   - Status final (`review` se happy path, `in-progress` se HALT).
   - Commit message sugerida (Eduardo NÃO executa commit).

5. **Próximo passo comum**: **QC** (acionar Iuri) para revisar código antes de marcar done.

---

## Handoff Cenários

### Cenário 1 — Eduardo conclui IS (happy path)

Orquestrador sugere ao usuário:
```
Eduardo concluiu story {story_key}. Status: review.
Tests: {T} added, regression PASS.

Commit message sugerida:
  feat({scope}): {title} ({story_key})

Próximo passo:
1. QC (acionar Iuri para revisar — recomendado ANTES do git commit)
2. git commit manual com a message sugerida (user decide)
```

**IMPORTANTE**: Eduardo jamais executa `git commit`. User revisa + commita.

### Cenário 2 — Eduardo em HALT (dep nova)

Eduardo pede: "Additional dependencies need user approval: {lib}".

Orquestrador:
1. Apresenta ao usuário.
2. Se autorizado: atualiza story Dev Notes com dep + retoma Eduardo IS.
3. Se não: escala ao Arthur via AR AM (refinar arquitetura) ou EA (editar PRD/constraints).

### Cenário 3 — Eduardo em HALT (3 failures consecutivos)

Eduardo pede guidance. Orquestrador:
1. Examina Debug Log do Eduardo.
2. Se causa for Dev Notes insuficiente: escala ao SM (Bento) para refinar story (capability CS via @scrum-master).
3. Se causa for arquitetura incompleta: escala ao Arthur (AR).
4. Se outra: engaja usuário diretamente para decidir.

### Cenário 4 — Eduardo RV (revisar follow-up pós-QA)

Sequência:
- Iuri retornou story com `Senior Developer Review (AI)` = Changes Requested.
- Orquestrador dispara DV com sub-capability RV.
- Eduardo lê follow-ups `[AI-Review]`, implementa correções, Status = `review` novamente.
- Loop: Orquestrador dispara QC novamente.

---

## Output Esperado (capability IS)

- Código + testes (conforme File List da story).
- Story file atualizado:
  - Tasks `[x]`.
  - Dev Agent Record preenchido (Implementation Plan, Debug Log, Completion Notes).
  - File List completa.
  - Change Log com entry da sessão.
  - Status = `review`.
- `sprint-status.yaml`: story `ready-for-dev → in-progress → review`.

---

## Regra de Ouro (recordar ao usuário)

Eduardo é **stateless**. Não carrega contexto entre stories. Cada sessão começa do zero lendo o story file.

**Eduardo NUNCA lê PRD, ANEXOS, SOFTWARE_ARCHITECTURE, FRONTEND_ARCHITECTURE diretamente.** Todo contexto técnico DEVE estar em Dev Notes da story (responsabilidade do Bento).

Se Eduardo reportar "Dev Notes insuficiente" → escalar ao SM (Bento) para refinar.

---

## Detalhes Completos

Ver `.claude/agents/desenvolvedor-core.md` e pasta `.claude/agents/desenvolvedor-capabilities/`.
