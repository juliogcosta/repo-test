---
# Frontmatter: Tracking de estado e progresso
stepsCompleted: []
inputDocuments: []
workflowType: 'prd'
documentCounts:
  briefCount: 0
  researchCount: 0
  projectDocsCount: 0
currentStatus: "in_progress"
lastEdited: null
editCount: 0
createdAt: null
approvedBy: null
approvedAt: null
version: "1.0"
---

# Product Requirements Document — {PROJECT_ALIAS}

**Projeto**: {PROJECT_NAME}
**Cliente**: {CLIENT_NAME}
**Autor**: {PM_NAME} (Orquestrador/PM) + {BA_NAME} (Analista de Negócio)
**Data de Criação**: {YYYY-MM-DD}
**Versão**: 1.0
**Status**: {Em Elaboração | Aguardando Aprovação | Aprovado}

---

## 1. Executive Summary

> **Responsável**: Orquestrador/PM (Giovanna)
> **Objetivo**: Comunicar visão, diferenciação e objetivos estratégicos para stakeholders

### Vision

{Descreva em 2-3 frases a visão do produto. O QUE estamos construindo e POR QUÊ isso importa?}

**Exemplo**:
> Sistema centralizado de gestão de licitações públicas que elimina processos manuais e reduz tempo de ciclo em 70%. Primeira solução nacional com rastreabilidade completa e compliance automático com Lei de Licitações.

---

### Differentiator

{O que torna este produto ÚNICO? Qual a principal vantagem competitiva?}

**Exemplo**:
> Único sistema que automatiza análise comparativa de propostas usando IA, reduzindo análise técnica de 3 dias para 2 horas, com 95% de precisão.

---

### Target Users

{Quem são os usuários principais? Liste por ordem de prioridade.}

**Exemplo**:

| Perfil | Necessidade Principal | Volume |
|--------|----------------------|--------|
| Gerente de Compras | Aprovar licitações rapidamente com visibilidade de pipeline | 5 usuários |
| Analista de Licitações | Criar editais e analisar propostas sem retrabalho manual | 15 usuários |
| Fornecedor (Externo) | Enviar propostas e acompanhar status em tempo real | 200+ usuários |

---

## 2. Success Criteria

> **Responsável**: Orquestrador/PM (Giovanna)
> **Objetivo**: Definir métricas SMART que comprovam sucesso do produto

{Liste critérios de sucesso mensuráveis. Use formato: Métrica + Target + Prazo + Método de Medição}

**Template**:
```
[Métrica] alcançar [Target] até [Prazo] medido por [Método]
```

**Exemplo**:

### Business Metrics

- **Redução de tempo de ciclo**: Reduzir tempo médio de licitação de 45 dias para 13 dias (-70%) até 6 meses após lançamento, medido por análise de histórico de processos
- **Taxa de erro em editais**: Reduzir de 25% para < 5% até 3 meses, medido por auditorias
- **Compliance**: 100% das licitações com rastreabilidade completa (Lei nº 8.666/93) desde dia 1, medido por auditoria legal

### User Metrics

- **Adoção**: 80% dos Analistas usando sistema como ferramenta principal até 2 meses
- **Satisfação (NPS)**: NPS >= 50 até 6 meses
- **Produtividade**: Analistas criam 3x mais editais por semana comparado a processo manual, medido após 3 meses

### Technical Metrics

- **Performance**: Dashboard carrega em < 2 segundos para 95% das requisições
- **Uptime**: 99.9% durante horário comercial (8am-6pm)
- **Adoção de features**: 70% dos usuários usam análise comparativa de propostas até 4 meses

---

## 3. Product Scope

> **Responsável**: Orquestrador/PM (Giovanna)
> **Objetivo**: Definir fases de entrega (MVP → Growth → Vision)

### MVP (Minimum Viable Product)

{O menor conjunto de features que valida a hipótese de valor. O que DEVE estar na primeira versão?}

**Exemplo**:

**Objetivo do MVP**: Validar que centralização + automação reduz tempo de ciclo em licitações

