# Capability RV — Revisar Código

**Quando usar**: story em `review`; code review completo pós-Dev.

**Duração estimada**: 30-90 minutos.

**Output**:
- Seção "Senior Developer Review (AI)" injetada no story file.
- Subseção "Review Follow-ups (AI)" em Tasks/Subtasks (se Changes Requested).
- Change Log com entry de review.
- Status transition: `review → done` (Approve) / `review → in-progress` (Changes Requested) / `review` (Blocked — escalonamento).

---

## Pré-condições

- Story file em `{IMPLEMENTATION_ARTIFACTS}/stories/{story_key}.md` com Status = `review`.
- File List não vazio.
- Código referenciado por File List existe no working tree.

---

## Steps

### Step 1 — Load Inputs

1. Ler `.claude-context`.
2. Ler story file INTEGRAL — parse todas as 8 seções.
3. Validar `Status == review`. Se não: HALT "Story não está em review (atual: {status})".
4. Extrair File List.
5. Ler `sprint-status.yaml`.

---

### Step 2 — Determine Review Surface

1. Para cada path em File List:
   - Verificar via Glob/Read que o arquivo existe.
   - Classificar: `prod` / `test` / `config` (heurística por extensão/pasta).
2. Se algum path não existir → **finding HIGH**: "File List inconsistente: {path} declarado mas não encontrado".
3. Produzir `review_targets`:
   ```yaml
   - path: "src/auth/login.ts"
     exists: true
     type: prod
   - path: "src/auth/login.test.ts"
     exists: true
     type: test
   ```
4. Se `review_targets` vazio → HALT CRITICAL "Nothing to review".
5. Se `review_targets` > 30 arquivos → avisar + oferecer chunking por diretório.

---

### Step 3 — Fresh Re-Analysis dos Acceptance Criteria

**Regra crítica**: **NÃO ler ainda** `Implementation Notes` nem `Dev Agent Record` nem `Debug Log` do Dev.

1. Ler apenas seções:
   - **Story** (As a / I want / so that).
   - **Acceptance Criteria** (lista BDD).
2. Para cada AC, formular mentalmente:
   - "Como eu implementaria?"
   - "Que arquivos eu mexeria?"
   - "Que testes eu escreveria?"
3. **Só depois** abrir arquivos do `review_targets` e verificar se a implementação do Dev bate com sua hipótese.
4. Registrar divergências:
   - Dev implementou **diferente mas correto** → finding LOW "Implementação alternativa — verificar se documentada em Dev Notes".
   - Dev implementou **incompleto** → finding HIGH "AC {N} não coberto (evidência: {file:line})".
   - Dev implementou **errado** → finding HIGH "AC {N} implementado incorretamente (evidência: {file:line})".
5. **Só aqui**: ler Implementation Notes + Completion Notes. Pode ajustar severity das findings com base no "porquê" do Dev.

---

### Step 4 — Verify DoD (20 itens)

Percorrer os **20 itens** do DoD do Dev (reference: `bmad-dev-story/checklist.md` V6).

Para cada item, marcar:
- `[x]` — cumprido (com evidência file:line ou seção do story file).
- `[ ]` — não cumprido (gera finding).
- `[N/A]` — não aplicável (com justificativa curta).

#### Grupos de 20 itens com severity default

| Grupo | Itens | Severity se não cumprido |
|-------|-------|--------------------------|
| 1. Context & Requirements | 4 (Story Context, Arch Compliance, Tech Specs, Previous Learnings) | MED |
| 2. Implementation Completion | 5 (All Tasks, AC Satisfaction, No Ambiguity, Edge Cases, Deps In Scope) | HIGH |
| 3. Testing & Quality | 7 (Unit/Integration/E2E/Coverage/Regression/Code Quality/Test Framework) | HIGH (regression/coverage) / MED (smell) |
| 4. Documentation & Tracking | 5 (File List, Dev Agent Record, Change Log, Review Follow-ups, Story Structure) | LOW (exceto File List → MED) |
| 5. Final Status | 4 (Story Status, Sprint Status, Quality Gates, No HALT, User Comm Ready) | LOW |

---

### Step 5 — Architecture Compliance Check

**Regra crítica**: Iuri **NÃO lê** `SOFTWARE_ARCHITECTURE.md` nem `FRONTEND_ARCHITECTURE.md`. Confia em **Dev Notes** da story (que o SM/Arthur transpôs).

1. Ler seção "Dev Notes" (Tech Stack, Source Tree, Coding Standards, File Locations).
2. Para cada afirmação em Dev Notes, verificar no código:
   - "Use framework X versão Y" → `grep`/Read para confirmar `package.json`/`pom.xml`/etc.
   - "Source tree: arquivo Y vai em path Z" → verificar File List.
   - "Coding standard: usar padrão K" → inspecionar 1-2 arquivos críticos.
3. Se divergência: finding MED "Dev Notes prescreve {X} mas código implementa {Y} (file:line)".

**Se detectar divergência spec↔código**: marcar veredito preliminar = **Blocked** + registrar escalação. Não prosseguir com Approve/Changes Requested.

---

### Step 6 — Regression Scan

Executar full test suite via **Bash**:

1. Detectar framework:
   - `package.json` com `test` script → `npm test`
   - `pytest.ini` → `pytest`
   - `go.mod` → `go test ./...`
   - `pom.xml` → `mvn test`
   - `Cargo.toml` → `cargo test`
   - Etc.
2. Rodar comando.
3. Timeout padrão: 10 min.
4. Se algum teste falhar: finding **HIGH** "Regression: teste {nome} falhou em {file:line} — {evidência stacktrace}".
5. Se suite vazia ou config quebrada: finding **HIGH** "Test suite não executou: {erro}".
6. Se timeout: avisar + seguir (não HALT; registrar como finding MED).

**Política sobre execução**: QA **pode** rodar testes via Bash. Evidência empírica > confiança no Dev (mitiga alucinação).

---

### Step 7 — Security / Performance / Quality Eyeball

Escolher **1-2 arquivos mais críticos** do `review_targets`.

**Heurística de criticidade**:
- Arquivos com mais linhas alteradas (File List indica, mas sem diff automático, aproximar via tamanho).
- Arquivos que tocam em auth, payment, PII, I/O externo.
- Arquivos de migration (DB).

Passagem visual (NÃO é SAST/DAST completo — deliberadamente superficial):

- **Segurança**: SQL injection, XSS, hardcoded secrets, falta de validação de input.
- **Performance**: loops O(n²) óbvios, I/O em loop, queries N+1.
- **Qualidade**: funções >50 linhas, duplicação evidente, naming ruim.

Cada achado → finding com severity apropriada.

---

### Step 8 — Produce Senior Review + Veredito

#### 8.1 Decidir veredito

Regras:
- **Blocked**: detectou spec↔código divergence; ou 3+ findings CRITICAL; ou ambiente catastroficamente quebrado.
- **Changes Requested**: qualquer finding HIGH OR 5+ findings MED.
- **Approve**: zero HIGH, ≤4 MED, LOW ok. DoD com pelo menos 18/20 `[x]`.

#### 8.2 Injetar seção "Senior Developer Review (AI)"

Via Edit, inserir após Change Log e antes de Dev Agent Record (ver template em core.md):

```markdown
## Senior Developer Review (AI)

**Review Date**: {ISO}
**Reviewer Agent**: qa-de-codigo (Iuri) v1.0
**Review Outcome**: {veredito}

### Summary
{2-4 linhas}

### Action Items
- [ ] **[HIGH]** ... ({file:line}) — Sugestão: ...
...

### Strengths
- ...

### DoD Compliance (20 itens)
{checklist marcado}

### Architecture Compliance
...

### Regression Suite
Comando: `{cmd}`
Resultado: {PASS | N falhas}
```

#### 8.3 Injetar "Review Follow-ups (AI)" (se Changes Requested)

Via Edit, inserir subseção em Tasks/Subtasks:

```markdown
### Review Follow-ups (AI)

- [ ] **[AI-Review][HIGH]** {descrição}
- [ ] **[AI-Review][MED]** {descrição}
- [ ] **[AI-Review][LOW]** {descrição}
```

#### 8.4 Transição de Status

- **Approve**: Status `review → done` + atualizar `sprint-status.yaml`.
- **Changes Requested**: Status `review → in-progress` + atualizar `sprint-status.yaml`.
- **Blocked**: manter Status `review` (não transiciona) + escalar via relatório.

#### 8.5 Append Change Log entry

```markdown
| {ISO date} | review-1 | Senior review completed: {veredito} ({H} HIGH, {M} MED, {L} LOW findings) | qa-de-codigo |
```

#### 8.6 Reportar

```
Review {story_key} concluído.

Veredito: {Approve | Changes Requested | Blocked}
Findings: {H} HIGH, {M} MED, {L} LOW
DoD: {N}/20 itens cumpridos
Regression suite: {PASS | {K} falhas}

Arquivo atualizado: {IMPLEMENTATION_ARTIFACTS}/stories/{story_key}.md
Status: {novo status}

Próximo passo:
  Approve → story done; @scrum-master CS (próxima)
  Changes Requested → @desenvolvedor RV (retornar follow-ups)
  Blocked → escalar ao @orquestrador-pm (provável qa-de-specs ou Arthur AM)
```

---

## File List Policy (graduada — decisão 11.5)

| % ausentes | Severity do finding | Veredito |
|-----------|---------------------|----------|
| 0% | — | procede normalmente |
| <10% | finding MED | procede review |
| 10-50% | finding HIGH | procede review (menos confiança) |
| >50% | finding CRITICAL | **Blocked** (File List corrupto demais) |

---

## Halt Conditions

- Story Status ≠ `review` → HALT (mensagem no Step 1).
- File List vazio / >50% ausentes → Blocked + HALT.
- Contexto contaminado (Iuri gerou o código) → HALT + escalar.
- Parse YAML/markdown falha → HALT + reportar linha do erro.

---

## Fontes

- `bmad/investigacao/SPEC_qa-de-codigo.md §4` (workflow RV completo).
- V6 `bmad-code-review/` (Blind Hunter / Edge Case Hunter / Acceptance Auditor).
- V6 `bmad-dev-story/checklist.md` (DoD 20 pontos).
- V4 `V4_LITERAL_QUOTES.md §11.1` (qa-gate-tmpl do Quinn).
