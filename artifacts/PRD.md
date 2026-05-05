# PRD — Ycodify CRM - Service
# Versao: 1.0 (passagem 1 — fechado)
# Ultima atualizacao: 2026-04-30
# Responsavel: PM (Giovanna) + Analista de Negocio (Sofia)

---

## 1. Visao Geral do Produto

<!-- RASCUNHO PM — refinar em VE -->

**Nome do produto**: Ycodify CRM - Service

**Descricao**: Plataforma de CRM de uso interno da Ycodify para gestao do ciclo comercial completo — desde a captacao de leads ate o fechamento de oportunidades e encaminhamento para a equipe de Engenharia. Substitui o uso de planilhas e ferramentas externas de CRM.

**Problema que resolve**:
- Leads gerenciados em planilhas sem historico centralizado.
- Pipeline de vendas invisivel para gestao.
- Churn invisivel — sem rastreabilidade de oportunidades perdidas.
- Vendedores sem background do cliente ao iniciar contato.
- Gap entre area comercial e equipe de Engenharia no handoff de contratos fechados.

**Solucao**: Aplicacao web interna B2B, single-tenant (Ycodify), com gestao de Leads, Contas, Contatos, Pipeline de Oportunidades, Historico de Vendas e notificação automática da Engenharia ao fechar a Oportunidade.

**Driver estrategico**: Solucao propria para cortar custos com CRMs externos e adaptar o fluxo exatamente ao processo da Ycodify.

---

## 2. Objetivos de Negocio

<!-- RASCUNHO PM — refinar em VE -->

| ID | Objetivo | Metrica de Sucesso |
|----|----------|--------------------|
| OB-01 | Centralizar captacao e qualificacao de leads | 100% dos leads registrados no CRM (zero planilhas) |
| OB-02 | Tornar o pipeline de vendas visivel em tempo real | Gerente e Gestor consultam pipeline sem solicitar relatorio manual |
| OB-03 | Reduzir leads sem contato | Reducao de leads sem interacao por mais de 5 dias (alerta automatico) |
| OB-04 | Automatizar handoff comercial -> engenharia | 100% das oportunidades ganhas notificam Engenharia automaticamente |
| OB-05 | Eliminar custos de CRM externo | Desativacao de ferramentas externas apos go-live |

---

## 3. Stakeholders e Personas

<!-- RASCUNHO PM — refinar em VE -->

### Stakeholders

| Papel | Nome/Grupo | Interesse |
|-------|-----------|-----------|
| Sponsor / Decisor | Gestao Ycodify | ROI, corte de custo, visibilidade comercial |
| Usuario Principal | Time Comercial (Vendedores, Gerente) | Produtividade, pipeline claro |
| Usuario Secundario | Atendimento | Tickets pos-venda (Fase 2) |
| Downstream | Engenharia | Receber handoff de oportunidades ganhas |

### Personas

| ID | Persona | Descricao | Perfil de Acesso |
|----|---------|-----------|-----------------|
| P-VEN | Vendedor | Responsavel por leads, contatos e oportunidades proprios | Ve apenas seus proprios registros |
| P-GER | Gerente Comercial | Supervisiona time, redistribui oportunidades, cria registros | Ve registros de todo o time |
| P-GES | Gestor | Visao estrategica — dashboards, historico, metricas | Ve todos os registros |
| P-ATE | Atendimento | Gerencia tickets pos-venda | Ve tickets atribuidos a si (Fase 2) |

---

## 4. User Journeys

### Jornada 1 — Vendedor: Captura e Conversao de Lead

**Persona**: Vendedor (P-VEN)
**Objetivo**: Registrar, qualificar e converter um lead em oportunidade de venda.

