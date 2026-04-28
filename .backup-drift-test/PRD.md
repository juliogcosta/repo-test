# Product Requirements Document (PRD) - Versão Compilada

> **NOTA**: Este documento foi gerado automaticamente pela compilação das seções fragmentadas.
> Para editar, trabalhe nas seções individuais em `sections/` e recompile com `./compile-prd.sh`

---

**Gerado em**: 2026-04-18 22:01:31
**Fonte**: Compilado a partir de seções fragmentadas

---


# Seção 1: Executive Summary (Overview)

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Orquestrador/PM (Giovanna)
**Objetivo**: Comunicar visão, diferenciação e perfis de usuário para stakeholders

---

## 1.1. Vision

Ycognio é uma interface webchat multi-participante que expõe a arquitetura de agentes Claude já operacional nos projetos Ycodify, tornando o processo de elicitação e especificação de requisitos uma atividade colaborativa assistida por IA.

O propósito central do MVP é resolver a dor raiz da Ycodify: especificações de baixa qualidade que geram múltiplas idas e vindas durante o desenvolvimento — custosas para o cliente (espera e retrabalho de escopo) e para a Ycodify (retrabalho de análise e desenvolvimento). O processo atual é 100% manual, distribuído em 6-8 horas ao longo de aproximadamente duas semanas. Ycognio comprime esse ciclo e eleva a qualidade do output.

O produto atua nas fases iniciais de definição de produto — construção, manutenção e evolução de sistemas de informação, integrações entre sistemas e protótipos — e produz como output principal um PRD completo, consistente (internamente coerente e alinhado às expectativas do cliente), armazenado em repositório Git compartilhado entre cliente e Ycodify.

O Ycognio é peça crítica da estratégia comercial da Ycodify: melhora a qualidade da entrega, reduz o tempo de onboarding de novos projetos e diferencia a empresa no mercado pela maturidade do processo de elicitação. A visão de longo prazo inclui integração nativa com a plataforma Forger, abertura automatizada de chamados de mudança em especificações e consulta ao estado operacional de sistemas em produção — todos fora do escopo do MVP.

---

## 1.2. Differentiator

O diferencial do Ycognio no MVP não é a tecnologia de IA isoladamente — é a combinação de três elementos que, juntos, não existem em nenhuma ferramenta atual da Ycodify:

**Arquitetura de agentes especializados exposta diretamente no chat.** Os agentes que já existem em `.claude/` de cada projeto (Orquestrador, Analista de Negócio, Guardião de Linguagem, QA, etc.) são invocáveis diretamente pelos participantes. Cada mensagem identifica qual agente respondeu. Não é um chatbot genérico — é o workflow de elicitação da Ycodify operando em interface conversacional.

**Colaboração multi-participante com papéis explícitos.** Até 5 participantes simultâneos (IA + humanos) com papéis distintos: PO do cliente como interlocutor principal da IA, Analista Ycodify como interlocutor secundário com profundidade técnica, e observadores passivos. A IA fala linguagem de negócios para o cliente, pensa tecnicamente quando possível, e pede esclarecimentos quando o contexto técnico for insuficiente.

**Output versionado em Git compartilhado.** O resultado da conversa não é um resumo de chat — são artefatos concretos (PRD.md, ANEXOS, specs JSON) materializados diretamente na estrutura de pastas do projeto e versionados em repositório acessível tanto pelo cliente quanto pela Ycodify. Rastreabilidade total desde a conversa até a especificação técnica.

**Fora do escopo diferencial do MVP**: integração nativa com Forger para provisionamento automático e análise de concorrentes de mercado.

---

## 1.3. Target Users

### 1.3.1. Persona A — PO do Cliente (Interlocutor Principal)

- **Perfis típicos**: Product Owners, Gerentes de TI, Diretores com ownership do produto sendo especificado
- **Papel no login (select)**: `PO`
- **Linguagem**: pura de negócios — não conhece (nem precisa conhecer) jargão técnico, BPMN, DDD, JSON
- **Papel na conversa**: interlocutor principal da IA; responde perguntas de elicitação, valida escopo, aprova artefatos; é para quem a IA adapta primariamente seu registro de comunicação
- **Dor que traz para o chat**: incerteza sobre o que pedir, dificuldade de articular requisitos com precisão suficiente para desenvolvimento

### 1.3.2. Persona B — Analista Ycodify (Interlocutor Secundário)

- **Perfil típico**: Analista de Domínio e Processos; outros perfis técnicos da Ycodify também participam conforme necessidade
- **Papel no login (select)**: `YC Analyst`
- **Bagagem técnica**: completa — codificação, análise de sistemas, modelagem de domínio, integrações
- **Papel na conversa**: interlocutor secundário da IA; aprofunda aspectos técnicos quando necessário, medeia ambiguidades entre cliente e IA, orienta o PO em decisões de escopo com implicação técnica, e pode invocar agentes diretamente para tarefas específicas
- **Responde em qualquer nível técnico** conforme o contexto da conversa exigir

### 1.3.3. Persona C — Observadores

- **Perfis típicos**: demais colaboradores da empresa cliente (gerentes funcionais, especialistas de área, diretores que não são o PO)
- **Papel no login (select)**: `Guest`
- **Participação**: majoritariamente passiva — acompanham a conversa, validam pontos do seu domínio quando acionados, mas não interagem ativamente com os agentes como interlocutores principais
- **Exceção explícita**: PO do cliente (Persona A) sempre interage ativamente, mesmo sendo "do lado do cliente"

---

## 1.4. Scope Summary

**Dentro do MVP**:

- Webchat multi-participante (até 5 participantes simultâneos: IA + humanos)
- Exposição dos agentes Claude operacionais em `.claude/` via Claude Agent SDK
- Cada mensagem identifica o agente respondente; qualquer participante pode invocar qualquer agente diretamente (ex: `@guardiao`, `@analista-de-negocio`)
- Output: artefatos de projeto (PRD.md, ANEXOS, specs) materializados e versionados em repositório Git compartilhado (cliente + Ycodify)
- IA opera em linguagem de negócios com raciocínio técnico implícito; solicita esclarecimentos quando contexto técnico for insuficiente
- 2 sessões simultâneas, ~10 PRDs/mês
- Modalidade de uso: cliente usa diretamente ou assistido por Analista Ycodify

**Fora do MVP (Growth/Vision)**:

- Integração nativa com plataforma Forger (provisionamento automático pós-PRD)
- Agentes de abertura de chamados de mudança em especificações existentes
- Consulta de estado operacional de sistemas e dados em produção
- Análise competitiva de mercado

---

## 1.5. Volume e Escala (MVP)

| Métrica | Valor MVP |
|---|---|
| Sessões simultâneas | 2 |
| PRDs/mês esperados | ~10 |
| Participantes por sessão | até 5 (IA + humanos) |
| Processo baseline (manual atual) | 6-8h distribuídas em ~2 semanas |
| Modalidades de uso | self-service (cliente) + assistido (com Analista Ycodify) |

---

## 🔗 Navegação