**Features Essenciais**:
- ✅ Criar e publicar editais de licitação
- ✅ Receber propostas de fornecedores (upload de arquivos)
- ✅ Fluxo de aprovação multinível (Analista → Gerente)
- ✅ Notificações automáticas por email
- ✅ Log de auditoria completo
- ✅ Dashboard de status de licitações

**Out of Scope (MVP)**:
- ❌ Análise comparativa automática com IA (Growth phase)
- ❌ Integração com portal de compras governamental (Growth phase)
- ❌ Assinatura digital de contratos (Vision phase)
- ❌ App mobile (Vision phase)

**Critério de sucesso do MVP**:
- 10 licitações completadas usando o sistema em 2 meses
- Tempo médio de ciclo < 20 dias (vs 45 dias manual)

---

### Growth Phase

{Features que escalam o produto após validação do MVP}

**Exemplo**:

**Objetivo**: Escalar adoção e adicionar diferenciação competitiva

**Features**:
- ✅ Análise comparativa automática de propostas com IA
- ✅ Integração com Receita Federal (validação automática de CNPJ)
- ✅ Relatórios analíticos e dashboards executivos
- ✅ Biblioteca de templates de editais
- ✅ Integração com portal ComprasNet (governo federal)

**Critério de sucesso**:
- 50+ licitações/mês processadas
- Análise comparativa reduz tempo de análise técnica em 80%

---

### Vision Phase

{Features de longo prazo que transformam o produto}

**Exemplo**:

**Objetivo**: Tornar-se plataforma completa de procurement público

**Features**:
- ✅ Assinatura digital de contratos (integração ICP-Brasil)
- ✅ Gestão de contratos pós-homologação (aditivos, renovações)
- ✅ App mobile para fornecedores
- ✅ Marketplace de fornecedores pré-qualificados
- ✅ Integração com sistemas de pagamento (empenho, liquidação)

---

## 4. User Journeys

> **Responsável**: Analista de Negócio (Sofia) — escreve | Orquestrador/PM (Giovanna) — revisa e valida value
> **Objetivo**: Mapear jornadas end-to-end dos usuários principais

{Para cada user persona, descreva a jornada completa. Foco em NECESSIDADES, não em clicks.}

---

### Journey 4.1: Gerente de Compras — Aprovar Licitação

**Persona**: Maria Silva, Gerente de Compras, 15 anos de experiência

**Contexto**: Maria precisa aprovar editais rapidamente mas sem comprometer qualidade. Recebe 20-30 solicitações/mês.

**Journey Steps**:

1. **Notificação de novo edital para aprovação**
   - Recebe email com resumo executivo do edital
   - **Need**: Ver informação crítica sem abrir sistema (valor, categoria, prazo)
   - **Pain**: Sistema atual exige login para ver qualquer detalhe

2. **Revisar edital**
   - Acessa dashboard, vê lista de editais pendentes
   - **Need**: Priorizar por urgência (prazo de publicação)
   - **Pain**: Não sabe quais são mais urgentes
   - Abre edital, revisa: objeto, valor, prazo, critérios técnicos
   - **Need**: Validar que campos obrigatórios estão preenchidos
   - **Pain**: Editais incompletos passam para aprovação

3. **Decisão: Aprovar ou Solicitar Correção**
   - **Se APROVADO**: Clica "Aprovar" → Sistema publica automaticamente → Notificações enviadas
   - **Se CORRIGIR**: Adiciona comentários → Devolve para Analista → Analista notificado
   - **Need**: Comunicar razão da devolução de forma clara
   - **Pain**: Vai-e-vem desnecessário por falta de clareza

4. **Acompanhar status pós-aprovação**
   - Vê dashboard atualizado com licitação "Aberta"
   - **Need**: Confirmar que fornecedores foram notificados
   - **Pain**: Sem visibilidade se notificações falharam

**Outcomes Esperados**:
- ✅ Aprova edital em < 15 minutos (vs 1-2 horas manual)
- ✅ 0 editais incompletos aprovados (validação automática)
- ✅ 100% rastreabilidade de decisões (auditoria)

**Links para FRs**: FR-001 (Notificações), FR-005 (Dashboard), FR-010 (Aprovação)

---

