# Capability IS — Implementar Story

**Quando usar**: story em `ready-for-dev`; ciclo principal de trabalho do Eduardo.

**Duração estimada**: 1-3 dias (Dev agent com TDD; depende da complexidade da story).

**Output**:
- Código-fonte + testes conforme File Locations em Dev Notes.
- Story file atualizado: Tasks `[x]`, Dev Agent Record preenchido, File List completo, Change Log com entry, Status = `review`.
- `sprint-status.yaml` atualizado: `ready-for-dev → in-progress → review`.

---

## Pré-condições

- Story file existe em `{IMPLEMENTATION_ARTIFACTS}/stories/{story_key}.md`.
- Status = `ready-for-dev` OU `in-progress` (retomada).
- Dev Notes preenchido pelo Scrum Master (Bento).
- `sprint-status.yaml` existe e entry da story está em estado consistente.

---

## Steps

### Step 1 — Find/Load Story

**Goal**: Localizar story alvo e carregar conteúdo completo.

**Actions**:
1. Se usuário forneceu `story_path` explícito, usar direto.
2. Senão, ler `{IMPLEMENTATION_ARTIFACTS}/sprint-status.yaml` COMPLETO.
3. Encontrar PRIMEIRA story (top→down) onde `status == "ready-for-dev"` e chave no padrão `N-M-slug`.
4. Se encontrada: abrir `{IMPLEMENTATION_ARTIFACTS}/stories/{story_key}.md` e ler INTEGRAL.
5. Se não encontrada E `sprint-status.yaml` não existe: varrer `{IMPLEMENTATION_ARTIFACTS}/stories/` por files `*-*-*.md` com `Status: ready-for-dev`.
6. Parsear 8 seções: Story, AC, Tasks/Subtasks, Dev Notes, Dev Agent Record, File List, Change Log, Status.

**Halt conditions**:
- Story file inacessível → HALT: "Cannot develop story without access to story file".
- Zero stories em `ready-for-dev` → apresentar menu:
  1. `@scrum-master CS` (criar próxima story)
  2. Fornecer path explícito
  3. Revisar sprint-status

**CRÍTICO**: Eduardo NUNCA cria story. Responsabilidade do SM (Bento).

*Fonte*: V6 `bmad-dev-story/workflow.md` linhas 53-173.

---

### Step 2 — Load Project Context

**Goal**: Carregar contexto mínimo auxiliar — **apenas `project-context.md` se existir**.

**Actions**:
1. Buscar `**/project-context.md` via Glob.
2. Se existir, carregar como referência auxiliar (convenções project-wide).
3. Se não existir, continuar **apenas com Dev Notes da story**.

**CRÍTICO**: Eduardo NUNCA lê PRD, ANEXOS, SOFTWARE_ARCHITECTURE, FRONTEND_ARCHITECTURE. Se Dev Notes for insuficiente para alguma task, Step 5 entra em HALT.

*Fonte*: V6 `workflow.md` linhas 175-186 + V4 `dev.md` linha 51.

---

### Step 3 — Detect Review Continuation

**Goal**: Detectar se é fresh start ou retomada pós-QA.

**Actions**:
1. Procurar seção `Senior Developer Review (AI)` no story file.
2. Procurar subseção `Review Follow-ups (AI)` em Tasks/Subtasks.
3. Se existirem:
   - `review_continuation = true`.
   - Extrair review outcome (Approve/Changes Requested/Blocked).
   - Contar `[AI-Review]` items com `[ ]` (pendentes).
   - Armazenar lista como `pending_review_items`.
4. Se não existirem: `review_continuation = false`, fluxo normal.

**CRÍTICO**: se `review_continuation = true`, **priorizar follow-ups ABSOLUTAMENTE** sobre tasks regulares. Capability RV seria o padrão; se IS foi invocado mesmo com review continuation, Eduardo alerta e oferece redirect para RV.

*Fonte*: V6 `workflow.md` linhas 188-226.

---

### Step 4 — Mark In-Progress

**Goal**: Atualizar `sprint-status.yaml` marcando story como `in-progress`.

**Actions**:
1. Ler `sprint-status.yaml` FULL.
2. Localizar `development_status[{story_key}]`.
3. Se status == `ready-for-dev` OU `review_continuation == true`: atualizar para `in-progress`.
4. Atualizar `last_updated` para timestamp corrente.
5. Preservar **toda** estrutura e comentários (STATUS DEFINITIONS block incluído).
6. Salvar via Edit (não Write — preserva integridade).

