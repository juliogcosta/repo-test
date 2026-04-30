# SOFTWARE_ARCHITECTURE-template.md (backend/sistema)

> **Escopo deste template**: backend/sistema/infraestrutura. Para frontend, ver `FRONTEND_ARCHITECTURE-template.md` (complemento obrigatório).

**Derivado de**: BMAD V4 `bmad-core/templates/architecture-tmpl.yaml` — 15 seções (17 originais menos §4 Data Models → ANEXO_B e §6 External APIs → ANEXO_C).
**Produzido por**: Arthur (arquiteto-de-software) via capability CA.
**Artefato final**: `artifacts/SOFTWARE_ARCHITECTURE.md`.

---

**Cabeçalho esperado do artefato final (quando Arthur criar)**:

```markdown
# {{project_name}} — Software Architecture Document

**Projeto**: {{project_name}}
**Alias**: {{project_alias}}
**Cliente**: {{client_name}}
**Versão do Documento**: 1.0
**Status**: Rascunho | Em Elicitação | Aprovado
**Autor**: Arthur (Arquiteto de Software)
**Data**: {{iso_date}}

---
```

**Frontmatter YAML esperado** (Arthur atualiza durante CA):

```yaml
---
template_version: "1.0"
stepsCompleted: []  # vai sendo preenchido: [intro, high-level, tech-stack, components, ...]
currentStatus: draft  # draft | in_elicitation | approved
lastUpdated: null
references:
  prd: "artifacts/PRD.md"
  anexo_a: "artifacts/ANEXO_A_ProcessDetails.md"
  anexo_b: "artifacts/ANEXO_B_DataModels.md"
  anexo_c: "artifacts/ANEXO_C_Integrations.md"
  frontend_architecture: "artifacts/FRONTEND_ARCHITECTURE.md"
  ubiquitous_language: "UBIQUITOUS_LANGUAGE.yaml"
  terminology_map: "claude/TERMINOLOGY_MAP.yaml"
  implementation_map: "IMPLEMENTATION_MAP.yaml"
scope: backend
---
```

---

## 1. Introduction

<!-- elicit: true (subsection Starter Template) -->
<!-- source: V4 architecture-tmpl §1 Introduction | PARCIAL complementa PRD header -->

**Instruction for agent**: Se disponível, revise todos os documentos fornecidos antes de começar. No mínimo, deve existir `PRD.md`. Se não houver, ASK ao usuário quais documentos servirão de base. Esta seção NÃO duplica metadados do PRD (cliente, projeto, versão) — referenciar. Foco específico: relação deste documento com o `FRONTEND_ARCHITECTURE.md` (complemento obrigatório — decisão Q7 do SPEC), decisão de starter template backend, e changelog independente.

**Elicitation requirement**:
- Subseção "Starter Template or Existing Project" exige decisão explícita do usuário.
- Subseção "Change Log" é apenas tabela — não requer elicitação.

---

### 1.1 Visão Geral

Este documento descreve a arquitetura de **backend, serviços compartilhados, infraestrutura e aspectos não-UI** de **{{project_name}}**. Serve como blueprint para desenvolvimento dirigido por IA, garantindo consistência com padrões e tecnologias escolhidas.

**Relação com Frontend Architecture**: o `FRONTEND_ARCHITECTURE.md` (complemento obrigatório deste documento) cobre UI framework, componentes, state management, routing, styling, testing frontend e PWA/SSR/SSG. Escolhas cross-stack (linguagem, package manager, build target, política de segurança) são decididas aqui e **referenciadas** no FRONTEND.

**Referências externas** (evitar duplicação): `artifacts/PRD.md`, `artifacts/ANEXO_A_ProcessDetails.md`, `artifacts/ANEXO_B_DataModels.md`, `artifacts/ANEXO_C_Integrations.md`, `artifacts/FRONTEND_ARCHITECTURE.md`, `UBIQUITOUS_LANGUAGE.yaml`, `claude/TERMINOLOGY_MAP.yaml`.

---

### 1.2 Starter Template or Existing Project

<!-- elicit: true -->

**Instruction for agent** (resumo do V4 §1.starter-template):

1. Revisar PRD/brief buscando menção a starter template (Next.js, Spring Initializr, CRA, etc.), projeto existente a clonar/adaptar, ou boilerplate.
2. Se mencionado → pedir link/repo/upload; analisar stack pré-configurada, estrutura, tooling, limitações; usar para informar decisões.
3. Se greenfield sem menção → sugerir starters apropriados; deixar usuário decidir.
4. Se usuário confirmar from-scratch → notar esforço de setup manual.

**Template content (preencher):**

```
Decisão: [Starter template | Projeto existente adaptado | Greenfield sem starter | N/A]
- Nome/versão/link: ...
- Razão: ...
- Limitações/adaptações: ...
```

---

### 1.3 Change Log

<!-- source: V4 architecture-tmpl §1.changelog (tipo table) -->

**Template content:**

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| {{iso_date}} | 1.0 | Rascunho inicial do Software Architecture Document | Arthur |

---

## 2. High Level Architecture

<!-- elicit: true (seção inteira) -->
<!-- source: V4 architecture-tmpl §2 (AUSENTE no PRD/ANEXOS atuais — integral) -->

**Instruction for agent** (V4 §2.instruction): Esta seção contém múltiplas subseções que estabelecem a fundação da arquitetura. **Apresentar todas as subseções juntas de uma só vez** (não uma de cada vez).

**Elicitation requirement**:
- Arthur apresenta contexto extraído do PRD+ANEXOS.
- Apresenta 2-3 opções para estilo arquitetural (monolito/micro/serverless/event-driven), estrutura de repo (mono/polyrepo), padrões (CQRS/Hexagonal/Layered/etc.).
- Recomenda com justificativa.
- Aguarda aprovação explícita.

---

### 2.1 Technical Summary