- ⬅️ Anterior: [Índice](../PRD_index.md)
- ➡️ Próxima: [Seção 2: Objectives](PRD_02_Objectives.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 2: Objectives (Success Criteria)

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Orquestrador/PM (Giovanna)
**Objetivo**: Definir métricas SMART que provam o sucesso do MVP

---

## 2.1. Overview

A dor raiz que o Ycognio endereça é qualidade de especificação: PRDs incompletos ou inconsistentes gerados no processo manual atual resultam em retrabalho no desenvolvimento — ciclos de clarificação entre analista e arquiteto após a entrega do documento. O sucesso do MVP é medido em três dimensões complementares: **Business** (o que a Ycodify ganha operacionalmente), **User** (o que o PO do cliente experimenta durante e após a sessão) e **Technical** (o que o sistema garante em infraestrutura e dados). Todas as métricas são SMART: específicas, mensuráveis, com método de coleta definido e baseline estabelecido.

---

## 2.2. Business Metrics

| ID | Métrica | Meta MVP | Método de Medição |
|---|---|---|---|
| BM-01 | Completude + tempo integrado: PRD com 100% das 10 seções preenchidas (zero `[A PREENCHER]`), produzido em ≤ 8h de chat ativo cumulativo | 100% das sessões atingem ambos os critérios simultaneamente | Validação estática do PRD (`grep "[A PREENCHER]"` retorna 0) + telemetria de turns acumulados via SDK do agente |
| BM-02 | Distribuição de calendário: janela entre primeira e última mensagem da sessão | ≤ 4 dias corridos | Timestamp do primeiro evento `session_start` e do último evento `artifact_approved` no log da sessão |
| BM-03 | Consistência interna entre PRD, ANEXOS e specs: zero issues críticos na validação cruzada | 100% das sessões passam no QA cruzado sem edição adicional pós-entrega | Execução de `@qa-de-specs` ao final da sessão; métrica = 0 issues críticos no `QA_REPORT.md` |
| BM-04 | Satisfação do analista receptor (arquiteto que consome o PRD) | NPS ≥ 50 | Formulário de **4 perguntas** (1 pergunta NPS escala 0-10: "Quão provável você recomendar este PRD como ponto de partida?" + 3 perguntas complementares qualitativas — definição operacional das 3 complementares em fase de deploy) enviado ao arquiteto após entrega |

**Business Metrics descartadas no MVP**:

- **Taxa de retrabalho no desenvolvimento**: proposta na elicitação, descartada por ausência de baseline histórico Ycodify e de instrumentação de change tracking no pipeline atual. Candidata a métrica futura quando houver coleta operacional. Registrada em `LEARNING_LOG.md`.

---

## 2.3. User Metrics (PO do Cliente)

| ID | Métrica | Meta MVP | Método de Medição |
|---|---|---|---|
| UM-01 | Clareza da condução da entrevista | NPS ≥ 70 | 1 pergunta pós-sessão, imediatamente após aprovação do PRD: *"Quão clara foi a condução da entrevista de elicitação?"* (escala NPS 0-10) |
| UM-02 | Reconhecimento e profundidade de captura | Média ≥ 4,5/5 em ambas as perguntas | Formulário de 2 perguntas exibido na tela de aprovação: (a) *"O PRD reflete o que você queria construir?"* (1-5); (b) *"O PRD captura aspectos do seu negócio que você não teria conseguido articular sozinho?"* (1-5) |

---

## 2.4. Technical Metrics

| ID | Métrica | Meta MVP | Método de Medição |
|---|---|---|---|
| TM-01 | Disponibilidade do webchat | ≥ 99% em horário comercial (8h-20h BRT, dias úteis) | Monitoramento de uptime via ping + health check a cada 60s; cálculo mensal de disponibilidade em janela comercial |
| TM-02 | Persistência de artefatos | 100% das sessões encerradas com todos os artefatos commitados no repositório Git do projeto e recuperáveis via `git pull` | Auditoria pós-sessão: script verifica presença dos artefatos esperados no commit mais recente do repositório |
| TM-03 | Sincronização multi-participante | Latência de broadcast ≤ 2s para 99% dos eventos de sessão | Instrumentação de `event_sent → event_received` por participante; percentil 99 calculado por sessão |

**Technical Metric descartada como Success Criterion**:

- **Latência de resposta do agente (LLM)**: descartada do conjunto formal de Success Criteria por ser dependente de variáveis externas (provedor de LLM, carga). Registrada como NFR soft target na Seção 9 (meta referencial: p95 ≤ 15s para streaming completo da resposta do agente).

---

## 2.5. Resumo: Baseline vs. Meta

| Dimensão | Baseline (Processo Manual Atual) | Meta MVP (Ycognio) |
|---|---|---|
| Tempo total de elicitação | 6-8h (estimado, inclui idas e vindas) | 6-8h preservado; foco é reduzir esforço cognitivo, não o tempo bruto |
| Tempo em chat ativo | N/A | ≤ 8h cumulativo por sessão |
| Distribuição de calendário | ~2 semanas (reuniões esparsas + revisões) | ≤ 4 dias corridos |
| Cobertura de seções do PRD | Variável — seções críticas frequentemente incompletas | 100% das 10 seções preenchidas |
| Consistência entre artefatos | Manual, propensa a gaps e contradições | 100% validado por QA cruzado automatizado |
| Retrabalho no desenvolvimento | Alto (sem número exato disponível) | A instrumentar em fase futura com pipeline de coleta |

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 1: Overview](PRD_01_Overview.md)
- ➡️ Próxima: [Seção 3: Product Scope](PRD_03_ProductScope.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 3: Product Scope

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Orquestrador/PM (Giovanna)
**Objetivo**: Definir fases de entrega (MVP → Growth → Vision), delimitar escopo com precisão e declarar anti-roadmap

---

## 3.1. MVP (Minimum Viable Product)

### 3.1.1. Objetivo do MVP

Entregar uma interface webchat operacional que exponha a arquitetura de agentes Claude existente nos projetos Ycodify, suportando sessões de elicitação colaborativas entre Persona A (PO do Cliente) e Persona B (Analista Ycodify), com output em artefatos PRD versionados em repositório Git — validando a hipótese de que o processo assistido por IA produz PRDs completos, consistentes e em menos dias corridos do que o processo manual atual.

O MVP deliberadamente evita fricções de onboarding (autenticação formal, provisionamento de infra) para permitir validação rápida com base de usuários conhecida (meta: 10 PRDs/mês). Controles formais são endereçados na Growth Phase.

### 3.1.2. Features IN (18 features)

Numeração preserva o conjunto original de 15 candidatos elicitados — F2 está OUT do MVP (ver 3.1.3).

| ID | Feature | Descrição | Ancora |
|---|---|---|---|
| F1 | Webchat multi-participante | Interface web com canal de mensagens compartilhado; suporte a até 5 participantes simultâneos (IA + humanos: PO, Analista, Observadores) | — |
| F3 | Identificação visível do agente respondendo | Cada mensagem da IA exibe prefixo/badge identificando qual agente Claude respondeu (`[Orquestrador]`, `[Analista de Negócio]`, `[Guardião]`, etc.) | — |
| F4 | Invocação direta de agentes por qualquer participante | Qualquer participante humano pode invocar qualquer agente via `@nome-do-agente` na mensagem; IA roteia a invocação ao agente correto conforme `.claude/agents/` do projeto | — |
| F5 | Integração com Claude Agent SDK | Backend executa os agentes Claude operacionais via SDK oficial Anthropic; passa contexto de sessão, recebe streaming de respostas; opera sobre `working_dir = project_path` | BM-01 |
| F6 | Persistência em pasta Git pré-existente | Ycognio opera sobre pasta Git já existente passada como input; agentes escrevem artefatos no filesystem; commits e push automáticos no repositório Git remoto | TM-02 |
| F7 | Acesso Git compartilhado cliente+Ycodify | Repositório Git acessível externamente tanto pela Ycodify quanto pelo cliente (clone, pull, PRs); onboarding de colaboradores no Git é pré-condição externa (ver A2) | TM-02 |
| F8 | Telemetria de tempo de chat ativo | Instrumentação de eventos `user_typing_start`, `user_message_sent`, `ai_response_complete`; calcula tempo de chat ativo cumulativo por sessão | BM-01 |
| F9 | Formulário NPS pós-sessão — PO do Cliente | Form de 1 pergunta NPS exibido ao PO imediatamente após aprovação do PRD: *"Quão clara foi a condução da entrevista de elicitação?"* (escala 0-10) | UM-01 |
| F10 | Formulário de reconhecimento e profundidade — PO do Cliente | Form de 2 perguntas exibido na tela de aprovação para o PO: (a) *"O PRD reflete o que você queria construir?"* (1-5); (b) *"O PRD captura aspectos do seu negócio que você não teria conseguido articular sozinho?"* (1-5) | UM-02 |
| F11 | Formulário de feedback analista receptor — Analista Ycodify | Form de **4 perguntas** enviado ao arquiteto que consome o PRD após entrega: 1 pergunta NPS (escala 0-10) *"Quão provável você recomendaria este PRD como ponto de partida para desenvolvimento?"* + 3 perguntas complementares qualitativas (conteúdo exato definido em fase de deploy) | BM-04 |
| F12 | Monitoramento de uptime (health check) | Ping + health check a cada 60s; cálculo mensal de disponibilidade em janela comercial (8h-20h BRT, dias úteis); alertas em caso de indisponibilidade | TM-01 |
| F13 | Auditoria de commit pós-sessão | Script de verificação que confirma presença dos artefatos esperados no commit mais recente do repositório Git ao final de cada sessão; resultado registrado em log de auditoria | TM-02 |
| F14 | Painel dedicado de visualização do PRD em andamento | **Área separada do chat** (painel lateral ou aba dedicada da UI) que exibe o PRD.md em construção sob demanda do participante; útil para validação incremental pelo PO sem poluir o canal de mensagens | — |
| F15 | Retomada da última sessão do projeto | Ao entrar na sala de um projeto, participante pode "Retomar última sessão" — abre **nova sessão de chat** tendo apenas o **resumo/status** da sessão anterior como contexto (agente internalizas via summary); NÃO exibe mensagens anteriores no chat; NÃO há navegação sessão-a-sessão | BM-02 |
| F17 | Tela inicial — lista de projetos iniciados | Página acessada via link compartilhado, **sem login prévio**; exibe lista de projetos (nome, nicks dos participantes, data/hora da última sessão); usuário clica em um projeto para entrar no fluxo de login | — |
| F18 | Painel de status do projeto na sala | Ao entrar na sala, participante vê painel com: resumo da última sessão (data/hora início-fim, principais pontos), tempo decorrido desde a 1ª sessão até a atual (esforço de elicitação acumulado) | BM-02 |
| F19 | Lista de participantes ativos na sala | Visualização dos participantes humanos atualmente conectados à sala (nick + papel), além dos agentes IA participantes | — |
| F21 | Roteamento de mensagens por papel | Mensagens de participantes com papel `PO` ou `YC Analyst` são **encaminhadas aos agentes IA via SDK** (consumidas como contexto de conversa). Mensagens de participantes com papel `Guest` ficam **visíveis no webchat multi-participante** (F1) para outros humanos, mas **NÃO são consumidas pela IA**. Regra de segregação arquitetural alinhada ao Design Principle 3.1.6 | — |
| F22 | Compilação de PRD em PDF sob demanda do agente | Após aprovação do PRD pelo PO, o agente `@orquestrador-pm` compila o PRD (10 seções + ANEXOS A/B/C) em um **único arquivo PDF** via ferramenta shell executada pelo Claude Agent SDK (ex: pandoc). O PDF é persistido no filesystem do projeto e commitado no Git. Conforme Design Principle 3.1.6: a compilação é **ato do agente** (via tool), não lógica do sistema web | BM-04 |
| F23 | Envio automático de PRD em PDF por email pós-aprovação | Após a geração do PDF (F22), o agente `@orquestrador-pm` envia automaticamente o PDF ao **PO** e ao **Arquiteto Receptor** via **servidor MCP de email** (`ycognio-email-mcp`). O email do Arquiteto Receptor inclui link para o formulário F11 (4 perguntas). Remetente, template e endpoint MCP `[A DEFINIR em deploy]`. Ato do agente via MCP tool, não do sistema web | BM-04 |

**Total IN**: 20 features (F1, F3-F15, F17, F18, F19, F21, F22, F23). Renumeração não foi aplicada — gap em F2 é intencional para preservar rastreabilidade com a elicitação. F16 (listagem de sessões) foi considerada e **descartada** — o modelo adotado não prevê navegação sessão-a-sessão. F20 foi considerada (modos de resposta estruturados por turno) e **descartada** como feature — tratada como comportamento implícito dos agentes Claude (em `.claude/agents/`), conforme Design Principle 3.1.6.

### 3.1.3. Feature OUT do MVP + Mecanismos de Cobertura

**F2 — Autenticação formal**: OUT no MVP.

**Razão**: reduzir fricção de onboarding para validação inicial do produto em 10 PRDs/mês com base de usuários conhecida. A lacuna de identidade é coberta por três mecanismos leves:

| Mecanismo | Descrição |
|---|---|
| (a) Identificação de participantes | **Login acontece ao entrar na sala de um projeto** (não antes de ver a lista de projetos). Participante informa **nick/username livre** + seleciona **papel** em lista fechada de 3 opções: `PO` (↔ Persona A), `Guest` (↔ Persona C), `YC Analyst` (↔ Persona B). Sem digitação livre de papel — estrutura controlada |
| (b) Prevenção de acesso não autorizado | **Link único compartilhado multi-uso** de acesso ao Ycognio **com TTL** — a mesma URL é usada por todos os participantes (PO, Analista, Guests) para ver a lista de projetos e acessar as salas. **Não existe conceito de link de convite individual/single-use no MVP** — a identificação individual acontece apenas no momento da entrada na sala (complemento (a): nick + papel). Expiração bloqueia novas entradas; rotação é decisão operacional |
| (c) Identidade para commits Git | Bot único `Ycognio Bot <ycognio@ycodify.com>` com token GitHub no backend; autoria humana rastreada via mensagem de commit (ex: `[PO: João] checkpoint: projeto X, sessão Y — seção 3 aprovada`) |

F2 será reativado como **G1** (Growth Phase) quando o volume de PRDs/mês exigir controle de acesso formal (SSO, RBAC, auditoria).

### 3.1.4. Pré-condições do MVP (Assumptions)

Três pré-condições externas ao Ycognio precisam estar satisfeitas antes de qualquer sessão ser iniciada. **O Ycognio NÃO provisiona nenhuma delas**.

| ID | Assumption | Responsável | O que Ycognio espera |
|---|---|---|---|
| A1 | Repositório Git pré-existente | Ycodify (setup manual ou automação externa) | Repo criado, branch `main` existente, agentes implantados em `.claude/agents/` |
| A2 | Acesso Git provisionado | Ycodify (onboarding manual no **GitHub apenas** — provedor único no MVP, conforme Seção 5.2.5) | Cliente (PO) e Ycodify (YC Analyst) com permissões de leitura/escrita já configuradas no repositório; Guests convidados a acessar o PRD final recebem permissão de **leitura** conforme política operacional Ycodify (pode ser decidido caso a caso) |
| A3 | `project_path` como input de sessão | Operador que abre a sessão | Parâmetro informado na abertura; Ycognio usa `working_dir = project_path` via Agent SDK |

**Implicação direta**: criação de repositório, configuração de permissões Git e deploy de agentes em `.claude/` são atividades manuais ou automatizadas por outras ferramentas internas da Ycodify, **fora do escopo deste produto**.

### 3.1.5. Critério de Sucesso da Fase MVP

A Fase MVP é considerada validada quando, em produção por 3 meses consecutivos ou ao longo de 30 PRDs concluídos (o que vier primeiro):

| Critério | Meta | Ancora |
|---|---|---|
| PRD com 100% das 10 seções preenchidas (zero `[A PREENCHER]`) em ≤ 8h de chat ativo cumulativo | ≥ 80% das sessões | BM-01 |
| Janela de calendário (primeira mensagem → artefato aprovado) | ≤ 4 dias corridos em ≥ 80% das sessões | BM-02 |
| Validação QA cruzada sem issues críticos | ≥ 95% das sessões | BM-03 |
| NPS analista receptor (arquiteto que consome PRD) | NPS ≥ 50 em ≥ 80% das medições | BM-04 |
| NPS clareza da condução — PO do Cliente | NPS ≥ 70 em ≥ 80% das sessões | UM-01 |
| Reconhecimento e profundidade de captura — PO do Cliente | Média ≥ 4,5/5 em ambas as perguntas, em ≥ 80% das sessões | UM-02 |
| Disponibilidade do webchat em horário comercial | ≥ 99% (dias úteis, 8h-20h BRT) | TM-01 |
| Persistência Git: todos os artefatos commitados e recuperáveis | 100% das sessões | TM-02 |
| Latência de broadcast entre participantes | ≤ 2s para 99% dos eventos de sessão | TM-03 |

**Nota**: as metas por sessão estão definidas na Seção 2 (SMART). Aqui são metas de **adoção/conformidade em nível de portfólio** — atingi-las é o gatilho formal para iniciar o planejamento da Growth Phase.

### 3.1.6. Design Principle — Chat como Wrapper (não como Controlador)

**Princípio arquitetural fundamental**:

> O Ycognio é uma **interface/wrapper** para a arquitetura de agentes existente em `.claude/agents/` dos projetos Ycodify. **O chat NÃO tem agência sobre os agentes — ele os expõe.** Toda lógica de comportamento dos agentes (como perguntar, quando invocar outro agente, como sugerir formato de resposta, como conduzir elicitação, etc.) reside nos **prompts dos agentes** — não no código do webchat.

**Implicações práticas para PMs e desenvolvedores**:

- ✅ **Features do chat podem**: expor agentes, identificar qual agente respondeu, rotear invocações (`@agente`), persistir mensagens, renderizar estado visível (painéis, listas), instrumentar telemetria, facilitar login e navegação
- ❌ **Features do chat NÃO podem**: reescrever o comportamento dos agentes, substituir lógica de elicitação, injetar "inteligência" paralela à dos agentes, modificar saídas dos agentes em trânsito
- 🔒 **Guardrail de escopo**: qualquer feature proposta que viole este princípio deve ser rejeitada ou reformulada. Casos típicos a evitar: "chat resume mensagem de agente antes de exibir", "chat filtra perguntas do agente", "chat adiciona lógica de retry customizada", etc.

**Motivação**: preservar a arquitetura de agentes Claude como fonte única de comportamento permite evolução independente dos agentes (melhorias em `.claude/agents/` refletem automaticamente no produto) e evita duplicação de lógica entre webchat e agentes.

---

## 3.2. Growth Phase (Fase 2 — 3 a 6 meses pós-MVP)

**Objetivo**: Consolidar o Ycognio como ferramenta operacional no pipeline da Ycodify — adicionando controles de escala (autenticação, integração Forger), instrumentação de qualidade retrospectiva (retrabalho, dashboards) e capacidades de exportação para ecossistemas externos. Esta fase transforma o produto validado em ferramenta de produção.

### 3.2.1. Features Growth (priorizadas)

| ID | Feature | Prioridade | Justificativa |
|---|---|---|---|
| G1 | Autenticação formal (F2 reativado) | Alta | Necessária quando base de usuários cresce além de equipes conhecidas; controle de acesso, SSO, auditoria |
| G2 | Integração nativa com Forger (provisionamento automático) | Alta | Fecha o ciclo elicitação → especificação → provisionamento sem saída manual do Ycognio |
| G3 | Instrumentação de retrabalho (Proxy A reativado) | Média | Mede custo de sessões que exigiram revisão de seções; insumo para melhoria contínua dos agentes |
| G4 | Dashboard de métricas agregadas (BM/UM/TM) | Média | Visibilidade gerencial do portfólio de PRDs; suporte a decisões de produto |
| G5 | Exportação multi-formato (PDF, Word, Confluence) | Média | Atende clientes com processos de aprovação em ferramentas externas |
| G6 | Templates de PRD por vertical (GovTech, Fintech, e-commerce) | Baixa | Reduz tempo de sessão para domínios recorrentes; requer base histórica de PRDs |
| G7 | Validação de qualidade em tempo real durante a sessão | Média | Guardião de linguagem e completude operam de forma proativa, não só ao final |
| G8 | Multi-idioma no chat (inglês, espanhol) | Baixa | Expansão para clientes fora do Brasil; dependente de validação de mercado |

### 3.2.2. Critério de Sucesso da Fase Growth

A Fase Growth é considerada bem-sucedida quando:

- G1 (autenticação formal) e G2 (integração Forger) estão em produção e estáveis por ≥ 30 dias
- Baseline de retrabalho (G3) coletado em ≥ 30 PRDs históricos com dados suficientes para análise de padrões
- Ciclo medido de elicitação → especificação → arquitetura reduzido em ≥ 30% comparado ao processo manual pré-Ycognio

---

## 3.3. Vision Phase (Fase 3 — 1 a 3+ anos)

**Objetivo**: Posicionar o Ycognio como plataforma central de engenharia de produto da Ycodify — com capacidades multimodais, integração end-to-end com pipeline de implementação, marketplace de templates de domínio e presença no ambiente de desenvolvimento do cliente (IDEs). Nesta fase o produto deixa de ser ferramenta interna e passa a ser plataforma extensível.

### 3.3.1. Direções Vision

| ID | Direção | Dependências externas |
|---|---|---|
| V1 | Agentes de abertura de chamados de mudança em especificações existentes | Integração com sistemas de ticketing (Jira, Linear); maturidade do pipeline Forger |
| V2 | Consulta de estado operacional de sistemas em produção via Ycognio | APIs de observabilidade dos sistemas provisionados; acesso seguro a dados de produção |
| V3 | Geração de especificações executáveis end-to-end (código + infra a partir do PRD) | Maturidade dos Arquitetos de código; parceria com provedores de infra-as-code |
| V4 | Marketplace de templates de domínio (comunidade contribui) | Base de ≥ 100 PRDs históricos; governança de contribuição; modelo de negócio definido |
| V5 | Modalidades multimodais (voz, vídeo com transcrição + agentes ao vivo) | Maturidade de STT/TTS em português; latência aceitável para interação em tempo real |
| V6 | Integração com IDEs (VSCode, JetBrains) para acompanhar PRD durante implementação | Plugin ecosystem; adoção pelos times de desenvolvimento dos clientes |

**Nota sobre Vision**: não é backlog comprometido. São direções que a Ycodify reserva o direito de perseguir conforme validação das fases anteriores. Reavaliação formal a cada 6 meses, condicionada a resultados de MVP e Growth.

---

## 3.4. Out-of-Scope Explícito (Anti-Roadmap)

A Ycodify decidiu **deliberadamente não perseguir** as capacidades abaixo, mesmo que clientes ou mercado venham a demandá-las. Declarar isso protege o posicionamento do produto e evita expansão não gerenciada de escopo em vendas, marketing e desenvolvimento.

| ID | Item | Razão do corte |
|---|---|---|
| X1 | Análise competitiva de mercado como feature do produto | Fora do domínio de elicitação; criaria produto diferente; ferramentas especializadas existem (G2M, Crayon) |
| X2 | Chatbot genérico de uso geral fora do escopo de elicitação | Diluiria posicionamento; Ycognio é especializado em PRD — não é assistente de propósito geral |
| X3 | Hospedar código de implementação dos sistemas especificados | Escopo de repositório de código (GitHub, GitLab, Azure DevOps) — não de ferramenta de elicitação |
| X4 | Substituir ferramentas de gestão de projeto (Jira, Trello, Linear, Notion) | Ycognio é upstream do backlog — alimenta essas ferramentas, não as substitui |
| X5 | Escalar limite de participantes simultâneos por sessão acima de 5 | Sessões maiores indicam falta de foco; risco de qualidade de elicitação; limitação intencional de design |
| X6 | Oferecer Ycognio como plataforma white-label para terceiros operarem sem Ycodify | Requer modelo de negócio, suporte e governança radicalmente diferentes; decisão estratégica de não fazer |

---

## 3.5. Dependências entre Fases

| Transição | Pré-condição obrigatória |
|---|---|
| Iniciar MVP | A1: pasta do projeto criada; A2: repositório Git provisionado com agentes em `.claude/`; A3: `project_path` informado na abertura da sessão |
| MVP → Growth | 3 meses em produção OU 30 PRDs concluídos; metas de adoção da Seção 3.1.5 atingidas |
| Growth → Vision | G1 + G2 em produção estável; baseline de retrabalho coletado (≥ 30 PRDs); validação de mercado para expansão |

---

## 3.6. Roadmap Visual (linha do tempo indicativa)

```
MVP (0-6 meses)
├── F1, F3-F15, F17-F19, F21 conforme 3.1.2 (18 features IN)
├── F2 OUT com complementos (a/b/c) — login na sala com 3 papéis (PO/Guest/YC Analyst)
├── Modelo de acesso: link único compartilhado → lista de projetos → sala do projeto
├── 2 sessões simultâneas, ~10 PRDs/mês
└── Validação de BM-01 a TM-03 em ≥ 80% das sessões

Growth (6-18 meses)
├── G1: Autenticação formal (F2 reativado)
├── G2: Integração Forger (DS automático)
├── G3-G8: Features incrementais
└── Dashboard analítico

Vision (18+ meses)
├── V1-V6: Plataforma de inteligência de produto
└── API pública + multi-projeto
```

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 2: Objectives](PRD_02_Objectives.md)
- ➡️ Próxima: [Seção 4: User Journeys](PRD_04_UserJourneys.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 4: User Journeys

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Analista de Negócio (Sofia)
**Objetivo**: Mapear as jornadas principais de cada persona (A, B, C) através do Ycognio no MVP — incluindo gatilhos, fluxos, pain points, needs e outcomes

---

## 4.1. Overview

Esta seção descreve as jornadas principais dos usuários do Ycognio no MVP. As 4 jornadas mapeadas cobrem as modalidades de uso e os perfis de participantes:

| Jornada | Persona | Modalidade | Criticidade MVP |
|---|---|---|---|
| **A.2** | Persona A (PO do Cliente) | Assistida (com YC Analyst presente) | **Canônica** — caso típico |
| **A.1** | Persona A (PO do Cliente) | Self-service (sem YC Analyst) | Secundária — cliente autônomo |
| **B.1** | Persona B (YC Analyst) | Operacional Ycodify | Complementar — perspectiva do mediador |
| **C.1** | Persona C (Guest) | Observação passiva | Suporte — stakeholders extras |

**Escopo das jornadas**: mapeiam o que o usuário **vê** e **faz** na UI do Ycognio. **Não** mapeiam comportamento interno dos agentes Claude — este é responsabilidade dos prompts em `.claude/agents/` (ver Design Principle 3.1.6 da Seção 3).

**Rastreabilidade com Seção 3**: cada menção a feature (F1, F4, F9, F10, F14, F15, F17, F18, F19, F21) refere-se às capabilities MVP detalhadas em Seção 3.1.2.

---

## 4.2. Jornada A.2 — PO do Cliente em sessão assistida (CANÔNICA)

### 4.2.1. Gatilho e Acesso

- O PO recebe, por canal externo (e-mail ou link direto), a **URL única compartilhada** do Ycognio (F2=OUT complemento (b))
- Ao acessar, é apresentada a **tela inicial com lista de projetos iniciados** (F17) — sem login prévio; vê nome de cada projeto, nicks dos participantes e data/hora da última sessão
- Clica no projeto desejado → **tela de login**: informa `nick/username` livre e seleciona papel `PO` no dropdown (F2=OUT complemento (a))
- Entra na **sala do projeto**, que exibe:
  - **Painel de status do projeto** (F18) — resumo da última sessão, data/hora início-fim, tempo decorrido desde a primeira sessão
  - **Lista de participantes ativos** na sala (F19) — nicks + papéis, além dos agentes IA
  - Botão **"Retomar última sessão"** (F15) ou **"Sair"**

**Perfil esperado do PO nesta jornada**:
- Conhece o negócio comercialmente
- Tem clareza do que se espera do sistema a especificar
- **Não** precisa chegar com material prévio (briefing, esboços, planilhas)
- Precisa estar disponível para responder perguntas durante a sessão

### 4.2.2. Abertura da sessão

**Primeira sessão do projeto (nova)**:
- A IA (`@orquestrador-pm`) abre com **saudação + apresentação do processo** de elicitação
- PO responde livremente; conversa segue conforme o estilo que a IA propuser (comportamento implícito dos agentes — fora do escopo do PRD)

**Sessões subsequentes (N > 1)**:
- Participante clica "Retomar última sessão" na sala do projeto
- Nova sessão é aberta tendo apenas o **resumo/status** da sessão anterior como contexto (H-B) — o chat **não exibe** mensagens anteriores; a IA internaliza o summary e retoma o trabalho
- Saudação da IA é mais enxuta: posicionamento do estado atual + proposta do próximo passo

**Entradas e saídas de Guests durante a sessão são transparentes para a IA** — não geram eventos especiais no fluxo da conversa. Isso é consequência direta de **F21 (Roteamento de mensagens por papel)**: mensagens de Guests ficam visíveis no webchat para outros humanos mas **não são consumidas pelos agentes**; portanto, a presença ou ausência de Guests não altera o contexto conversacional da IA.

### 4.2.3. Fluxo Principal da Conversa

O fluxo é **governado pelos agentes Claude** (não pelo chat — Design Principle 3.1.6). Do ponto de vista do usuário, a dinâmica envolve:

- **Qualquer participante com papel `PO` ou `YC Analyst`** pode enviar mensagem — ela é encaminhada aos agentes via SDK (F21) e recebe resposta
- **Invocação direta de agentes específicos** via `@nome-do-agente` (F4) — ex: `@guardiao valida esse termo`, `@analista-de-negocio detalhe isso`
- **Painel dedicado separado do chat** (F14) permite ao participante visualizar o PRD em construção a qualquer momento, sem poluir o canal de mensagens
- YC Analyst (quando presente) atua em 3 modos intercambiáveis conforme necessidade:
  1. **Facilitador** — reformula perguntas da IA em termos mais simples quando percebe que o PO não entendeu
  2. **Especialista técnico** — provê profundidade técnica quando a IA demanda e o PO não consegue
  3. **Invocação por demanda** — pode ser chamado tanto pela IA quanto pelo PO

### 4.2.4. Encerramento

- A IA pode **sugerir encerramento** quando detecta um bom ponto de parada (ex: seção concluída). Comportamento implícito dos agentes — fora do escopo do PRD.
- **PO ou YC Analyst podem encerrar a qualquer momento**, invocando `@orquestrador-pm` para realizar **checkpoint** do trabalho (via F4). Os agentes consolidam o estado, commitam no Git e a sessão é marcada como encerrada.
- Na **última sessão do projeto** (quando o PRD é considerado pronto):
  - Há **apresentação do PRD final ao PO** para aprovação formal
  - Formulário **NPS pós-sessão** (F9) é exibido ao PO: *"Quão clara foi a condução da entrevista de elicitação?"* (escala NPS 0-10)
  - Formulário de **reconhecimento e profundidade** (F10) é exibido ao PO: *(a) "O PRD reflete o que você queria construir?"* (1-5); *(b) "O PRD captura aspectos do seu negócio que você não teria conseguido articular sozinho?"* (1-5)

### 4.2.5. Pain Points (processo manual atual que o Ycognio resolve)

- Reuniões ad-hoc sem estrutura definida
- Sem rastreabilidade das decisões tomadas
- PRDs incompletos ou inconsistentes
- Ciclos de revisão repetitivos por lacunas de elicitação
- Dificuldade de articular requisitos com clareza ("sei o que quero mas não sei como explicar")

### 4.2.6. Needs (o que o PO precisa para ter sucesso)

- Condução clara e estruturada pelos agentes
- Linguagem acessível (sem jargão técnico obrigatório)
- Confiança de que o que foi dito foi capturado fielmente
- **Visibilidade de progresso** na sessão — painel dedicado (F14)
- **Possibilidade de pausar e retomar** sem perder contexto (F15)
- **YC Analyst como rede de segurança** — saber que há alguém humano disponível para destravar situações técnicas ou de ambiguidade

### 4.2.7. Outcomes (o que o PO leva embora)

- PRD completo (10 seções) + ANEXOS A/B/C **versionados em Git** ao final
- Confiança de que o documento representa fielmente o que foi discutido
- **Reconhecimento de aspectos do negócio** que não teria conseguido articular sozinho (ancora UM-02 da Seção 2)
- Previsibilidade do processo de elicitação
- Rastreabilidade total entre decisões de negócio e documentação técnica (via histórico Git)

---

## 4.3. Jornada A.1 — PO do Cliente em modalidade self-service

**Diferenças em relação a A.2** (apenas o que muda):

- Apenas PO + agentes IA na sala — **nenhum YC Analyst presente**
- PO assume o papel de interlocutor único humano; maior dependência da IA e dos agentes
- **Pain adicional**: solidão cognitiva — sem mediação humana quando travar em termo técnico ou ambíguo
- **Need adicional**: confiança total nos agentes Claude (especialmente `@guardiao` para desambiguação de termos de negócio)
- **Outcomes**: equivalentes a A.2
- **Quando se aplica**: cliente opta por modalidade self-service; Ycodify oferece a ferramenta sem consultoria acoplada durante a elicitação

---

## 4.4. Jornada B.1 — YC Analyst (perspectiva dele)

**Persona**: Persona B (Analista de Domínio e Processos da Ycodify — papel `YC Analyst` no login)

**Gatilho**: cliente contratou serviço Ycodify; PO do cliente agendado ou já ativo em algum projeto

**Steps da jornada**:

1. Analyst acessa o link único compartilhado (mesmo URL que o PO usa)
2. Vê **lista de projetos iniciados** (F17) — localiza o projeto do cliente que vai atender
3. Clica no projeto → tela de login → informa nick + seleciona papel `YC Analyst`
4. Entra na sala: vê **painel de status do projeto** (F18) e **participantes já ativos** (F19)
5. Participa da sessão conforme A.2 — operando nos 3 modos (facilitador, especialista, demandado)
6. Pode **invocar agentes específicos** via `@nome-do-agente` (F4) sempre que útil
7. Pode **solicitar checkpoint/encerramento** via `@orquestrador-pm` (F4) a qualquer momento
8. Pode **transitar entre projetos** — voltar à tela inicial (F17) e entrar em outro projeto que está atendendo (limite MVP: 2 sessões simultâneas)

**Pain Points próprios**:

- Manter 2 sessões simultâneas ativas (limite MVP) sem perder contexto ao alternar
- Conciliar agenda com múltiplos POs de clientes diferentes

**Needs próprios**:

- Visão rápida do status de cada projeto ao entrar (F17 + F18 atendem)
- Discernimento sobre quando **precisa intervir** ativamente vs. quando pode ficar **passivo/observador**
- Confiança na qualidade dos agentes — saber que a IA cobre bem o básico, permitindo ao Analyst focar em situações complexas

**Outcomes**:

- PRDs completos e aprovados entregues aos arquitetos Ycodify com qualidade
- Redução do tempo gasto em reuniões ad-hoc com clientes (meta estratégica MVP)
- Capacidade de atender mais clientes em paralelo sem perda de qualidade

---

## 4.5. Jornada C.1 — Guest (observador)

**Persona**: Persona C (Observadores — papel `Guest` no login)

**Gatilho**: convidado pelo PO ou pelo YC Analyst para acompanhar uma sessão específica (via link compartilhado externamente — e-mail, chat interno do cliente, etc.)

**Steps da jornada**:

1. Acessa o link único compartilhado
2. Vê **lista de projetos iniciados** (F17) — precisa saber qual projeto clicar (informado externamente por quem o convidou)
3. Clica no projeto → tela de login → informa nick + seleciona papel `Guest`
4. Entra na sala: vê **chat em andamento**, **painel de status** (F18), **participantes ativos** (F19)
5. **Pode digitar no webchat**, mas **suas mensagens NÃO são consumidas pela IA** (F21) — apenas outros participantes humanos (PO, YC Analyst, outros Guests) as leem
6. **Pode sair quando quiser** — nenhuma ação de encerramento é necessária; sua saída não gera eventos especiais (F21)

**Pain Points próprios**:

- Entrar em uma conversa em andamento **sem contexto acumulado** (o painel de status F18 mitiga parcialmente)
- Não ter poder de **influenciar diretamente a IA** — depende de PO ou YC Analyst para repassar sua contribuição à IA

**Needs próprios**:

- **Transparência de progresso** (F18) — entender onde o projeto está sem precisar perguntar
- Não ser obrigado a **participar ativamente** da elicitação — conforto de observador

**Outcomes**:

- **Validação silenciosa** de pontos do seu domínio (comunicando com PO/YC Analyst pelo chat; estes decidem se a contribuição entra na elicitação)
- Acesso ao PRD final **via repositório Git** para revisão assíncrona pós-sessão

---

## 4.6. Rastreabilidade com Features MVP (Seção 3)

As jornadas acima referenciam as seguintes features da Seção 3.1.2. Use como índice cruzado:

| Feature | Aparição nas jornadas |
|---|---|
| F1 — Webchat multi-participante | Todas (fundação) |
| F4 — Invocação direta de agentes (`@agente`) | A.1, A.2, B.1 |
| F9 — Form NPS pós-sessão (PO) | A.1, A.2 (última sessão) |
| F10 — Form reconhecimento PRD (PO) | A.1, A.2 (última sessão) |
| F14 — Painel dedicado de visualização do PRD | A.1, A.2 (sob demanda) |
| F15 — Retomada da última sessão | A.1, A.2, B.1 (sessões N>1) |
| F17 — Tela inicial com lista de projetos | Todas (ponto de entrada) |
| F18 — Painel de status do projeto | Todas (ao entrar na sala) |
| F19 — Lista de participantes ativos | Todas (na sala) |
| F21 — Roteamento de mensagens por papel | Todas (regra arquitetural) |

F2=OUT complemento (a) (identificação: nick + papel) aparece em todas as jornadas na tela de login.
F2=OUT complemento (b) (link único compartilhado com TTL) é o ponto de entrada de todas as jornadas.

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 3: Product Scope](PRD_03_ProductScope.md)
- ➡️ Próxima: [Seção 5: Domain Requirements](PRD_05_DomainRequirements.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 5: Domain Requirements

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Analista de Negócio (Sofia)
**Objetivo**: Registrar decisões de compliance, propriedade e privacidade aplicáveis ao Ycognio MVP, com declaração explícita do que está dentro e fora do escopo regulatório

---

## 5.1. Escopo Regulatório do MVP

O Ycognio MVP é uma ferramenta de **uso interno da Ycodify** em fase de **validação**, atendendo exclusivamente **clientes brasileiros**. Nestas condições:

**FORA do escopo MVP**:

- **LGPD formal** (Lei Geral de Proteção de Dados): nenhuma implementação de compliance regulatório formal — DPO oficial nomeado, termos de serviço detalhados, canais de exercício de direitos na UI, consentimento granular, registro de atividades de tratamento, etc.
- **Compliance de segurança de acesso** (autenticação formal, SSO, RBAC, auditoria de acesso): endereçado pela Growth Phase com G1 (autenticação formal)
- **Compliance internacional** (GDPR, transferência internacional elaborada, consentimento por titular, banners de privacidade por sessão): não aplicável no MVP — clientes brasileiros, transferência operacional coberta por contratos-padrão dos fornecedores

**Justificativa**: MVP é fase de validação de hipóteses de produto, não lançamento comercial formal. Compliance regulatório será tratado quando houver lançamento amplo ou expansão internacional.

**Impacto operacional**: decisões regulatórias devem ser **reavaliadas antes do lançamento comercial**, especialmente antes da Growth Phase quando G1 (autenticação formal) entra e a base de usuários sai do perímetro controlado interno.

---

## 5.2. Decisões Arquiteturais e Comerciais (Independentes de Compliance Formal)

As decisões abaixo **não são compliance** no sentido regulatório, mas afetam como a arquitetura e o modelo comercial são estruturados desde o dia 1 do MVP.

### 5.2.1. Retenção de Dados

| Tipo de Dado | Retenção MVP | Motivação |
|---|---|---|
| Mensagens de chat (DB Ycognio) | **21 dias** | Decisão de infraestrutura — balanço entre histórico útil e custo de armazenamento |
| Logs de sessão (timestamps, turns, nicks) | **21 dias** | Consistência com mensagens |
| Artefatos no repositório Git (PRD, ANEXOS) | **Perpétuos enquanto repositório existir** | Não controlado pelo Ycognio — cliente e Ycodify decidem a vida do repositório |

### 5.2.2. Propriedade Intelectual e Conteúdo

| Ativo | Propriedade |
|---|---|
| Conteúdo das conversas durante sessões | **Cliente da Ycodify** (é o negócio dele sendo especificado) |
| Artefatos gerados (PRD, ANEXOS, specs JSON) | **Cliente da Ycodify** |
| Plataforma Ycognio (código, infraestrutura, UI) | **Ycodify** |
| Prompts dos agentes Claude em `.claude/agents/` | **Ycodify** (ativo intelectual da arquitetura de agentes) |
| Melhorias derivadas anonimizadas (padrões de uso, refinamento de agentes) | **Ycodify** — desde que não contenham informações identificáveis do cliente |

### 5.2.3. Acordo de Confidencialidade (NDA)

- **Modelo**: NDA **padrão único** — contrato-modelo aplicado a todos os clientes do Ycognio, sem negociação por cliente no MVP
- **Abrangência**: obrigação de sigilo da Ycodify sobre o conteúdo das conversas e artefatos; sub-operadores (Anthropic, GitHub) cobertos por seus próprios termos contratuais

### 5.2.4. Uso Interno do Conteúdo pela Ycodify

A Ycodify **pode** usar o conteúdo de projetos para:

- **(α)** Melhoria dos agentes Claude (análise de padrões, refinamento de prompts) — **com anonimização prévia**
- **(β)** Estudo interno de casos de uso — **de forma genérica, sem identificar o cliente**
- **(γ)** Marketing e cases de sucesso — **somente com autorização explícita do cliente em cada caso**

**Não aplica**: restrição estrita de "nada além do contratado". A Ycodify reserva-se direito de aprender operacionalmente com os projetos, dentro dos limites acima.

### 5.2.5. Provedor Git

- **Provedor único no MVP**: **GitHub**
- **GitLab e outros**: FORA do MVP. Reavaliar se cliente demandar em Growth Phase
- **Implicação**: Assumption A2 na Seção 3 atualizada de "GitHub/GitLab" para "GitHub apenas"

---

## 5.3. Itens para Reavaliação Futura (LEARNING_LOG)

As seguintes decisões foram deliberadamente adiadas e devem ser retomadas em fases futuras:

1. **LGPD formal + Compliance internacional elaborada**: retomar na Growth Phase, especialmente antes de qualquer expansão para clientes internacionais ou lançamento comercial amplo. Itens específicos: nomeação oficial de DPO, canal de exercício de direitos na UI, consentimento granular, banners de privacidade, cláusulas contratuais para transferência internacional.

2. **Compliance de segurança de acesso**: retomar com G1 (autenticação formal) em Growth Phase. Itens específicos: SSO, RBAC por projeto, auditoria de acesso, rotação de credenciais, política de senhas/tokens.

Ambos registrados em `LEARNING_LOG.md`.

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 4: User Journeys](PRD_04_UserJourneys.md)
- ➡️ Próxima: [Seção 6: Innovation Analysis](PRD_06_Glossary.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 6: Innovation Analysis

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Orquestrador/PM (Giovanna)
**Objetivo**: Registrar postura do projeto quanto à análise de inovação e cenário competitivo

---

## 6.1. Postura do Projeto

O Ycognio é uma **ferramenta interna da Ycodify**, construída para uso próprio e de clientes da Ycodify. A decisão estratégica **explícita** é:

> **Não há interesse em realizar análise competitiva ou de inovação nesta seção.** O Ycognio será construído e operado para benefício direto da Ycodify e de seus clientes, **independentemente do que existe ou venha a existir no mercado de ferramentas análogas**.

Consequências desta postura:

- **Não há estudo de concorrentes** no escopo deste projeto (nem MVP, nem Growth, nem Vision)
- **Não há benchmarking técnico** frente a alternativas de mercado
- **O critério de sucesso** é a substituição do processo manual interno atual pela operação assistida por agentes Claude (ver Seção 2 — Success Criteria)

## 6.2. Relação com outras Seções

Itens adjacentes que já foram declarados em outras seções e **cobrem implicitamente** o que um "Innovation Analysis" tradicional abordaria:

| Tópico | Onde foi tratado |
|---|---|
| Diferenciação do produto | Seção 1.2 (Differentiator) — 3 pilares declarados |
| O que o MVP entrega vs. processo manual | Seção 2.5 (Baseline vs. Meta) |
| O que explicitamente NÃO fazemos | Seção 3.4 (Out-of-Scope Explícito — X1 declara que "análise competitiva de mercado como feature do produto" está fora do escopo) |
| Princípio arquitetural que organiza a solução | Seção 3.1.6 (Design Principle — Chat como Wrapper) |

---

## 6.3. Reavaliação Futura

Caso a Ycodify, em momento futuro, decida posicionar o Ycognio **comercialmente** (como produto de mercado aberto, não apenas ferramenta interna), esta seção deve ser reavaliada. Nesse cenário, análise competitiva e de inovação tornam-se relevantes para estratégia comercial, marketing e posicionamento de mercado.

No MVP e Growth (escopo atual), permanece como **não aplicável**.

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 5: Domain Requirements](PRD_05_DomainRequirements.md)
- ➡️ Próxima: [Seção 7: Project-Type Requirements](PRD_07_ProjectTypeRequirements.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 7: Project-Type Requirements

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsável**: Analista de Negócio (Sofia)
**Objetivo**: Requisitos técnicos específicos do tipo de aplicação (web app) no MVP

---

## 7.0. Tipo de Projeto

**Tipo**: **Web Application** com **responsividade aplicada** (layout adaptativo desktop → tablet → mobile via mesma base de código).

**NÃO é**: app nativo mobile (iOS/Android), desktop nativo, API standalone, nem PWA offline-first.

---

## 7.1. PT-001 — Browser Compatibility

| Navegador | Versão Mínima | Justificativa |
|---|---|---|
| **Google Chrome** | Chrome 100+ (desktop + Android) | Principal navegador corporativo + mobile |
| **Mozilla Firefox** | Firefox 100+ (desktop + Android) | Segundo mais comum entre usuários técnicos (YC Analyst) |

**NÃO suportados no MVP**: Safari, Edge, Opera, Brave, Internet Explorer, navegadores proprietários corporativos.

**Racional**: reduzir matriz de teste no MVP. Expansão (Safari, Edge) avaliada em Growth conforme demanda.

**Testes de compatibilidade**: manuais nas 2 plataformas durante QA; automação em Growth.

---

## 7.2. PT-002 — Responsive Design

| Breakpoint | Faixa | Prioridade |
|---|---|---|
| **Desktop** | ≥ 1024px | **Alta** (uso primário — sessões longas de elicitação) |
| **Tablet** | 768px – 1023px | Média (validação pelo PO ou Guest via iPad) |
| **Mobile** | ≤ 767px | Baixa (leitura/validação; digitação intensiva desconfortável) |

**Abordagem**: **Desktop-first** com adaptação responsiva. O uso pesado (elicitação) acontece em desktop; mobile é para leitura/acompanhamento.

**Elementos críticos no mobile**: chat + painel de status (F18) + lista de participantes (F19). **Elementos secundários no mobile**: painel de PRD em construção (F14) pode ser apresentado em layout vertical ou via drawer.

---

## 7.3. PT-003 — Autenticação e Identificação de Participantes

**Autenticação formal**: **FORA do MVP** (ver F2=OUT na Seção 3.1.3; complementos a/b/c cobrem o modelo adotado).

Resumo do modelo de entrada (Seção 3.1.3):

- **Link único compartilhado** (com TTL) distribuído externamente — mesma URL para todos os participantes
- **Tela inicial (F17)** — lista de projetos iniciados, sem login prévio
- **Login na sala** — nick/username livre + papel selecionado em dropdown (`PO` / `YC Analyst` / `Guest`)
- **Identidade para commits Git** — bot único `Ycognio Bot` com autoria humana rastreada via mensagem de commit

**Autenticação formal (SSO, RBAC, 2FA)**: endereçada em **G1 (Growth Phase)** — ver Seção 3.2.

---

## 7.4. PT-004 — Internacionalização (i18n)

**FORA do MVP**. Idioma único: **português (Brasil / pt-BR)**.

| Aspecto | MVP | Growth (futuro) |
|---|---|---|
| Idioma da UI | **pt-BR apenas** | Inglês, Espanhol (via **G8** da Seção 3.2) |
| Idioma das conversas | pt-BR (agentes Claude ajustados) | Multi-idioma conforme G8 |
| Timezone | BRT (UTC-3) fixo | Multi-timezone quando houver expansão |
| Formato de data/hora | DD/MM/YYYY HH:MM (BRT) | Localizado por idioma |

**Racional**: clientes brasileiros apenas no MVP (alinha com Seção 5.1 — compliance internacional fora de escopo).

---

## 7.5. PT-005 — Requisitos Operacionais Adicionais

| Requisito | Decisão MVP |
|---|---|
| **Online obrigatório** | Sim. Sessão de chat requer conexão ativa com o servidor Ycognio (sem modo offline). Interrupção de rede: F15 (Retomada) permite retomar a sessão ao reconectar. |
| **Persistência de sessão** | Coberta por F15 (retomada via summary — H-B) |
| **Notificações push** | FORA do MVP. Usuários acompanham via sessão ativa ou painel de status (F18) quando retornam. |
| **Acessibilidade (WCAG)** | FORA do MVP como compliance formal. Boas práticas mínimas (contraste adequado, navegação por teclado nos elementos principais) aplicadas como padrão, sem certificação. |

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 6: Innovation Analysis](PRD_06_Glossary.md)
- ➡️ Próxima: [Seção 8: Functional Requirements](PRD_08_FunctionalRequirements.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 8: Functional Requirements (FRs)

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsáveis**: PM (Giovanna) define capabilities; BA (Sofia) detalha Test Criteria
**Objetivo**: Traduzir as 18 features IN do MVP (Seção 3) em capabilities testáveis com critérios verificáveis

---

## 8.0. Overview

Esta seção lista os **27 FRs do MVP** organizados em 6 grupos funcionais. Cada FR descreve **o que o usuário pode fazer** de forma atômica e verificável — **não** descreve comportamento interno dos agentes Claude (preservando Design Principle 3.1.6 da Seção 3).

### Formato de cada FR

- **ID** (ex: `FR-ACC-01`)
- **Capability**: sentença testável no formato "Users can X [in Y time / with Z constraint]"
- **Feature origem** (F-ID): referência à Seção 3.1.2 ou F2=OUT complementos em Seção 3.1.3
- **Jornada(s)**: referência às jornadas da Seção 4 (A.1, A.2, B.1, C.1)
- **Métrica ancorada**: referência à Seção 2 (BM/UM/TM) quando aplicável
- **Priority**: MoSCoW (Must-Have / Should-Have / Could-Have)
- **Test Criteria**: Setup · Action · Expected Result · Measurement Method

### Priorização MoSCoW — Sumário

| Priority | Quantidade | FRs |
|---|---|---|
| **Must-Have** (MVP obrigatório) | 17 | FR-ACC-01, FR-ACC-03, FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-VIS-01, FR-VIS-02, FR-VIS-03, FR-PER-01, FR-PER-02, FR-PER-04, FR-PER-05, FR-PER-06, FR-PER-07, FR-FBK-01, FR-TEL-01 |
| **Should-Have** (MVP desejável) | 10 | FR-ACC-02, FR-ACC-04, FR-CHT-05, FR-VIS-04, FR-VIS-05, FR-PER-03, FR-FBK-02, FR-FBK-03, FR-TEL-02, FR-TEL-03 |
| **Could-Have** | 0 | Residem na Growth Phase (G1-G8 da Seção 3.2) |

---

## 8.1. FR-ACC — Acesso e Identidade (4 FRs)

### FR-ACC-01 — Acesso à tela inicial sem autenticação

- **Capability**: Qualquer participante com o link compartilhado pode acessar a tela inicial de projetos **sem autenticação prévia**
- **Feature origem**: F17 + F2=OUT(b)
- **Jornada(s)**: A.1, A.2, B.1, C.1 (ponto de entrada universal)
- **Métrica ancorada**: —
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Link único com TTL válido + Chrome 100+ ou Firefox 100+
  - **Action**: Acessar URL sem fornecer credenciais, nick ou papel
  - **Expected Result**: Tela inicial com lista de projetos carrega; nenhuma tela de login é exibida
  - **Measurement Method**: Teste E2E (Playwright) verifica URL final e presença do componente de lista de projetos

### FR-ACC-02 — Listagem de projetos com metadados

- **Capability**: Participante pode ver lista de projetos com **nome, participantes e data/hora da última sessão**
- **Feature origem**: F17
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: —
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Ao menos 1 projeto existente com sessão anterior registrada
  - **Action**: Acessar tela inicial via link válido
  - **Expected Result**: Lista exibe nome do projeto, participantes e data/hora da última sessão para cada entrada
  - **Measurement Method**: Teste E2E verifica presença e preenchimento dos três campos por item da lista

### FR-ACC-03 — Entrada na sala com nick e papel

- **Capability**: Participante pode entrar na sala informando **nick livre** + selecionando **papel via dropdown** (`PO` / `YC Analyst` / `Guest`)
- **Feature origem**: F2=OUT(a)
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: —
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala de projeto ativa + tela de entrada carregada
  - **Action**: Preencher nick livre (ex: "Ana") + selecionar papel "PO" no dropdown + confirmar entrada
  - **Expected Result**: Participante entra na sala; nick e papel ficam visíveis na lista de participantes
  - **Measurement Method**: Teste E2E verifica redirecionamento para sala e presença do nick/papel no painel de participantes

### FR-ACC-04 — Expiração de link por TTL

- **Capability**: Link de acesso **expira após TTL configurado** e bloqueia novas entradas após vencimento
- **Feature origem**: F2=OUT(b)
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: —
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Link gerado com TTL de X horas; simular passagem de tempo além do TTL
  - **Action**: Tentar acessar o link expirado
  - **Expected Result**: Sistema bloqueia acesso e exibe mensagem de link expirado; nenhuma tela de projeto é carregada
  - **Measurement Method**: Teste automatizado: gerar link, avançar relógio (mock ou TTL curto de teste), verificar resposta HTTP 401/403 ou redirect para página de erro

---

## 8.2. FR-CHT — Chat e Interação (5 FRs)

### FR-CHT-01 — Mensagem broadcast em tempo real

- **Capability**: Qualquer participante pode enviar mensagem no chat e **todos recebem em tempo real**
- **Feature origem**: F1
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: TM-03 (broadcast ≤2s para 99% dos eventos)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala com ≥2 participantes conectados (diferentes browsers/tabs)
  - **Action**: Participante A envia mensagem de texto
  - **Expected Result**: Mensagem aparece no chat de todos os participantes; 99% das entregas em ≤2s
  - **Measurement Method**: Teste E2E com 2 clientes Playwright; medir delta entre `user_message_sent` e renderização no cliente B. Coletar p99 em 100 envios sob carga normal

### FR-CHT-02 — Encaminhamento de mensagens PO/YC Analyst aos agentes

- **Capability**: Mensagens de participantes com papel `PO` ou `YC Analyst` são **encaminhadas aos agentes IA**
- **Feature origem**: F21
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: BM-01 (insumo para elicitação completa em ≤8h)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala ativa + participante com papel PO ou YC Analyst autenticado
  - **Action**: Enviar mensagem de texto comum (sem @mention) no chat
  - **Expected Result**: Mensagem é encaminhada ao pipeline de agentes e retorno do agente ativo aparece no chat
  - **Measurement Method**: Verificar via log de eventos que o evento `ai_response_complete` é gerado após `user_message_sent` para mensagens de PO/YC Analyst

### FR-CHT-03 — Isolamento de mensagens Guest

- **Capability**: Mensagens de participantes com papel `Guest` são **visíveis no chat mas NÃO encaminhadas aos agentes**
- **Feature origem**: F21
- **Jornada(s)**: C.1
- **Métrica ancorada**: —
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala ativa + participante com papel Guest
  - **Action**: Guest envia mensagem no chat
  - **Expected Result**: Mensagem aparece no chat para todos; nenhum evento de encaminhamento para agentes é gerado; nenhuma resposta de agente é disparada
  - **Measurement Method**: Verificar logs: ausência de evento `ai_request_sent` após `user_message_sent` com `role=guest`. Teste E2E confirma que nenhuma bolha de agente aparece após mensagem de Guest

### FR-CHT-04 — Invocação direta de agente via @mention

- **Capability**: `PO` ou `YC Analyst` pode invocar agente específico via `@nome-do-agente`
- **Feature origem**: F4
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: UM-01 (clareza da condução ≥70)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala ativa + participante PO ou YC Analyst
  - **Action**: Enviar mensagem com `@sofia Qual o próximo passo?` no chat
  - **Expected Result**: Agente "sofia" responde no chat; identificação visual mostra nome "sofia"
  - **Measurement Method**: Teste E2E verifica que bolha de resposta contém label "sofia" e que a resposta é gerada (evento `ai_response_complete` com `agent=sofia`)

### FR-CHT-05 — Latência de broadcast ≤2s p99

- **Capability**: Broadcast de mensagens **≤2s para 99% dos eventos** sob carga normal
- **Feature origem**: F1
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: TM-03
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Ambiente de carga normal (≤20 participantes simultâneos, ≤10 msgs/min)
  - **Action**: Enviar 100 mensagens em sequência por participantes distintos
  - **Expected Result**: 99% das mensagens entregues a todos os participantes em ≤2s
  - **Measurement Method**: Instrumentação no backend registra timestamp de envio e timestamp de entrega por cliente; script de análise calcula p99; relatório de teste documenta resultado

---

## 8.3. FR-VIS — Visibilidade e Painéis (5 FRs)

### FR-VIS-01 — Identificação visual do agente respondente

- **Capability**: Participante identifica **visualmente qual agente** respondeu cada mensagem (prefixo/badge)
- **Feature origem**: F3
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: UM-01
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala com resposta de ao menos 2 agentes distintos em sequência
  - **Action**: Observar o histórico do chat após respostas
  - **Expected Result**: Cada bolha de resposta exibe nome ou avatar distintivo do agente que a gerou; diferente das bolhas de participantes humanos
  - **Measurement Method**: Teste E2E verifica presença de atributo `data-agent-name` (ou equivalente) nas bolhas de resposta, com valor distinto por agente; revisão visual manual complementa

### FR-VIS-02 — Painel de PRD em construção sob demanda

- **Capability**: Participante acessa **painel dedicado separado do chat** com PRD em construção, sob demanda
- **Feature origem**: F14
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: UM-02 (reconhecimento e profundidade ≥4,5/5)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala com ao menos 1 artefato de PRD gerado (ex: Seção 4 preenchida)
  - **Action**: Participante aciona painel de PRD (ex: botão "Ver PRD")
  - **Expected Result**: Painel separado do chat é exibido com o conteúdo atual do PRD em construção
  - **Measurement Method**: Teste E2E verifica abertura do painel, presença de conteúdo não vazio e separação visual do fluxo do chat

### FR-VIS-03 — Painel de status do projeto ao entrar na sala

- **Capability**: Ao entrar na sala, participante vê **painel de status do projeto** (resumo última sessão, tempo decorrido desde 1ª)
- **Feature origem**: F18
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: BM-02 (distribuição ≤4 dias corridos)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Projeto com ao menos 1 sessão anterior registrada
  - **Action**: Participante acessa a sala do projeto
  - **Expected Result**: Painel de status exibe resumo da última sessão e tempo decorrido desde a última atividade
  - **Measurement Method**: Teste E2E verifica presença e preenchimento dos campos "resumo última sessão" e "tempo decorrido" no painel de status imediatamente após entrada

### FR-VIS-04 — Lista de participantes ativos

- **Capability**: Participante vê **lista de participantes ativos** (humanos + agentes) na sala
- **Feature origem**: F19
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: —
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Sala com ≥2 participantes humanos + ≥1 agente ativo
  - **Action**: Observar painel lateral de participantes
  - **Expected Result**: Lista exibe todos os participantes humanos conectados (com nick e papel) e agentes IA ativos; participantes que saem são removidos da lista
  - **Measurement Method**: Teste E2E: conectar 2 clientes, verificar presença de ambos; desconectar 1, verificar remoção em ≤5s

### FR-VIS-05 — Tempo acumulado de elicitação

- **Capability**: Painel de status mostra **tempo acumulado de elicitação** desde 1ª sessão
- **Feature origem**: F18
- **Jornada(s)**: A.2, B.1
- **Métrica ancorada**: BM-02
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Projeto com ≥2 sessões anteriores registradas
  - **Action**: Observar painel de status após entrar na sala
  - **Expected Result**: Campo "tempo acumulado" exibe soma do tempo de chat ativo de todas as sessões desde a primeira
  - **Measurement Method**: Verificar via API ou banco de dados que o valor exibido corresponde à soma dos registros de duração de sessão; teste automatizado compara valor exibido com cálculo da fonte de dados

---

## 8.4. FR-PER — Persistência e Retomada (4 FRs)

### FR-PER-01 — Commit de artefatos ao final de sessão (operado pelo agente via SDK)

- **Capability**: Ao final de sessão ou em checkpoint solicitado, o agente `@orquestrador-pm` executa **`git commit + git push`** no repositório Git pré-existente **via Claude Agent SDK (shell tool)**, usando credenciais do bot `Ycognio Bot` configuradas no servidor. Autoria humana (PO / YC Analyst) é rastreada na **mensagem de commit** (não no committer Git). A mensagem de commit é **gerada autonomamente pelo agente** a partir do contexto da sessão
- **Feature origem**: F6
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: TM-02 (persistência 100%)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sessão ativa com ao menos 1 artefato gerado (ex: `ANEXO_A.md`); repositório Git pré-configurado; credenciais do bot disponíveis no servidor
  - **Action**: Solicitar checkpoint ao agente via chat (formato flexível: `@orquestrador-pm checkpoint` ou linguagem natural — o LLM reconhece intenção)
  - **Expected Result**: Agente executa git commit + git push; hash de commit registrado; mensagem de commit gerada pelo agente contém identificação do autor humano (ex: `[PO: Ana] checkpoint: Seção 4 aprovada`); arquivos chegam ao repositório remoto
  - **Measurement Method**: Após checkpoint, executar `git log --oneline -1` no remoto e verificar presença do commit; inspecionar mensagem de commit para identificar autor humano; confirmar conteúdo dos arquivos contra o estado esperado

### FR-PER-02 — Controle de acesso ao repositório (GitHub apenas)

- **Capability**: **PO e YC Analyst têm leitura/escrita**; **Guest tem leitura** no repositório Git compartilhado (GitHub apenas, conforme Seção 3 A2)
- **Feature origem**: F7
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: TM-02
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Repositório GitHub configurado; 3 participantes com papéis PO, YC Analyst e Guest
  - **Action**: Tentar operação de leitura e escrita para cada papel
  - **Expected Result**: PO e YC Analyst podem ler e escrever (via bot); Guest pode apenas ler (acesso somente-leitura)
  - **Measurement Method**: Teste automatizado tenta push via credenciais de cada papel; verifica sucesso para PO/YC Analyst e rejeição (HTTP 403) para Guest

### FR-PER-03 — Auditoria pós-sessão de artefatos

- **Capability**: Auditoria pós-sessão confirma artefatos commitados e acessíveis via `git pull`
- **Feature origem**: F13
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: TM-02
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Sessão encerrada com commit realizado (FR-PER-01 aprovado)
  - **Action**: Executar `git pull` no repositório após encerramento
  - **Expected Result**: Artefatos da sessão estão presentes e acessíveis; conteúdo íntegro (não truncado)
  - **Measurement Method**: Script de auditoria lista arquivos do último commit, verifica extensão `.md` e tamanho > 0 bytes para cada artefato esperado; resultado logado com timestamp

### FR-PER-04 — Retomada de sessão com contexto resumido

- **Capability**: Participante retoma última sessão do projeto com **resumo/status como contexto** (H-B — sem mensagens anteriores)
- **Feature origem**: F15
- **Jornada(s)**: A.2, B.1
- **Métrica ancorada**: BM-02 (enables distribuição ≤4 dias)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Projeto com sessão anterior encerrada; participante retorna ao projeto
  - **Action**: Entrar na sala do projeto após sessão prévia
  - **Expected Result**: Sistema apresenta resumo do status da última sessão (ex: "User journeys mapeados; domain requirements em andamento") como contexto visível antes ou durante o início da nova sessão
  - **Measurement Method**: Teste E2E verifica presença de componente de "resumo de sessão anterior" com texto não vazio ao entrar em projeto com histórico registrado

### FR-PER-05 — Compilação do PRD em PDF sob demanda do agente

- **Capability**: Após aprovação do PRD pelo PO, o agente `@orquestrador-pm` **compila o PRD (10 seções + ANEXOS A/B/C) em um único arquivo PDF** via ferramenta shell executada pelo Claude Agent SDK (ex: pandoc). PDF é persistido no filesystem do projeto (`artifacts/PRD_<project>_<data>.pdf`) e incluído no commit de entrega
- **Feature origem**: F22
- **Jornada(s)**: A.1, A.2, B.1 (encerramento/aprovação)
- **Métrica ancorada**: BM-04 (PDF é insumo do envio ao receptor)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Projeto com PRD aprovado (checkbox marcado) e ANEXOS completos; ferramenta de conversão (pandoc ou equivalente) disponível no ambiente do SDK; `@orquestrador-pm` acionável
  - **Action**: Agente invoca ferramenta shell para compilar PRD+ANEXOS em PDF
  - **Expected Result**: Arquivo PDF gerado em `artifacts/`, contém todas as 10 seções + ANEXOS A/B/C, não está corrompido, tamanho > 0 bytes
  - **Measurement Method**: Script de verificação abre o PDF (ex: `pdftotext`), verifica presença dos títulos das 10 seções e 3 ANEXOS; tamanho do arquivo > limite mínimo (ex: 50KB); hash registrado na auditoria pós-sessão

### FR-PER-06 — Envio automático de PRD em PDF por email via MCP

- **Capability**: Após geração do PDF (FR-PER-05), o agente `@orquestrador-pm` **envia automaticamente o PDF por email** ao PO e ao Arquiteto Receptor via **servidor MCP** (`ycognio-email-mcp`). Email do Arquiteto Receptor contém **link para o formulário F11** (FR-FBK-03, 4 perguntas)
- **Feature origem**: F23
- **Jornada(s)**: A.1, A.2 (PO) e B.1 (Arquiteto Receptor downstream)
- **Métrica ancorada**: BM-04 (entrega do PRD e disparo do NPS receptor)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Projeto com PRD aprovado e PDF gerado (FR-PER-05 aprovado); emails de PO e Arquiteto Receptor configurados no projeto; servidor MCP `ycognio-email-mcp` acessível
  - **Action**: Agente invoca tool MCP de email com payload (destinatários, assunto, corpo, anexo PDF, link NPS F11 para o Arquiteto Receptor)
  - **Expected Result**: (a) PO recebe email com PDF anexado; (b) Arquiteto Receptor recebe email com PDF anexado + link para formulário F11 funcional; (c) Status de envio registrado com `message_id` do MCP
  - **Measurement Method**: Teste end-to-end em ambiente controlado: inspecionar caixa de entrada de PO+Receptor (ou mock SMTP), validar presença do PDF e do link, validar que link abre formulário web com 4 perguntas; registro do `message_id` disponível no log da sessão

### FR-PER-07 — Encerramento da sessão com guard de checkpoint

- **Capability**: Participante (PO ou YC Analyst) pode acionar **botão "Encerrar Sala"** — o sistema exibe **modal de confirmação com guard**: encerramento só é concluído após (a) checkpoint executado com sucesso OU (b) confirmação explícita do tipo "encerrar sem salvar". Guest **não** pode acionar o botão
- **Feature origem**: F6 (persistência) + F21 (papel)
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: TM-02 (garante persistência antes do encerramento)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sessão ativa com artefatos não commitados desde o último checkpoint; participante com papel PO ou YC Analyst
  - **Action**: (a) Participante clica "Encerrar Sala" → sistema exibe modal com opções "Executar checkpoint" / "Encerrar sem salvar" / "Cancelar"; (b) Participante escolhe "Executar checkpoint" → agente executa; (c) Após sucesso do checkpoint, participante confirma encerramento
  - **Expected Result**: (a) Modal bloqueia encerramento imediato; (b) Botão acessível apenas para PO/YC Analyst; Guest não vê ou recebe erro ao clicar; (c) Se "encerrar sem salvar" for escolhido, dupla confirmação é exigida; (d) Sessão só encerra após caminho explícito de confirmação
  - **Measurement Method**: Teste E2E para cada caminho (checkpoint OK / encerrar sem salvar / cancelar); teste para Guest tentando acionar botão → verificar ausência do botão ou resposta 403

---

## 8.5. FR-FBK — Feedback (3 FRs)

### FR-FBK-01 — NPS pós-sessão do PO (modal bloqueante)

- **Capability**: PO responde NPS pós-sessão (1 pergunta escala 0-10: *"clareza da condução"*) em **modal obrigatório que bloqueia o encerramento da sala até submissão**
- **Feature origem**: F9
- **Jornada(s)**: A.1, A.2
- **Métrica ancorada**: UM-01 (meta NPS ≥70 em agregado)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sessão de elicitação em andamento; participante com papel PO; PO aciona fluxo de encerramento da sala (via botão ou comando)
  - **Action**: Sistema apresenta **modal bloqueante** com o prompt NPS antes de concluir o encerramento; PO tenta fechar o modal sem responder; PO submete a resposta NPS
  - **Expected Result**: (a) Modal não permite fechamento sem submissão (bloqueante); (b) Após submissão, sessão é encerrada; (c) Resposta registrada no backend com timestamp
  - **Measurement Method**: Teste E2E verifica que tentar fechar o modal sem resposta mantém a sessão ativa; submissão registra valor 0-10 no backend e libera o fluxo de encerramento; NPS agregado calculado mensalmente

### FR-FBK-02 — Formulário de aprovação com 2 perguntas (escala 1-5)

- **Capability**: PO responde form de **2 perguntas (escala 1-5)** na aprovação: reconhecimento do pedido + captura de não-articulado
- **Feature origem**: F10
- **Jornada(s)**: A.1, A.2
- **Métrica ancorada**: UM-02 (meta média ≥4,5/5 em ambas)
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: PRD marcado como completo/aprovado; participante com papel PO
  - **Action**: PO aciona aprovação do PRD
  - **Expected Result**: Sistema exibe formulário com exatamente 2 perguntas em escala 1-5; PO consegue submeter
  - **Measurement Method**: Teste E2E verifica presença de 2 inputs de escala no modal de aprovação e registro da resposta no backend; média agregada calculada a partir dos registros

### FR-FBK-03 — Formulário de feedback do analista receptor (4 perguntas)

- **Capability**: Analista receptor (arquiteto Ycodify) responde **formulário de 4 perguntas** (1 pergunta NPS escala 0-10 + 3 perguntas complementares qualitativas) após consumir o PRD
- **Feature origem**: F11
- **Jornada(s)**: B.1
- **Métrica ancorada**: BM-04 (meta NPS ≥50 em agregado, a partir da pergunta NPS das 4)
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: PRD entregue (PDF via email) ao analista receptor; link do formulário web incluído no corpo do email (F23)
  - **Action**: Analista receptor clica no link do email, acessa formulário web e submete as 4 respostas
  - **Expected Result**: Formulário web exibe **exatamente 4 perguntas** (1 escala 0-10 marcada como NPS + 3 complementares com formatos a definir em deploy); analista submete e recebe confirmação; todas as 4 respostas são registradas
  - **Measurement Method**: Teste manual de fluxo end-to-end: enviar email com PDF + link, acessar link, verificar 4 perguntas presentes, submeter, verificar registro no backend; NPS agregado calculado por coorte de PRDs entregues a partir da 1ª pergunta

---

## 8.6. FR-TEL — Telemetria e Monitoramento (3 FRs)

### FR-TEL-01 — Streaming de respostas dos agentes

- **Capability**: Participantes recebem respostas dos agentes em **streaming** (tokens progressivos)
- **Feature origem**: F5
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: BM-01 (SDK habilita elicitação completa em ≤8h)
- **Priority**: Must-Have
- **Test Criteria**:
  - **Setup**: Sala ativa + participante PO ou YC Analyst
  - **Action**: Enviar mensagem que aciona agente IA
  - **Expected Result**: Resposta do agente aparece progressivamente no chat (tokens visíveis à medida que chegam), não de uma vez após longo silêncio
  - **Measurement Method**: Teste E2E registra timestamps do primeiro token visível e do último token; verifica que delta entre tokens consecutivos é < 3s e que o primeiro token aparece em < 5s após envio

### FR-TEL-02 — Registro de eventos de interação

- **Capability**: Sistema registra eventos `user_typing_start` / `user_message_sent` / `ai_response_complete` para cálculo de tempo de chat ativo
- **Feature origem**: F8
- **Jornada(s)**: A.1, A.2, B.1
- **Métrica ancorada**: BM-01 (instrumento de medição)
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Sala ativa com participante PO enviando mensagem e agente respondendo
  - **Action**: Executar ciclo completo: participante começa a digitar → envia mensagem → agente responde
  - **Expected Result**: Três eventos registrados nos logs: `user_typing_start`, `user_message_sent`, `ai_response_complete`; cada evento com timestamp e identificadores de sessão/participante
  - **Measurement Method**: Após ciclo, consultar log ou endpoint de telemetria; verificar presença dos 3 eventos com campos obrigatórios (timestamp, session_id, participant_id, event_type)

### FR-TEL-03 — Health check e monitoramento de uptime

- **Capability**: Health check a cada 60s + endpoint de status para monitoramento externo
- **Feature origem**: F12
- **Jornada(s)**: A.1, A.2, B.1, C.1
- **Métrica ancorada**: TM-01 (meta ≥99% em horário comercial 8h-20h BRT dias úteis)
- **Priority**: Should-Have
- **Test Criteria**:
  - **Setup**: Sistema em operação normal
  - **Action**: Requisição GET ao endpoint `/health` (ou equivalente) a cada 60s; verificação adicional via monitor externo (ex: UptimeRobot)
  - **Expected Result**: Endpoint retorna HTTP 200 com payload de status em < 1s
  - **Measurement Method**: Monitor externo registra uptime em janela de 30 dias; cálculo: (minutos com resposta 200 / total de minutos em horário comercial) ≥ 99%; relatório mensal gerado a partir dos dados do monitor

---

## 8.7. Rastreabilidade — FR × Feature × Jornada × Métrica

Tabela cruzada para auditoria de cobertura. Cada FR referencia exatamente 1 feature origem + 1+ jornada(s) + 0-1 métrica(s) ancorada(s).

| FR ID | Feature Origem | Jornadas | Métrica | Priority |
|---|---|---|---|---|
| FR-ACC-01 | F17 + F2=OUT(b) | A.1, A.2, B.1, C.1 | — | Must |
| FR-ACC-02 | F17 | A.1, A.2, B.1, C.1 | — | Should |
| FR-ACC-03 | F2=OUT(a) | A.1, A.2, B.1, C.1 | — | Must |
| FR-ACC-04 | F2=OUT(b) | A.1, A.2, B.1, C.1 | — | Should |
| FR-CHT-01 | F1 | Todas | TM-03 | Must |
| FR-CHT-02 | F21 | A.1, A.2, B.1 | BM-01 | Must |
| FR-CHT-03 | F21 | C.1 | — | Must |
| FR-CHT-04 | F4 | A.1, A.2, B.1 | UM-01 | Must |
| FR-CHT-05 | F1 | Todas | TM-03 | Should |
| FR-VIS-01 | F3 | Todas | UM-01 | Must |
| FR-VIS-02 | F14 | A.1, A.2, B.1 | UM-02 | Must |
| FR-VIS-03 | F18 | Todas | BM-02 | Must |
| FR-VIS-04 | F19 | Todas | — | Should |
| FR-VIS-05 | F18 | A.2, B.1 | BM-02 | Should |
| FR-PER-01 | F6 | A.1, A.2, B.1 | TM-02 | Must |
| FR-PER-02 | F7 | Todas | TM-02 | Must |
| FR-PER-03 | F13 | A.1, A.2, B.1 | TM-02 | Should |
| FR-PER-04 | F15 | A.2, B.1 | BM-02 | Must |
| FR-PER-05 | F22 | A.1, A.2, B.1 | BM-04 | Must |
| FR-PER-06 | F23 | A.1, A.2, B.1 | BM-04 | Must |
| FR-PER-07 | F6 + F21 | A.1, A.2, B.1 | TM-02 | Must |
| FR-FBK-01 | F9 | A.1, A.2 | UM-01 | Must |
| FR-FBK-02 | F10 | A.1, A.2 | UM-02 | Should |
| FR-FBK-03 | F11 | B.1 | BM-04 | Should |
| FR-TEL-01 | F5 | Todas | BM-01 | Must |
| FR-TEL-02 | F8 | A.1, A.2, B.1 | BM-01 | Should |
| FR-TEL-03 | F12 | Todas | TM-01 | Should |

### Cobertura de Features MVP

Das 20 features IN da Seção 3.1.2 + 2 complementos de F2=OUT, todas possuem ≥1 FR correspondente:

| Feature | FRs | Feature | FRs |
|---|---|---|---|
| F1 | FR-CHT-01, FR-CHT-05 | F14 | FR-VIS-02 |
| F3 | FR-VIS-01 | F15 | FR-PER-04 |
| F4 | FR-CHT-04 | F17 | FR-ACC-01, FR-ACC-02 |
| F5 | FR-TEL-01 | F18 | FR-VIS-03, FR-VIS-05 |
| F6 | FR-PER-01, FR-PER-07 | F19 | FR-VIS-04 |
| F7 | FR-PER-02 | F21 | FR-CHT-02, FR-CHT-03, FR-PER-07 |
| F8 | FR-TEL-02 | F22 | FR-PER-05 |
| F9 | FR-FBK-01 | F23 | FR-PER-06 |
| F10 | FR-FBK-02 | F2=OUT(a) | FR-ACC-03 |
| F11 | FR-FBK-03 | F2=OUT(b) | FR-ACC-01, FR-ACC-04 |
| F12 | FR-TEL-03 | F13 | FR-PER-03 |

### Cobertura de Métricas da Seção 2

Todas as 9 métricas da Seção 2 estão ancoradas em ≥1 FR:

| Métrica | FRs que ancoram |
|---|---|
| BM-01 (100% seções ≤8h chat ativo) | FR-CHT-02, FR-TEL-01, FR-TEL-02 |
| BM-02 (≤4 dias calendário) | FR-VIS-03, FR-VIS-05, FR-PER-04 |
| BM-03 (100% QA cruzado) | *Não coberto por FR do MVP — validação operada fora do webchat* |
| BM-04 (NPS analista ≥50) | FR-PER-05, FR-PER-06, FR-FBK-03 |
| UM-01 (NPS clareza ≥70) | FR-CHT-04, FR-VIS-01, FR-FBK-01 |
| UM-02 (Reconhecimento ≥4,5/5) | FR-VIS-02, FR-FBK-02 |
| TM-01 (Disponibilidade ≥99%) | FR-TEL-03 |
| TM-02 (Persistência Git 100%) | FR-PER-01, FR-PER-02, FR-PER-03, FR-PER-07 |
| TM-03 (Broadcast ≤2s) | FR-CHT-01, FR-CHT-05 |

**Observação**: BM-03 (validação QA cruzada) é executada pelo agente `@qa-de-specs` externamente ao webchat (conforme Design Principle 3.1.6). O FR correspondente — se necessário — viria na Growth Phase (G7: Validação em tempo real durante a sessão).

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 7: Project-Type Requirements](PRD_07_ProjectTypeRequirements.md)
- ➡️ Próxima: [Seção 9: Non-Functional Requirements](PRD_09_NonFunctionalRequirements.md)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---


