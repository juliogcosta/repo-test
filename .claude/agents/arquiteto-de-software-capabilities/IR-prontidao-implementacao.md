# Capability IR — Prontidão para Implementação

**Quando usar**:
- Após `CA` completa (todas as seções de `SOFTWARE_ARCHITECTURE.md` concluídas).
- Quando usuário ou Orquestrador quer checar se arquitetura é suficiente para SM (Bento) fragmentar em stories.
- Antes de qualquer handoff para `@scrum-master`.

**Duração estimada**: 10-25 minutos.

**Output**: `{ARTIFACTS_DIR}/READINESS_REPORT.md` com status global **PASS** / **WARN** / **FAIL** + lista de bloqueios e recomendações.

---

## Pré-condições

- `SOFTWARE_ARCHITECTURE.md` existe e frontmatter `stepsCompleted` contém todas as 15 seções.
- `FRONTEND_ARCHITECTURE.md` existe (conteúdo completo OU nota "N/A — sem UI" explícita).
- `IMPLEMENTATION_MAP.yaml` existe (v ≥ 1.0).
- `PRD.md`, `ANEXO_A/B/C.md`, `UBIQUITOUS_LANGUAGE.yaml` existem.

**Se alguma pré-condição falhar**:
- `SOFTWARE_ARCHITECTURE.md` incompleto → retornar para `CA`.
- `FRONTEND_ARCHITECTURE.md` inexistente → retornar para `CA`.
- `IMPLEMENTATION_MAP.yaml` inexistente → retornar para `CA` ou executar `AM` para criar inicial.

---

## Inspiração

Lógica de checklist inspirada em V6 local `bmad-check-implementation-readiness` (ignorando a regressão arquitetural V6 — apenas a lógica de validação aproveita) e V4 `architect-checklist.md`.

---

## Steps

### Step 1 — Load and Parse

1. Ler `SOFTWARE_ARCHITECTURE.md` integralmente (todas as 15 seções).
2. Ler `FRONTEND_ARCHITECTURE.md` integralmente (todas as seções ou nota N/A).
3. Ler `IMPLEMENTATION_MAP.yaml` — parsear todas as `categories.entries`.
4. Ler `PRD.md` — extrair todos os IDs (`FR-*`, `NFR-*`, `modulos[].name`, `documentos[].id`, `comandos[].id`).
5. Ler `ANEXO_A/B/C.md` — extrair aggregate IDs, command IDs, integration IDs.
6. Ler `UBIQUITOUS_LANGUAGE.yaml` — lista de business_terms canônicos.

**Inicializar contadores** para cada eixo (passa/warn/fail).

---

### Step 2 — Validação Cross-Artefato (6 Eixos)

#### Eixo 1 — Cobertura de Requisitos

- [ ] Todo `FR-*` do PRD §8 tem:
  - (a) Component responsável identificado em `SOFTWARE_ARCHITECTURE.md §4` (Components)?
  - (b) Endpoint REST em `§6 REST API Spec` (quando aplicável)?
  - (c) Entry em `IMPLEMENTATION_MAP.yaml` categoria `requirements_traceability` (se existir) OU referência cruzada explícita em alguma categoria?

- [ ] Todo `NFR-*` do PRD §9 está **materializado** em pelo menos uma das seguintes seções:
  - `§11 Infrastructure/Deployment` (NFRs de disponibilidade, escalabilidade).
  - `§14 Security` (NFRs de segurança, LGPD).
  - `§12 Test Strategy` (NFRs de performance testáveis).
  - `§10 Error Handling` (NFRs de resiliência).

**Status**:
- PASS: 100% dos FRs e NFRs cobertos.
- WARN: ≥ 90% cobertos.
- FAIL: < 90% cobertos.

---

#### Eixo 2 — Consistência PRD ↔ SOFTWARE_ARCHITECTURE ↔ FRONTEND_ARCHITECTURE

