# Capability CA — Criar Arquitetura

**Quando usar**: Primeira vez produzindo arquitetura do projeto OU retomada após interrupção com `SOFTWARE_ARCHITECTURE.md` incompleto (`stepsCompleted` não tem todas as seções).

**Duração estimada**: 45-120 minutos (elicitação interativa intensa).

**Artefatos produzidos** (decisão Q7 — dual-documento):
- `{ARTIFACTS_DIR}/SOFTWARE_ARCHITECTURE.md` — 15 seções backend/sistema/infra.
- `{ARTIFACTS_DIR}/FRONTEND_ARCHITECTURE.md` — ~13 seções frontend (OU "N/A — projeto sem UI" se não aplicável).
- `{PROJECT_ROOT}/IMPLEMENTATION_MAP.yaml` — v1.0 com mappings iniciais.

---

## Pré-condições

- `PRD.md` existe e `Status: Aprovado`.
- `ANEXO_A_ProcessDetails.md`, `ANEXO_B_DataModels.md`, `ANEXO_C_Integrations.md` existem.
- `UBIQUITOUS_LANGUAGE.yaml` v ≥ 1.0 existe.
- `TERMINOLOGY_MAP.yaml` existe.
- `templates/SOFTWARE_ARCHITECTURE-template.md` e `templates/FRONTEND_ARCHITECTURE-template.md` existem no projeto (copiados por `init-project.sh`).

**Se alguma pré-condição falhar**: HALT e reportar ao usuário com recomendação de agente/capability a acionar.

---

## Política de Condução

**Workflow unificado** (decisão Q7 — 2026-04-19):

Arthur cobre **ambos documentos** em uma única execução CA. Não há `CA-backend` e `CA-frontend` separados.

- No **Step 3** (elicitação), Arthur alterna entre seções backend (**B**) e frontend (**F**) conforme dependências: ex.: Tech Stack backend → Tech Stack frontend; REST API Spec backend → API Integration frontend.
- No **Step 4** (produção), Arthur escreve seções no arquivo correspondente (B no `SOFTWARE_ARCHITECTURE.md`, F no `FRONTEND_ARCHITECTURE.md`) conforme vão sendo elicitadas.
- **Projetos sem UI**: Arthur cria `FRONTEND_ARCHITECTURE.md` apenas com cabeçalho + nota explícita `"N/A — projeto sem componente UI (confirmado pelo usuário em <data>)"`. Isso mantém consistência para agentes downstream (SM, QA).

---

## Steps

### Step 1 — Load Configuration e Descoberta de Artefatos

1. Ler `.claude-context` e resolver variáveis:
   - `PROJECT_NAME`, `PROJECT_ALIAS`, `PROJECT_ROOT`, `ARTIFACTS_DIR`.
   - `TEMPLATE_VERSION` (validar ≥ 3.3).
2. Verificar pré-condições (listadas acima).
3. Copiar `templates/SOFTWARE_ARCHITECTURE-template.md` para `{ARTIFACTS_DIR}/SOFTWARE_ARCHITECTURE.md` (se não existir).
4. Copiar `templates/FRONTEND_ARCHITECTURE-template.md` para `{ARTIFACTS_DIR}/FRONTEND_ARCHITECTURE.md` (se não existir).
5. Copiar `templates/IMPLEMENTATION_MAP-template.yaml` para `{PROJECT_ROOT}/IMPLEMENTATION_MAP.yaml` (se não existir; substituir `{{project_name}}` e `{{iso_date}}` nos metadados).
6. Inicializar `TodoWrite` com 26 itens (seções a elicitar, ordem do Step 3.1 abaixo).

**Halt conditions**:
- PRD ausente → HALT e acionar Orquestrador-PM capability `MP`.
- ANEXOS ausentes → HALT e acionar `@analista-de-negocio`.
- Glossário ausente → HALT e acionar `@guardiao-linguagem-ubiqua`.
- Templates locais ausentes → HALT e reportar "init-project.sh desatualizado; atualizar template-project e re-rodar init".