# Seção 9: Non-Functional Requirements (NFRs)

**Projeto**: Ycognio — Webchat de Elicitação Assistida
**Cliente**: Ycodify
**Responsáveis**: PM (Giovanna) + BA (Sofia)
**Objetivo**: Registrar NFRs aplicáveis ao MVP com escopo minimalista — a maioria já está ancorada em métricas e decisões de seções anteriores

---

## 9.1. Postura do Projeto

O Ycognio MVP é ferramenta interna da Ycodify em fase de validação (ver Seção 5.1). **A elaboração formal de NFRs não é prioridade do MVP**: a maioria dos aspectos não-funcionais relevantes **já está ancorada em outras seções** (métricas da Seção 2, decisões de domínio da Seção 5, requisitos de tipo da Seção 7).

Esta seção **consolida** os NFRs já existentes (9.2) + registra NFRs **soft targets não-formalizados** (9.3) + declara explicitamente o que está **fora do escopo MVP** (9.4).

---

## 9.2. NFRs Formais Ancorados em Seções Anteriores

Os NFRs abaixo **têm medição formal** definida, com métrica da Seção 2 e FRs correspondentes da Seção 8. São **contratuais** para o MVP.

| NFR ID | Categoria | Requisito | Âncora | FR correspondente |
|---|---|---|---|---|
| **NFR-AVA-01** | Disponibilidade | Sistema disponível ≥ 99% em horário comercial (8h-20h BRT, dias úteis) | TM-01 | FR-TEL-03 |
| **NFR-PER-01** | Performance (latência de rede) | Broadcast de mensagens ≤ 2s para 99% dos eventos | TM-03 | FR-CHT-01, FR-CHT-05 |
| **NFR-REL-01** | Confiabilidade (durabilidade de dados) | 100% das sessões encerradas com artefatos commitados e acessíveis via `git pull` | TM-02 | FR-PER-01, FR-PER-02, FR-PER-03 |
| **NFR-USA-01** | Usabilidade (clareza) | NPS de clareza da condução ≥ 70 (medido agregado) | UM-01 | FR-CHT-04, FR-VIS-01, FR-FBK-01 |
| **NFR-USA-02** | Usabilidade (reconhecimento) | Média ≥ 4,5/5 em ambas as 2 perguntas de reconhecimento | UM-02 | FR-VIS-02, FR-FBK-02 |
| **NFR-BUS-01** | Eficiência de entrega | PRD completo (10 seções, zero `[A PREENCHER]`) em ≤ 8h de chat ativo cumulativo | BM-01 | FR-CHT-02, FR-TEL-01, FR-TEL-02 |
| **NFR-BUS-02** | Eficiência de calendário | Distribuição da elicitação em ≤ 4 dias corridos | BM-02 | FR-VIS-03, FR-VIS-05, FR-PER-04 |
| **NFR-QUA-01** | Qualidade (consistência) | 100% dos PRDs passam na validação cruzada (QA) sem edição adicional | BM-03 | *(validação operada fora do webchat — ver 9.5)* |
| **NFR-QUA-02** | Qualidade (satisfação receptor) | NPS do analista receptor ≥ 50 (agregado) | BM-04 | FR-FBK-03 |

