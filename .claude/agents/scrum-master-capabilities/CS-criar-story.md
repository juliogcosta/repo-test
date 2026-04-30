# Capability CS — Criar Story

**Quando usar**: após EP/SP; sempre que for momento de preparar a próxima story para o Dev agent.

**Duração estimada**: 15-45 minutos por story (depende do volume de artefatos a absorver).

**Output**: `{ARTIFACTS_DIR}/stories/{epic_num}-{story_num}-{story_slug}.md` com:
- 8 seções (owner: Bento; editors rígidos por seção — ver `templates/story-template.md`).
- Status: `ready-for-dev`.
- Dev Notes **auto-contidas** (regra de ouro: *"dev agent NEVER need to read architecture documents"*).
- Cada bloco técnico com `[Source: path:section]`.

---

## Pré-condições

- `{ARTIFACTS_DIR}/sprint-status.yaml` existe (ou `story_path` fornecido diretamente pelo usuário).
- `{ARTIFACTS_DIR}/epics.md` existe com a story no backlog.
- `{ARTIFACTS_DIR}/SOFTWARE_ARCHITECTURE.md` existe e `stepsCompleted` completo.
- Se story é frontend-aware: `{ARTIFACTS_DIR}/FRONTEND_ARCHITECTURE.md` existe.
- `{PROJECT_ROOT}/IMPLEMENTATION_MAP.yaml` existe.
- `{PROJECT_ROOT}/UBIQUITOUS_LANGUAGE.yaml` e `{PROJECT_ROOT}/claude/TERMINOLOGY_MAP.yaml` existem.
- `{ARTIFACTS_DIR}/READINESS_REPORT.md` existe (consulta; status≠PASS avisa mas não bloqueia).

**Se pré-condição falhar**: HALT + handoff (`@arquiteto-de-software` se arquitetura / `@analista-de-negocio` se ANEXO / `@guardiao-linguagem-ubiqua` se glossário).

---

## Steps

### Step 1 — Determinar Story Alvo

1. **Se usuário forneceu `story_path`** ou formato `E-S-slug` (ex.: `1-2-user-auth`, `2.4`):
   - Parse direto: extrair `epic_num`, `story_num`, `story_title/slug`.
   - Pular para Step 2.

2. **Senão, auto-discover**:
   - Ler `{ARTIFACTS_DIR}/sprint-status.yaml` **INTEGRAL** (ler arquivo inteiro; não confiar em parse parcial).
   - Encontrar **primeira** entry em `development_status` com:
     - Chave no pattern `{num}-{num}-{slug}` (ex.: `1-2-user-auth`).
     - **Não** epic (`epic-X`) nem retrospective (`epic-X-retrospective`).
     - Status exatamente `"backlog"`.
   - Extrair `epic_num`, `story_num`, `story_slug` da chave.

3. **Se é a primeira story do epic**:
   - Verificar status atual de `epic-{epic_num}` em `sprint-status.yaml`.
   - Se `backlog` ou `contexted` (legado): atualizar para `in-progress`.
   - Se `done`: **HALT** — "Cannot create story in completed epic".
   - Se status inválido (fora de `{backlog, contexted, in-progress, done}`): HALT + pedir correção manual.

#### Halt conditions do Step 1

- `sprint-status.yaml` ausente **E** nenhum `story_path` fornecido → sugerir SP.
- Zero stories em `backlog` → sugerir SS (revisão) ou retrospective.
- Epic da story já em `done` → HALT (não criar story em epic concluído).
- Status epic inválido → HALT + correção manual de sprint-status.yaml.

---

### Step 2 — Carregar e Analisar Artefatos Core

**Princípio V6**: análise **exaustiva** — *"do NOT be lazy or skim"* (`bmad-create-story/workflow.md:212`).

1. Executar protocolo `discover-inputs` — carregar com estratégia apropriada:
   - `epics_content`: SELECTIVE_LOAD por `{epic_num}` (só o epic relevante + stories adjacentes para cross-context).
   - `prd_content`: INDEX_GUIDED se PRD está shardado, SELECTIVE_LOAD pelas seções relevantes (§8 FR-X, §4 User Journeys se mencionados em AC).
   - `anexo_a_content`, `anexo_b_content`, `anexo_c_content`: SELECTIVE_LOAD pelas seções relevantes citadas pelo epic.
   - `software_architecture_content`: FULL_LOAD se monolítico ≤ 2000 linhas; senão SELECTIVE_LOAD.
   - `frontend_architecture_content`: **só se story é frontend-aware** (heurística: title/AC/Tasks mencionam UI, tela, form, dashboard, view, button, página, componente, modal).
   - `terminology_map`, `implementation_map`, `readiness_report`: sempre carregar (referência).

