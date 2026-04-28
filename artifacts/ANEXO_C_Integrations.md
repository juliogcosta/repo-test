---
document: "ANEXO_C_Integrations"
project: "ycognio"
responsible: "BA (Analista de Negócio — Sofia)"
created_at: "2026-04-18"
last_updated: "2026-04-18"
version: "1.1"
prd_mode: "fragmented"
status: "completed"
template_version: "3.1"
ve_note: "VE-1: 3 ocorrências de 'até 5 questões' corrigidas para '4 perguntas'; FR-PER-05 adicionado a C.1; FR-PER-06 adicionado a C.3; FR-PER-07 adicionado a C.2"
integrations:
  - claudeagentsdk
  - github
  - emailmcp
---

# ANEXO C: Integrations — Ycognio — Webchat de Elicitação Assistida

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Documentar as três integrações externas do MVP — propósito, contrato, autenticação, política de falha e rastreabilidade com os processos do ANEXO A e FRs da Seção 8
> **Consumidores**: Arquiteto de Integrações (gera `spec_integracoes.json`) e QA de Specs

**Rastreabilidade**: Este anexo está alinhado com `UBIQUITOUS_LANGUAGE.yaml` v1.2.1, ANEXO A (processos A.1, A.2, A.3) e Seção 8 (FRs).

---

## Mapa de Integrações

| # | ID Técnico | Nome de Negócio | Direção | Criticidade | Processos | FRs |
|---|-----------|-----------------|---------|-------------|-----------|-----|
| C.1 | `claudeagentsdk` | Claude Agent SDK (Anthropic) | Outbound | Alta | A.1, A.2, A.3 | FR-CHT-01 a FR-CHT-05, FR-VIS-01, FR-VIS-02, FR-PER-01, FR-PER-05, FR-FBK-02 |
| C.2 | `github` | GitHub — Repositório Remoto | Outbound | Alta | A.2, A.3 | FR-PER-01, FR-PER-02, FR-PER-03, FR-PER-07 |
| C.3 | `emailmcp` | Servidor MCP de Email (`ycognio-email-mcp`) | Outbound via MCP | Alta | A.3 | FR-FBK-02, FR-FBK-03, FR-PER-06 |

**Dependência de ordem** (dentro de A.3):

```
PRDAprovado
  └─→ [C.1] Agente compila PDF via SDK
        └─→ [C.2] Ycognio Bot commita artefatos
              └─→ [C.3] Agente envia email via MCP
```

---

## Integração C.1: Claude Agent SDK (Anthropic)

---

### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `claudeagentsdk` |
| **Nome de Negócio** | Claude Agent SDK — Anthropic |
| **Módulo** | `ycognio` |
| **Tipo de Integração** | SDK (biblioteca cliente + streaming HTTP) |
| **Direção** | Outbound — Ycognio → Anthropic API |
| **Sincronicidade** | Síncrono com resposta em streaming (Server-Sent Events) |
| **Criticidade** | Alta — sem SDK o sistema é um chat estático; agentes não respondem; nenhum artefato é gerado |
| **SLA do Fornecedor** | [A DEFINIR em deploy — consultar contrato Anthropic] |
| **Link para FR** | FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-VIS-01, FR-VIS-02, FR-PER-01, FR-PER-05, FR-FBK-02 |
| **Link para Processos** | A.1 (Etapas 2 e 3), A.2 (Etapa 2), A.3 (Etapas 2 e 4) |

---

### Propósito de Negócio

É a integração central e indispensável do Ycognio. Permite que o backend invoque os agentes Claude (como `@orquestrador-pm` e `@analista-de-negocio`) para conduzir a elicitação, gerar respostas em streaming para o chat, escrever artefatos no filesystem do Projeto e executar ferramentas de sistema (shell, leitura/escrita de arquivos, git). Sem esta integração, o Ycognio é apenas um mural de texto colaborativo — não há IA, não há PRD, não há produto.

---

### Direção e Tipo

- **Origem**: Backend do Ycognio
- **Destino**: Anthropic API (cloud)
- **Protocolo**: HTTPS com streaming (Server-Sent Events / chunked transfer)
- **Invocação**: A cada mensagem de PO ou YC Analyst enviada no chat; também ao acionar checkpoint, encerramento e aprovação de PRD
- **Modo**: Síncrono-streaming — backend recebe tokens progressivos e os repassa aos clientes WebSocket em tempo real

---

### Operações Invocadas

O SDK é invocado pelo backend com o parâmetro `working_dir = project_path` do Projeto. O agente ativo (por padrão `@orquestrador-pm`) recebe o contexto da sessão e executa uma ou mais das seguintes ferramentas internas do SDK:

| Ferramenta SDK | Propósito de Negócio | Processo |
|----------------|---------------------|---------|
| `Read` / `Write` / `Edit` | Criar, ler e modificar artefatos (PRD, ANEXOS, seções) no filesystem do Projeto | A.1, A.2, A.3 |
| `Bash` / `Shell` | Executar `git add/commit/push`, `bash scripts/compile-prd.sh`, `pandoc` (PDF) | A.2, A.3 |
| `Grep` / `Glob` | Buscar termos e arquivos no projeto para alimentar respostas | A.1 |
| MCP Tool (`ycognio-email-mcp`) | Enviar email com PDF após aprovação do PRD | A.3 |

> **Nota**: A ferramenta MCP de email é acessada pelo agente via SDK como uma tool adicional registrada no ambiente. A configuração do servidor MCP é detalhada na Integração C.3.

---

### Payload de Invocação (por chamada)

O backend empacota o seguinte contexto ao invocar o SDK:

| Campo | Tipo | Descrição | Exemplo |
|-------|------|-----------|---------|
| `working_dir` | string (path absoluto) | Diretório do Projeto no servidor; imutável | `/var/ycognio/projects/ycognio-proj-abc` |
| `session_id` | UUID | Identificador da sessão ativa | `f3a1-...` |
| `participant_role` | enum | Papel do remetente da mensagem | `po`, `ycanalyst` |
| `message_content` | string | Texto da mensagem enviada pelo participante | `"Qual o próximo passo?"` |
| `context_summary` | string | Resumo do histórico da conversa (janela configurável) | `"..."` |
| `agent_target` | string (opcional) | Agente explicitamente invocado via @mention; se ausente, usa padrão | `@analista-de-negocio` |

**Invariantes de invocação**:
- INV-C1.1: O SDK só é invocado se `sessao.iaAtivada = true` e `participante.papel ∈ {po, ycanalyst}` — mensagens de Guest nunca atingem o SDK (RN-A1.1)
- INV-C1.2: `working_dir` passado ao SDK é sempre o `project_path` do Projeto — o webchat nunca sobrepõe este valor (RN-A1.4)
- INV-C1.3: Se `agent_target` for informado, o SDK roteia para o agente especificado; agente deve existir em `.claude/agents/` do Projeto — se não existir, SDK retorna erro tratado (RN-A1.8)

---

### Resposta (Streaming)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `tokens` | stream de string | Tokens progressivos da resposta do agente |
| `agent_name` | string | Nome do agente que está respondendo (exibido no badge — FR-VIS-01) |
| `tool_use_events` | eventos internos | Notificações de ferramentas em uso (não exibidas ao usuário final, mas logadas) |
| `finish_reason` | enum | Motivo do encerramento: `end_turn`, `max_tokens`, `error` |

**Invariante**:
- INV-C1.4: Toda resposta de agente exibida no chat deve carregar `agent_name` identificável — badge visual obrigatório (RN-A1.5)

---

### Autenticação e Credenciais

| Credencial | Tipo | Titular | Onde Armazenar | Rotação |
|------------|------|---------|----------------|---------|
| `ANTHROPIC_API_KEY` | API Key | Ycodify (service account da plataforma) | Variável de ambiente segura / Secret Manager [A DEFINIR em deploy] | [A DEFINIR em deploy] |

**Fluxo**:
1. Backend lê `ANTHROPIC_API_KEY` do ambiente de execução no startup
2. Cada invocação do SDK inclui a chave no header `Authorization: Bearer <api_key>`
3. Chave é da Ycodify (plataforma Ycognio) — não é do cliente (PO ou YC Analyst)
4. Rotação de chave requer restart do backend [A DEFINIR em deploy]

> **Pendência**: Definir política de rotação e onde armazenar (ex: Azure Key Vault, AWS Secrets Manager, variável de ambiente de container) — decisão de infraestrutura pós-MVP.

---

### Política de Falha e Resiliência

**Timeout**:
- Tempo máximo sem receber primeiro token: **30 segundos** (após este prazo, SDK considerado indisponível para a requisição)
- Timeout total por resposta: [A DEFINIR em deploy — depende do tipo de operação; respostas longas de elicitação podem ultrapassar 120s]

**Retry Policy** (por invocação única de mensagem):
- **3 tentativas** com intervalo fixo de **10 segundos** entre tentativas
- Retry apenas em: timeout sem primeiro token, erro de rede, erro 5xx da API Anthropic
- Sem retry em: erro de autenticação (401), erro de quota excedida (429 sem `Retry-After`), erro de input inválido (400)
- Após 3 falhas: mensagem marcada como não processada; exibir no chat "Agente temporariamente indisponível. Tente novamente." (RN-A1.3)