---

## 9.3. NFRs Soft Targets (Não-Formalizados)

Referências de qualidade **sem meta contratual** no MVP — servem de orientação para desenvolvimento e podem virar NFRs formais em Growth.

| NFR ID | Categoria | Soft Target MVP | Observação |
|---|---|---|---|
| **NFR-PER-02** | Performance (LLM) | p95 de streaming de resposta do agente ≤ 15s | Depende de provedor LLM (Anthropic); fora de controle direto — não é contratual. Declarado em Seção 2 nota Technical Metric |
| **NFR-PER-03** | Performance (UI) | Carregamento inicial da tela de projetos ≤ 3s | Boas práticas web; sem SLA formal no MVP |
| **NFR-USA-03** | Acessibilidade (informal) | Contraste adequado + navegação por teclado nos elementos principais | WCAG formal FORA do MVP (ver Seção 7.5) |
| **NFR-SEC-01** | Segurança (mínima) | Link único compartilhado com TTL + bot único para commits Git | Autenticação formal FORA do MVP (ver F2=OUT Seção 3.1.3 e Seção 5.1) |

---

## 9.4. NFRs FORA do Escopo MVP (Reavaliar em Growth)

As categorias abaixo **não têm requisito formal no MVP**. Serão endereçadas em **Growth Phase** quando mudança de contexto exigir.