2. **Extrair Epic Completo** (contexto cross-story):
   - Objetivos do epic e valor de negócio.
   - TODAS as stories do epic (para cross-context — saber dependências entre stories).
   - Story atual: user story (As a / I want / so that), AC detalhados em BDD, reqs técnicos, dependências, source hints.
   - Critério de sucesso.

#### Halt conditions do Step 2

- Epic não encontrado em `epics_content` → HALT + handoff para Bento EP.
- Story atual não encontrada no Epic → HALT + verificar `sprint-status.yaml` vs `epics.md`.
- `SOFTWARE_ARCHITECTURE.md` ausente ou `stepsCompleted` incompleto → HALT + handoff Arthur CA.

---

### Step 3 — Previous Story Intelligence

**Best-effort** — se falhar, pula; não é halt.

1. Se `story_num > 1`:
   - Buscar story anterior via Glob: `{ARTIFACTS_DIR}/stories/{epic_num}-{prev_story_num}-*.md` (maior número < `story_num`).
   - Ler integralmente.
   - Extrair:
     - **Dev Agent Record → Completion Notes**: problemas encontrados, soluções adotadas.
     - **File List**: padrões de path / convenções usadas.
     - **QA Results**: review feedback; correções pendentes.
     - **Testing approaches** que funcionaram ou falharam.
     - **Libs/dependencies** adicionadas que podem ser reusadas.

2. Se repo git detectado (`git rev-parse --is-inside-work-tree`):
   - `git log --oneline -5` — últimos 5 commits.
   - Extrair: arquivos modificados recentemente, padrões de código, libs recém-adicionadas.

3. Compilar **Previous Story Insights block** para Dev Notes (será preenchido no Step 6).

---

### Step 4 — Análise de Arquitetura (backend + frontend)

**Princípio V6**: extração sistemática de guardrails — *"Extract everything the developer MUST follow"* (`workflow.md:250`).

#### 4.1 Backend (`SOFTWARE_ARCHITECTURE.md`)

Para cada seção relevante à story, extrair com source:

| Seção | O que extrair | Citar como |
|-------|---------------|------------|
| §3 Tech Stack | Versões pinadas de libs/frameworks a usar | `[Source: SOFTWARE_ARCHITECTURE.md §3]` |
| §4 Components | Componentes tocados pela story | `[Source: SOFTWARE_ARCHITECTURE.md §4 Components]` |
| §5 Core Workflows | Sequence relevante (se story toca fluxo específico) | `[Source: SOFTWARE_ARCHITECTURE.md §5 Core Workflows]` |
| §6 REST API Spec | Endpoints a implementar (método, path, payload, response) | `[Source: SOFTWARE_ARCHITECTURE.md §6]` |
| §7 Database Schema | Tabelas/colunas tocadas | `[Source: SOFTWARE_ARCHITECTURE.md §7 Database Schema]` |
| §8 Source Tree | Paths canônicos para novos files | `[Source: SOFTWARE_ARCHITECTURE.md §8 Source Tree]` |
| §10 Error Handling | Policies de retry/CB/timeout relevantes | `[Source: SOFTWARE_ARCHITECTURE.md §10]` |
| §11 Coding Standards | Naming, linting, patterns obrigatórios | `[Source: SOFTWARE_ARCHITECTURE.md §11]` |
| §12 Test Strategy | Frameworks, pyramid, coverage target | `[Source: SOFTWARE_ARCHITECTURE.md §12]` |
| §13 Security | Políticas de input validation, auth, secrets | `[Source: SOFTWARE_ARCHITECTURE.md §13]` |

#### 4.2 Frontend (`FRONTEND_ARCHITECTURE.md` — só se story frontend-aware)

| Seção | O que extrair | Citar como |
|-------|---------------|------------|
| §2 Frontend Tech Stack | Framework UI + versões | `[Source: FRONTEND_ARCHITECTURE.md §2]` |
| §3 Project Structure | Paths frontend canônicos | `[Source: FRONTEND_ARCHITECTURE.md §3]` |
| §4 Component Standards | Template de component, naming | `[Source: FRONTEND_ARCHITECTURE.md §4]` |
| §5 State Management | Store structure, slice/action patterns | `[Source: FRONTEND_ARCHITECTURE.md §5]` |
| §6 API Integration | Service template, API client config | `[Source: FRONTEND_ARCHITECTURE.md §6]` |
| §7 Routing | Route config, protected routes | `[Source: FRONTEND_ARCHITECTURE.md §7]` |
| §8 Styling Guidelines | Approach, theme tokens | `[Source: FRONTEND_ARCHITECTURE.md §8]` |
| §9 Testing Requirements | Component test template, coverage | `[Source: FRONTEND_ARCHITECTURE.md §9]` |
| §11 Frontend Developer Standards | Critical coding rules frontend | `[Source: FRONTEND_ARCHITECTURE.md §11]` |