**Comportamento em Indisponibilidade**:
- Sessão NÃO é encerrada por falha no SDK (RN-A1.10)
- Mensagem de PO/YC Analyst fica em fila de espera com indicador visual "aguardando agente"
- Após esgotar retries, participante pode reenviar manualmente
- Sessão continua como "chat sem IA" — participantes humanos podem trocar mensagens normalmente

**Rate Limiting (Anthropic)**:
- Limites dependem do contrato/tier da chave da Ycodify [A DEFINIR em deploy]
- Se resposta 429 com header `Retry-After`: aguardar tempo indicado e retry (1 tentativa adicional)

---

### Monitoramento

| Métrica | Target | Alerta se |
|---------|--------|-----------|
| Tempo para primeiro token (p95) | < 5s (BM-01) | > 10s por 5 minutos |
| Taxa de invocações bem-sucedidas | > 98% | < 95% por 10 minutos |
| Taxa de erros 5xx Anthropic | < 1% | > 3% por 5 minutos |
| Tentativas de retry por invocação | < 5% com retry | > 15% das invocações com retry |
| Invocações de Guest (deve ser zero) | 0 (INV-C1.1) | Qualquer ocorrência — indica bug crítico de roteamento |

**Eventos de log por invocação**:

```json
{
  "timestamp": "2026-04-18T14:30:00.000Z",
  "integration_id": "claudeagentsdk",
  "session_id": "f3a1-...",
  "participant_role": "po",
  "agent_target": "orquestrador-pm",
  "first_token_ms": 3200,
  "finish_reason": "end_turn",
  "retry_count": 0,
  "error": null
}
```

---

### Rastreabilidade

| Processo (ANEXO A) | Etapa | O Que Acontece |
|-------------------|-------|----------------|
| A.1 — Conversação no Chat | Etapa 2 | Backend invoca SDK com mensagem do participante |
| A.1 — Conversação no Chat | Etapa 3 | SDK responde em streaming; tokens exibidos no chat |
| A.2 — Checkpoint e Encerramento | Etapa 2 | Agente consolida artefatos e gera mensagem de commit |
| A.3 — Aprovação de PRD | Etapa 2 | Agente executa `compile-prd.sh` e gera PDF via pandoc |
| A.3 — Aprovação de PRD | Etapa 4 | Agente invoca MCP de email como tool interna do SDK |

---

### Pendências de Deploy

| Item | Descrição | Prioridade |
|------|-----------|-----------|
| `ANTHROPIC_API_KEY` | Provisionar chave service account Ycodify; definir onde armazenar | Crítica (bloqueante) |
| Tier / Rate Limits | Confirmar limites de RPM e TPM do contrato Anthropic | Alta |
| Timeout total | Definir timeout máximo por resposta longa (operações de elicitação profunda) | Alta |
| Política de rotação de chave | Processo de rotação sem downtime | Média |
| Ambiente de staging | Chave separada para ambiente de testes (não usar prod key em staging) | Alta |

---

## Integração C.2: GitHub — Repositório Remoto

---

### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `github` |
| **Nome de Negócio** | GitHub — Repositório do Projeto |
| **Módulo** | `ycognio` |
| **Tipo de Integração** | REST API (GitHub API v3) via comandos Git executados pelo agente |
| **Direção** | Outbound — Ycognio Bot → GitHub (writes); humanos externos → GitHub (reads diretos) |
| **Sincronicidade** | Síncrono (commit/push bloqueante dentro do processo de checkpoint) |
| **Criticidade** | Alta — único ponto de persistência remota dos artefatos; sem GitHub, trabalho produzido não é entregue ao cliente |
| **SLA do Fornecedor** | GitHub.com: 99.9% uptime declarado (SLA não vinculante para planos free) [A DEFINIR em deploy — confirmar plano] |
| **Link para FR** | FR-PER-01, FR-PER-02, FR-PER-03, FR-PER-07 |
| **Link para Processos** | A.2 (Etapa 3 — checkpoint e encerramento), A.3 (Etapa 3 — commit final de aprovação) |

---

### Propósito de Negócio

Garante que todos os artefatos produzidos na sessão (PRD, ANEXOS, seções fragmentadas, PDF) sejam persistidos remotamente de forma versionada e auditável. O repositório Git é o canal de entrega oficial do PRD para o PO e para os Arquitetos da Ycodify — eles acessam o conteúdo diretamente via navegador ou clone Git, sem precisar entrar no chat. É também o mecanismo de backup e rastreabilidade histórica de toda a elicitação.