| Categoria | O que está fora | Quando retomar |
|---|---|---|
| **Escalabilidade horizontal** | Suporte a >2 sessões simultâneas | Growth Phase — sem item G dedicado atualmente; reavaliar quando volume de projetos simultâneos crescer (eventualmente um novo item de Growth) |
| **Segurança formal** | SSO, RBAC, 2FA, auditoria de acesso | G1 (Seção 3.2) — autenticação formal |
| **Compliance LGPD formal** | DPO nomeado, canal de direitos na UI, consentimento granular, DPA formal | Ver Seção 5.1 (FORA do MVP) |
| **Compliance internacional** | GDPR, cláusulas de transferência internacional elaboradas | Ver Seção 5.1 (FORA do MVP) |
| **Manutenibilidade formal** | Test coverage metas, complexidade ciclomática, technical debt tracking | Growth — quando time crescer |
| **Observabilidade avançada** | APM completo, distributed tracing, alerting sofisticado | Growth — quando volume crescer |
| **Internacionalização** | Multi-idioma, multi-timezone, multi-currency | G8 (Seção 3.2) — expansão internacional |
| **Notificações push / assíncronas** | Push notifications, e-mails transacionais por evento | Growth — quando fluxo assíncrono entrar |
| **Disaster Recovery / BC** | RTO, RPO, backup multi-região, failover automatizado | Growth ou Vision — dependendo de criticidade comercial |
| **SEO / descoberta orgânica** | Meta tags, sitemap, SEO strategy | Não aplicável (ferramenta interna) |