---

### Step 2 — Análise Exaustiva das Entradas

Ler em ordem:

1. **PRD.md completo** — extrair:
   - §1-3: visão, métricas, escopo MVP.
   - §4 User Journeys → insumo para Core Workflows (seção §5 do backend template).
   - §5 Domain Requirements + §7 Project-Type Requirements → insumos para Tech Stack e Security.
   - §8 FRs → insumos para Components e REST API Spec.
   - §9 NFRs → insumos para Infra/Deployment, Performance, Security, Test Strategy.
   - §10 Metadados YAML → `modulos` (sementes de Components), `documentos` (cross-ref com ANEXO_B), `comandos` (cross-ref com endpoints).

2. **ANEXO_A_ProcessDetails.md** — processos BPMN narrativos, fluxos de exceção → Core Workflows (sequence diagrams) e Error Handling Strategy.

3. **ANEXO_B_DataModels.md** — aggregates, invariantes, commands, eventos, índices → Data Models (link direto, **não duplicar**), Database Schema físico derivado, REST API Spec (commands → endpoints).

4. **ANEXO_C_Integrations.md** — integrações externas com auth, endpoints, retry/circuit-breaker/timeout → External APIs (link direto) e Error Handling Strategy.

5. **UBIQUITOUS_LANGUAGE.yaml** — glossário consolidado (business).

6. **TERMINOLOGY_MAP.yaml** — mapeamento business ↔ technical-conceitual; naming conventions já definidas. **Arthur herda essas convenções** no IMPLEMENTATION_MAP — não duplica.

Ao final, Arthur produz **nota de análise interna** (não gravada em disco, apenas em memória do workflow) resumindo:
- Bounded contexts identificados (derivados de `modulos`).
- Aggregates principais (ANEXO_B).
- Integrações externas (ANEXO_C).
- Restrições NFR críticas (latência, uptime, encryption, LGPD etc.).
- Lacunas detectadas → candidatas a acionar Sofia (BA).

**Halt conditions**:
- Lacuna bloqueante detectada → HALT e acionar `@analista-de-negocio` com template de handoff (ver `core.md` seção "Como Delegar").
- Contradição irreconciliável entre ANEXO_A e ANEXO_B → HALT e pedir esclarecimento ao usuário.

---

### Step 3 — Elicitação Interativa Seção a Seção (ambos documentos)

Para **cada seção** marcada `elicit: true` em `SOFTWARE_ARCHITECTURE-template.md` **E** `FRONTEND_ARCHITECTURE-template.md`, Arthur executa o **Protocolo de Elicitação**:

1. **Apresenta contexto** extraído do Step 2.
2. **Apresenta 2-3 opções viáveis** com prós/contras explícitos.
3. **Recomenda uma opção** com justificativa (cita fonte sempre).
4. **Aguarda aprovação explícita** do usuário. **NUNCA bypassa por eficiência** (regra V4 BMAD `elicit: true` — V4_LITERAL_QUOTES.md §1.1 activation-instructions).
5. **Registra a decisão** na seção correspondente (B no `SOFTWARE_ARCHITECTURE.md`, F no `FRONTEND_ARCHITECTURE.md`), com fonte citada.
6. **Marca item no TodoWrite** como concluído.

#### 3.1 Ordem Recomendada de Elicitação

**Convenção**: **B** = seção do `SOFTWARE_ARCHITECTURE.md` (backend); **F** = seção do `FRONTEND_ARCHITECTURE.md` (frontend).