---

### Direção e Acessos

| Ator | Direção | Tipo de Acesso |
|------|---------|----------------|
| Ycognio Bot (`ycognio@ycodify.com`) | Outbound (write) | Push de commits — **único** committer autorizado no fluxo automatizado |
| PO do Cliente | Inbound (read externo) | Leitura via browser ou clone — colaborador do repositório privado |
| YC Analyst (Ycodify) | Inbound (read+write externo) | Acesso via conta Ycodify na organização GitHub |
| Arquitetos Receptores (Ycodify) | Inbound (read+write externo) | Membros da organização `ycodify` no GitHub |

**Invariante**:
- INV-C2.1: Ycognio Bot é o ÚNICO identidade que faz commits automatizados — nunca credenciais pessoais de participantes são usadas em operações Git automatizadas (RN-A2.2)
- INV-C2.2: Autoria humana (nick + papel do participante) é registrada na MENSAGEM de commit, não na identidade do committer (RN-A2.3)

---

### Estrutura dos Repositórios

| Elemento | Padrão | Exemplo |
|----------|--------|---------|
| Organização | `ycodify` | `github.com/ycodify` |
| Nome do repositório | `<nomeProjeto>` (normalizado `^[a-z0-9-]+$`) | `ycognio`, `meu-projeto-abc` |
| URL do repositório | `github.com/ycodify/<nomeProjeto>` | `github.com/ycodify/ycognio` |
| Visibilidade | Privado (padrão) | — |
| Branch principal | `main` | — |

> **Nota**: Repositórios são criados manualmente pelo YC Analyst no onboarding do Projeto. O Ycognio não cria repositórios automaticamente — assume repositório pré-existente e acessível pelo Ycognio Bot (Assumption A2 da Seção 3 do PRD).

---

### Operações Realizadas

Todas as operações Git são executadas pelo agente Claude via ferramenta `Bash` do SDK, com o Ycognio Bot como identidade Git configurada no ambiente do servidor.

#### Operação 1: Commit de Checkpoint (Processo A.2)

**Acionado por**: Etapa 3 do checkpoint manual ou encerramento formal

**Sequência de comandos**:
```bash
git -C <project_path> add .
git -C <project_path> commit -m "[YC Analyst: <nick>] checkpoint: <projeto>, sessão <N> — <resumo>"
git -C <project_path> push origin main
```

**Formato da mensagem de commit**:
```
[<papel>: <nick>] checkpoint: <nomeProjeto>, sessão <N> — <resumo do estado atual>
```

**Dados recebidos na resposta**:
- Hash do commit (registrado no log da sessão — FR-PER-03)

---

#### Operação 2: Commit Final de Aprovação (Processo A.3)

**Acionado por**: Etapa 3 da aprovação de PRD

**Sequência de comandos**:
```bash
git -C <project_path> add .
git -C <project_path> commit -m "[PO: <nick> / YC Analyst: <nick>] aprovacao: PRD <projeto> aprovado — versão final commitada"
git -C <project_path> push origin main
```

**Arquivos incluídos** (além dos já presentes): `artifacts/PRD_COMPILED.md`, `artifacts/PRD_<projeto>_<data>.pdf` (se PDF gerado com sucesso)

---

### Autenticação e Credenciais

| Credencial | Tipo | Titular | Onde Armazenar | Rotação |
|------------|------|---------|----------------|---------|
| Credencial de autenticação do Ycognio Bot | SSH Key, PAT ou GitHub App [A DEFINIR em deploy] | Ycodify (service account) | Variável de ambiente segura / Secret Manager [A DEFINIR em deploy] | [A DEFINIR em deploy] |

**Fluxo de autenticação**:
1. Ycognio Bot possui credencial configurada no ambiente do servidor (SSH key ou PAT com escopo `repo`)
2. Configuração Git no servidor: `git config user.name "Ycognio Bot"`, `git config user.email "ycognio@ycodify.com"`
3. Push autenticado via credencial do bot — sem interação com credenciais do participante humano
4. Ycognio Bot é adicionado como colaborador nos repositórios dos Projetos no onboarding

> **Pendência crítica**: Definir método de autenticação — SSH key (recomendado para automação), PAT com escopo mínimo, ou GitHub App (mais seguro para produção). Decisão impacta infraestrutura de deploy.

---

### Política de Falha e Resiliência

**Timeout por operação de push**: 30 segundos