- [ ] Todos os `modulos` do PRD §10 têm Component correspondente em `SOFTWARE_ARCHITECTURE §4`?
- [ ] Todas as personas do PRD §4 aparecem em pelo menos um Core Workflow `§5`?
- [ ] Se projeto tem UI (FRONTEND_ARCHITECTURE ≠ "N/A"):
  - [ ] Requisitos UI do PRD §4 e §7 têm reflexo em FRONTEND §2-3 (Tech Stack, Component Standards)?
  - [ ] Tech Stack frontend (§2) não contradiz decisões cross-stack do backend `§3` (linguagem, package manager, build target)?

**Status**:
- PASS: 100% consistente.
- WARN: 1-3 inconsistências menores (ex.: módulo sem component mas documentado como futuro).
- FAIL: ≥ 4 inconsistências ou contradição bloqueante.

---

#### Eixo 3 — Consistência ANEXO_B ↔ SOFTWARE_ARCHITECTURE ↔ IMPLEMENTATION_MAP

- [ ] Todo aggregate do ANEXO_B tem entrada em `IMPLEMENTATION_MAP.yaml` categoria `domain_entities` ou `data_models`?
- [ ] Todo command do ANEXO_B tem:
  - (a) Endpoint em `SOFTWARE_ARCHITECTURE §6 REST API Spec`?
  - (b) Entrada em `IMPLEMENTATION_MAP.yaml` (handler + endpoint)?
- [ ] Todo invariant do ANEXO_B tem `validation_file` listado no IMPLEMENTATION_MAP?

**Status**:
- PASS: 100% mapeado.
- WARN: ≥ 90% mapeado.
- FAIL: < 90% mapeado (SM não conseguirá gerar Dev Notes sem fonte).

---

#### Eixo 4 — Consistência ANEXO_C ↔ SOFTWARE_ARCHITECTURE

- [ ] Toda integração do ANEXO_C tem:
  - (a) Tratamento em `SOFTWARE_ARCHITECTURE §10 Error Handling Strategy` (retry, circuit breaker, timeout)?
  - (b) Client em `IMPLEMENTATION_MAP.yaml` categoria `integrations`?
  - (c) Configuração de auth consistente com o declarado no ANEXO?

**Status**:
- PASS: 100% tratado.
- WARN: integrações não-críticas sem tratamento explícito (aceitar com débito).
- FAIL: integração crítica sem tratamento de resiliência.

---

#### Eixo 5 — Suficiência para SM Gerar Stories Auto-contidas

- [ ] `SOFTWARE_ARCHITECTURE §8 Source Tree` está **completo** e suficiente para SM escrever File Locations nas stories sem inventar paths?
- [ ] `§10 Coding Standards` contém regras suficientes (linting, naming, error handling patterns) para Dev gerar código sem deriva?
- [ ] `§12 Test Strategy` contém frameworks + pyramid + location + coverage targets suficientes para Dev escrever testes?
- [ ] Se projeto tem UI:
  - [ ] `FRONTEND_ARCHITECTURE §11 Frontend Developer Standards` contém critical coding rules.
  - [ ] `§9 Testing Requirements` contém component test template + best practices.

**Status**:
- PASS: SM pode gerar stories sem ambiguidade.
- WARN: SM poderá gerar stories com 1-2 perguntas ao usuário (aceitável).
- FAIL: SM ficaria cego — refinar seções indicadas antes de prosseguir.

---

#### Eixo 6 — Ausência de `[A DEFINIR]` Bloqueantes

- [ ] Listar **todos** os marcadores `[A DEFINIR]` em:
  - `SOFTWARE_ARCHITECTURE.md` (grep literal).
  - `FRONTEND_ARCHITECTURE.md` (grep literal).
  - `IMPLEMENTATION_MAP.yaml` (entries com paths marcados como TBD).

- [ ] Classificar cada `[A DEFINIR]` como:
  - **BLOQUEANTE**: impede SM de gerar stories (ex.: Tech Stack sem linguagem escolhida, Source Tree sem estrutura de módulos).
  - **NÃO-BLOQUEANTE**: pode ser refinado em iteração futura (ex.: política de cache em componente não-crítico, escolha fina de lib de validation).

**Status**:
- PASS: zero bloqueantes; ≤ 5 não-bloqueantes registrados em LEARNING_LOG.
- WARN: zero bloqueantes; 6-15 não-bloqueantes.
- FAIL: ≥ 1 bloqueante OU > 15 não-bloqueantes.

