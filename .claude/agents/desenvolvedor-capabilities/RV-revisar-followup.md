# Capability RV — Revisar Follow-up (QA)

**Quando usar**: story teve code-review do QA (Iuri) com veredito `Changes Requested`; existe seção `Senior Developer Review (AI)` no story file com itens `[AI-Review]` em `[ ]` (pendentes).

**Duração estimada**: 30min - 2 horas (depende do número e severidade de findings).

**Output**:
- Correções implementadas no código.
- Follow-ups `[AI-Review]` marcados `[x]` no story file.
- Action items correspondentes em `Senior Developer Review (AI)` marcados resolvidos.
- Change Log com entry de sessão RV.
- Status → `review` novamente (para re-QA).

---

## Pré-condições

- Story file tem seção `Senior Developer Review (AI)`.
- Review outcome = `Changes Requested` (não `Approve` nem `Blocked`).
- Subseção `Review Follow-ups (AI)` existe em Tasks/Subtasks com pelo menos 1 item `[ ]`.
- Status atual: `review` (Dev vai retransicionar para `in-progress`).

---

## Steps

### Step 1 — Detectar Review Context

**Actions**:
1. Ler story file INTEGRAL.
2. Localizar seção `Senior Developer Review (AI)`.
3. Extrair:
   - Review Date.
   - Review Outcome.
   - Action Items (agrupados por severity: High/Med/Low).
   - Total de items + count de checked vs unchecked.
4. Localizar subseção `Review Follow-ups (AI)` em Tasks/Subtasks.
5. Contar items `[ ]` pendentes.

**Halt**:
- Seção `Senior Developer Review (AI)` não existe → HALT: "Não há review pendente. Use IS para implementação fresh."
- Todos items `[x]` → HALT: "Nenhum follow-up pendente. Possivelmente já foi resolvido anteriormente."
- Review outcome = `Approve` → HALT: "Review aprovado; nada a corrigir."
- Review outcome = `Blocked` → HALT + orientar escalar ao Orquestrador.

---

### Step 2 — Priorizar Follow-ups

**Ordem de tratamento** (por severity):
1. **High** (blockers).
2. **Medium** (importantes, não-bloqueadores).
3. **Low** (nice-to-have).

Dentro do mesmo nível, ordem de aparição no story file.

**Regra**: follow-ups `[AI-Review]` têm prioridade ABSOLUTA sobre qualquer task regular ainda pendente. Se houver tasks `[ ]` regulares + follow-ups, primeiro follow-ups.

---

### Step 3 — Transicionar Status

**Actions**:
1. Atualizar Status do story file: `review → in-progress`.
2. Atualizar `sprint-status.yaml` correspondente.
3. Adicionar Change Log entry: `"RV started - {N} review findings to address (Date: {iso})"`.

---

### Step 4 — Implementar Correções

Para cada item `[AI-Review]` em `Review Follow-ups (AI)`:

#### 4.1 Extrair detalhes

1. Severity (High/Med/Low).
2. Description.
3. File:line apontado.
4. Suggested fix (se presente).

#### 4.2 Implementar fix (TDD aplicável)

1. Se fix envolve código novo/lógica:
   - RED: escrever teste que reproduz o problema (se feasible).
   - GREEN: implementar correção.
   - REFACTOR: ajustar sem quebrar.
2. Se fix é refactor simples (rename, tipo, formatação): aplicar direto mas rodar test suite depois.
3. Se fix é documentação: atualizar e validar.

#### 4.3 Rodar validações

- Full test suite após cada fix crítico (evitar acumular regressions).
- Linting + static analysis.

#### 4.4 Marcar resolvido

Após gates passando:

1. Marcar `[x]` no item em `Review Follow-ups (AI)`.
2. Buscar action item correspondente em `Senior Developer Review (AI) → Action Items` (matching por description).
3. Marcar `[x]` nesse action item também.
4. Adicionar em `Dev Agent Record → Completion Notes`:
   ```
   ✅ Resolved review finding [{severity}]: {description}
      Files: {file:line}
      Fix: {short description}
   ```
5. Atualizar File List com files tocados durante o fix.

**Halt**:
- Fix impossível sem clarificação → HALT e pedir guidance ao usuário.
- Fix requer mudança arquitetural → HALT + escalar Orquestrador (provavelmente @arquiteto-de-software AM).
- 3 tentativas frustradas → HALT.

---

### Step 5 — Final Validation

Após todos follow-ups `[x]`:

1. Rodar full regression suite.
2. Confirmar DoD ainda válido (especialmente se fix impactou testes existentes).
3. Atualizar Change Log:
   ```
   "RV completed - {N} findings resolved ({H} High, {M} Med, {L} Low) (Date: {iso})"
   ```
4. Transicionar Status: `in-progress → review`.
5. Atualizar `sprint-status.yaml`.
6. Reportar:
   ```
   Eduardo RV concluído.
   Findings resolvidos: {N}/{N}
   Regression suite: PASS
   Status: review (aguardando re-QA por Iuri)

   Próximo: @qa-de-codigo RV (re-review)
   ```

---

## Regras Críticas

1. **RV NÃO adiciona features**: só corrige findings explícitos. Se durante o fix emergir oportunidade de melhoria, anotar em Completion Notes (`Observed: ...`) mas NÃO implementar.
2. **RV NÃO remove testes**: se fix quebra teste existente, corrigir o código; se teste estava errado, documentar na Completion Notes e discutir com usuário antes de modificar.
3. **RV preserva rastreabilidade**: cada fix citado com file:line original do finding + file:line do novo código.

---

## Fontes

- `bmad/investigacao/SPEC_desenvolvedor.md §11 RV + §4 Step 8 review follow-up handling`.
- V6 `bmad-dev-story/workflow.md` linhas 320-333 (review follow-up logic).