**Retry Policy**:
- **3 tentativas** com intervalo fixo de **30 segundos** entre tentativas
- Retry em: timeout, erro de rede, erro 5xx GitHub API
- Sem retry em: erro de autenticação (401/403), conflito de branch (409)
- Após 3 falhas: registrar erro em log; exibir no chat "Não foi possível salvar os artefatos no repositório Git. Tente checkpoint novamente em instantes." (Exc-1 do Processo A.2)

**Comportamento em Indisponibilidade**:
- Artefatos permanecem no filesystem local do servidor — NÃO são deletados em caso de falha (RN-A2.12)
- Sessão NÃO é marcada como encerrada (`SessaoEncerrada`) enquanto commit não for confirmado (RN-A2.11)
- Sem retry automático após esgotar tentativas — participante aciona novo checkpoint manualmente
- Falha no commit final de aprovação (A.3): `PRDAprovado` já registrado; aprovação não é revertida (RN-A3.14 aplicado analogamente)

**Conflito de Branch**:
- Se `git push` retornar conflito (outro push concorrente): registrar como erro; exibir no chat indicação para o YC Analyst resolver manualmente via terminal
- Sem resolução automática de conflito — requer intervenção humana

---

### Monitoramento

| Métrica | Target | Alerta se |
|---------|--------|-----------|
| Taxa de commits bem-sucedidos | > 98% (TM-02) | < 95% por 24 horas |
| Tempo de checkpoint (comando → confirmação) | < 5 minutos | > 10 minutos em qualquer tentativa |
| Taxa de falhas na GitHub API | < 2% | > 5% por 1 hora |
| Sessões encerradas sem commit | 0% (TM-02) | Qualquer ocorrência — indica bug crítico |

**Eventos de log por operação**:

```json
{
  "timestamp": "2026-04-18T15:00:00.000Z",
  "integration_id": "github",
  "session_id": "f3a1-...",
  "operation": "checkpoint",
  "commit_hash": "a3f9b1c",
  "files_committed": 4,
  "author_nick": "julio",
  "retry_count": 0,
  "error": null
}
```

---

### Rastreabilidade

| Processo (ANEXO A) | Etapa | O Que Acontece |
|-------------------|-------|----------------|
| A.2 — Checkpoint Manual | Etapa 3 | Ycognio Bot push via GitHub API; hash registrado no chat |
| A.2 — Encerramento Formal | Etapa 3 | Commit final de encerramento; `SessaoEncerrada` aguarda confirmação |
| A.3 — Aprovação de PRD | Etapa 3 | Commit com PDF e PRD compilado; hash registrado; `ArtefatoCommitado (aprovacao_final)` |

---

### Pendências de Deploy

| Item | Descrição | Prioridade |
|------|-----------|-----------|
| Método de autenticação | SSH Key vs PAT vs GitHub App — definir antes do deploy | Crítica (bloqueante) |
| Credencial do Ycognio Bot | Criar conta / service account `ycognio@ycodify.com` no GitHub; adicionar como colaborador nos repos | Crítica (bloqueante) |
| Configuração Git no servidor | `user.name`, `user.email`, credencial SSH/PAT disponível no PATH do agente | Crítica (bloqueante) |
| Onboarding de Projeto | Processo de adicionar Ycognio Bot como colaborador ao criar novo Projeto | Alta |
| Branch protection | Definir se `main` tem proteção (force-push bloqueado) — relevante para conflitos | Média |

---

## Integração C.3: Servidor MCP de Email (`ycognio-email-mcp`)

> ⚠️ **STATUS: SUBSTITUIDO — 2026-04-22** (decisão PO — AD-03 reclassificado em backlog review Sprint 4; confirmado 2026-04-23).
>
> **O conteúdo desta seção descreve arquitetura SUBSTITUIDA e NÃO reflete a direção atual.** A exposição de email via protocolo MCP (tool ao agente Claude) foi abandonada em favor de integração direta com **biblioteca `mailsender`** (ecossistema Ycodify interno) via `ycognio-core` módulo `emailsafetynet`. A chamada será síncrona/assíncrona conforme o caso, sem intermediação MCP.
>
> **Razão da substituição**: MCP server adicional aumentaria superfície operacional sem ganho funcional claro para o caso Ycognio (agente Claude não precisa decidir "enviar email?" — a decisão é determinística: pós-aprovação PO → enviar sempre).
>
> **Direção atual**: story futura a ser planejada para `emailsafetynet` consumir lib `mailsender`. Rastreada em `artifacts/sprint-status.yaml` (AD-03 status `SUBSTITUIDO_2026-04-22`).
>
> **Leitores**: pule esta seção para entender o estado real. O conteúdo abaixo é preservado como referência histórica e para rastreabilidade de decisão.