**Instruction for agent** (V4 §2.technical-summary): Fornecer parágrafo breve (3-5 sentenças) cobrindo:
- Estilo arquitetural geral do sistema.
- Componentes-chave e seus relacionamentos.
- Escolhas primárias de tecnologia.
- Padrões arquiteturais centrais em uso.
- Referência aos objetivos do PRD e como esta arquitetura os suporta.

**Template content:**

```
[3-5 sentenças em prosa técnica, citando fontes]

Exemplo: "O sistema {{project_alias}} adota arquitetura de [monolito modular | microsserviços | serverless]
seguindo padrão [Hexagonal | CQRS | Layered], composto por [N] componentes principais organizados em
[monorepo | polyrepo]. A stack primária é [linguagem] + [framework] + [banco], com deployment em
[cloud provider]. Esta arquitetura suporta os objetivos do PRD [Source: PRD.md §2 Success Criteria]
especialmente [NFR-002 uptime 99.9%] e [FR-001..N capabilities]."
```

---

### 2.2 High Level Overview

**Instruction for agent** (V4 §2.high-level-overview): Baseado em Technical Assumptions do PRD (se existir — ver Recomendação de enriquecimento na AUDITORIA §3.3.1), descrever:

1. Estilo arquitetural principal (Monolito, Microsserviços, Serverless, Event-Driven).
2. Decisão de estrutura de repositório (Monorepo/Polyrepo).
3. Decisão de arquitetura de serviços.
4. Fluxo primário de interação do usuário ou fluxo de dados em nível conceitual.
5. Decisões arquiteturais-chave e suas justificativas.

**Template content:**

```
- **Estilo Arquitetural**: [Monolito Modular | Microsserviços | Serverless | Event-Driven | Híbrido]
  - Justificativa: [texto, citar NFRs]

- **Estrutura de Repositório**: [Monorepo | Polyrepo]
  - Justificativa: [texto]

- **Arquitetura de Serviços**: [Monolito único | N microsserviços | Funções serverless + ...]
  - Justificativa: [texto]

- **Fluxo Primário** (alto nível): [descrição em 3-5 linhas, sem detalhes de implementação]

- **Decisões-Chave**:
  1. [Decisão 1] — Justificativa: [texto] — [Source: PRD §X ou ANEXO Y]
  2. [Decisão 2] — ...
```

---

### 2.3 High Level Project Diagram

**Instruction for agent** (V4 §2.project-diagram, tipo `mermaid` — `graph`): Criar diagrama Mermaid visualizando a arquitetura de alto nível. Considerar:
- Fronteiras do sistema.
- Componentes/serviços principais.
- Direções de fluxo de dados.
- Integrações externas (ver ANEXO C).
- Pontos de entrada do usuário.

**Arthur pode delegar** geração para Diana (`@diagrama-designer` capability DC) se o diagrama envolve >10 nós.

**Template content**: bloco mermaid `graph TD` cobrindo Usuário → Frontend → API Gateway → Serviços → DB + Integrações Externas (linka ANEXO_C). Arthur delega para Diana se >10 nós.

---

### 2.4 Architectural and Design Patterns

**Instruction for agent** (V4 §2.architectural-patterns): Listar padrões de alto nível que guiarão a arquitetura. Para cada padrão:

1. Apresentar 2-3 opções viáveis se múltiplas existirem.
2. Fornecer recomendação com justificativa clara.
3. Obter confirmação do usuário antes de finalizar.
4. Padrões devem alinhar com Technical Assumptions do PRD e objetivos do projeto.

Padrões comuns a considerar (do V4):
- **Estilo arquitetural**: Serverless, Event-Driven, Microservices, CQRS, Hexagonal.
- **Organização de código**: Dependency Injection, Repository, Module, Factory.
- **Padrões de dados**: Event Sourcing, Saga, Database per Service.
- **Comunicação**: REST, GraphQL, Message Queue, Pub/Sub.

**Template content (repeatable, template V4):**

```
- **{{pattern_name}}:** {{pattern_description}} — _Rationale:_ {{rationale}}
```

**Exemplos (do V4 literal):**

```
- **Serverless Architecture:** Usando AWS Lambda para compute — _Rationale:_ Alinha com requisito do PRD para otimização de custo e escalabilidade automática.
- **Repository Pattern:** Abstrair lógica de acesso a dados — _Rationale:_ Habilita testes e flexibilidade futura para migração de DB.
- **Event-Driven Communication:** Usando SNS/SQS para desacoplamento de serviços — _Rationale:_ Suporta processamento assíncrono e resiliência do sistema.
```

---

## 3. Tech Stack

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §3 (AUSENTE no PRD/ANEXOS — integral, CRÍTICO) -->

**Instruction for agent** (V4 §3, tradução integral — preservada por ser crítica):

Esta é a seção **DEFINITIVA** de seleção de tecnologia. Trabalhar com o usuário para fazer escolhas específicas:

1. Revisar Technical Assumptions do PRD e quaisquer preferências em `{root}/data/technical-preferences.yaml` (se existir).
2. Para cada categoria, apresentar 2-3 opções viáveis com prós/contras.
3. Fazer recomendação clara baseada nas necessidades do projeto.
4. **Obter aprovação explícita do usuário para cada seleção**.
5. **Documentar versões exatas** (evitar "latest" — pinar versões específicas). *Princípio não-negociável de Arthur.*
6. Esta tabela é a **única fonte da verdade** — todos os outros docs devem referenciar estas escolhas.

Decisões-chave a finalizar antes de exibir a tabela:
- Starter templates (se houver).
- Linguagens e runtimes com versões exatas.
- Frameworks e libraries / packages.
- Provedor cloud e escolhas de serviços-chave.
- Soluções de banco e storage (se não claro, sugerir SQL/NoSQL/outros dependendo do projeto e do cloud provider).
- Ferramentas de desenvolvimento.

Ao renderizar a tabela, garantir que o usuário entende a importância das escolhas, procurar gaps/discordâncias, pedir clarificações, e elicitar feedback imediato.