### Journey 4.2: Analista de Licitações — Criar Edital

{Repetir estrutura acima para segundo journey mais crítico}

**Persona**: João Santos, Analista de Licitações, 3 anos de experiência

{Detalhar steps, needs, pains, outcomes}

**Links para FRs**: FR-002 (Criar edital), FR-003 (Validações), FR-008 (Templates)

---

### Journey 4.3: Fornecedor — Enviar Proposta

{Repetir estrutura para terceiro journey}

**Links para FRs**: FR-015 (Upload proposta), FR-016 (Acompanhar status)

---

## 5. Domain Requirements

> **Responsável**: Analista de Negócio (Sofia) — descobre | Orquestrador/PM (Giovanna) — valida criticidade
> **Objetivo**: Identificar requisitos específicos da indústria/domínio que são OBRIGATÓRIOS

{Auto-detectar baseado em contexto do projeto. Exemplos: Healthcare=HIPAA, Fintech=PCI-DSS, GovTech=Lei de Licitações}

**Domínio Identificado**: {GovTech / Fintech / Healthcare / E-commerce / Outro}

**Exemplo (GovTech — Licitações Públicas)**:

### DR-001: Compliance com Lei nº 8.666/93 ⚠️ OBRIGATÓRIA

**Descrição**: Todas as licitações devem seguir princípios da Lei de Licitações: legalidade, impessoalidade, moralidade, igualdade, publicidade

**Implicações Técnicas**:
- Log de auditoria completo (quem fez o quê, quando)
- Publicidade obrigatória (editais públicos)
- Prazo mínimo de 15 dias para recebimento de propostas
- Critérios de julgamento transparentes e objetivos

**Método de Validação**: Auditoria legal trimestral

---

### DR-002: LGPD (Lei Geral de Proteção de Dados) ⚠️ OBRIGATÓRIA

**Descrição**: Dados de fornecedores (CNPJ, razão social, contatos) são dados pessoais e devem ser protegidos

**Implicações Técnicas**:
- Consentimento explícito para armazenamento de dados
- Direito de exclusão (fornecedor pode pedir remoção de dados)
- Criptografia em trânsito (HTTPS) e em repouso (database encryption)
- Log de acesso a dados pessoais

**Método de Validação**: Relatório LGPD de DPO (Data Protection Officer)

---

### DR-003: Acessibilidade (WCAG 2.1 AA) ✅ DESEJÁVEL

**Descrição**: Sistema deve ser acessível para pessoas com deficiência (Lei Brasileira de Inclusão - LBI)

**Implicações Técnicas**:
- Navegação por teclado
- Leitores de tela compatíveis
- Contraste mínimo de cores (4.5:1)
- Textos alternativos em imagens

**Método de Validação**: Teste com ferramenta automatizada (Axe, WAVE)

---

## 6. Innovation Analysis

> **Responsável**: Orquestrador/PM (Giovanna) — OPCIONAL para projetos com componente de inovação
> **Objetivo**: Documentar diferenciação competitiva e inovação

{Preencher apenas se projeto tem componente de inovação/diferenciação tecnológica significativa}

### Competitive Landscape

{Quem são os competidores? O que eles fazem bem? Onde falhamos?}

**Exemplo**:

| Competidor | Pontos Fortes | Gaps/Fraquezas |
|-----------|---------------|----------------|
| Sistema Legado Interno | Conhecimento institucional profundo | Interface DOS, sem automação, sem mobile |
| ComprasNet (Governo Federal) | Integração governamental | Complexo, lento, não adaptável para estados/municípios |
| Startups (BidManager, LicitaFácil) | UX moderna, mobile-first | Sem compliance robusto, sem histórico de auditoria |

---

### Our Innovation

{O que fazemos de DIFERENTE tecnologicamente?}

**Exemplo**:

**IA para Análise Comparativa Automática**:
- Primeiro sistema nacional que usa NLP para extrair critérios técnicos de propostas automaticamente
- Reduz análise técnica de 3 dias para 2 horas
- 95% de precisão (validado em 100 licitações piloto)