```
1. Vendedor recebe notificacao de novo Lead (via formulario web)
   OU
   Vendedor cria Lead manualmente (nome, e-mail, empresa, telefone)

2. Vendedor acessa o Lead com status Novo

3. Vendedor registra primeiro contato (ligacao, e-mail, reuniao)
   -> Sistema move Lead para "Em Contato"
   -> Sistema registra ultima_interacao_em

4. Vendedor qualifica o Lead apos entender necessidade
   -> Sistema move Lead para "Qualificado"

5. Vendedor converte o Lead
   -> Sistema cria Conta e Oportunidade automaticamente
   -> Lead fica com status Convertido (preservado como historico)

6. Vendedor preenche Oportunidade:
   - valor_estimado (obrigatorio)
   - define estagio inicial: Proposta Enviada

7. Vendedor avanca a Oportunidade pelo pipeline (Negociacao -> Fechamento)

8a. Oportunidade Ganha:
    -> Vendedor marca como Ganha
    -> Sistema envia e-mail automatico para Engenharia
    -> Historico de Vendas atualizado

8b. Oportunidade Perdida:
    -> Vendedor preenche motivo_perda (texto livre, obrigatorio)
    -> Sistema registra Oportunidade como Perdida
```

**Restricoes de visibilidade**: Vendedor ve apenas seus proprios Leads e Oportunidades.

---

### Jornada 2 — Gerente Comercial: Supervisao e Redistribuicao

**Persona**: Gerente Comercial (P-GER)
**Objetivo**: Monitorar pipeline do time, redistribuir oportunidades, garantir que leads nao fiquem parados.

```
1. Gerente acessa painel de pipeline com visao do time completo

2. Gerente identifica Leads sem interacao ha 5+ dias
   (ou recebe notificacao automatica do sistema)

3. Gerente pode:
   a) Redistribuir Lead para outro Vendedor
   b) Redistribuir Oportunidade para outro Vendedor
   c) Criar Lead ou Oportunidade diretamente

4. Gerente consulta Historico de Vendas do time:
   - Lista de Oportunidades Ganhas
   - Metricas: total por periodo, por vendedor, por conta

5. Gerente valida pipeline e projeta fechamentos futuros
```

**Restricoes de visibilidade**: Gerente ve todos os registros do seu time.

---

### Jornada 3 — Gestor: Visao Estrategica

**Persona**: Gestor (P-GES)
**Objetivo**: Acompanhar performance comercial, identificar gargalos, tomar decisoes.

```
1. Gestor acessa painel global (todos os times e vendedores)

2. Gestor consulta metricas:
   - Total de leads por periodo e por origem
   - Taxa de conversao (Leads -> Oportunidades)
   - Pipeline por estagio
   - Historico de Vendas: total por periodo, por vendedor, por conta

3. Gestor identifica alertas:
   - Leads parados (5 dias sem contato)
   - Oportunidades estagnadas em determinado estagio

4. Gestor toma decisoes gerenciais (redistribuicao, meta, foco)
```

**Restricoes de visibilidade**: Gestor ve todos os registros sem restricao.

---

### Jornada 4 — Atendimento: Gestao de Tickets (Fase 2)

**Persona**: Atendimento (P-ATE)
**Status**: FASE 2 — fora do MVP. Jornada a detalhar no proximo ciclo.

> Atendimento gerencia tickets de suporte pos-venda vinculados a Contas existentes. Detalhamento pendente.

---

## 5. Domain Requirements

### 5.1 Setor e Compliance

**Setor**: Tecnologia / SaaS (uso interno)

**Compliance identificado**:
- **LGPD**: Provavel aplicabilidade — dados pessoais de leads e contatos (nome, e-mail, telefone) sao coletados e armazenados. Detalhamento em ciclo futuro.
- **Outros**: Nao identificados na passagem 1. [A DEFINIR]

**Nota**: Cliente nao impôs restricoes de compliance na passagem 1. Registrado como pendencia para ciclo de refinamento (VE).

### 5.2 Regras de Negocio por Dominio

As regras de negocio detalhadas estao no ANEXO A (processos) e ANEXO B (invariantes dos aggregates). Resumo:

| ID | Regra | Referencia |
|----|-------|------------|
| RN-L01 | Lead sem interacao ha 5 dias -> notificacao automatica ao Gerente + Vendedor responsavel | ANEXO A — P-01 |
| RN-L02 | Leads nao sao excluidos (historico preservado) | ANEXO A — P-01 |
| RN-L04 | Conversao de Lead dispara criacao automatica de Conta + Oportunidade | ANEXO A — P-01 |
| RN-O01 | Oportunidade herda Vendedor Responsavel do Lead de origem | ANEXO A — P-02 |
| RN-O02 | Gerente pode redistribuir Oportunidade a qualquer momento | ANEXO A — P-02 |
| RN-O05 | valor_estimado e obrigatorio na Oportunidade | ANEXO A — P-02 |
| RN-O06 | motivo_perda obrigatorio quando estagio = Perdida | ANEXO A — P-02 |
| RN-HV01 | Historico de Vendas segue matriz de visibilidade por perfil | ANEXO A — P-03 |

### 5.3 Modelo de Dominio

Ver ANEXO B — Data Models para:
- Aggregates: Lead, Conta, Oportunidade
- Entidade: Contato (filha de Conta)
- Projection: HistoricoVenda (read model de Oportunidades Ganhas)
- Bounded Contexts: comercial (MVP), posvenda (Fase 2)

---

## 6. Innovation Analysis / Competitive Landscape

<!-- RASCUNHO PM — refinar em VE -->

**Contexto**: Substituicao de CRMs externos por solucao propria da Ycodify.

**Alternativas avaliadas**: Ferramentas externas de CRM (nao especificadas pelo cliente). Decisao foi por solucao propria por dois fatores: custo e adequacao ao fluxo especifico da Ycodify (especialmente o handoff automatico para Engenharia).

**Diferenciais da solucao propria**:
- Integracao nativa com o sistema da Engenharia (MVP: e-mail; Pos-MVP: sistemica)
- Fluxo adaptado exatamente ao processo interno
- Custo operacional controlado (sem licenca externa)

---

## 7. Project-Type Requirements

### 7.1 Tipo de Produto

- **Tipo**: Aplicacao web interna
- **Modelo**: B2B, single-tenant (Ycodify)
- **Ambiente**: Uso interno — usuarios sao funcionarios/colaboradores da Ycodify

### 7.2 Plataforma

- **Plataforma alvo**: Web (browser)
- **Browsers suportados**: [A DEFINIR — ciclo futuro]
- **Mobile**: [A DEFINIR — ciclo futuro]
- **Aplicacao desktop/nativa**: Nao prevista

### 7.3 Autenticacao e Autorizacao

- **Autenticacao**: Obrigatoria. Mecanismo especifico a definir (login/senha, SSO, etc.) — [A DEFINIR]
- **Autorizacao por perfil**:

| Perfil | Escopo de Visibilidade |
|--------|----------------------|
| Vendedor | Apenas seus proprios registros (Leads, Oportunidades, HistoricoVenda) |
| Gerente Comercial | Todos os registros do seu time |
| Gestor | Todos os registros sem restricao |
| Atendimento | Tickets atribuidos (Fase 2) |

- **Isolamento**: Single-tenant — todos os dados pertencem a Ycodify. Nao ha isolamento multi-tenant.

### 7.4 Integrações

Ver ANEXO C — Integrations. Resumo:
- **INT-01a** (MVP): E-mail automatico para Engenharia ao fechar OportunidadeGanha
- **INT-01b** (Pos-MVP): Notificacao sistemica ao sistema da Engenharia
- **INT-02**: Formulario web de captura de Lead (entrada)
- **INT-03**: Servico de e-mail transacional (base para notificacoes)

---

## 8. Functional Requirements

<!-- RASCUNHO PM+BA — refinar criterios de aceite em VE -->