1. **B** Introduction — Starter Template decision.
2. **B** High Level Architecture — estilo (monolito/micro/serverless), repo (mono/polyrepo), diagrama Mermaid de alto nível, padrões arquiteturais.
3. **B** Tech Stack (**crítico — bloqueia todas as seguintes**) — cloud, linguagens, frameworks, DB, tools, versões **pinadas**.
4. **F** Template and Framework Selection — CRA / Next.js / Vite / Nuxt / Angular CLI / Remix / "N/A — sem UI".
5. **F** Frontend Tech Stack — framework UI, state management, routing, build tool, styling, testing, component library, forms, animation.
6. **B** Components — derivados de `modulos` do PRD §10, enriquecidos com interfaces / deps / tech.
7. **B** Core Workflows — 2-3 sequence diagrams Mermaid para jornadas críticas do PRD §4.
8. **B** REST API Spec — OpenAPI 3.0 derivado de commands do ANEXO_B.
9. **F** API Integration — service template, API client config (consome §8 do backend).
10. **B** Database Schema — DDL/JSON Schema derivado do ANEXO_B.
11. **B** Source Tree (**crítico — base do IMPLEMENTATION_MAP**) — estrutura canônica de pastas backend.
12. **F** Project Structure — estrutura de pastas frontend (alinhada ao framework UI).
13. **F** Component Standards — template de component, naming conventions frontend.
14. **F** State Management — store structure, state template.
15. **F** Routing — route configuration, protected routes, lazy loading.
16. **F** Styling Guidelines — approach (CSS Modules / Tailwind / styled-components), global theme, dark mode.
17. **B** Infrastructure and Deployment — IaC tool, pipeline CI/CD, ambientes, rollback strategy.
18. **B** Error Handling Strategy — hierarchy, logging, correlation ID, idempotência.
19. **B** Coding Standards (**crítico para Dev**) — linting, naming (linkar `TERMINOLOGY_MAP`), critical rules.
20. **F** Frontend Developer Standards — critical coding rules frontend, quick reference.
21. **B** Test Strategy backend (**crítico para QA/Dev**) — pyramid, frameworks, data management.
22. **F** Testing Requirements — component test template, testing best practices, coverage frontend.
23. **F** Environment Configuration — variáveis de ambiente frontend (`NEXT_PUBLIC_*`, `VITE_*` etc.).
24. **B** Security — materialização dos NFRs de segurança (cross-stack; CSP/XSS anotados em nota cruzada no FRONTEND se aplicável).
25. **B** Checklist Results — auto-validação backend (checklist embutido na seção do template).
26. **B** Next Steps — handoff para SM/Dev/QA.

**Regra de alternância**: Arthur decide a próxima seção pela dependência (ex.: API Integration frontend depende de REST API Spec backend; então REST API Spec vem primeiro). Se o usuário preferir ordem diferente (ex.: frontend-first), Arthur aceita mas **avisa** das dependências invertidas.

---

### Step 4 — Produção Progressiva

Para **cada seção aprovada** pelo usuário no Step 3:

1. **Localizar** a seção no template correto (`SOFTWARE_ARCHITECTURE.md` para B, `FRONTEND_ARCHITECTURE.md` para F).
2. **Editar** a seção substituindo placeholders pelo conteúdo decidido:
   - Primeira seção escrita de cada arquivo: pode usar `Write` (se arquivo ainda está no estado-template).
   - Seções subsequentes: **obrigatoriamente** `Edit` (preserva conteúdo já escrito).
3. **Atualizar frontmatter YAML** do arquivo correspondente:
   - Adicionar seção em `stepsCompleted:`.
   - Atualizar `lastUpdated:` (ISO timestamp).
   - Se todas as seções concluídas: `currentStatus: approved`.
4. **Atualizar Change Log** interno da seção Introduction do arquivo correspondente.

**Regra de densidade**: **não re-explicar** o que está no PRD/ANEXOS — **referenciar**. Exemplo em Data Models:
```markdown
## 4. Data Models

Aggregates principais: ver `ANEXO_B_DataModels.md` (fonte canônica).

**Principais aggregates**:
- `DOC-lic-Edital` — raiz de agregado de Edital de Licitação.
- `DOC-lic-Proposta` — raiz de agregado de Proposta.

**Decisões adicionais** (não cobertas no ANEXO_B):
- Encoding: UTF-8 em todos os campos texto.
- Timezone: UTC na camada de domínio; conversão para America/Fortaleza apenas na apresentação.
```