**Compliance-First Architecture**:
- Log de auditoria imutável (blockchain-style hashing)
- Rastreabilidade completa desde criação até homologação
- Aprovado em auditoria TCU (Tribunal de Contas da União)

---

## 7. Project-Type Requirements

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Identificar requisitos específicos do tipo de projeto (web app, mobile, API, etc)

**Project Type Identificado**: {Web Application / Mobile App / API Platform / Desktop App / Outro}

**Exemplo (Web Application)**:

### PT-001: Browser Compatibility

- Suporta Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **NÃO** suporta Internet Explorer (EOL)
- Testes de compatibilidade automatizados (BrowserStack)

### PT-002: Responsive Design

- Layout adaptativo para desktop (1920x1080), tablet (1024x768), mobile (375x667)
- Prioridade: Desktop-first (80% dos usuários)

### PT-003: Authentication

- Login via CPF + senha (usuários internos)
- Login via CNPJ + senha (fornecedores)
- MFA (Multi-Factor Authentication) obrigatório para Gerentes
- Integração com Gov.br (SSO governamental) — Growth phase

---

## 8. Functional Requirements (FRs)

> **Responsável**: Orquestrador/PM (Giovanna) + Analista de Negócio (Sofia) — COLABORATIVO
> **Objetivo**: Definir capabilities testáveis que o sistema DEVE ter

**REGRAS PARA FRs**:
- ✅ Escrever como **capability** ("Users can X") — NÃO como process step
- ✅ **Mensurável** com critério de teste específico
- ✅ **Rastreável** a User Journey (referenciar journey ID)
- ✅ **Sem implementação** (evitar mencionar tecnologia específica)
- ✅ **Conciso** (1-3 frases, zero fluff)

**Template**:
```
### FR-XXX: [Nome do Requirement]

**Capability**: [Users can / System can] [ação] [condição] [resultado esperado]

**Source**: [Journey 4.X / Success Criteria / Domain Requirement]

**Test Criteria**:
- [Critério 1 mensurável]
- [Critério 2 mensurável]

**Priority**: [Must-Have / Should-Have / Nice-to-Have]
```

---

### FR-001: Email Notifications on Status Change

**Capability**: Users receive email notifications within 5 minutes when status of edital or proposta changes

**Source**: Journey 4.1 (Gerente needs visibility), Journey 4.3 (Fornecedor needs updates)

**Test Criteria**:
- Email delivered within 5 minutes of status change in 99% of cases
- Email contains: edital number, old status, new status, link to detail page
- Users can opt-out of notifications per category

**Priority**: Must-Have (MVP)

---

### FR-002: Create and Submit Edital

**Capability**: Analistas can create edital draft, fill required fields, and submit for approval in under 30 minutes

**Source**: Journey 4.2 (Analista creates edital)

**Test Criteria**:
- Required fields validated before submission (valor > 0, prazo >= 15 dias)
- Draft auto-saved every 2 minutes
- Submission triggers notification to Gerente within 5 minutes
- Edital receives unique sequential number (YYYY/NNNN format)

**Priority**: Must-Have (MVP)

---

### FR-003: Field Validation Rules

**Capability**: System enforces validation rules on edital fields before allowing save or submission

**Source**: DR-001 (Compliance Lei de Licitações)

**Test Criteria**:
- `valor_estimado` must be > 0 and <= R$ 100,000,000
- `data_encerramento` must be >= `data_abertura` + 15 calendar days
- `objeto` must have minimum 100 characters
- `categoria` must be from predefined list
- Validation errors displayed inline with field

**Priority**: Must-Have (MVP)

---

### FR-005: Approval Dashboard

**Capability**: Gerentes can view all editais pending approval sorted by urgency (closest deadline first) and approve/reject in under 3 clicks

**Source**: Journey 4.1 (Gerente approves quickly)

**Test Criteria**:
- Dashboard loads in < 2 seconds with up to 100 pending editais
- Editais sorted by `(data_encerramento - today)` ascending
- Each edital shows: número, objeto (truncated 50 chars), valor, prazo, status
- Click on edital → detail page loads in < 1 second
- Approve button → confirmation modal → approved status + notification sent

**Priority**: Must-Have (MVP)

---