---

## 9.5. Observação sobre NFR-QUA-01 (BM-03)

O NFR de consistência (BM-03 — validação cruzada QA) é executado pelo **agente `@qa-de-specs`** fora do webchat (via invocação direta do Analyst ou PO durante sessão final).

- **Conformidade com Design Principle 3.1.6** (Chat como Wrapper): o webchat não executa lógica de QA; apenas expõe o agente
- **Medição**: ao final de cada sessão de aprovação, `@qa-de-specs` gera relatório de issues no repositório Git (artefato auditável)
- **FR correspondente no MVP**: nenhum — a funcionalidade reside inteiramente no agente e não requer feature específica do chat além de F4 (invocação via `@`)
- **Growth candidato**: **G7** (Seção 3.2) traria validação em tempo real durante a sessão (não apenas ao final)

---

## 9.6. Itens para LEARNING_LOG

Nenhum novo item — os itens de compliance e segurança formal já estão registrados no LEARNING_LOG pelas entries das Seções 5 (LGPD e segurança de acesso) e 3 (Design Principle 3.1.6). Esta Seção 9 apenas consolida e referencia.

---

## 🔗 Navegação

- ⬅️ Anterior: [Seção 8: Functional Requirements](PRD_08_FunctionalRequirements.md)
- ➡️ Próxima: [Seção 10: Metadados YAML](PRD_10_Metadata.yaml)
- 📖 PRD Completo: [Compilar](../compile-prd.sh)