#### 4.3 IMPLEMENTATION_MAP.yaml

Para cada `business_term` relevante à story (via AC ou descrição), extrair:
- `implementation.module`
- `implementation.files`
- `implementation.tests`
- `implementation.public_api`
- `implementation.endpoint_consumed` (integrations) ou `implementation.endpoints` (REST API)

Citar como: `[Source: IMPLEMENTATION_MAP.yaml categories.{categoria}.entries[...] where business_term="X"]`.

#### 4.4 TERMINOLOGY_MAP.yaml

Para cada termo de negócio na AC, encontrar o `technical_term` correspondente. Isso alimenta a tradução nas Dev Notes (ex.: "Edital de Licitação" → `Edital` class em `src/modules/licitacao/domain/`).

#### Halt conditions do Step 4

- Seção necessária vazia ou marcada `[A DEFINIR]` com relevância bloqueante → HALT + handoff Arthur (CA para refinar).
- Componente referenciado na story não existe em `SOFTWARE_ARCHITECTURE.md §4 Components` → HALT + handoff Arthur.
- Endpoint necessário não está em §6 REST API Spec → HALT + handoff Arthur.
- `business_term` da story não existe em `IMPLEMENTATION_MAP.yaml` → HALT + handoff Arthur AM.
- `design_term` não existe em `TERMINOLOGY_MAP.yaml` → HALT + handoff Lexicon.

---

### Step 5 — Web Research (opcional, default: pular)

**Decisão Q7 (2026-04-19)**: WebFetch **não habilitado** no Bento por padrão. Versões já pinadas pelo Arthur em SOFTWARE_ARCHITECTURE. Se Bento detectar que precisa confirmar versão atual ou doc de lib externa:
- Confirmar com usuário se pode usar WebFetch pontualmente, OU
- HALT e pedir Arthur para confirmar via capability AM (ele tem WebFetch autorizado).

**Nunca** pesquisar tecnologia nova (Bento herda restrição do Arthur: apenas confirmar tech já escolhida).

---

### Step 6 — Criar Story File

Produzir `{ARTIFACTS_DIR}/stories/{epic_num}-{story_num}-{story_slug}.md` a partir de `templates/story-template.md`.

#### Preencher 8 seções (ownership V4 §6.2)

1. **Status**: `ready-for-dev` (preencher no final, após checklist).

2. **Story**:
   ```markdown
   As a {role},
   I want {action},
   so that {benefit}.
   ```

3. **Acceptance Criteria**: BDD numerado, copiado literal do `epics.md` (preservar numeração Given/When/Then).

4. **Tasks / Subtasks**: derivar dos AC. Cada task com `(AC: N)` apontando critério(s). `[ ]` — **NUNCA marcar `[x]`** aqui.

5. **Dev Notes** — 8 categorias obrigatórias (quando aplicável; declarar "No specific guidance" se ausente):

   #### Previous Story Insights
   Se `story_num > 1`, blocos curtos com `[Source: stories/{epic}-{prev_story}-*.md]`.

   #### Data Models
   Aggregates/entidades tocadas com `[Source: ANEXO_B_DataModels.md §X]` e/ou `[Source: IMPLEMENTATION_MAP.yaml categories.domain_entities#business_term=Y]`.

   #### API Specifications
   Endpoints + payloads + responses com `[Source: SOFTWARE_ARCHITECTURE.md §6]`.

   #### Component Specifications (só frontend-aware)
   Components + props + state com `[Source: FRONTEND_ARCHITECTURE.md §4]`.

   #### File Locations
   Paths canônicos para novos files com `[Source: IMPLEMENTATION_MAP.yaml]` e `[Source: SOFTWARE_ARCHITECTURE.md §8 Source Tree]`.

   #### Testing Requirements
   Framework + coverage target + test location + padrões com `[Source: SOFTWARE_ARCHITECTURE.md §12]` e `[Source: FRONTEND_ARCHITECTURE.md §9]` se frontend.

   #### Technical Constraints
   NFRs aplicáveis (performance, segurança, LGPD) com `[Source: PRD.md §9]` e/ou `[Source: SOFTWARE_ARCHITECTURE.md §13]`.

   #### Git Intelligence (se disponível)
   Últimos 5 commits, libs recém-adicionadas, padrões — sem source formal (descrever como "From git log").

   **Regra de ausência** (V4 `create-next-story.md:93`): se categoria não tem fonte encontrada, declarar explicitamente:
   > *"No specific guidance found in architecture docs for {categoria}. Dev to confirm with user during implementation."*