**Elicitation requirement**: Máxima — esta seção bloqueia todas as seguintes. Arthur não avança para §4 antes de todas as linhas da tabela terem versão pinada e aprovação do usuário.

---

### 3.1 Cloud Infrastructure

**Template content (V4 §3.cloud-infrastructure):**

```
- **Provider:** {{cloud_provider}}              [AWS | Azure | GCP | on-premise | híbrido]
- **Key Services:** {{core_services_list}}      [lista de serviços principais, ex.: Lambda, S3, RDS, CloudFront]
- **Deployment Regions:** {{regions}}           [ex.: us-east-1, sa-east-1]
```

---

### 3.2 Technology Stack Table

**Template content (V4 §3.technology-stack-table, type: table, colunas literais do V4):**

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| | | | | |

**Exemplos (V4 literais):**

```
| **Language** | TypeScript | 5.3.3 | Primary development language | Strong typing, excellent tooling, team expertise |
| **Runtime** | Node.js | 20.11.0 | JavaScript runtime | LTS version, stable performance, wide ecosystem |
| **Framework** | NestJS | 10.3.2 | Backend framework | Enterprise-ready, good DI, matches team patterns |
```

**Categorias sugeridas a preencher — escopo backend/sistema** (Arthur expande conforme necessário):
- Language (cross-stack se monorepo poliglota; específico backend caso contrário)
- Runtime
- Backend Framework
- Database (primary)
- Database (cache)
- Database (search, se aplicável)
- Message Queue / Event Bus
- Authentication (backend-side: JWT issuer, OAuth provider, session store)
- Secrets Management
- Observability (Logs, Metrics, Tracing)
- CI/CD
- IaC Tool
- Unit Test Framework (backend)
- Integration Test Framework (backend)
- E2E Test Framework (API-level)
- Linter / Formatter (backend)
- Package Manager (se cross-stack, idem)
- Container Runtime

**Categorias que NÃO entram aqui** (vão para FRONTEND_ARCHITECTURE.md §2):
- UI Framework (React/Vue/Angular/Svelte)
- UI Library / Component Library
- Frontend State Management (Redux/Pinia/NgRx/Zustand)
- Frontend Routing
- Frontend Build Tool (Vite/Webpack/Turbopack)
- Styling Solution (Tailwind/Styled-Components/CSS Modules)
- Frontend Testing (Vitest/Jest DOM/Playwright component)
- Frontend Form Handling (React Hook Form, Formik, etc.)
- Frontend Animation (Framer Motion, etc.)
- Frontend Dev Tools (Storybook, React DevTools profiles)

---

## 4. Components

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §5 Components | PARCIAL complementa PRD §10 modulos e ANEXO_B documents -->

**Instruction for agent** (V4 §5): Baseado nos padrões arquiteturais, tech stack e data models acima:

1. Identificar componentes/serviços lógicos principais e suas responsabilidades.
2. Considerar a estrutura de repositório (monorepo/polyrepo).
3. Definir fronteiras e interfaces claras entre componentes.
4. Para cada componente, especificar:
   - Responsabilidade primária.
   - Interfaces/APIs-chave expostas.
   - Dependências de outros componentes.
   - Especificidades técnicas baseadas em Tech Stack.
5. Criar diagramas de componentes quando útil.

**Complementa**: PRD §10 `modulos` lista bounded contexts (tecnico_id, descrição, FRs relacionados) — use como **sementes**. Expandir com interfaces e tech.

**Elicitation requirement**: Arthur apresenta componentes derivados dos `modulos`, sugere refinamentos (ex.: dividir um módulo grande em 2 componentes), pede aprovação linha a linha.

---

### 4.1 Component List (V4 §5.component-list, repeatable)

Para cada componente: **Responsibility**; **Key Interfaces** (lista); **Dependencies**; **Technology Stack** (subset de §3); **Source Reference** (PRD §10 `modulos.{id}`); **Related FRs** (lista FR-*); **Owns Aggregates** (lista DOC-* do ANEXO_B).

---

### 4.2 Component Diagrams

**Instruction for agent** (V4 §5.component-diagrams, type: mermaid): Criar diagramas Mermaid para visualizar relacionamentos entre componentes. Opções:
- C4 Container Diagram (visão de alto nível).
- Component Diagram (estrutura interna detalhada).
- Sequence Diagram (interações complexas — mas sequences específicas pertencem a §5 Core Workflows).

**Arthur pode delegar** para Diana (`@diagrama-designer` DC) quando >8 componentes.

**Template content**: bloco mermaid `graph LR` com `subgraph` por bounded context, setas mostrando interfaces e dependências. Arthur delega para Diana DC se >8 componentes.

---

## 5. Core Workflows

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §7 Core Workflows (tipo mermaid sequence) | PARCIAL complementa ANEXO_A BPMN narrativo -->

**Instruction for agent** (V4 §7): Ilustrar workflows-chave do sistema usando **sequence diagrams**:

1. Identificar jornadas críticas do usuário (PRD §4).
2. Mostrar interações entre componentes **incluindo APIs externas** (ANEXO_C).
3. Incluir **caminhos de tratamento de erro**.
4. Documentar operações assíncronas.
5. Criar diagramas tanto high-level quanto detalhados conforme necessário.

Focar em workflows que **clarifiquem decisões arquiteturais ou interações complexas**. Não redocumentar BPMN — referenciar ANEXO_A.

**Complementa**: ANEXO_A tem BPMN narrativo (processo de negócio) — use como input; §5 produz sequence diagrams técnicos (componente↔componente↔API externa).

**Elicitation requirement**: Arthur escolhe 2-3 workflows críticos (derivados de PRD §4 User Journeys) e apresenta sequence diagram Mermaid para cada.

**Template content (repetir por workflow):**

