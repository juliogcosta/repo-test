# Capability ET — Executar Testes

**Quando usar**: usuário pede "roda os testes" sem disparar implementação. Útil para:
- Debug rápido (confirmar estado atual).
- Check de regressão pós-refactor manual.
- Sanity check após pull de remote.

**Duração**: 1-10 minutos (depende do tamanho da suite).

**Output**: relatório passes/fails/skipped + links para failures.

---

## Pré-condições

- Repo com test framework configurado (`package.json`/`pytest.ini`/`go.mod`/`pom.xml` etc.).
- Nenhuma — não requer story file nem sprint-status.

---

## Steps

### Step 1 — Detectar Test Framework

**Actions**:
1. Glob por indicadores comuns:
   - `package.json` → Node.js (npm/yarn/pnpm test; jest/vitest/mocha).
   - `pytest.ini` / `pyproject.toml` com pytest → pytest.
   - `go.mod` → `go test ./...`.
   - `pom.xml` → `mvn test`.
   - `build.gradle*` → `./gradlew test`.
   - `Cargo.toml` → `cargo test`.
   - `Gemfile` com rspec → rspec.
   - Outros: usar Read em `README.md` para detectar comando declarado.
2. Se múltiplos frameworks: perguntar ao usuário qual rodar.

**Halt**:
- Nenhum framework detectado → HALT + pedir comando explícito.

---

### Step 2 — Executar Suite

**Actions**:
1. Rodar comando via Bash.
2. Capturar stdout + stderr + exit code.
3. Timeout padrão: 10 minutos (suite grande). Ajustar se necessário.
4. **NUNCA** usar flags que pulem testes (ex.: `--skip`, `-k`) sem autorização explícita do usuário.

---

### Step 3 — Parsear Resultado

**Actions**:
1. Extrair counts:
   - Passed.
   - Failed.
   - Skipped (se framework suporta).
   - Errored (se distingue de failed).
2. Para cada failed: capturar nome do teste + file:line + primeiras linhas de stacktrace.
3. Calcular coverage se framework suporta e `--coverage` foi default.

---

### Step 4 — Reportar

**Formato**:

```
ET — Test Suite Report

Framework: {detected}
Command: {command}
Duration: {seconds}s

Passed:   {N}
Failed:   {M}
Skipped:  {K}
Errored:  {E}

Coverage (se aplicável): {pct}%

Failures:
1. {test_name}
   File: {path:line}
   Error: {first_2_lines_stacktrace}

2. ...

Exit code: {0|1}
```

**Se suite passa 100%**: mensagem curta `✅ Suite completa: {N} tests PASS`.

**Se há failures**: lista completa, não truncar.

---

## Regras

1. **ET NÃO modifica código** — é read-only (executa + reporta).
2. **ET NÃO marca `[x]`** em story file — essa é competência de IS/RV.
3. **ET NÃO gasta tempo** fazendo análise de falhas — só reporta; análise é responsabilidade do usuário ou da próxima capability invocada.

---

## Halt Conditions

- Nenhum framework detectável → HALT + pedir comando.
- Timeout de 10 minutos excedido → reportar timeout + sugerir rodar subset.
- Bash falha catastroficamente (OOM, disk full) → reportar + parar.

---

## Fontes

- `bmad/investigacao/SPEC_desenvolvedor.md §11 ET`.
- V4 `dev.md` linha 482 (`*run-tests`).