---

### Step 3 — Geração do Relatório

Gravar `{ARTIFACTS_DIR}/READINESS_REPORT.md`:

```markdown
# Relatório de Prontidão para Implementação

**Projeto**: {PROJECT_ALIAS}
**Data**: {ISO timestamp}
**Avaliador**: Arthur (Arquiteto de Software v1.0)

**Status Global**: PASS | WARN | FAIL

---

## Resumo Executivo

{2-4 linhas: quantos eixos PASS / WARN / FAIL; recomendação geral.}

---

## Eixos Avaliados

| # | Eixo | Status | Issues |
|---|------|--------|--------|
| 1 | Cobertura de Requisitos (FRs/NFRs) | PASS/WARN/FAIL | N |
| 2 | PRD ↔ Arquitetura (backend + frontend) | ... | N |
| 3 | ANEXO_B ↔ Arquitetura ↔ IMPLEMENTATION_MAP | ... | N |
| 4 | ANEXO_C ↔ Error Handling | ... | N |
| 5 | Suficiência para SM gerar stories | ... | N |
| 6 | Ausência de [A DEFINIR] bloqueantes | ... | N |

---

## Bloqueios (ordenados por severidade)

### 🔴 Bloqueantes (impedem handoff para SM)

1. **[Eixo X]** — {descrição específica} → **Ação**: {capability / agente a acionar}
2. ...

### 🟡 Warnings (prosseguir com cautela; registrar débito)

1. **[Eixo X]** — {descrição} → **Recomendação**: {ação sugerida}
2. ...

---

## Recomendações Não-Bloqueantes

- {item 1}
- {item 2}

---

## Próximo Passo Sugerido

- **PASS** → `@scrum-master SP` (iniciar Sprint Planning) → depois `CS` (criar primeira story).
- **WARN** → prosseguir com cautela; registrar pendências em `LEARNING_LOG.md` via `@orquestrador-pm RL`.
- **FAIL** → ações corretivas:
  - Se bloqueio em Eixo 1-3 → `@arquiteto-de-software CA` refinar seção X.
  - Se bloqueio em Eixo 4 (ANEXO_C) → `@analista-de-negocio C` enriquecer ANEXO_C.
  - Se bloqueio em Eixo 5 → `@arquiteto-de-software CA` refinar §8 Source Tree ou §10 Coding Standards.

---

## Anexo A: Lista Completa de `[A DEFINIR]` Marcados

| Arquivo | Linha | Seção | Tipo | Classificação |
|---------|-------|-------|------|---------------|
| SOFTWARE_ARCHITECTURE.md | 234 | §3 Tech Stack | Versão de lib X | Não-bloqueante |
| ... | ... | ... | ... | ... |
```

---

### Step 4 — Handoff

1. Se **PASS**:
   - Sugerir `@scrum-master SP` ao usuário.
   - Atualizar `PROJECT.md` via Orquestrador: `Status: Pronto para Implementação`.

2. Se **WARN**:
   - Propor plano de correção opcional.
   - Se usuário aceitar prosseguir: acionar Orquestrador capability `RL` para cada pendência não-bloqueante (registra em `LEARNING_LOG.md`).
   - Depois: `@scrum-master SP`.

3. Se **FAIL**:
   - Bloquear handoff.
   - Propor plano específico por eixo.
   - Retornar para `CA` ou acionar agente upstream (Sofia / Lexicon).

---

## Halt Conditions

- `SOFTWARE_ARCHITECTURE.md` inexistente ou `stepsCompleted` incompleto → HALT + retornar para `CA`.
- `FRONTEND_ARCHITECTURE.md` inexistente → HALT + retornar para `CA`.
- `IMPLEMENTATION_MAP.yaml` inexistente → HALT + retornar para `CA` ou executar `AM`.
- Parse failure em YAML/markdown de qualquer arquivo → HALT + reportar erro estrutural (provável corrupção manual).

---

## Fontes

- `bmad/investigacao/SPEC_arquiteto-de-software.md` §5.
- V4 BMAD `architect-checklist.md` (lógica conceitual).
- V6 local `bmad-check-implementation-readiness/` (lógica de checklist — ignorando regressão arquitetural).
