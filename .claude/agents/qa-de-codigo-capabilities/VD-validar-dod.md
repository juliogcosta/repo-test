# Capability VD — Validar Definition of Done

**Quando usar**: sanity check rápido do DoD (20 itens) sem análise qualitativa profunda. Útil:
- Antes de disparar RV completo (checagem preliminar).
- Como "smoke test" após Dev reportar `review`.
- Para Orquestrador decidir se RV vale a pena (se DoD está ruim demais, vale pedir refactor ao Dev antes).

**Duração**: 5-15 minutos.

**Output**: mini-relatório não-persistido (stdout apenas) com os 20 itens marcados + contagem + recomendação.

---

## Pré-condições

- Story file em `Status: review`.
- File List presente.

---

## Steps

### Step 1 — Load Story

1. Ler story file INTEGRAL.
2. Validar `Status == review` (se não, avisar mas prosseguir — VD é diagnóstico).
3. Extrair File List + Dev Notes.

---

### Step 2 — Auditar 20 Itens DoD

Referência literal: `bmad-dev-story/checklist.md` V6 (traduzido no DoD inline do Eduardo IS-implementar-story.md §Step 9).

#### Grupo 1 — Context & Requirements (4 itens)

- [x]/[ ]/[N/A] **Story Context Completeness** — Dev Notes cobre 8 categorias (ou declara "No specific guidance").
- [x]/[ ]/[N/A] **Architecture Compliance** — implementação segue patterns citados em Dev Notes.
- [x]/[ ]/[N/A] **Technical Specifications** — libs/versions/frameworks de Dev Notes implementados.
- [x]/[ ]/[N/A] **Previous Story Learnings** — se story_num > 1, insights incorporados.

#### Grupo 2 — Implementation Completion (5 itens)

- [x]/[ ]/[N/A] **All Tasks Complete** — todas `[x]`.
- [x]/[ ]/[N/A] **Acceptance Criteria Satisfaction** — cada AC coberto.
- [x]/[ ]/[N/A] **No Ambiguous Implementation** — implementação clara e sem gambiarras.
- [x]/[ ]/[N/A] **Edge Cases Handled** — error conditions e edge cases cobertos.
- [x]/[ ]/[N/A] **Dependencies Within Scope** — só usa deps listadas em story/project-context.md.

#### Grupo 3 — Testing & Quality (7 itens)

- [x]/[ ]/[N/A] **Unit Tests** — added/updated para toda funcionalidade core.
- [x]/[ ]/[N/A] **Integration Tests** — quando story exigir.
- [x]/[ ]/[N/A] **End-to-End Tests** — para critical flows quando story especificar.
- [x]/[ ]/[N/A] **Test Coverage** — atende target em Dev Notes.
- [x]/[ ]/[N/A] **Regression Prevention** — suite completa passa.
- [x]/[ ]/[N/A] **Code Quality** — linting + static analysis passam.
- [x]/[ ]/[N/A] **Test Framework Compliance** — usa framework do projeto.

#### Grupo 4 — Documentation & Tracking (5 itens)

- [x]/[ ]/[N/A] **File List Complete** — todos os arquivos tocados.
- [x]/[ ]/[N/A] **Dev Agent Record Updated** — Implementation Plan, Debug Log, Completion Notes.
- [x]/[ ]/[N/A] **Change Log Updated** — entry da sessão.
- [x]/[ ]/[N/A] **Review Follow-ups** — se havia (AI-Review items) do ciclo anterior, todos resolvidos.
- [x]/[ ]/[N/A] **Story Structure Compliance** — apenas seções autorizadas modificadas.

#### Grupo 5 — Final Status (4 itens, 1 tem subitem)

- [x]/[ ]/[N/A] **Story Status Updated** — Status = review.
- [x]/[ ]/[N/A] **Sprint Status Updated** — sprint-status.yaml transição em `review`.
- [x]/[ ]/[N/A] **Quality Gates Passed** — tudo acima OK.
- [x]/[ ]/[N/A] **No HALT Conditions** — sem blockers ativos.
- [x]/[ ]/[N/A] **User Communication Ready** — reporte do Dev claro.

---

### Step 3 — Mini-Relatório

```
VD — Definition of Done Check

Story: {story_key}
Data: {ISO}

Grupo 1 — Context & Requirements:      4/4 ✅
Grupo 2 — Implementation Completion:   4/5 ⚠️  (Edge Cases [ ])
Grupo 3 — Testing & Quality:           5/7 ⚠️  (Coverage [ ], E2E [N/A mas sem justificativa])
Grupo 4 — Documentation & Tracking:    5/5 ✅
Grupo 5 — Final Status:                5/5 ✅

TOTAL: 23/25 (92%)

Recomendação:
  ≥ 20/20 itens [x] → pronto para RV completo
  18-19/20       → RV vai prosseguir (ajustes menores durante review)
  < 18/20        → sugerir ao @desenvolvedor completar DoD antes de RV

Neste caso: 18/20 itens [x] (2 [ ] + 5 [N/A parcialmente OK)
Recomendação: prosseguir para RV mas Dev deve cobrir Edge Cases primeiro.
```

---

## Regras

1. **VD NÃO modifica story file** — é diagnóstico puro, stdout only.
2. **VD NÃO injeta "Senior Developer Review (AI)"** — essa é função de RV (análise qualitativa).
3. **VD NÃO emite veredito** (Approve/Changes/Blocked) — só indicador quantitativo.
4. **VD é complementar a RV**, não substituto. VD dá visão rápida; RV é a revisão com análise de AC fresh, regression suite, architecture compliance etc.

---

## Halt Conditions

- Story file inacessível → HALT.
- Parse markdown falha → HALT + reportar linha.

---

## Fontes

- `bmad/investigacao/SPEC_qa-de-codigo.md §11 VD`.
- V6 `bmad-dev-story/checklist.md` (DoD oficial).
