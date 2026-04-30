# Capability AR — Acionar Arquiteto (Arthur)

**Quando usar**: PRD aprovado + ANEXOS completos; é hora de produzir arquitetura técnica antes de fragmentar em stories.

**Skill invocada**: delegação via Task tool para `@arquiteto-de-software` (persona Arthur).

---

## Pré-condições

- `artifacts/PRD.md` com `Status: Aprovado`.
- `artifacts/ANEXO_A_ProcessDetails.md` + `ANEXO_B_DataModels.md` + `ANEXO_C_Integrations.md` existem.
- `UBIQUITOUS_LANGUAGE.yaml` e `claude/TERMINOLOGY_MAP.yaml` existem.

**Se pré-condição falhar**: Orquestrador aciona agente upstream antes de disparar Arthur (Sofia para ANEXOS, Lexicon para glossário, capability MP para PRD).

---

## Ações Resumidas

1. **Confirmar pré-condições** (leitura de PROJECT.md + frontmatters dos ANEXOS).

2. **Escolher sub-capability** (default: CA):
   - **CA**: Criar Arquitetura (primeira execução — produz SOFTWARE_ARCHITECTURE + FRONTEND_ARCHITECTURE + IMPLEMENTATION_MAP v1.0).
   - **IR**: Prontidão para Implementação (após CA completa, antes de chamar Bento).
   - **AM**: Alimentar Map (atualização cirúrgica pós-refactor ou HALT de downstream).

3. **Disparar Arthur via Task tool**:
   ```typescript
   Task({
     subagent_type: "general-purpose",
     description: "Criar arquitetura (Arthur)",
     prompt: `
       Você é Arthur (Arquiteto de Software). Leia
       .claude/agents/arquiteto-de-software-core.md e
       .claude/agents/arquiteto-de-software-capabilities/CA-criar-arquitetura.md.

       Parâmetros:
       - project_name: "${project_name}"
       - capability: "CA"
       - output_paths:
         - backend:  "${project_root}/artifacts/SOFTWARE_ARCHITECTURE.md"
         - frontend: "${project_root}/artifacts/FRONTEND_ARCHITECTURE.md"
         - map:      "${project_root}/IMPLEMENTATION_MAP.yaml"

       Execute Steps 1-7 de CA e reporte quando os 3 artefatos estiverem
       completos OU quando houver HALT ativo.
     `
   })
   ```

4. **Aguardar retorno de Arthur** com:
   - Resumo de seções escritas em cada documento.
   - Pendências `[A DEFINIR]` (bloqueantes vs. não-bloqueantes).
   - Próximo passo sugerido (normalmente: AR IR).

5. **Atualizar `PROJECT.md`**:
   - Status → `Arquitetura Definida`.
   - Artefatos gerados: linkar os 3 arquivos.

6. **Próximo passo comum**: **AR IR** (validar prontidão) → **SM** (fragmentar em stories).

---

## Output Esperado

- `artifacts/SOFTWARE_ARCHITECTURE.md` (15 seções, `stepsCompleted` completo).
- `artifacts/FRONTEND_ARCHITECTURE.md` (completo ou "N/A — sem UI").
- `IMPLEMENTATION_MAP.yaml` (v1.0, com entries em categorias essenciais).
- `artifacts/READINESS_REPORT.md` (se AR IR foi executado).

---

## Handoff Cenários

### Cenário 1 — Arthur conclui CA (happy path)

Orquestrador sugere ao usuário:
```
Arthur concluiu arquitetura. Artefatos criados. Próximo passo:
1. AR IR (validar prontidão antes de fragmentar em stories)
2. (pulo de etapa) SM (acionar Bento diretamente — não recomendado)
```

### Cenário 2 — Arthur escala para Sofia (lacuna em ANEXO)

Arthur pede: `@analista-de-negocio Preciso enriquecimento do ANEXO_B`.

Orquestrador:
1. Recebe escala.
2. Aciona Sofia via capability da Analista de Negócio.
3. Após Sofia retornar: retoma AR CA.

### Cenário 3 — Arthur escala para Lexicon (termo novo)

Similar — Orquestrador aciona Lexicon para enriquecer TERMINOLOGY_MAP ou UBIQUITOUS_LANGUAGE, depois retoma.

### Cenário 4 — Arthur IR = FAIL

Orquestrador apresenta ao usuário:
- Eixos com problemas (Cobertura / Consistência / Suficiência).
- Recomendação de ação corretiva (AR CA para refinar seção X, ou ANEXO enriquecimento).

---

## Detalhes Completos

Ver `.claude/agents/arquiteto-de-software-core.md` e pasta `.claude/agents/arquiteto-de-software-capabilities/`.