6. **Change Log**: tabela vazia `| Date | Version | Description | Author |`.

7. **Dev Agent Record**: headers vazios (owner Dev):
   ```markdown
   ### Agent Model Used
   ### Debug Log References
   ### Completion Notes List
   ### File List
   ```

8. **QA Results**: vazio (owner QA-código).

#### Completion note

Adicionar no final do arquivo (como comentário ou nota):
> *"Ultimate context engine analysis completed — comprehensive developer guide created by Bento on {date}."*

---

### Step 7 — Validar contra Checklist Interno

**Decisão Q5 (2026-04-19)**: checklist roda **embutido em CS** (não há capability VS separada).

Executar validações (inspiradas em `bmad-create-story/checklist.md` V6):

#### 7.1 Reinvention Prevention
- [ ] File Locations aponta para paths EXISTENTES (ou marcados como "new file in path X")?
- [ ] Nenhuma classe/função duplicada sendo criada (consultou IMPLEMENTATION_MAP)?

#### 7.2 Technical Specification
- [ ] Versões de libs citadas batem com SOFTWARE_ARCHITECTURE §3 Tech Stack?
- [ ] Endpoints citados batem com SOFTWARE_ARCHITECTURE §6 REST API Spec?
- [ ] Schema de DB bate com SOFTWARE_ARCHITECTURE §7 Database Schema?

#### 7.3 File Structure
- [ ] Todos os paths seguem SOFTWARE_ARCHITECTURE §8 Source Tree?
- [ ] Paths frontend seguem FRONTEND_ARCHITECTURE §3 Project Structure?
- [ ] Naming de novos files segue Coding Standards (§11 backend / §11 frontend)?

#### 7.4 Regression Prevention
- [ ] Previous Story Insights consultado (se `story_num > 1`)?
- [ ] Padrões/libs reutilizados em vez de duplicar?
- [ ] Breaking changes flagadas explicitamente?

#### 7.5 Implementation Readiness
- [ ] Cada AC tem pelo menos 1 Task?
- [ ] Cada Task tem AC mapeado `(AC: N)`?
- [ ] Dev Notes cobre 8 categorias (mesmo que seja "No specific guidance")?
- [ ] Toda informação técnica tem `[Source: ...]`?

**Se qualquer item falhar**:
- Issues críticas (>3) não auto-corrigíveis → HALT + manter status `backlog` + pedir review do usuário.
- Issues menores → aplicar correção no story file e re-validar (non-interactive na v1).

---

### Step 8 — Atualizar Sprint Status e Reportar

1. **Update `sprint-status.yaml`**:
   - `development_status[{story_key}]`: `backlog` → `ready-for-dev`.
   - `last_updated`: timestamp atual.
   - Preservar **todos** os comentários (STATUS DEFINITIONS etc.) e ordem das entries.

2. **Salvar story file** (Write se novo, Edit se revisão pós-checklist).

3. **Reportar ao usuário**:
   ```
   Story {epic_num}.{story_num} criada, {user_name}.

   Arquivo: {ARTIFACTS_DIR}/stories/{epic_num}-{story_num}-{story_slug}.md
   Status: ready-for-dev
   Dev Notes: {N} categorias preenchidas (cobrindo {M} fontes citadas)
   Checklist: PASS

   Próximo passo sugerido:
   1. `@desenvolvedor IS` — implementar esta story
   2. `@scrum-master SS` — ver sumário do sprint
   3. `@scrum-master CS` — criar próxima story do backlog
   ```

4. **Atualizar `PROJECT.md`** (via Orquestrador) com progresso.

#### Halt conditions do Step 8

- Write/Edit falha → reportar erro específico; não marcar ready-for-dev.
- `sprint-status.yaml` corrompido → HALT + pedir restauração manual.

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md` §4 (workflow CS completo).
- `bmad/agents/bmad-create-story/workflow.md` V6 (base de 6 steps adaptados para 8 aqui).
- `bmad/agents/bmad-create-story/template.md` V6 (esqueleto).
- `bmad/agents/bmad-create-story/checklist.md` V6 (validações).
- `bmad/agents/bmad-create-story/discover-inputs.md` V6 (protocolo de carregamento).
- `V4_LITERAL_QUOTES.md §4.4` (regra de ouro Dev Notes self-contained) + §6.2 (ownership por seção) + §6 (create-next-story.md:82-93 categorias de Dev Notes).