---

### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `emailmcp` |
| **Nome de Negócio** | Servidor MCP de Email — `ycognio-email-mcp` |
| **Módulo** | `ycognio` |
| **Tipo de Integração** | MCP (Model Context Protocol) — ferramenta exposta ao agente Claude via SDK |
| **Direção** | Outbound — Agente (via SDK) → Servidor MCP → Provedor de email → Destinatários |
| **Sincronicidade** | Síncrono do ponto de vista do agente (aguarda confirmação do MCP antes de reportar sucesso) |
| **Criticidade** | Alta — canal oficial de entrega do PRD ao PO e ao Arquiteto Receptor; sem envio do email, o ciclo de aprovação não tem ciência formal dos destinatários e o NPS do Arquiteto Receptor não é acionado |
| **SLA do Fornecedor** | [A DEFINIR em deploy — depende do provedor de email subjacente] |
| **Link para FR** | FR-FBK-02, FR-FBK-03, FR-PER-06 |
| **Link para Processos** | A.3 (Etapa 4 — envio pós-aprovação) |

---

### Propósito de Negócio

Permite que o agente Claude, após a aprovação do PRD pelo PO, envie automaticamente um email ao PO e ao Arquiteto Receptor da Ycodify. O email contém o PDF do PRD como anexo e, no caso do Arquiteto Receptor, inclui o link para o formulário de NPS (F11 — formulário de 4 perguntas: 1 NPS escala 0-10 + 3 complementares qualitativas). Esta integração é o ponto de fechamento formal do ciclo de elicitação: transforma a aprovação registrada no chat em uma entrega tangível e rastreável fora da plataforma.

---

### Protocolo: MCP (Model Context Protocol)

O envio de email **não é feito via SMTP direto nem via chamada REST a um provedor** (ex: SendGrid) pelo backend Ycognio. É uma ferramenta MCP registrada no ambiente do agente Claude. O agente invoca a tool `send_email` (ou equivalente) do servidor `ycognio-email-mcp`, que por sua vez se comunica com o provedor de email subjacente.

Esta arquitetura é intencional (Design Principle 3.1.6 e RN-A3.5): toda lógica de pós-aprovação é executada pelo agente, não pelo sistema web. O sistema apenas despacha o evento `PRDAprovado`.

**Invariante**:
- INV-C3.1: Email é sempre enviado via tool MCP — nunca via SMTP direto ou HTTP ao provedor de email (RN-A3.5)
- INV-C3.2: Envio é acionado automaticamente pelo agente ao detectar `PRDAprovado` — não requer comando manual do participante

---

### Operação: `send_email` (ou equivalente MCP)

#### Payload de Invocação (Agente → MCP Server)

| Campo | Tipo | Obrigatório? | Descrição | Pendência |
|-------|------|--------------|-----------|-----------|
| `from` | string (email) | Sim | Remetente do email | `[A DEFINIR em deploy]` — sugerido `noreply@ycognio.com` ou domínio Ycodify |
| `to` | array de string (email) | Sim | Destinatários: PO + Arquiteto Receptor | Emails configurados por Projeto no onboarding |
| `subject` | string | Sim | Assunto do email | `[A DEFINIR em deploy]` — sugerido `"PRD aprovado: <nomeProjeto> — Ycodify Ycognio"` |
| `body` | string (HTML ou texto) | Sim | Corpo do email | `[A DEFINIR em deploy]` — template a definir |
| `attachment` | base64 ou path | Não | PDF do PRD gerado; ausente se geração do PDF falhou (Exc-1 de A.3) | — |
| `nps_link` | string (URL) | Condicional | Link para formulário NPS F11 — **obrigatório quando destinatário é Arquiteto Receptor** (RN-A3.6) | URL do formulário web `[A DEFINIR em deploy]` |

**Invariantes de payload**:
- INV-C3.3: Email ao Arquiteto Receptor DEVE incluir `nps_link` — sem este link, o BM-04 (taxa de NPS do receptor ≥ 50%) não é atingível (RN-A3.6)
- INV-C3.4: Agente gera dois envios distintos ou um envio com destinatários diferenciados: PO recebe email sem `nps_link`; Arquiteto Receptor recebe com `nps_link`

#### Resposta Esperada (MCP Server → Agente)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `status` | enum | `"sent"` (sucesso) ou `"error"` |
| `message_id` | string | ID do email no provedor (para rastreabilidade) |
| `error_detail` | string (condicional) | Descrição do erro se `status = "error"` |

---

### Autenticação e Configuração