```markdown
### 5.{{N}} Workflow: {{workflow_name}}
- Related Journey: PRD §4 Journey X
- Related Process: ANEXO_A PROC-...
- Componentes envolvidos: [lista]
- APIs externas envolvidas: [lista, ou N/A]

[Bloco mermaid sequenceDiagram cobrindo: ator, FE, API Gateway, serviço, DB, integração externa; incluir `alt Sucesso / else Erro` referenciando §10 Error Handling]
```

---

## 6. REST API Spec

<!-- elicit: true (conditional: projeto inclui REST API) -->
<!-- source: V4 architecture-tmpl §8 REST API Spec (AUSENTE no PRD/ANEXOS — integral) -->

**Instruction for agent** (V4 §8, type: code, language: yaml): Se o projeto inclui REST API:

1. Criar uma **especificação OpenAPI 3.0**.
2. Incluir todos os endpoints (derivados dos `commands` do ANEXO_B).
3. Definir schemas de request/response baseados nos data models (ANEXO_B).
4. Documentar requisitos de autenticação.
5. Incluir exemplos de requests/responses.

Usar formato YAML para melhor legibilidade. Se não há REST API, **pular esta seção explicitamente** (registrar "N/A — este projeto não expõe REST API").

**Complementa**: cada `command_id` do ANEXO_B deve ter um endpoint correspondente aqui. Arthur alimenta `IMPLEMENTATION_MAP.yaml → mappings.commands.endpoint` em paralelo.

**Elicitation requirement**: Arthur deriva endpoints automaticamente dos commands do ANEXO_B; pede confirmação de convenções de URL (ex.: `/api/v1/editais/{id}/aprovar` vs `/editais/{id}:aprovar`).

**Template content (V4 §8.template — esqueleto mínimo; Arthur expande):**

```yaml
openapi: 3.0.0
info:
  title: {{api_title}}
  version: {{api_version}}
  description: {{api_description}}
servers:
  - url: {{server_url}}
    description: {{server_description}}

paths:
  # Um path por command do ANEXO_B. Ex.:
  /api/v1/editais/{id}/aprovar:
    post:
      summary: "Aprovar edital (command AprovarEdital)"
      security: [{ BearerAuth: [] }]
      # parameters, requestBody, responses (200/400/401/500 referenciando components)
      # ...

components:
  securitySchemes:
    BearerAuth: { type: http, scheme: bearer, bearerFormat: JWT }
  schemas:
    # Um schema por aggregate do ANEXO_B
  responses:
    # BadRequest, Unauthorized, InternalError
```

---

## 7. Database Schema

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §9 Database Schema | PARCIAL complementa ANEXO_B (conceitual) -->

**Instruction for agent** (V4 §9): Transformar os data models conceituais em schemas concretos de banco:

1. Usar o(s) tipo(s) de banco selecionados em §2 Tech Stack.
2. Criar definições de schema usando notação apropriada (DDL SQL, JSON Schema, etc.).
3. Incluir índices, constraints e relacionamentos.
4. Considerar performance e escalabilidade.
5. Para NoSQL, mostrar estruturas de documento.

Apresentar schema em formato apropriado ao tipo de banco. **Não duplicar ANEXO_B** — esta seção é a **tradução física** do modelo conceitual.

**Complementa**: ANEXO_B tem campos com tipos conceituais ("UUID", "Decimal(15,2)") + índices com justificativa (AUDITORIA §2.9). Esta seção traduz para DDL do banco escolhido.

**Elicitation requirement**: Arthur apresenta proposta de DDL/JSON Schema por aggregate; pede confirmação de decisões de particionamento, estratégia de PK, compound indexes.

**Template content (repetir por aggregate do ANEXO_B):**

```markdown
### 7.{{N}} {{aggregate_name}}
**Source**: ANEXO_B DOC-{{bc}}-{{name}} | **Database**: [ver §3 Tech Stack]

[Bloco DDL SQL ou JSON Schema concreto — CREATE TABLE com tipos, constraints, CHECKs, índices (compound index do ANEXO_B), comentário referenciando fonte conceitual]

- Particionamento: [N/A | por data | por tenant | hash de id]
- Estratégia de PK: [UUID v4 | ULID | serial | composite]
- Invariantes mapeadas (ANEXO_B INV-*): [lista → validation_file em IMPLEMENTATION_MAP]
```

---

## 8. Source Tree

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §10 Source Tree (AUSENTE — integral, CRÍTICO para IMPLEMENTATION_MAP) -->

**Instruction for agent** (V4 §10, type: code, language: plaintext — tradução integral): Criar uma estrutura de pastas que reflita:

1. A estrutura de repositório escolhida (monorepo/polyrepo).
2. A arquitetura de serviços (monolito/microsserviços/serverless).
3. A stack e linguagens selecionadas.
4. A organização de componentes (§4).
5. Best practices dos frameworks escolhidos.
6. Separação clara de preocupações.

Adaptar a estrutura às necessidades do projeto. Para monorepos, mostrar separação de serviços. Para serverless, mostrar organização de funções. Incluir convenções específicas de linguagem.

**CRÍTICO**: esta seção é a **base do IMPLEMENTATION_MAP.yaml**. Cada aggregate/command/integration mapeado terá seu path derivado desta árvore.

**Elicitation requirement**: Arthur propõe estrutura, pede aprovação por nível (raiz, packages, interior de um package).

**Template content (V4 §10.examples — adaptar ao projeto):**

```
project-root/
├── packages/                    # monorepo; ou src/ se polyrepo
│   ├── api/                    # Backend API (escopo DESTE documento)
│   │   ├── src/modules/<bc>/{domain,application,infrastructure,api}/
│   │   └── tests/              # espelhando src/ (ver §12 Test Strategy)
│   ├── web/                    # Frontend — estrutura interna detalhada em FRONTEND_ARCHITECTURE.md §3
│   ├── shared/                 # utilitários/tipos comuns (cross-stack; Arthur decide limites)
│   └── infrastructure/         # IaC (ver §9)
├── scripts/                    # management scripts
└── docs/architecture/          # Sharded architecture (se aplicável — SPEC Q10 decidido monolítico v1)
```