**Regra cross-documento**:
- `FRONTEND_ARCHITECTURE.md` **referencia** `SOFTWARE_ARCHITECTURE.md` para seções comuns (ex.: Tech Stack backend-side já decidido, Security cross-stack).
- `SOFTWARE_ARCHITECTURE.md` **nunca** referencia frontend (hierarquia: backend é cidadão autônomo; frontend consome).

---

### Step 5 — Alimentação do IMPLEMENTATION_MAP.yaml

**Em paralelo** ao Step 4, quando Arthur escrever seções §4 (Components), §6 (REST API Spec), §7 (Database Schema), §8 (Source Tree) do SOFTWARE_ARCHITECTURE, ele alimenta `IMPLEMENTATION_MAP.yaml` com triplets.

**Estrutura hierárquica** (decisão Q9 — 2026-04-19):

```yaml
categories:

  domain_entities:
    description: "Aggregates e entidades de domínio (DDD)."
    entries:
      - business_term: "Edital de Licitação"    # de UBIQUITOUS_LANGUAGE
        design_term: "DOC-lic-Edital"           # de ANEXO_B / TERMINOLOGY_MAP
        implementation:
          module: "src/modules/licitacao/domain/edital"
          files:
            - "src/modules/licitacao/domain/edital/Edital.ts"
            - "src/modules/licitacao/domain/edital/EditalInvariants.ts"
          tests:
            - "src/modules/licitacao/domain/edital/__tests__/Edital.spec.ts"
          public_api:
            - "Edital"
            - "Edital.publicar()"
            - "Edital.retificar()"
        cross_refs:
          ubiquitous_language: "Edital de Licitação"
          terminology_map: "DOC-lic-Edital"
          prd_section: "PRD §8 FR-001"
          anexo_b_section: "ANEXO_B §3.1"
          architecture_section: "SOFTWARE_ARCHITECTURE §4 Components → §7 Source Tree"

  business_processes:
    # ... derivado de ANEXO_A

  integrations:
    # ... derivado de ANEXO_C

  data_models:
    # ... derivado de ANEXO_B + SOFTWARE_ARCHITECTURE §9

  ui_components:
    # ... derivado de FRONTEND_ARCHITECTURE §4

  infrastructure:
    # ... derivado de SOFTWARE_ARCHITECTURE §11

  domain_events:
    # ... derivado de ANEXO_B
```

**Regras de alimentação**:
- **Toda entry DEVE** ter pelo menos 1 `cross_ref` para `UBIQUITOUS_LANGUAGE` OU `TERMINOLOGY_MAP`.
- `business_term` DEVE existir em `UBIQUITOUS_LANGUAGE.yaml`; se não existir, HALT e acionar Lexicon primeiro.
- `design_term` DEVE existir em `TERMINOLOGY_MAP.yaml`; se não, Arthur propõe novo termo ao Lexicon.
- Paths relativos à raiz do projeto (nunca absolutos).
- Versioning SemVer: MINOR bump ao adicionar entry; PATCH ao atualizar path; MAJOR ao remover categoria.

---

### Step 6 — Auto-Validação e Halt Conditions

Ao final de **cada seção** escrita, mini-checklist:

- [ ] Todas as decisões técnicas têm fonte citada (`[Source: ...]`)?
- [ ] Todas as versões estão pinadas (nenhum "latest")?
- [ ] Todos os termos técnicos novos foram submetidos ao Lexicon?
- [ ] As seções dependentes foram preenchidas **após** as dependências?
- [ ] IMPLEMENTATION_MAP.yaml atualizado se seção §4/§6/§7/§8?