| Credencial | Tipo | Titular | Onde Armazenar | Pendência |
|------------|------|---------|----------------|-----------|
| Credencial do servidor MCP de email | [A DEFINIR em deploy] | Ycodify | [A DEFINIR em deploy] | Definir tipo (API Key, OAuth, SMTP credentials) e cofre |
| Credencial do provedor de email subjacente | [A DEFINIR em deploy] | Ycodify | [A DEFINIR em deploy] | Definir provedor (SendGrid, SES, Mailgun, SMTP próprio) |

**Configuração do servidor MCP**:
- O servidor `ycognio-email-mcp` é registrado no ambiente do agente como MCP server antes do deploy
- Agente acessa via ferramenta nomeada (ex: `ycognio-email-mcp__send_email`) — nome exato `[A DEFINIR em deploy]`
- Configuração análoga ao `rosetta-forger` MCP server já em uso na plataforma Ycodify

> **Pendência crítica**: Toda a configuração desta integração (provedor, credenciais, templates, remetente, nome da tool MCP) é `[A DEFINIR em deploy]`. É a pendência de maior superfície deste ANEXO.

---

### Conteúdo dos Emails (Referência de Negócio)

#### Email ao PO

| Elemento | Conteúdo |
|----------|---------|
| Remetente | `[A DEFINIR em deploy]` |
| Assunto | `[A DEFINIR em deploy]` — deve mencionar nome do projeto e contexto "PRD aprovado" |
| Corpo | `[A DEFINIR em deploy]` — template deve incluir: nome do projeto, data de aprovação, saudação ao PO, instrução sobre o PDF anexo |
| Anexo | PDF do PRD (`artifacts/PRD_<projeto>_<data>.pdf`) — ou link ao repositório Git se PDF falhou (Exc-1 de A.3) |
| Link NPS | Não inclui (NPS do PO é respondido dentro do chat — F9 e F10) |

#### Email ao Arquiteto Receptor

| Elemento | Conteúdo |
|----------|---------|
| Remetente | `[A DEFINIR em deploy]` |
| Assunto | `[A DEFINIR em deploy]` — deve mencionar nome do projeto e "PRD para revisão técnica" |
| Corpo | `[A DEFINIR em deploy]` — template deve incluir: nome do projeto, data de aprovação, instrução sobre o PDF, **link para formulário NPS F11 (4 perguntas: 1 NPS escala 0-10 + 3 complementares qualitativas)** |
| Anexo | Mesmo PDF do PRD |
| Link NPS | **Obrigatório** — URL do formulário web F11 (INV-C3.3) |

**Invariante de conteúdo**:
- INV-C3.5: O template do email deve ser suficientemente descritivo para que o Arquiteto Receptor compreenda o contexto sem ter participado da sessão de elicitação

---

### Política de Falha e Resiliência

**Timeout por operação de envio**: 30 segundos

**Retry Policy**:
- **3 tentativas** com intervalo fixo de **30 segundos** entre tentativas
- Retry em: timeout, erro de rede, erro 5xx do servidor MCP ou do provedor de email
- Sem retry em: erro de autenticação, endereço de email inválido (400)
- Após 3 falhas: registrar erro em log; agente exibe no chat "Email não pôde ser enviado via MCP. O PRD está no repositório Git: `<url_repositorio>`" (Exc-2 do Processo A.3)

**Comportamento em Indisponibilidade**:
- Falha no MCP de email NÃO reverte a aprovação do PRD (`PRDAprovado` já registrado) (RN-A3.14)
- O artefato está no Git independentemente do email — entrega via repositório é o fallback natural
- Sem retry automático após esgotar tentativas — reenvio via novo comando do operador
- NPS do Arquiteto Receptor (F11) não será acionado se email falhar — registrar como risco no log de sessão

---

### Monitoramento

| Métrica | Target | Alerta se |
|---------|--------|-----------|
| Taxa de emails enviados com sucesso | > 95% das aprovações (FR-FBK-02) | < 90% por semana |
| Tempo de envio (aprovação → confirmação MCP) | < 2 minutos | > 5 minutos |
| Taxa de NPS F11 respondido | > 50% (BM-04) | < 30% no mês (indica problema no link ou no template) |
| Falhas de envio sem fallback registrado | 0% | Qualquer ocorrência |

**Eventos de log por operação**:

```json
{
  "timestamp": "2026-04-18T15:10:00.000Z",
  "integration_id": "emailmcp",
  "project_id": "a7b9-...",
  "session_id": "f3a1-...",
  "recipients": ["po@empresa.com", "arquiteto@ycodify.com"],
  "pdf_attached": true,
  "nps_link_included": true,
  "mcp_status": "sent",
  "message_id": "msg-abc123",
  "retry_count": 0,
  "error": null
}
```