Arthur adapta ao stack escolhido (Spring Boot / Django / Go modules / etc.). A estrutura interna de `packages/web/` (ou equivalente) é **escopo do FRONTEND_ARCHITECTURE.md** — aqui registra-se apenas o rótulo de pasta top-level para orientar monorepo.

---

## 9. Infrastructure and Deployment

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §11 (AUSENTE — integral) -->

**Instruction for agent** (V4 §11): Definir a arquitetura e práticas de deployment:

1. Usar a ferramenta IaC selecionada em Tech Stack.
2. Escolher estratégia de deployment apropriada para a arquitetura.
3. Definir ambientes e fluxo de promoção.
4. Estabelecer procedimentos de rollback.
5. Considerar segurança, monitoramento e otimização de custo.

Obter input do usuário sobre preferências de deployment e escolhas de CI/CD.

**Complementa**: NFRs do PRD §9 (uptime 99.9%, backup diário, RTO 4h — AUDITORIA §2.11) servem como **constraints**.

---

### 9.1 Infrastructure as Code (V4 §11.infrastructure-as-code)

- **Tool:** `{{iac_tool}} {{version}}` [Terraform 1.7.x | Pulumi | Bicep | CDK]
- **Location:** `{{iac_directory}}` [ex.: `packages/infrastructure/terraform`]
- **Approach:** `{{iac_approach}}` [modular por ambiente | stacks por serviço | single state]

### 9.2 Deployment Strategy (V4 §11.deployment-strategy)

- **Strategy:** `{{deployment_strategy}}` [Blue-green | Canary | Rolling | Recreate]
- **CI/CD Platform:** `{{cicd_platform}}` [GitHub Actions | GitLab CI | Azure DevOps]
- **Pipeline Configuration:** `{{pipeline_config_location}}` [ex.: `.github/workflows/`]

### 9.3 Environments (V4 §11.environments, repeatable)

Template: `- **{{env_name}}:** {{env_purpose}} — {{env_details}}`

Exemplos: dev (recursos mínimos, dados mock), staging (paridade prod, dados sintéticos), prod (HA, backup diário, monitoramento 24/7).

### 9.4 Environment Promotion Flow (V4 §11.promotion-flow)

```
PR→main → dev (auto) → [testes auto] → staging (approval) → [smoke] → prod (approval + changelog)
```

### 9.5 Rollback Strategy (V4 §11.rollback-strategy)

- **Primary Method:** `{{rollback_method}}` [redeploy previous image | DB migration rollback | IaC revert]
- **Trigger Conditions:** `{{rollback_triggers}}` [error rate > X% | latency p99 > Yms | manual]
- **Recovery Time Objective:** `{{rto}}` [ex.: 4h — Source: PRD NFR-010]

---

## 10. Error Handling Strategy

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §12 | PARCIAL complementa ANEXO_A (fluxos de exceção) + ANEXO_C (retry/CB por integração) -->

**Instruction for agent** (V4 §12): Definir abordagem abrangente de tratamento de erros:

1. Escolher padrões apropriados para a linguagem/framework de Tech Stack.
2. Definir padrões de logging e ferramentas.
3. Estabelecer categorias de erro e regras de tratamento.
4. Considerar necessidades de observabilidade e debug.
5. Garantir segurança (nenhum dado sensível em logs).

Esta seção guia tanto AI quanto desenvolvedores humanos para tratamento consistente de erros.

**Complementa** (AUDITORIA §2.12): ANEXO_A tem "Fluxos de Exceção" por processo; ANEXO_C tem retry/CB/timeout **por integração**. Esta seção é a **estratégia global transversal**: hierarquia de exception classes, formato de correlation ID, sistema global de error codes, abordagem de idempotência, estratégia de transação.

---

### 10.1 General Approach (V4 §12.general-approach)

- **Error Model:** `{{error_model}}` [Result<T,E> | exceptions hierárquicas | Either monad]
- **Exception Hierarchy:** `{{exception_structure}}` [BaseException → Domain | Application | Infrastructure]
- **Error Propagation:** `{{propagation_rules}}` [throw up até API boundary | capture+translate por camada]

### 10.2 Logging Standards (V4 §12.logging-standards)

- **Library:** `{{logging_library}} {{version}}` [pino | winston | Serilog | slog]
- **Format:** JSON estruturado
- **Levels:** debug | info | warn | error | fatal
- **Required Context:**
  - Correlation ID: `{{correlation_id_format}}` (ex.: UUID v4, header `X-Correlation-ID`)
  - Service Context: `service_name, version, env`
  - User Context: `user_id` hash; **NUNCA** email/CPF/dados sensíveis

### 10.3 Error Handling Patterns

**External API Errors** (V4 §12.external-api-errors): Retry Policy `{{retry_strategy}}` (exponential backoff, ver ANEXO_C por integração); Circuit Breaker `{{circuit_breaker_config}}` (threshold 50%, half-open 30s); Timeout `{{timeout_settings}}` (default 5s, override por integração); Error Translation `{{error_mapping_rules}}` (5xx externo → 503 | 4xx → 422).

**Business Logic Errors** (V4 §12.business-logic-errors): Custom Exceptions `{{business_exception_types}}` (InvariantViolationError, DomainRuleError, NotFoundError); User-Facing Errors `{{user_error_format}}` (`{code, message, details[]}`); Error Codes `{{error_code_system}}` (namespace.domain.code — ex.: `lic.edital.status_invalid`).

**Data Consistency** (V4 §12.data-consistency): Transaction Strategy `{{transaction_approach}}` (2PC | Saga | Outbox); Compensation Logic `{{compensation_patterns}}` (compensating commands por step); Idempotency `{{idempotency_approach}}` (`Idempotency-Key` header + dedup table com TTL).

---

## 11. Coding Standards (backend)

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §13 | PARCIAL — TERMINOLOGY_MAP.yaml já cobre naming de domínio -->