**CRÍTICO**: jamais reescrever o arquivo do zero. Use Edit com strings únicas.

*Fonte*: V6 `workflow.md` linhas 228-261.

---

### Step 5 — Implement Task (Red-Green-Refactor) — CORE

**Goal**: Implementar a task corrente seguindo TDD estrito.

Para cada task `[ ]` (da primeira em diante):

#### 5.1 Planejar

1. Revisar task + subtasks.
2. Identificar AC relacionadas (via `AC: N` mapping).
3. Planejar abordagem usando Dev Notes (File Locations, Data Models, API Spec etc.).
4. Documentar plano em `Dev Agent Record → Implementation Plan`.

#### 5.2 RED — Escrever teste que falha

1. Escrever teste(s) **primeiro**, ANTES de código de produção.
2. Rodar teste(s) e **confirmar que falham**.
3. Se teste passar sem implementação → algo errado; refazer.

#### 5.3 GREEN — Implementar mínimo

1. Implementar **mínimo código** necessário para os testes passarem.
2. Rodar testes e confirmar verdes.
3. Cobrir edge cases e error handling especificados na task.

#### 5.4 REFACTOR — Melhorar estrutura

1. Refatorar mantendo testes verdes.
2. Aderir a padrões em Dev Notes (Coding Standards, Source Tree conventions).
3. Rodar suite completa — confirmar zero regressões.

#### Halt Conditions

- Dep nova não listada em Dev Notes → HALT: "Additional dependencies need user approval".
- **3 falhas consecutivas** de implementação/fix → HALT + pedir guidance.
- Config necessária ausente → HALT: "Cannot proceed without necessary configuration files".
- Dev Notes insuficiente para task → HALT: "Dev Notes missing critical guidance for task N. Escalate to @scrum-master for clarification."

#### CRÍTICO

- **NUNCA** implementar nada não-mapeado a uma task/subtask.
- **NUNCA** prosseguir para próxima task antes da corrente estar completa E testes passando.
- **Executar continuamente** sem pausa até todas tasks completas OU HALT.
- **NÃO propor pausa** para review até Step 9 DoD gates satisfeitos.

*Fonte*: V6 `workflow.md` linhas 263-292 + V4 `dev.md` `order-of-execution`.

---

### Step 6 — Author Comprehensive Tests

**Goal**: Garantir cobertura completa.

**Actions**:
1. Unit tests para business logic core da task.
2. Integration tests para interações de componente (quando story exigir).
3. End-to-end tests para user flows críticos (quando story exigir).
4. Cobrir edge cases e error handling de Dev Notes.

Tests devem seguir Testing Requirements em Dev Notes — framework, coverage target, location.

---

### Step 7 — Run Validations

**Goal**: Executar full test suite + linting + coverage.

**Actions**:
1. Detectar test framework via estrutura do projeto (`package.json` → npm test; `pytest.ini` → pytest; `go.mod` → go test; etc.).
2. Rodar full regression suite via Bash.
3. Rodar linting + static analysis se configurado.
4. Validar implementação atende 100% dos AC da task (quantitative thresholds explícitos).

**Halt**:
- Regression failures → STOP + fix antes de continuar.
- New tests failing → STOP + fix.

---

### Step 8 — Validate & Mark Complete

**Goal**: Gate rígido antes de marcar `[x]`.

**Actions (VALIDATION GATES)**:
1. Verificar **TODOS** os testes para a task EXISTEM e PASSAM 100%.
2. Confirmar implementação bate EXATAMENTE com task (sem features extras).
3. Validar TODOS os AC da task satisfeitos.
4. Rodar full suite — zero regressions.

**Se todos os gates passam**:
- Marcar `[x]` na task (e subtasks).
- Atualizar File List com TODOS os files novos/modificados/removidos (paths relativos).
- Adicionar Completion Notes resumindo o que foi implementado e testado.

**Se qualquer gate falha**:
- **NÃO marcar** `[x]` — fix issues first.
- HALT se impossível de resolver.

**Review follow-up handling** (se `review_continuation == true`):
- Extrair review item details (severity, description).
- Marcar task `[x]` na subseção `Review Follow-ups (AI)`.
- Marcar action item correspondente em `Senior Developer Review (AI) → Action Items` como resolvido.
- Adicionar em Completion Notes: `✅ Resolved review finding [{severity}]: {description}`.

#### CRÍTICO

**NEVER mark a task complete unless ALL conditions are met — NO LYING OR CHEATING.**

Após Step 8:
- Se mais tasks restantes → voltar Step 5 para próxima task.
- Se zero tasks restantes → Step 9.

