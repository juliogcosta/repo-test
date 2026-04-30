# Capability TR — Revisar Testes

**Quando usar**:
- Análise específica de qualidade/cobertura de testes da story.
- Invocável independentemente (não precisa disparar RV completo).
- Útil em stories onde a preocupação é especificamente testes (ex.: story envolveu refactor; quer confirmar testes ainda são bons).

**Duração**: 15-40 minutos.

**Output**: seção adicional ao Senior Developer Review (AI) (se invocado após RV) OU mini-relatório standalone (se invocado solo).

---

## Pré-condições

- Story file em `Status: review` ou `done` (testes existem).
- File List inclui arquivos de teste (identificáveis por convenção: `*.test.*`, `*.spec.*`, `test_*`, pasta `__tests__/` etc.).
- Test framework configurado no repo.

---

## Steps

### Step 1 — Identificar Testes no File List

1. Ler story file e extrair File List.
2. Classificar cada path:
   - Prod: código de produção.
   - Test: arquivos de teste (matching por convenção).
   - Config: configs (tsconfig, jest.config, etc.).
3. Produzir lista `test_files`.

**Halt**:
- Zero test files na File List → finding HIGH "Nenhum teste introduzido nesta story" + encerra TR com recomendação.

---

### Step 2 — AC ↔ Test Traceability Matrix

Para cada AC da story, identificar quais test files o cobrem.

Técnica:
1. Extrair descrição de cada AC (texto BDD).
2. Para cada test file, procurar (via Grep) referências textuais a:
   - AC IDs (`AC-1`, `AC 2.3`, etc.) em comments ou describe/it blocks.
   - Palavras-chave da AC (nome de entidade, ação, etc.).
3. Produzir matriz:

   | AC | Test files que cobrem |
   |----|------------------------|
   | AC-1 | login.test.ts (describe "valid credentials") |
   | AC-2 | login.test.ts (describe "invalid credentials") |
   | AC-3 | ❌ Não encontrado |

4. Findings:
   - AC sem teste → finding **HIGH** "AC-{N} não tem teste associado".
   - AC referenciado em comment mas sem teste claro → finding MED "AC-{N} mencionado mas cobertura ambígua".

---

### Step 3 — Test Smells

Scan dos arquivos de teste procurando smells comuns:

| Smell | Detecção (heurística) | Severity |
|-------|----------------------|----------|
| **Asserts vazios** | `expect(...)` sem `.to...` / `assert(true)` / `assertThat(x, is(x))` | HIGH |
| **Hardcoded waits** | `sleep(`, `setTimeout`, `Thread.sleep` sem justificativa | MED |
| **Shared state entre testes** | variáveis modificadas fora de beforeEach/afterEach | MED |
| **Mock excessivo** | > 5 mocks em um único teste (fragilidade + teste de mock, não de código) | MED |
| **Test duplication** | 2+ testes com >80% de código idêntico | LOW |
| **Ignored tests** | `.skip`, `xit`, `@Disabled`, `pytest.mark.skip` sem justificativa em comment | MED |
| **Snapshot sem revisão** | snapshot updated-in-same-commit sem justificativa | LOW |
| **Tests com múltiplos asserts desrelacionados** | 1 test function cobre 3+ behaviors distintos | LOW |
| **Naming genérico** | `test1`, `test-foo`, `should work` | LOW |

Cada finding vem com:
- Severity.
- File:line.
- Descrição do smell.
- Sugestão de fix.

---

### Step 4 — Coverage Analysis

1. Se test framework suporta coverage (Jest, pytest-cov, gocover, etc.):
   - Rodar via Bash com flag de coverage.
   - Capturar relatório (lines, branches, functions).
2. Se não suporta ou não configurado: finding MED "Coverage reporting não configurado".
3. Comparar coverage atual vs. target declarado em Dev Notes (§Testing Requirements):
   - Acima do target: OK.
   - Abaixo do target: finding MED/HIGH "Coverage {X}% abaixo do target {Y}%".
4. Identificar arquivos com coverage 0% entre os tocados na story: finding HIGH.

---

### Step 5 — Flakiness Check

1. Rodar test suite **3 vezes consecutivas** via Bash.
2. Comparar resultado:
   - Todos 3 runs PASS iguais → **no flakiness detected**.
   - Algum teste alternando PASS/FAIL → **flaky test detected**.
3. Para cada flaky test: finding **MED** "Teste flaky: {name} — {run 1}/{run 2}/{run 3} results".

**Timeout**: se 3 runs > 15 minutos total, reduzir para 2 runs e reportar "flakiness check parcial (2 runs por timeout)".

---

### Step 6 — Produzir Relatório

Se invocado **como parte de RV**: anexar subseção ao "Senior Developer Review (AI)":

```markdown
### Test Review (TR) — qa-de-codigo

**AC↔Test Traceability**:
{tabela}

**Test Smells**: {N} findings
{lista}

**Coverage**: {pct}% ({target} target)
{gaps por arquivo}

**Flakiness**: {zero OR lista de flaky tests}

**Recomendação TR**: {OK | melhorar cobertura | fix flaky | refactor test smells}
```

Se invocado **solo**: mini-relatório stdout sem modificar story file.

---

## Regras

1. **TR NÃO modifica testes** — só analisa e documenta.
2. **TR NÃO executa novos testes** — só roda suite existente (coverage + flakiness).
3. **TR é complementar a RV**. Se invocado solo, pode resultar em findings que depois alimentam um RV follow-up.

---

## Halt Conditions

- Zero test files → HALT com finding HIGH.
- Test framework não detectável → HALT + pedir comando.
- 3 runs flakiness excedem timeout total de 15 min → seguir com 2 runs e reportar parcial.

---

## Fontes

- `bmad/investigacao/SPEC_qa-de-codigo.md §11 TR`.
- V6 `bmad-testarch-*` skills (trace, test-review, nfr, framework, automate, atdd, ci, test-design).