**Escopo desta seção**: coding standards de **backend**. Padrões específicos de frontend (JSX/TSX, hooks rules, component naming, CSS methodology) ficam em `FRONTEND_ARCHITECTURE.md §8 Frontend Developer Standards`.

**Instruction for agent** (V4 §13 — tradução integral, **MANDATÓRIO**):

Estes padrões são **MANDATÓRIOS** para AI agents. Trabalhar com usuário para definir **APENAS** as regras críticas necessárias para prevenir código ruim. Explicar que:

1. Esta seção **controla diretamente o comportamento do Dev agent**.
2. **Manter minimalista** — assumir que AI conhece best practices gerais.
3. Focar em convenções específicas do projeto e pegadinhas.
4. Standards detalhados demais incham contexto e desaceleram desenvolvimento.
5. Standards serão extraídos para arquivo separado para uso do dev agent (ver V4 process — sharding pelo PO).

Para cada standard, **obter confirmação explícita do usuário** de que é necessário.

**Complementa** (AUDITORIA §2.13): `TERMINOLOGY_MAP.yaml` já tem `naming_conventions` para IDs de domínio (bc_id regex `^[a-z_]+$`, aggregate_id `^[A-Z][a-zA-Z]+$`, etc.). **Não duplicar** — linkar.

---

### 11.1 Core Standards

**Template content (V4 §13.core-standards):**

```
- **Languages & Runtimes:** {{languages_and_versions}}  [fonte: §3 Tech Stack]
- **Style & Linting:** {{linter_config}}                [ex.: ESLint 8 + Prettier 3, config em .eslintrc.json]
- **Test Organization:** {{test_file_convention}}        [ex.: tests/ espelhando src/ | *.spec.ts co-localizado]
```

---

### 11.2 Naming Conventions

**Instruction** (V4 §13.naming-conventions): Incluir **apenas** se divergir dos defaults da linguagem.

**Para IDs de domínio** (bc_id, aggregate_id, command_id, etc.): **LINKAR** para `claude/TERMINOLOGY_MAP.yaml` `naming_conventions:`. **Não duplicar** aqui.

**Template content (V4 type: table):**

| Element | Convention | Example |
|---------|-----------|---------|
| File names (source) | kebab-case | `edital-repository.ts` |
| File names (test) | match source + .spec | `edital-repository.spec.ts` |
| Class names | PascalCase | `EditalRepository` |
| Function names | camelCase | `findByStatus` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| Domain IDs | ver TERMINOLOGY_MAP.yaml | — |

---

### 11.3 Critical Rules

**Instruction for agent** (V4 §13.critical-rules): Listar **APENAS** regras que AI **pode violar** ou requisitos específicos do projeto. Exemplos do V4:

- "Nunca usar console.log em production code — usar logger"
- "Todas as respostas de API devem usar tipo wrapper ApiResponse"
- "Queries de banco devem usar repository pattern, nunca ORM direto"

**Evitar** regras óbvias como "use SOLID" ou "write clean code".

**Template content (V4 §13.critical-rules, repeatable):**

```
- **{{rule_name}}:** {{rule_description}}
```

Exemplos iniciais propostos por Arthur (a validar com usuário):

```
- **Logger over console:** Nunca usar console.log em código de produção. Usar o logger configurado (ver §10.2).
- **No raw SQL in app layer:** Queries via repository pattern (§10.1). Nunca SQL inline em handlers.
- **Correlation ID propagation:** Todo request HTTP deve propagar `X-Correlation-ID`. Gerar se ausente.
- **Domain purity:** Camada domain/ não importa de infrastructure/ nem de framework HTTP.
- **No secrets in code:** Segredos vêm de {{secrets_service}} (§12.3), nunca hardcoded.
```

---

### 11.4 Language-Specific Guidelines

**Instruction** (V4 §13.language-specifics, condition: critical language-specific rules needed): Adicionar **APENAS** se crítico para prevenir erros do AI. Maioria dos times não precisa.

**Template content (V4 §13.language-rules, repeatable):**

```
### {{language_name}} Specifics

- **{{rule_topic}}:** {{rule_detail}}
```

---

## 12. Test Strategy and Standards (backend)

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §14 (AUSENTE — integral, CRÍTICO para QA e Dev) -->

**Escopo desta seção**: testes de backend (unit + integration + e2e API-level). Testes frontend (component tests, visual regression, E2E UI) são escopo do `FRONTEND_ARCHITECTURE.md §7 Testing Requirements`.

**Instruction for agent** (V4 §14 — tradução integral):

Trabalhar com usuário para definir estratégia de teste backend abrangente:

1. Usar frameworks de teste do Tech Stack (§3).
2. Decidir TDD vs test-after approach.
3. Definir organização e naming de testes.
4. Estabelecer metas de cobertura.
5. Determinar infraestrutura de testes de integração.
6. Planejar dados de teste e dependências externas.

Nota V4: info básica vai em Coding Standards para dev agent. Esta seção detalhada é para QA agent e referência do time.

**Elicitation requirement**: máxima — esta seção é consumida pelo QA de código (Fase II.2b) e pelo Dev.

---

### 12.1 Testing Philosophy

**Template content (V4 §14.testing-philosophy):**

```
- **Approach:** {{test_approach}}                  [TDD | test-after | test-as-you-go]
- **Coverage Goals:** {{coverage_targets}}          [ex.: unit 80% lines, integration 60%, critical path 100%]
- **Test Pyramid:** {{test_distribution}}           [ex.: 70% unit, 20% integration, 10% e2e]
```

---

### 12.2 Test Types and Organization

**Unit Tests** (V4 §14.unit-tests): Framework `{{unit_test_framework}} {{version}}`; File Convention `{{unit_test_naming}}` (ex.: `*.spec.ts`); Location `{{unit_test_location}}` (co-localizado | `tests/unit/`); Mocking Library `{{mocking_library}}` (vitest built-in | jest.mock | mockito); Coverage `{{unit_coverage}}` (ex.: 80% lines, 70% branches).