*Fonte*: V6 `workflow.md` linhas 311-360.

---

### Step 9 — Story Completion & Mark Review

**Goal**: Validar DoD completo e marcar story para code-review.

**Actions**:
1. Re-scan story file: confirmar TODAS as tasks/subtasks `[x]`.
2. Rodar full regression suite (não pular).
3. Confirmar File List inclui cada arquivo changed.
4. Executar **enhanced Definition of Done** (checklist abaixo).
5. Atualizar Status → `review`.

#### Definition of Done (5 grupos)

**1. Context & Requirements**
- [ ] Dev Notes atendido; compliance com architecture patterns citados.
- [ ] Technical specifications de Dev Notes implementados corretamente.
- [ ] Previous Story Insights incorporados (se story_num > 1).

**2. Implementation Completion**
- [ ] Todas tasks/subtasks `[x]`.
- [ ] Cada AC da story satisfeito.
- [ ] Implementação sem ambiguidade.
- [ ] Edge cases e error handling cobertos.
- [ ] Dependencies usadas apenas as listadas em story/`project-context.md`.

**3. Testing**
- [ ] Unit tests para toda funcionalidade core nova/alterada.
- [ ] Integration tests para component interactions (se story exigir).
- [ ] End-to-end tests para critical flows (se story exigir).
- [ ] Coverage atende target em Dev Notes.
- [ ] Zero regressions.
- [ ] Code quality (linting + static analysis) passa.

**4. Documentation**
- [ ] File List inclui TODOS arquivos (relativos à raiz).
- [ ] Dev Agent Record preenchido (Implementation Plan, Debug Log, Completion Notes).
- [ ] Change Log com entry da sessão.
- [ ] Apenas seções autorizadas modificadas.

**5. Final Status**
- [ ] Story Status = `review`.
- [ ] `sprint-status.yaml` atualizado para `review`.
- [ ] Zero HALT ativo.

#### Update `sprint-status.yaml`

- `development_status[{story_key}]`: `in-progress → review`.
- `last_updated`: agora.
- Preservar tudo mais.

**Halt Conditions finais**:
- Qualquer task incompleta → HALT: complete antes de mark review.
- Regression failures → HALT: fix antes.
- File List incompleto → HALT: atualizar.
- DoD falha → HALT + fix.

*Fonte*: V6 `workflow.md` linhas 362-411 + `checklist.md` V6.

---

### Step 10 — Completion Communication

**Goal**: Reportar ao usuário resumo final e próximos passos.

**Actions**:
1. Executar enhanced DoD checklist final.
2. Preparar resumo em `Dev Agent Record → Completion Notes`.
3. Comunicar ao usuário (tom ultra-succinct):
   ```
   Story {story_key} implementada.
   Status: review
   ACs satisfeitos: {N}/{N}
   Files: {N} new, {M} modified
   Tests: {T} added, {R} regression OK
   Coverage: {pct}%
   Commit message sugerido:
     "feat({scope}): {title} ({story_key})"

   Próximo: @qa-de-codigo RV
   ```
4. **NÃO executar** `git commit` — user revisa e commita.

#### CRÍTICO

- Eduardo **sugere** commit message. **Não executa** `git add` nem `git commit`.
- User tem autonomia para revisar changes antes de versionar.

*Fonte*: V6 `workflow.md` linhas 413-448.

---

## Regras de Edição do Story File

**Eduardo PODE modificar** (apenas):
- Tasks / Subtasks → marcar `[x]`; NUNCA reescrever descrição.
- Dev Agent Record → todas subseções (Agent Model, Implementation Plan, Debug Log, Completion Notes, File List).
- Change Log → append de entry.
- Status → transições `ready-for-dev → in-progress → review`.

**Eduardo NÃO PODE modificar**:
- Story statement (As a / I want / so that).
- Acceptance Criteria.
- Dev Notes (incluindo todas subseções).
- References.
- QA Results.
- Project Structure Notes.

Violação = SYSTEM FAILURE.

*Fonte*: V4 `dev.md` linhas 63-65 (`V4_LITERAL_QUOTES.md §3.4`) + V6 `workflow.md` Step §3.

---

## Fontes

- `bmad/investigacao/SPEC_desenvolvedor.md §4` (workflow completo).
- V6 `bmad-dev-story/workflow.md` (10 steps originais, adaptados).
- V6 `bmad-dev-story/checklist.md` (DoD oficial).
- V4 `V4_LITERAL_QUOTES.md §3` (James V4 + regras de edição story file).