---

**Template Version**: 3.1 (Dual-Mode PRD)
**Seção concluída**: 2026-04-17

---

## 10. Metadados do Projeto

```yaml
# ============================================================================
# Seção 10: Metadados Técnicos (Uso Interno)
# ============================================================================
# Projeto: Ycognio — Webchat de Elicitação Assistida
# Cliente: Ycodify
# Responsável: Analista de Negócio (Sofia)
# Objetivo: Facilitar tradução do PRD para specs técnicas (spec_documentos.json,
#           spec_processos.json, spec_integracoes.json)
# Consumidores: Arquitetos Ycodify (Documentos, Processos, Integrações) + QA
# Cliente: NÃO precisa revisar — é artefato técnico de apoio
# ============================================================================
# Template Version: 3.1 (Dual-Mode PRD)
# Seção concluída: 2026-04-17

section: 10
title: "Metadados Técnicos (Mapeamento Negócio → Técnico)"
responsible: "BA (Analista de Negócio)"
estimated_lines: 200-300
dependencies: [4, 5, 7, 8, 9]
related_sections: []
status: "completed"
completed_at: "2026-04-17"

# ============================================================================
# MÓDULOS (Bounded Contexts)
# ============================================================================

modulos:
  - negocio: "Ycognio"
    tecnico_id: "ycognio"
    bounded_context: true
    descricao: >
      Webchat de Elicitação Assistida. Wrapper sobre arquitetura de agentes Claude
      existente em .claude/agents/ dos projetos Ycodify. Opera sobre pasta Git
      pré-existente passada como project_path. Único bounded context do produto.
    frs_relacionados: []  # Abrange todos os 24 FRs

# ============================================================================
# DOCUMENTOS (Entidades / Aggregates)
# ============================================================================

documentos:
  - negocio: "Projeto"
    tecnico_id: "projeto"
    aggregate: true
    modulo: "ycognio"
    descricao: >
      Pasta Git pré-existente com sessões de elicitação. Contém agentes em
      .claude/agents/ e artefatos PRD versionados. Ciclo de vida: ativo → concluído.
      Um Projeto contém N Sessões e 1 PRD final aprovado.
    frs_relacionados: [FR-ACC-01, FR-ACC-02, FR-VIS-03, FR-PER-01, FR-PER-02, FR-FBK-02]
    features_origem: [F17, F6, F7, F10]

  - negocio: "Sessão"
    tecnico_id: "sessao"
    aggregate: true
    modulo: "ycognio"
    descricao: >
      Encontro de chat dentro de um Projeto. Pode ser retomada via resumo/status
      (F15). NÃO exibe mensagens anteriores ao retomar — nova sessão com contexto
      resumido. Uma Sessão contém N Mensagens e gera 0..N Artefatos.
    frs_relacionados: [FR-PER-04, FR-TEL-02, FR-FBK-01, FR-VIS-03, FR-VIS-05]
    features_origem: [F15, F8, F9, F18]

  - negocio: "Participante"
    tecnico_id: "participante"
    aggregate: false
    modulo: "ycognio"
    descricao: >
      Humano na sala identificado por nick livre + papel selecionado em lista
      fechada: PO, YC Analyst, Guest. Sem cadastro formal no MVP. Papel define
      roteamento de mensagens (F21) e permissões Git.
    frs_relacionados: [FR-ACC-03, FR-CHT-02, FR-CHT-03, FR-VIS-04, FR-PER-02]
    features_origem: [F2-OUT-a, F21, F19, F7]

  - negocio: "Mensagem"
    tecnico_id: "mensagem"
    aggregate: false
    modulo: "ycognio"
    descricao: >
      Texto enviado no chat. Roteamento para agentes IA depende do papel do
      remetente (F21): PO e YC Analyst → encaminhadas ao SDK; Guest → visíveis
      no chat mas NÃO consumidas pela IA. Pode conter @mention para invocação
      direta de agente (F4).
    frs_relacionados: [FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-TEL-02]
    features_origem: [F1, F21, F4, F8]

  - negocio: "Artefato"
    tecnico_id: "artefato"
    aggregate: false
    modulo: "ycognio"
    descricao: >
      Arquivo produzido pelos agentes durante sessão (PRD.md, ANEXO_A.md,
      ANEXO_B.md, ANEXO_C.md, sections/PRD_*.md). Commitado no Git via bot
      Ycognio Bot ao final de sessão ou checkpoint manual.
    frs_relacionados: [FR-PER-01, FR-PER-03, FR-VIS-02]
    features_origem: [F6, F13, F14]

  - negocio: "Link de Acesso"
    tecnico_id: "linkacesso"
    aggregate: false
    modulo: "ycognio"
    descricao: >
      URL única compartilhada com TTL — MULTI-USO. Ponto de entrada único ao
      Ycognio — mesma URL usada por todos os participantes (PO, Analista, Guests)
      para ver lista de projetos e acessar salas. Expiração por TTL bloqueia novas
      entradas. NÃO existe conceito de link de convite individual/single-use no
      MVP — identificação individual ocorre no login da sala (nick + papel).
    frs_relacionados: [FR-ACC-01, FR-ACC-04]
    features_origem: [F2-OUT-b, F17]

  - negocio: "Formulário de Feedback"
    tecnico_id: "formulariofeedback"
    aggregate: false
    modulo: "ycognio"
    descricao: >
      Coleta de feedback qualitativo ao final de sessão/aprovação. Três variantes:
      NPS pós-sessão do PO (F9, escala 0-10), form de reconhecimento do PO
      (F10, 2 perguntas escala 1-5), NPS analista receptor (F11, escala 0-10).
    frs_relacionados: [FR-FBK-01, FR-FBK-02, FR-FBK-03]
    features_origem: [F9, F10, F11]

# ============================================================================
# PROCESSOS (Fluxos de Negócio)
# ============================================================================

processos:
  - negocio: "Acesso ao Ycognio"
    tecnico_id: "acessoycognio"
    modulo: "ycognio"
    descricao: >
      Participante acessa tela inicial via link compartilhado (sem autenticação),
      visualiza lista de projetos com metadados e seleciona projeto.
    frs_relacionados: [FR-ACC-01, FR-ACC-02, FR-ACC-04]
    features_origem: [F17, F2-OUT-b]

  - negocio: "Entrada na Sala"
    tecnico_id: "entradasala"
    modulo: "ycognio"
    descricao: >
      Participante informa nick livre e seleciona papel (PO / YC Analyst / Guest)
      para entrar na sala do projeto. Ao entrar, painel de status do projeto é
      exibido (resumo da última sessão + tempo decorrido).
    frs_relacionados: [FR-ACC-03, FR-VIS-03, FR-VIS-04]
    features_origem: [F2-OUT-a, F18, F19]

  - negocio: "Conversação no Chat"
    tecnico_id: "conversacaochat"
    modulo: "ycognio"
    descricao: >
      Ciclo principal de elicitação: participantes enviam mensagens; mensagens
      de PO/YC Analyst são encaminhadas aos agentes via SDK; respostas chegam
      em streaming com badge de identificação do agente; Guests veem o chat
      mas não interagem com a IA.
    frs_relacionados: [FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-TEL-01, FR-VIS-01]
    features_origem: [F1, F3, F4, F5, F21]

  - negocio: "Retomada de Sessão"
    tecnico_id: "retomadasessao"
    modulo: "ycognio"
    descricao: >
      Participante retorna ao projeto em dia/horário posterior. Sistema apresenta
      resumo/status da última sessão como contexto; nova sessão de chat é aberta
      (sem exibir mensagens anteriores).
    frs_relacionados: [FR-PER-04, FR-VIS-03, FR-VIS-05]
    features_origem: [F15, F18]

  - negocio: "Checkpoint e Encerramento"
    tecnico_id: "checkpointencerramento"
    modulo: "ycognio"
    descricao: >
      YC Analyst solicita checkpoint manual ou encerramento de sessão. Sistema
      executa commit dos artefatos via bot Ycognio Bot no repositório Git; auditoria
      pós-sessão confirma presença dos artefatos commitados.
    frs_relacionados: [FR-PER-01, FR-PER-03, FR-TEL-02]
    features_origem: [F6, F8, F13]

  - negocio: "Aprovação de PRD e Feedback"
    tecnico_id: "aprovacaoprd"
    modulo: "ycognio"
    descricao: >
      PO acessa painel dedicado do PRD em construção, valida conteúdo e aprova.
      Sistema exibe formulário de reconhecimento (2 perguntas 1-5) e NPS de
      clareza (0-10). Analista receptor recebe NPS via link separado após entrega.
    frs_relacionados: [FR-VIS-02, FR-FBK-01, FR-FBK-02, FR-FBK-03]
    features_origem: [F9, F10, F11, F14]

# ============================================================================
# COMANDOS (Operações que mudam estado — PascalCase)
# ============================================================================

comandos:
  - negocio: "Entrar na Sala"
    tecnico_id: "EntrarNaSala"
    command: true
    documento: "participante"
    fr_source: FR-ACC-03
    feature_origem: F2-OUT-a

  - negocio: "Enviar Mensagem"
    tecnico_id: "EnviarMensagem"
    command: true
    documento: "mensagem"
    fr_source: FR-CHT-01
    feature_origem: F1

  - negocio: "Invocar Agente"
    tecnico_id: "InvocarAgente"
    command: true
    documento: "mensagem"
    fr_source: FR-CHT-04
    feature_origem: F4
    observacao: "Exclusivo para PO e YC Analyst; sintaxe @nome-do-agente"

  - negocio: "Solicitar Checkpoint"
    tecnico_id: "SolicitarCheckpoint"
    command: true
    documento: "sessao"
    fr_source: FR-PER-01
    feature_origem: F6
    observacao: "Ação disponível para YC Analyst"

  - negocio: "Encerrar Sessão"
    tecnico_id: "EncerrarSessao"
    command: true
    documento: "sessao"
    fr_source: FR-PER-01
    feature_origem: F6

  - negocio: "Retomar Última Sessão"
    tecnico_id: "RetomarUltimaSessao"
    command: true
    documento: "sessao"
    fr_source: FR-PER-04
    feature_origem: F15

  - negocio: "Aprovar PRD"
    tecnico_id: "AprovarPRD"
    command: true
    documento: "projeto"
    fr_source: FR-FBK-02
    feature_origem: F10
    observacao: "Exclusivo para PO; dispara exibição do formulário de feedback"

  - negocio: "Responder Feedback"
    tecnico_id: "ResponderFeedback"
    command: true
    documento: "formulariofeedback"
    fr_source: FR-FBK-01
    feature_origem: F9
    observacao: "Cobre NPS pós-sessão (F9), form reconhecimento (F10) e NPS analista (F11)"

# ============================================================================
# EVENTOS (Fatos de domínio — PascalCase)
# ============================================================================

eventos:
  - negocio: "Sessão Iniciada"
    tecnico_id: "SessaoIniciada"
    domain_event: true
    documento: "sessao"
    fr_source: FR-TEL-02
    feature_origem: F8

  - negocio: "Participante Entrou na Sala"
    tecnico_id: "ParticipanteEntrouNaSala"
    domain_event: true
    documento: "participante"
    fr_source: FR-ACC-03
    feature_origem: F2-OUT-a

  - negocio: "Mensagem Enviada"
    tecnico_id: "MensagemEnviada"
    domain_event: true
    documento: "mensagem"
    fr_source: FR-CHT-01
    feature_origem: F1

  - negocio: "Mensagem Encaminhada aos Agentes"
    tecnico_id: "MensagemEncaminhadaAgentes"
    domain_event: true
    documento: "mensagem"
    fr_source: FR-CHT-02
    feature_origem: F21
    observacao: "Apenas para mensagens de PO e YC Analyst (papel != guest)"

  - negocio: "Resposta de Agente Completa"
    tecnico_id: "RespostaAgenteCompleta"
    domain_event: true
    documento: "mensagem"
    fr_source: FR-TEL-02
    feature_origem: F5
    observacao: "Corresponde ao evento ai_response_complete da telemetria"

  - negocio: "Checkpoint Solicitado"
    tecnico_id: "CheckpointSolicitado"
    domain_event: true
    documento: "sessao"
    fr_source: FR-PER-01
    feature_origem: F6

  - negocio: "Sessão Encerrada"
    tecnico_id: "SessaoEncerrada"
    domain_event: true
    documento: "sessao"
    fr_source: FR-PER-01
    feature_origem: F6

  - negocio: "Artefato Commitado"
    tecnico_id: "ArtefatoCommitado"
    domain_event: true
    documento: "artefato"
    fr_source: FR-PER-01
    feature_origem: F6
    observacao: "Via bot Ycognio Bot <ycognio@ycodify.com>; autoria humana no commit message"

  - negocio: "Link Expirado"
    tecnico_id: "LinkExpirado"
    domain_event: true
    documento: "linkacesso"
    fr_source: FR-ACC-04
    feature_origem: F2-OUT-b

  - negocio: "PRD Aprovado"
    tecnico_id: "PRDAprovado"
    domain_event: true
    documento: "projeto"
    fr_source: FR-FBK-02
    feature_origem: F10

  - negocio: "Feedback Respondido"
    tecnico_id: "FeedbackRespondido"
    domain_event: true
    documento: "formulariofeedback"
    fr_source: FR-FBK-01
    feature_origem: F9
    observacao: "Cobre os três formulários: NPS PO (F9), reconhecimento PO (F10), NPS analista (F11)"

# ============================================================================
# INTEGRAÇÕES (Sistemas Externos)
# ============================================================================

integracoes:
  - negocio: "Claude Agent SDK (Anthropic)"
    tecnico_id: "claudeagentsdk"
    tipo: "SDK"
    direcao: "outbound"
    criticidade: "alta"
    autenticacao: "API Key Anthropic (backend)"
    descricao: >
      Motor de execução dos agentes Claude. Recebe mensagens de PO e YC Analyst
      com contexto de sessão; retorna respostas em streaming. Opera sobre
      working_dir = project_path. Conforme Design Principle 3.1.6: o chat
      expõe os agentes, não controla seu comportamento.
    frs_relacionados: [FR-CHT-02, FR-CHT-04, FR-TEL-01]
    features_origem: [F5, F21]
    fallback: >
      Se SDK indisponível: mensagens de PO/YC Analyst ficam enfileiradas com
      indicação visual de "aguardando agente"; broadcast entre participantes
      humanos continua funcionando (degradação parcial, não bloqueio total)

  - negocio: "GitHub (Git CLI + API)"
    tecnico_id: "github"
    tipo: "GIT_CLI_PLUS_REST_API"
    direcao: "outbound"
    criticidade: "alta"
    autenticacao: "Credenciais do bot Ycognio Bot (service account Ycodify — SSH Key/PAT/GitHub App [A DEFINIR em deploy]) no backend"
    descricao: >
      Persistência de artefatos via operações Git CLI (git commit, git push, git pull)
      executadas pelo agente @orquestrador-pm via Claude Agent SDK (shell tool), usando
      credenciais do bot Ycognio Bot no servidor. GitHub REST API usada eventualmente
      para operações adicionais (criação de repo, colaboradores). Repo criado pelo
      YC Analyst na organização ycodify; colaboradores do cliente adicionados ao repo.
      Provedor único no MVP (GitHub apenas — conforme Seção 3 A2 e Seção 5.2.5).
    frs_relacionados: [FR-PER-01, FR-PER-02, FR-PER-03, FR-PER-04]
    features_origem: [F6, F7, F13, F15]
    fallback: >
      Se GitHub indisponível: artefatos gerados pelos agentes são retidos em
      memória/storage temporário; commit executado quando conexão restabelecida;
      agente reporta erro no chat (regra do Processo 2 — sem retry automático
      bloqueante).

  - negocio: "Servidor MCP de Email (ycognio-email-mcp)"
    tecnico_id: "emailmcp"
    tipo: "MCP_TOOL"
    direcao: "outbound"
    criticidade: "alta"
    autenticacao: "Credenciais do servidor MCP [A DEFINIR em deploy]"
    descricao: >
      Envio automático de email com o PDF do PRD após aprovação (F23). Invocado
      pelo agente @orquestrador-pm via Claude Agent SDK como MCP tool (NÃO é SMTP
      direto nem REST API tradicional). Destinatários: PO + Arquiteto Receptor.
      Email do Arquiteto Receptor inclui link para formulário NPS F11 (4 perguntas).
      Remetente, template HTML, URL do formulário NPS e endpoint MCP [A DEFINIR em
      deploy]. Conforme Design Principle 3.1.6: o envio é ato do agente via MCP,
      não lógica do sistema web.
    frs_relacionados: [FR-FBK-03, FR-PER-06]
    features_origem: [F11, F23]
    fallback: >
      Se MCP indisponível: agente reporta erro no chat; artefato já está no Git
      (suficiente como canal primário); email é canal adicional. Sem retry automático
      bloqueante — operador humano pode reenviar via novo comando ao agente.

# ============================================================================
# PAPÉIS (Roles de Acesso)
# ============================================================================

papeis:
  - negocio: "PO do Cliente"
    tecnico_id: "po"
    persona: "A"
    descricao: "Product Owner do cliente. Participa ativamente da elicitação; aprova PRD."
    permissoes:
      - "entrar_sala"
      - "enviar_mensagem_para_ia"
      - "invocar_agente"
      - "visualizar_prd_em_construcao"
      - "aprovar_prd"
      - "responder_feedback_nps"
      - "responder_feedback_reconhecimento"
      - "git_leitura_escrita"
    frs_relacionados: [FR-ACC-03, FR-CHT-02, FR-CHT-04, FR-VIS-02, FR-FBK-01, FR-FBK-02, FR-PER-02]

  - negocio: "Analista Ycodify"
    tecnico_id: "ycanalyst"
    persona: "B"
    descricao: >
      Analista da Ycodify que conduz a elicitação. Pode invocar agentes,
      solicitar checkpoint/encerramento e transitar entre projetos.
    permissoes:
      - "entrar_sala"
      - "enviar_mensagem_para_ia"
      - "invocar_agente"
      - "visualizar_prd_em_construcao"
      - "solicitar_checkpoint"
      - "encerrar_sessao"
      - "responder_feedback_analista"
      - "git_leitura_escrita"
      - "transitar_entre_projetos"
    frs_relacionados: [FR-ACC-03, FR-CHT-02, FR-CHT-04, FR-VIS-02, FR-PER-01, FR-PER-02, FR-FBK-03]

  - negocio: "Guest (Observador)"
    tecnico_id: "guest"
    persona: "C"
    descricao: >
      Observador sem interação com IA. Vê o chat e o painel de status,
      mas suas mensagens NÃO são encaminhadas aos agentes (F21).
    permissoes:
      - "entrar_sala"
      - "enviar_mensagem_sem_ia"
      - "visualizar_painel_status"
      - "visualizar_prd_em_construcao"
      - "git_leitura"
    frs_relacionados: [FR-ACC-03, FR-CHT-03, FR-VIS-03, FR-VIS-04, FR-PER-02]

# ============================================================================
# NFR MAPPING (Mapeamento de NFRs da Seção 9 para métricas técnicas)
# ============================================================================

nfr_mapping:
  - nfr_id: "NFR-AVA-01"
    categoria: "Availability"
    metrica: "uptime_horario_comercial"
    target: "99%"
    medida_por: >
      Monitor externo (ex: UptimeRobot) configurado com ping a cada 60s ao
      endpoint /health; cálculo mensal: (minutos com resposta HTTP 200 /
      total de minutos em horário comercial 8h-20h BRT dias úteis) ≥ 99%
    fr_source: FR-TEL-03
    feature_origem: F12

  - nfr_id: "NFR-PER-01"
    categoria: "Performance"
    metrica: "broadcast_latency_p99"
    target: "2s"
    medida_por: >
      Instrumentação backend registra timestamp de envio e entrega por cliente;
      p99 calculado em 100 envios sob carga normal (≤20 participantes, ≤10 msgs/min)
    fr_source: FR-CHT-05
    feature_origem: F1

  - nfr_id: "NFR-REL-01"
    categoria: "Reliability"
    metrica: "git_persistence_rate"
    target: "100%"
    medida_por: >
      Script de auditoria pós-sessão lista arquivos do último commit; verifica
      extensão .md e tamanho > 0 bytes para cada artefato esperado; resultado
      logado com timestamp. Referência: FR-PER-03
    fr_source: FR-PER-01
    feature_origem: F6

  - nfr_id: "NFR-USA-01"
    categoria: "Usability"
    metrica: "nps_po_clareza"
    target: "NPS ≥ 70"
    medida_por: >
      Agregação mensal de respostas de F9 (FR-FBK-01); NPS calculado como
      (% Promotores - % Detratores) x 100 sobre coorte mensal de sessões encerradas
    fr_source: FR-FBK-01
    feature_origem: F9

  - nfr_id: "NFR-USA-02"
    categoria: "Usability"
    metrica: "media_reconhecimento_po"
    target: "Média ≥ 4,5/5 em ambas as perguntas"
    medida_por: >
      Agregação mensal de respostas de F10 (FR-FBK-02); média aritmética das
      respostas por pergunta calculada sobre coorte mensal de PRDs aprovados
    fr_source: FR-FBK-02
    feature_origem: F10

  - nfr_id: "NFR-BUS-01"
    categoria: "Business"
    metrica: "prd_completo_em_8h_chat_ativo"
    target: "≥ 80% das sessões"
    medida_por: >
      Telemetria F8 (FR-TEL-02): soma do tempo entre user_typing_start e
      ai_response_complete por sessão cumulativa; validação estática do PRD
      confirma 10 seções preenchidas sem [A PREENCHER]
    fr_source: FR-TEL-02
    feature_origem: F8

  - nfr_id: "NFR-BUS-02"
    categoria: "Business"
    metrica: "janela_calendario_dias"
    target: "≤ 4 dias corridos em ≥ 80% das sessões"
    medida_por: >
      Delta entre timestamp da primeira mensagem do projeto e timestamp do
      evento PRDAprovado; calculado por projeto e agregado mensalmente
    fr_source: FR-VIS-03
    feature_origem: F18

  - nfr_id: "NFR-QUA-01"
    categoria: "Quality"
    metrica: "qa_cruzado_passou"
    target: "≥ 95% das sessões"
    medida_por: >
      Relatório do agente @qa-de-specs (QA_REPORT.md) por PRD entregue;
      resultado binário APROVADO/REPROVADO; agregação mensal sobre coorte
      de PRDs concluídos. Operado externamente ao webchat (Design Principle 3.1.6)
    fr_source: null
    feature_origem: null
    observacao: "BM-03 não possui FR no MVP — validação é operada pelo agente @qa-de-specs fora do webchat"

  - nfr_id: "NFR-QUA-02"
    categoria: "Quality"
    metrica: "nps_analista_receptor"
    target: "NPS ≥ 50"
    medida_por: >
      Agregação de respostas de F11 (FR-FBK-03); NPS calculado como
      (% Promotores - % Detratores) x 100 sobre coorte de PRDs entregues
      ao arquiteto/analista receptor downstream
    fr_source: FR-FBK-03
    feature_origem: F11
```