**AI Agent Requirements** (V4 literal, MANDATÓRIO): Generate tests for all public methods; cover edge cases and error conditions; follow AAA pattern (Arrange, Act, Assert); mock all external dependencies.

**Integration Tests** (V4 §14.integration-tests): Scope `{{integration_scope}}` (handlers + repositories + DB real); Location `{{integration_test_location}}` (`tests/integration/`); Test Infrastructure por dependência: `**{{dependency_name}}:** {{test_approach}} ({{test_tool}})`.

*Exemplos V4 literais*: **Database** — In-memory H2 (unit) / Testcontainers PostgreSQL (integration); **Message Queue** — Embedded Kafka for tests; **External APIs** — WireMock for stubbing.

**End-to-End Tests** (V4 §14.e2e-tests): Framework `{{e2e_framework}} {{version}}` (Playwright | Cypress | Selenium); Scope `{{e2e_scope}}` (top 5 journeys do PRD §4); Environment `{{e2e_environment}}` (staging dedicado | ephemeral testcontainers); Test Data `{{e2e_data_strategy}}` (seed por fixture | factory runtime).

---

### 12.3 Test Data Management (V4 §14.test-data-management)

Strategy `{{test_data_approach}}` (fixtures JSON | factories código | snapshots controlados); Fixtures `{{fixture_location}}` (`tests/fixtures/`); Factories `{{factory_pattern}}` (test-data-bot | fishery | faker custom); Cleanup `{{cleanup_strategy}}` (transaction rollback | truncate per test | schema drop).

### 12.4 Continuous Testing (V4 §14.continuous-testing)

CI Integration `{{ci_test_stages}}` (PR: unit+lint+typecheck / merge: +integration / nightly: +e2e); Performance Tests `{{perf_test_approach}}` (k6 contra staging, gates p99<Xms); Security Tests `{{security_test_approach}}` (SAST na PR, DAST nightly em staging).

---

## 13. Security

<!-- elicit: true -->
<!-- source: V4 architecture-tmpl §15 | PARCIAL complementa PRD §9 NFRs + PRD §5 DR + ANEXO_C Security -->

**Instruction for agent** (V4 §15): Definir requisitos **MANDATÓRIOS** de segurança para AI e desenvolvedores humanos:

1. Focar em regras específicas de implementação.
2. Referenciar ferramentas de segurança do Tech Stack.
3. Definir padrões claros para cenários comuns.
4. Estas regras impactam diretamente geração de código.
5. Trabalhar com usuário para garantir completude sem redundância.

**Complementa** (AUDITORIA §2.15): PRD cobre requisitos (NFR-004 TLS/AES-256, NFR-005 auth+MFA, DR-002 LGPD). ANEXO_C cobre security por integração. Esta seção materializa tudo em **decisões técnicas concretas**: libs, tools, patterns.

---

### 13.1 Input Validation (V4 §15.input-validation)

- **Validation Library:** `{{validation_library}}` [zod | joi | class-validator | pydantic]
- **Validation Location:** `{{where_to_validate}}` (API boundary antes de handler)
- **Required Rules** (V4 literal): all external inputs MUST be validated; validation at API boundary before processing; **whitelist preferido sobre blacklist**.

### 13.2 Authentication & Authorization (V4 §15.auth-authorization)

- **Auth Method:** `{{auth_implementation}}` [JWT Bearer | OAuth2 | Session cookie]
- **Session Management:** `{{session_approach}}` [stateless JWT | Redis session store]
- **Required Patterns:** `{{auth_pattern_1}}`, `{{auth_pattern_2}}` (ex.: MFA obrigatório para admin — PRD NFR-005; token refresh com rotation)

### 13.3 Secrets Management (V4 §15.secrets-management)

- **Development:** `{{dev_secrets_approach}}` (ex.: `.env.local` gitignored + direnv)
- **Production:** `{{prod_secrets_service}}` (Azure Key Vault | AWS Secrets Manager | HashiCorp Vault)
- **Code Requirements** (V4 literal): NEVER hardcode secrets; access via configuration service only; no secrets in logs or error messages.

### 13.4 API Security (V4 §15.api-security)

- **Rate Limiting:** `{{rate_limit_implementation}}` (ex.: Redis token bucket, 100 req/min por IP)
- **CORS Policy:** `{{cors_configuration}}` (origins whitelistadas)
- **Security Headers:** `{{required_headers}}` (HSTS, CSP, X-Frame-Options, X-Content-Type-Options)
- **HTTPS Enforcement:** `{{https_approach}}` (redirect 80→443, HSTS max-age 31536000)

### 13.5 Data Protection (V4 §15.data-protection)

- **Encryption at Rest:** `{{encryption_at_rest}}` [AES-256 — Source: PRD NFR-004]
- **Encryption in Transit:** `{{encryption_in_transit}}` [TLS 1.3 — Source: PRD NFR-004]
- **PII Handling:** `{{pii_rules}}` [LGPD — Source: PRD DR-002; pseudonimização em logs]
- **Logging Restrictions:** `{{what_not_to_log}}` (CPF, email plain, senhas, tokens, dados bancários)

### 13.6 Dependency Security (V4 §15.dependency-security)

- **Scanning Tool:** `{{dependency_scanner}}` [npm audit | Snyk | Dependabot | Trivy]
- **Update Policy:** `{{update_frequency}}` (security patches 7d, minors mensal)
- **Approval Process:** `{{new_dep_process}}` (PR review + license check + vuln scan)

### 13.7 Security Testing (V4 §15.security-testing)

- **SAST Tool:** `{{static_analysis}}` [SonarQube | Semgrep | CodeQL]
- **DAST Tool:** `{{dynamic_analysis}}` [OWASP ZAP em staging]
- **Penetration Testing:** `{{pentest_schedule}}` (anual por terceiro + após major releases)

---