| ID | Titulo | Descricao | Ator(es) | Criterio de Aceite |
|----|--------|-----------|----------|--------------------|
| FR-001 | Captura de Lead via formulario web | Sistema recebe submissao do formulario web e cria Lead com status Novo automaticamente | Sistema | Lead criado com criado_por = Sistema, status = Novo, origem = formulario_web |
| FR-002 | Captura manual de Lead | Vendedor ou Gerente Comercial cria Lead manualmente preenchendo campos obrigatorios | Vendedor, Gerente Comercial | Lead criado com criado_por = usuario logado, status = Novo, origem = manual |
| FR-003 | Qualificacao de Lead | Vendedor avanca o Lead pelos estados (Novo -> Em Contato -> Qualificado). Registra ultima_interacao_em a cada transicao. | Vendedor | Transicoes de estado registradas. ultima_interacao_em atualizado. |
| FR-004 | Conversao de Lead em Conta e Oportunidade | Ao converter Lead Qualificado, sistema cria automaticamente Conta e Oportunidade vinculadas. Lead fica com status Convertido. | Vendedor, Gerente Comercial | Conta criada, Oportunidade criada com responsavel = Vendedor do Lead, Lead.status = Convertido, Lead preservado. |
| FR-005 | Notificacao de Lead sem contato (5 dias) | Sistema dispara notificacao automatica ao Gerente Comercial e ao Vendedor responsavel quando Lead fica 5 dias sem interacao registrada. | Sistema | Notificacao enviada apos 5 dias sem ultima_interacao_em atualizado. Status do Lead nao e Convertido nem Descartado. |
| FR-006 | CRUD de Conta | Criacao, leitura, edicao de Conta com seus dados cadastrais. | Vendedor, Gerente Comercial, Gestor | Conta criada/editada com campos obrigatorios. Cardinalidade 1 Conta : N Contatos respeitada. |
| FR-007 | CRUD de Contato | Criacao, leitura, edicao de Contato vinculado a uma Conta. | Vendedor, Gerente Comercial, Gestor | Contato criado com conta_id obrigatorio. Exatamente um Contato marcado como principal por Conta. |
| FR-008 | Gestao do Pipeline de Oportunidades | Vendedor e Gerente avancam Oportunidade pelos estagios: Proposta Enviada -> Negociacao -> Fechamento. | Vendedor, Gerente Comercial | Transicoes de estagio registradas. valor_estimado obrigatorio ao criar. |
| FR-009 | Marcar Oportunidade como Ganha | Ao marcar Oportunidade como Ganha, sistema dispara OportunidadeGanha e envia e-mail automatico para Engenharia. | Vendedor, Gerente Comercial | Oportunidade.estagio = Ganha, fechado_em preenchido, e-mail enviado para Engenharia. |
| FR-010 | Marcar Oportunidade como Perdida | Ao marcar Oportunidade como Perdida, sistema exige preenchimento obrigatorio de motivo_perda (texto livre). | Vendedor, Gerente Comercial | Oportunidade.estagio = Perdida, motivo_perda preenchido, fechado_em preenchido. Bloqueio se motivo_perda vazio. |
| FR-011 | Historico de Vendas — registros individuais | Usuario consulta listagem de Oportunidades Ganhas com filtros, respeitando visibilidade por perfil. | Vendedor, Gerente Comercial, Gestor | Lista exibe conta, valor_estimado, fechado_em, vendedor. Visibilidade por perfil aplicada. |
| FR-012 | Historico de Vendas — metricas agregadas | Usuario consulta totais de vendas por periodo, por vendedor e por conta, respeitando visibilidade por perfil. | Gerente Comercial, Gestor | Metricas calculadas corretamente. Vendedor ve apenas seus proprios totais. |
| FR-013 | Visibilidade por perfil | Sistema aplica regras de visibilidade em todos os modulos: Vendedor (seus), Gerente (time), Gestor (tudo). | Sistema | Vendedor nao ve registros de outros vendedores. Gerente ve time. Gestor ve tudo. |
| FR-014 | Redistribuicao de Oportunidade pelo Gerente | Gerente Comercial pode alterar o VendedorResponsavel de qualquer Lead ou Oportunidade a qualquer momento. | Gerente Comercial | Responsavel alterado. Evento OportunidadeResponsavelAlterado registrado. |
| FR-015 | Solicitacao de Substituicao de Vendedor | O Vendedor pode solicitar sua propria substituicao na conducao de um Lead ou Oportunidade. A solicitacao exige preenchimento obrigatorio de motivo (texto livre). A solicitacao e encaminhada ao Gerente Comercial para aprovacao. Distinto de FR-014 (que e iniciativa do Gerente): este fluxo e iniciativa do proprio Vendedor. | Vendedor | Dado que Vendedor preenche motivo e confirma solicitacao, quando submete, entao Gerente Comercial recebe notificacao com dados do Lead/Oportunidade e motivo informado. |
| FR-016 | Aprovacao de Substituicao pelo Gerente Comercial | O Gerente Comercial recebe a solicitacao de substituicao, avalia, escolhe o Vendedor substituto e aprova ou recusa. Se aprovado, o Lead e a Oportunidade vinculada sao transferidos ao substituto. Se recusado, o Vendedor solicitante permanece responsavel. | Gerente Comercial | Dado que Gerente recebe solicitacao, quando aprova e escolhe substituto, entao Lead + Oportunidade vinculada sao reatribuidos ao substituto e evento SubstituicaoAprovada e disparado. Quando recusa, evento SubstituicaoRecusada e disparado e responsavel permanece inalterado. |