Ao final do **documento completo**, checklist global (equivalente ao V4 `architect-checklist.md`):

- [ ] Todas as 15 seções de `SOFTWARE_ARCHITECTURE.md` têm `stepsCompleted`.
- [ ] `FRONTEND_ARCHITECTURE.md` completo OU nota "N/A" explícita.
- [ ] `IMPLEMENTATION_MAP.yaml` tem entries para todos os aggregates do ANEXO_B.
- [ ] Pendências `[A DEFINIR]` classificadas (bloqueantes × não-bloqueantes).
- [ ] Changelog interno de cada documento atualizado.

#### Halt Conditions Explícitas

1. **PRD ausente ou incompleto** → HALT + acionar Orquestrador-PM (MP).
2. **ANEXO_B vazio ou sem aggregates** → HALT + acionar `@analista-de-negocio` capability B.
3. **Contradição entre ANEXO_A e ANEXO_B** (command no A sem aggregate em B) → HALT + pedir esclarecimento ou acionar BA.
4. **Tecnologia solicitada pelo usuário incompatível com NFR** (ex.: NFR exige 99.9% uptime mas usuário pede SQLite em produção) — HALT + apresentar conflito; usuário decide.
5. **Usuário pede "latest" em versão** → HALT + solicitar versão específica (princípio não-negociável).
6. **3 tentativas frustradas de elicitação na mesma seção** → HALT + propor marcar como `[A DEFINIR]` com entry em `LEARNING_LOG` (via Orquestrador RL).
7. **Dependência circular de decisão** (Tech Stack ↔ Components) → HALT + propor ordem alternativa explícita.

---

### Step 7 — Entrega e Handoff

1. **Emitir resumo** para o usuário:
   ```
   ✅ Arquitetura Concluída

   SOFTWARE_ARCHITECTURE.md: 15/15 seções
   FRONTEND_ARCHITECTURE.md: 13/13 seções (OU "N/A — sem UI")
   IMPLEMENTATION_MAP.yaml: v1.0 com N entries em M categorias

   Decisões críticas registradas:
   - Tech Stack: {...}
   - Database: {...}
   - Deployment: {...}

   Pendências [A DEFINIR]:
   - {lista — classificadas como bloqueantes ou não}

   Próximo passo sugerido:
   1. @arquiteto-de-software IR  → validar prontidão
   2. @scrum-master SP            → iniciar planejamento de stories
   ```

2. **Atualizar PROJECT.md** via Orquestrador (reportar status `Arquitetura Definida` e linkar os 3 artefatos).

3. **Gravar `stepsCompleted`** completo no frontmatter de ambos documentos.

4. **Sugerir handoff**: `@arquiteto-de-software IR` para validação antes de SM.

---

## Integração com Outros Agentes Durante CA

| Agente | Quando acionar durante CA | Ação |
|--------|---------------------------|------|
| **Sofia (BA)** | Lacuna bloqueante em ANEXO_A/B/C | HALT + handoff |
| **Lexicon (Guardião)** | Termo técnico novo (Saga, Event Bus, Virtual DOM, SSR, etc.) | Registrar em TERMINOLOGY_MAP (não em UBIQUITOUS) |
| **Diana (Diagram Designer)** | Diagrama complexo (>20 nós) OU estado detalhado | Delegar `@diagrama-designer DC` ou `DS` |
| **Orquestrador-PM (Giovanna)** | Reportar progresso / pedir RL para `[A DEFINIR]` | Via Task tool |

---

## Fontes

- `bmad/investigacao/SPEC_arquiteto-de-software.md` §4.
- `bmad/investigacao/V4_LITERAL_QUOTES.md` §1.1 activation-instructions (regra `elicit: true`).
- `bmad/investigacao/AUDITORIA_COMPLETUDE_PRD_ANEXOS.md` (sobreposição PRD/ANEXOS × template V4).
- Template V4 BMAD `architecture-tmpl.yaml` (17 seções originais).