### FR-008: Edital Templates Library

**Capability**: Analistas can select from library of pre-approved edital templates to reduce creation time from 30 min to 10 min

**Source**: Success Criteria (Produtividade — 3x mais editais), Growth Phase

**Test Criteria**:
- Library contains >= 10 templates covering common categories (TI, Obras, Serviços)
- Template selection pre-fills 70% of edital fields
- Analista can customize pre-filled fields
- Templates versioned and approved by Legal team

**Priority**: Should-Have (Growth Phase)

---

### FR-010: Approval Workflow

**Capability**: System enforces approval workflow (Analista creates → Gerente approves → System publishes) with status transitions and audit log

**Source**: Journey 4.1 (Gerente approves), DR-001 (Auditoria)

**Test Criteria**:
- Status transitions: Rascunho → Aguardando Aprovação → Aprovado → Aberto → Encerrado
- Only Gerente role can approve/reject
- Rejection requires comment (minimum 20 characters)
- Approval triggers automatic publication + notifications
- Every transition logged with: timestamp, user ID, old status, new status, comment

**Priority**: Must-Have (MVP)

---

### FR-015: Upload Proposta

**Capability**: Fornecedores can upload proposta (PDF, max 10 MB) before deadline with automatic validation

**Source**: Journey 4.3 (Fornecedor envia proposta)

**Test Criteria**:
- Upload only allowed if edital status = "Aberto"
- Upload rejected if `now() > data_encerramento`
- File size validation (max 10 MB)
- File format validation (PDF only)
- Fornecedor receives confirmation email within 5 minutes with upload timestamp (proof of submission)

**Priority**: Must-Have (MVP)

---

{Continue FR-016, FR-020, etc para cobrir TODOS os capabilities essenciais}

**Rastreabilidade**: Cada FR deve linkar para pelo menos 1 User Journey ou Success Criteria.

---

## 9. Non-Functional Requirements (NFRs)

> **Responsável**: Orquestrador/PM (Giovanna) define NFRs de negócio | Analista de Negócio (Sofia) define NFRs técnicos
> **Objetivo**: Definir quality attributes mensuráveis

**REGRAS PARA NFRs**:
- ✅ **Sempre mensurável**: [Métrica] [condição] [método de medição]
- ✅ **Realista**: Baseado em constraints conhecidos
- ❌ **Evitar adjetivos vagos**: "rápido", "escalável", "seguro" → usar números

**Template**:
```
### NFR-XXX: [Categoria] - [Nome]

**Requirement**: The system shall [métrica] [condição] as measured by [método]

**Rationale**: [Por quê isso importa?]

**Priority**: [Must-Have / Should-Have / Nice-to-Have]
```

---

### NFR-001: Performance - API Response Time

**Requirement**: The system shall respond to API requests in under 200ms for 95th percentile under normal load (up to 500 concurrent users) as measured by APM monitoring (DataDog)

**Rationale**: Users expect instant feedback. Response time > 500ms degrades UX and productivity.

**Priority**: Must-Have (MVP)

---

### NFR-002: Availability - Uptime

**Requirement**: The system shall maintain 99.9% uptime during business hours (8am-6pm BRT, Mon-Fri) as measured by cloud provider SLA

**Rationale**: Downtime during business hours blocks critical workflows. Licitações têm prazos legais.

**Priority**: Must-Have (MVP)

---

### NFR-003: Scalability - Concurrent Users

**Requirement**: The system shall support 500 concurrent users without performance degradation (response time < 500ms) as measured by load testing (JMeter)

**Rationale**: Growth phase expects 50 organizations × 10 users/org = 500 concurrent users in peak hours.

**Priority**: Should-Have (Growth Phase)

---

### NFR-004: Security - Data Encryption

**Requirement**: The system shall encrypt all data in transit (TLS 1.3) and at rest (AES-256) as measured by security audit

**Rationale**: DR-002 (LGPD) mandates protection of personal data. Auditoria TCU exige.

**Priority**: Must-Have (MVP)

---

### NFR-005: Security - Authentication

**Requirement**: The system shall enforce password complexity (min 8 chars, 1 uppercase, 1 number, 1 special char) and MFA for Gerente role as measured by security policy enforcement