---

## 9. Non-Functional Requirements

<!-- RASCUNHO PM+BA — refinar em VE com cliente -->

> **Nota**: Cliente informou explicitamente "sem restricoes" de NFRs na passagem 1. Todos os itens abaixo sao placeholders para refinamento no ciclo VE.

| ID | Categoria | Requisito | Status |
|----|-----------|-----------|--------|
| NFR-001 | Performance | Tempo de resposta das operacoes CRUD e consultas: a definir | [A DEFINIR — ciclo VE] |
| NFR-002 | Performance | Volume de dados / usuarios simultaneos: estimativa ~20 leads/semana, time pequeno | [A DEFINIR — ciclo VE] |
| NFR-003 | Seguranca | Autenticacao obrigatoria para todos os usuarios | Confirmado |
| NFR-004 | Seguranca | Isolamento de visibilidade por perfil (ver FR-013) | Confirmado |
| NFR-005 | Compliance | LGPD: dados pessoais de leads/contatos coletados — avaliar impacto | [A DEFINIR — ciclo VE] |
| NFR-006 | Disponibilidade | SLA de disponibilidade: a definir | [A DEFINIR — ciclo VE] |
| NFR-007 | Escalabilidade | Volume esperado baixo (uso interno, ~20 leads/semana) — sem requisito critico de escala no MVP | Observado |
| NFR-008 | Auditoria | Rastreabilidade de alteracoes (quem criou, quem modificou, quando): desejavel | [A DEFINIR — ciclo VE] |

---

## 10. Metadata (Rastreabilidade)