---

### Rastreabilidade

| Processo (ANEXO A) | Etapa | O Que Acontece |
|-------------------|-------|----------------|
| A.3 — Aprovação de PRD | Etapa 4 | Agente invoca tool MCP `send_email` com PDF e parâmetros de destinatários |
| A.3 — Fluxo Alternativo Alt-2 | Assíncrono (fora da sessão) | Arquiteto Receptor clica no `nps_link` do email e responde F11 |

---

### Pendências de Deploy

| Item | Descrição | Prioridade |
|------|-----------|-----------|
| Provedor de email | Definir: SendGrid, Amazon SES, Mailgun, SMTP próprio Ycodify | Crítica (bloqueante) |
| Credenciais do servidor MCP | Configurar autenticação do `ycognio-email-mcp` no ambiente do agente | Crítica (bloqueante) |
| Nome da tool MCP | Confirmar nome exato da ferramenta que o agente invoca (ex: `ycognio-email-mcp__send_email`) | Crítica (bloqueante) |
| Remetente | Definir endereço: `noreply@ycognio.com`, `noreply@ycodify.com` ou outro | Alta |
| Templates de email | Criar templates HTML para: (a) email ao PO, (b) email ao Arquiteto Receptor (com NPS link) | Alta |
| URL do formulário NPS F11 | Definir URL onde o Arquiteto Receptor acessa o formulário web de 4 perguntas (1 NPS + 3 complementares qualitativas) | Alta |
| Emails por Projeto | Definir onde/como capturar email do PO e do Arquiteto Receptor no onboarding de cada Projeto | Alta |
| Registro de domínio SPF/DKIM | Configurar para evitar que emails caiam em spam | Média |

---

## Dependências entre Integrações

```
Processo A.3 — Aprovação de PRD
  1. [C.1] Claude Agent SDK executa compile-prd.sh e pandoc → gera PDF
       ↓ (artefatos prontos no filesystem)
  2. [C.2] Ycognio Bot push via GitHub → commit de aprovação
       ↓ (hash confirmado — ArtefatoCommitado)
  3. [C.3] Agente invoca MCP send_email → email com PDF enviado ao PO e ao Arquiteto Receptor
```

**Regra de dependência**:
- INV-C.DEP.1: O email (C.3) só é enviado após o commit (C.2) ser confirmado — garante que o repositório já tem o estado final antes de notificar os destinatários
- INV-C.DEP.2: Falha no PDF (C.1) degrada o email (C.3) — anexo ausente, substituído por link ao Git — mas não impede o envio
- INV-C.DEP.3: Falha no commit (C.2) bloqueia o email (C.3) — sem commit confirmado, processo de aprovação não avança

---

## Rastreabilidade Consolidada

| Integração | Processos (ANEXO A) | FRs (Seção 8) | NFRs (Seção 9) |
|-----------|---------------------|---------------|----------------|
| C.1 — Claude Agent SDK | A.1 (Etapas 2-3), A.2 (Etapa 2), A.3 (Etapas 2, 4) | FR-CHT-01 a 05, FR-VIS-01, FR-VIS-02, FR-PER-01, FR-FBK-02 | NFR-BM-01 (primeiro token < 5s), NFR-TM-03 (broadcast ≤ 2s) |
| C.2 — GitHub | A.2 (Etapa 3), A.3 (Etapa 3) | FR-PER-01, FR-PER-02, FR-PER-03 | NFR-TM-02 (100% sessões com commit) |
| C.3 — MCP Email | A.3 (Etapa 4) | FR-FBK-02, FR-FBK-03 | NFR-BM-04 (NPS receptor ≥ 50%) |

---

## Checklist de Completude

- [x] C.1 (Claude Agent SDK): propósito, payload, autenticação, streaming, política de falha, monitoramento
- [x] C.2 (GitHub): propósito, operações Git, autenticação, política de falha, monitoramento
- [x] C.3 (MCP Email): propósito, protocolo MCP, payload send_email, política de falha, monitoramento
- [x] Invariantes de integração documentadas (INV-C1.1 a C.DEP.3)
- [x] Pendências de deploy mapeadas por integração
- [x] Rastreabilidade com ANEXO A (processos) e Seção 8 (FRs)
- [x] Dependências de ordem entre integrações documentadas

---

**Versão**: 1.0
**Data**: 2026-04-18
**Responsável**: Analista de Negócio (Sofia)
**Consumidores**: Arquiteto de Integrações (para gerar `spec_integracoes.json` — OpenAPI + políticas de resiliência)