## 14. Checklist Results Report

<!-- elicit: false -->
<!-- source: V4 architecture-tmpl §16 (AUSENTE — integral) -->

**Instruction for agent** (V4 §16): Antes de rodar o checklist, oferecer output do documento inteiro de arquitetura. Após confirmação do usuário, executar o `architect-checklist` e popular resultados aqui.

**Arthur executa auto-validação** (10-12 eixos — detalhe em CA-criar-arquitetura.md do agente) cobrindo:

1. Todas as seções (1-13) têm conteúdo ≠ placeholder?
2. Tech Stack tem versões pinadas (nenhum "latest")?
3. Source Tree está consistente com Components?
4. REST API Spec tem endpoint para cada command do ANEXO_B?
5. Database Schema tem tabela para cada aggregate do ANEXO_B?
6. Core Workflows cobre top-3 user journeys do PRD §4?
7. Error Handling Strategy referencia ANEXO_A exceção e ANEXO_C retry?
8. Coding Standards linka TERMINOLOGY_MAP?
9. Test Strategy tem framework + location + coverage por tipo?
10. Security materializa todos os NFRs de segurança do PRD?
11. Infrastructure tem IaC tool + pipeline + rollback?
12. Todas as decisões têm fonte citada `[Source: ...]`?

**Template content**: tabela com colunas `| Eixo | Status (PASS/WARN/FAIL) | Notas |` cobrindo os 12 eixos acima.

**Status Global**: PASS | WARN | FAIL

---

## 15. Next Steps

<!-- elicit: false -->
<!-- source: V4 architecture-tmpl §17 | PARCIAL — ANEXO_C tem padrão "Consumo por Agentes Downstream" -->

**Instruction for agent** (V4 §17): Após completar a arquitetura:

1. Se o projeto tem componentes UI: usar "Frontend Architecture Mode" (ou prosseguir com arquitetura unificada — ver SPEC §9.7).
2. Para todos os projetos:
   - Review com Product Owner.
   - Iniciar implementação de stories com Dev agent.
   - Setup de infraestrutura com DevOps agent (no nosso pipeline: via IaC do próprio Dev ou agente dedicado em fase futura).
3. Incluir prompts específicos para próximos agentes se necessário.

**Padrão a replicar** (AUDITORIA §2.17): ANEXO_C tem seção "Consumo por Agentes Downstream" — replicar aqui.

---

### 15.1 Consumo por Agentes Downstream

Este documento será consumido por:

- **Scrum Master (Fase II.2b)** → Usa `SOFTWARE_ARCHITECTURE.md` **e** `FRONTEND_ARCHITECTURE.md` + `IMPLEMENTATION_MAP.yaml` + `READINESS_REPORT.md` (IR) para escrever stories self-contained com Dev Notes extraindo apenas o relevante por story (ver V4 `create-next-story.md` §3).
- **Desenvolvedor (Fase II.2b)** → Lê **stories + devLoadAlwaysFiles** (tipicamente seções §3 Tech Stack, §8 Source Tree, §11 Coding Standards deste documento + §2 Frontend Tech Stack, §3 Project Structure, §10 Frontend Developer Standards do FRONTEND — extraídas via sharding — se habilitado). **Nunca lê arquitetura completa diretamente** (V4 core_principle).
- **QA de Código (Fase II.2b)** → Usa §12 Test Strategy (backend) + `FRONTEND_ARCHITECTURE.md §7 Testing Requirements` como referência normativa; §13 Security para security review (cross-stack).
- **Guardião de Linguagem Ubíqua (Lexicon)** → Lê a seção §11.2 (backend) e equivalente do FRONTEND para sincronização com TERMINOLOGY_MAP.yaml e termos técnicos novos introduzidos.
- **Arquiteto de Software (Arthur, reentrada)** → Capability AM para atualização incremental; capability IR para re-validação após mudanças em qualquer dos dois documentos.

---

### 15.2 Cross-Referência ao FRONTEND_ARCHITECTURE.md

**Nota V4 (adaptada — decisão Q7 em 2026-04-19)**: nesta arquitetura, o Arquiteto Frontend é o **próprio Arthur** produzindo o documento-irmão `FRONTEND_ARCHITECTURE.md` na mesma capability CA. Não há handoff para outro agente. Esta subseção lista o que é esperado no documento-irmão:

- Tech Stack frontend (framework UI, state, routing, build, styling — ver FRONTEND §2).
- Project Structure frontend (§3).
- Component Standards (§4).
- State Management (§5).
- API Integration com o backend (§6) — consome REST API Spec deste documento (§6).
- Routing (§7).
- Styling Guidelines (§7).
- Testing Requirements frontend (§7).
- Environment Configuration frontend (§9).
- Frontend Developer Standards (§10 — coding rules frontend, quick reference).

---

### 15.3 Próximo passo imediato sugerido

Após aprovação deste documento pelo usuário:

1. Executar capability **IR** (`@arquiteto-de-software IR`) para gerar `READINESS_REPORT.md`.
2. Se status = **PASS** → acionar **Scrum Master** (Fase II.2b) para fragmentação em stories.
3. Se status = **WARN/FAIL** → retornar à capability CA para refinar seções apontadas, ou ao Analista de Negócio (Sofia) para enriquecer ANEXO.

---

**Fim do template backend.**

**Total de seções**: 15 (V4 17 - 2 cobertas por ANEXO_B/ANEXO_C)
**Seções com `elicit: true`**: 11 (§1.2 Starter, §2, §3, §4, §5, §6, §7, §8, §9, §10, §11, §12, §13 — quase todas; §14 e §15 são auto-geradas)
**Versão do template**: 1.0 (draft — amendment 2026-04-19: banner dual-documento + delimitações backend-only)
**Derivado de**: BMAD V4 `architecture-tmpl.yaml` v2.0
**Complemento obrigatório**: `DRAFT_FRONTEND_ARCHITECTURE-template.md` (escopo frontend).