**Rationale**: Gerentes approve high-value transactions. Compromised accounts = risk legal/financial.

**Priority**: Must-Have (MVP)

---

### NFR-006: Auditability - Complete Audit Log

**Requirement**: The system shall log 100% of operations that modify editais or propostas with timestamp (ISO 8601), user ID, IP address, old value, new value, stored in immutable log as measured by audit report

**Rationale**: DR-001 (Lei de Licitações) exige rastreabilidade completa para auditorias TCU.

**Priority**: Must-Have (MVP)

---

### NFR-007: Usability - Onboarding Time

**Requirement**: New users shall complete first edital creation within 60 minutes of onboarding (including training) in 80% of cases as measured by user testing

**Rationale**: Success Criteria (Adoção 80% em 2 meses) depende de UX intuitiva.

**Priority**: Should-Have (MVP)

---

### NFR-008: Data Retention - Archive Policy

**Requirement**: The system shall retain all editais and propostas for minimum 5 years after licitação closure as measured by database retention policy

**Rationale**: Lei de Licitações exige guarda de documentos por 5 anos para auditorias.

**Priority**: Must-Have (MVP)

---

### NFR-010: Backup - Disaster Recovery

**Requirement**: The system shall perform daily backups at 2:00 AM BRT with retention of 30 days and RTO (Recovery Time Objective) < 4 hours as measured by DR drill quarterly

**Rationale**: Data loss = perda de conformidade legal. RTO 4h permite recovery durante business hours.

**Priority**: Must-Have (MVP)

---

{Continue NFR-011, NFR-015, etc para cobrir: Maintainability, Compatibility, Localization, etc}

---

## 10. Metadados Técnicos (Uso Interno)

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Facilitar tradução de PRD para specs técnicas (spec_documentos.json, spec_processos.json)

{Esta seção é consumida por Arquitetos e QA. Cliente NÃO precisa revisar.}

```yaml
# Mapeamento Negócio → Técnico
# Baseado em TERMINOLOGY_MAP.yaml

modulos:
  - negocio: "Licitações"
    tecnico_id: "licitacao"
    bounded_context: true
    descricao: "Gestão de editais e ciclo de vida de licitações"
    frs_relacionados: [FR-001, FR-002, FR-003, FR-005, FR-010]

  - negocio: "Propostas"
    tecnico_id: "proposta"
    bounded_context: true
    descricao: "Recebimento e análise de propostas de fornecedores"
    frs_relacionados: [FR-015, FR-016]

  - negocio: "Contratos"
    tecnico_id: "contrato"
    bounded_context: true
    descricao: "Gestão de contratos pós-homologação"
    frs_relacionados: []  # Growth phase

documentos:
  - negocio: "Edital de Licitação"
    tecnico_id: "Edital"
    aggregate: true
    modulo: "licitacao"
    frs_relacionados: [FR-002, FR-003, FR-010]

  - negocio: "Proposta"
    tecnico_id: "Proposta"
    aggregate: true
    modulo: "proposta"
    frs_relacionados: [FR-015]

comandos:
  - negocio: "Criar Rascunho de Edital"
    tecnico_id: "CriarRascunhoEdital"
    command: true
    fr_source: FR-002

  - negocio: "Aprovar Edital"
    tecnico_id: "AprovarEdital"
    command: true
    fr_source: FR-010

  - negocio: "Enviar Proposta"
    tecnico_id: "EnviarProposta"
    command: true
    fr_source: FR-015

eventos:
  - negocio: "Edital Criado"
    tecnico_id: "EditalCriado"
    domain_event: true
    fr_source: FR-002

  - negocio: "Edital Aprovado"
    tecnico_id: "EditalAprovado"
    domain_event: true
    fr_source: FR-010

  - negocio: "Proposta Enviada"
    tecnico_id: "PropostaEnviada"
    domain_event: true
    fr_source: FR-015

nfrs_mapeados:
  - nfr_id: NFR-001
    categoria: "Performance"
    metrica: "API response time < 200ms (p95)"
    metodo_medicao: "APM (DataDog)"

  - nfr_id: NFR-006
    categoria: "Auditability"
    metrica: "100% operations logged"
    metodo_medicao: "Audit report"
    implicacao_tecnica: "Event sourcing pattern recomendado"
```