```yaml
prd_metadata:
  project: "crm"
  project_alias: "Ycodify CRM - Service"
  client: "Ycodify"
  version: "1.0"
  passagem: 1
  data: "2026-04-30"
  prd_mode: "monolithic"
  status: "Negocio Mapeado (passagem 1)"

  bounded_contexts:
    - id: "comercial"
      tecnico_id: "comercial"
      descricao: "Gestao de Leads, Contas, Contatos, Oportunidades e Pipeline"
      escopo: "MVP"
      aggregates:
        - nome: "Lead"
          tecnico_id: "lead"
          fr_relacionados: ["FR-001", "FR-002", "FR-003", "FR-004", "FR-005", "FR-013"]
        - nome: "Conta"
          tecnico_id: "conta"
          fr_relacionados: ["FR-006", "FR-013"]
        - nome: "Oportunidade"
          tecnico_id: "oportunidade"
          fr_relacionados: ["FR-008", "FR-009", "FR-010", "FR-013", "FR-014"]
        - nome: "SolicitacaoSubstituicao"
          tecnico_id: "solicitacaosubstituicao"
          fr_relacionados: ["FR-015", "FR-016"]
      entidades:
        - nome: "Contato"
          tecnico_id: "contato"
          fr_relacionados: ["FR-007", "FR-013"]
      projections:
        - nome: "HistoricoVenda"
          tecnico_id: "historicovenda"
          fr_relacionados: ["FR-011", "FR-012", "FR-013"]

    - id: "posvenda"
      tecnico_id: "posvenda"
      descricao: "Tickets de suporte pos-venda"
      escopo: "Fase 2 — fora do MVP"
      aggregates:
        - nome: "Ticket"
          tecnico_id: "ticket"
          fr_relacionados: []

  integracoes:
    - id: "emailengenharia"
      tecnico_id: "emailengenharia"
      escopo: "MVP"
      fr_relacionados: ["FR-009"]
    - id: "sistemaengenharia"
      tecnico_id: "sistemaengenharia"
      escopo: "Pos-MVP"
      fr_relacionados: ["FR-009"]
    - id: "formularioweb"
      tecnico_id: "formularioweb"
      escopo: "MVP"
      fr_relacionados: ["FR-001"]
    - id: "emailtransacional"
      tecnico_id: "emailtransacional"
      escopo: "MVP"
      fr_relacionados: ["FR-005", "FR-009"]

  personas:
    - id: "vendedor"
      tecnico_id: "vendedor"
      perfil_acesso: "proprios_registros"
      fr_relacionados: ["FR-001", "FR-002", "FR-003", "FR-004", "FR-008", "FR-009", "FR-010", "FR-011", "FR-012", "FR-015"]
    - id: "gerentecomercial"
      tecnico_id: "gerentecomercial"
      perfil_acesso: "registros_do_time"
      fr_relacionados: ["FR-002", "FR-004", "FR-006", "FR-007", "FR-008", "FR-009", "FR-010", "FR-011", "FR-012", "FR-014", "FR-016"]
    - id: "gestor"
      tecnico_id: "gestor"
      perfil_acesso: "todos_os_registros"
      fr_relacionados: ["FR-011", "FR-012", "FR-013"]
    - id: "atendimento"
      tecnico_id: "atendimento"
      perfil_acesso: "tickets_atribuidos"
      fr_relacionados: []
      nota: "Fase 2 — jornada nao detalhada no MVP"

  pendencias_ciclo_futuro:
    - "Suporte a Contato sem Conta (pessoa fisica / B2C)"
    - "Detalhamento da integracao sistemica com Sistema da Engenharia (INT-01b)"
    - "NFRs: performance, compliance/LGPD, disponibilidade, auditoria"
    - "Atividades, Historico de Interacoes, Tickets pos-venda (Fase 2)"
    - "Jornada da persona Atendimento (Fase 2)"
    - "Lista fixa de motivos de perda (apenas texto livre na passagem 1)"
    - "Criterios de qualificacao de Lead — nao detalhados"
    - "Regras detalhadas de redistribuicao de Oportunidade pelo Gerente"
    - "Atribuicao de Lead vindo de formulario web (automatica vs fila)"
    - "Browsers suportados, suporte mobile"
    - "Mecanismo de autenticacao (login/senha, SSO)"
    - "CNPJ da Conta — obrigatorio ou opcional"

  secos_rascunho_pm:
    - "Secao 1 — Visao Geral"
    - "Secao 2 — Objetivos de Negocio"
    - "Secao 3 — Stakeholders"
    - "Secao 6 — Innovation Analysis"
    - "Secao 8 — Criterios de Aceite (refinamento)"
    - "Secao 9 — NFRs (refinamento)"
```