---

## Anexos

{Referenciar anexos criados pelo Analista de Negócio com detalhes operacionais}

- **ANEXO A**: [Process Details](./ANEXO_A_ProcessDetails.md) — Processos detalhados, etapas, fluxos BPMN narrativos
- **ANEXO B**: [Data Models](./ANEXO_B_DataModels.md) — Documentos, campos, relacionamentos, ERD narrativo
- **ANEXO C**: [Integrations](./ANEXO_C_Integrations.md) — APIs externas, sistemas legados, contratos de integração

---

## Aprovação e Histórico de Mudanças

### Aprovações

| Data | Aprovador | Papel | Status | Comentários |
|------|-----------|-------|--------|-------------|
| {YYYY-MM-DD} | {Nome} | {Papel} | {Aprovado/Pendente/Rejeitado} | {Comentários} |

---

### Histórico de Versões

| Versão | Data | Autor | Seções Modificadas | Motivo |
|--------|------|-------|-------------------|--------|
| 1.0 | {YYYY-MM-DD} | {PM + BA} | Todas | Versão inicial |

---

**Fim do PRD**

---

## 📝 Instruções para Orquestrador/PM e Analista

### Para Orquestrador/PM (Giovanna):

**Você escreve**:
- ✅ Seção 1 (Executive Summary): Vision, Differentiator, Target Users
- ✅ Seção 2 (Success Criteria): Business/User/Technical metrics
- ✅ Seção 3 (Product Scope): MVP, Growth, Vision phases
- ✅ Seção 6 (Innovation Analysis): Competitive landscape (se aplicável)

**Você revisa e valida**:
- ⚠️ Seção 4 (User Journeys): Sofia escreve, você pergunta "POR QUÊ?" até clarificar value
- ⚠️ Seção 5 (Domain Requirements): Sofia descobre, você valida criticidade
- ⚠️ Seção 7 (Project-Type): Sofia identifica, você valida prioridades

**Você colabora**:
- 🤝 Seção 8 (FRs): Você LIDERA escrita (foco em capabilities), Sofia DETALHA (test criteria)
- 🤝 Seção 9 (NFRs): Você define NFRs de negócio, Sofia define NFRs técnicos

---

### Para Analista de Negócio (Sofia):

**Você escreve**:
- ✅ Seção 4 (User Journeys): End-to-end journeys com needs/pains
- ✅ Seção 5 (Domain Requirements): Compliance, industry-specific
- ✅ Seção 7 (Project-Type Requirements): Browser, auth, platform
- ✅ Seção 10 (Metadados YAML): Mapeamento negócio→técnico
- ✅ ANEXOS A, B, C: Process details, data models, integrations

**Você colabora**:
- 🤝 Seção 8 (FRs): Giovanna LIDERA (capabilities), você DETALHA (test criteria, edge cases)
- 🤝 Seção 9 (NFRs): Giovanna define NFRs de negócio, você define NFRs técnicos

**Você valida**:
- ⚠️ Seções 1-3: Garantir que Giovanna capturou requisitos de negócio corretamente

---

### Critérios de Completude:

- ✅ Seções 1-9 completamente preenchidas (sem placeholders `{...}`)
- ✅ Pelo menos 3 User Journeys detalhados (Seção 4)
- ✅ Mínimo 10 FRs Must-Have (Seção 8)
- ✅ Mínimo 8 NFRs Must-Have (Seção 9)
- ✅ Rastreabilidade: Todos os FRs linkam para Journey ou Success Criteria
- ✅ Seção 10 (Metadados YAML) preenchida com IDs técnicos normalizados
- ✅ ANEXOS A, B, C criados e linkados
- ✅ Cliente aprovou PRD

---

**Versão do Template**: 1.0 (BMAD-Style)
**Data**: 2026-04-15
**Baseado em**: BMAD Method + Padrões de Mercado 2025
**Mantido por**: Arquitetura de Agentes YC Platform
