---
document: "ANEXO_A_ProcessDetails"
project: "ycognio"
responsible: "BA (Analista de Negócio)"
created_at: "2026-04-18"
prd_mode: "fragmented"
status: "completed"
last_updated: "2026-04-18"
ve_note: "VE-1: 9 ocorrências de 'até 5 questões' corrigidas para '4 perguntas (1 NPS 0-10 + 3 complementares qualitativas)' — decisão C-02"
processes:
  - conversacaochat
  - checkpointencerramento
  - aprovacaoprd
---

# ANEXO A: Process Details — Ycognio — Webchat de Elicitação Assistida

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Detalhar os três processos nucleares do MVP — como o sistema executa operacionalmente cada fluxo, quais atores participam, quais regras se aplicam e quais eventos são gerados
> **Consumidores**: Arquiteto de Processos (gera `spec_processos.json` — BPMN 2.0)

**Rastreabilidade**: Este anexo está alinhado com os termos do `UBIQUITOUS_LANGUAGE.yaml` v1.2.1 e referencia FRs da Seção 8 e Jornadas da Seção 4.

---

## Processo A.1: Conversação no Chat

---

### Metadados do Processo

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `conversacaochat` |
| **Nome de Negócio** | Conversação no Chat |
| **Módulo** | `ycognio` |
| **Tipo** | Semi-automático (humano + agentes IA em loop contínuo) |
| **Frequência** | Toda sessão ativa — processo central do produto |
| **Tempo Médio** | 30 a 180 minutos por sessão |
| **SLA** | Resposta do agente: primeiro token em < 5s; broadcast de mensagem a todos os participantes: p99 ≤ 2s |
| **Responsável Principal** | PO do Cliente (interlocutor da IA) + Analista Ycodify (facilitador/invocador) |
| **Link para FR** | FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-VIS-01, FR-VIS-02, FR-TEL-01, FR-TEL-02 |
| **Link para Journey** | A.1, A.2, B.1, C.1 |

---

### Objetivo do Processo

Viabilizar a troca de mensagens entre participantes humanos e agentes Claude dentro de uma sessão ativa, garantindo que mensagens de PO e YC Analyst sejam encaminhadas ao Claude Agent SDK e que mensagens de Guest fiquem visíveis no chat sem acionar os agentes. O processo é o coração da elicitação — é onde o PRD é construído.

---

### Participantes (Atores)

| Ator | Papel | Responsabilidades no Processo |
|------|-------|-------------------------------|
| `po` | PO do Cliente | Responder perguntas de elicitação; validar escopo; invocar agentes via @mention se necessário |
| `ycanalyst` | Analista Ycodify | Facilitar conversa; reformular perguntas da IA; prover profundidade técnica; invocar agentes por demanda; monitorar qualidade da elicitação |
| `guest` | Guest (Observador) | Observar sessão; digitar no chat para comunicação com outros humanos (sem acionar IA) |
| `sistema` | Sistema Ycognio (backend) | Rotear mensagens por papel; encaminhar ao Claude Agent SDK; transmitir respostas em streaming; registrar eventos de telemetria |
| `agente` | Agentes Claude (via SDK) | Conduzir elicitação; gerar perguntas; escrever artefatos; responder invocações diretas |

---

### Pré-condições

- Sessão ativa criada no Projeto (SessaoIniciada)
- Participante entrou na sala com nick e papel selecionado (ParticipanteEntrouNaSala)
- `project_path` configurado no backend (pré-condição de toda sessão — Assumption A3 da Seção 3)
- Repositório Git pré-existente acessível pelo Ycognio Bot
- Link de Acesso com TTL vigente (não expirado)
- Claude Agent SDK disponível e com chave de API válida

---

### Pós-condições (Sucesso)

- Mensagens de PO e YC Analyst foram processadas pelos agentes e respostas exibidas no chat
- Artefatos PRD atualizados no filesystem do Projeto (conforme agentes geraram conteúdo)
- Eventos de telemetria registrados (`user_typing_start`, `user_message_sent`, `ai_response_complete`) por ciclo completo
- Mensagens de Guest exibidas no chat sem gerar eventos de encaminhamento à IA
- Estado da sessão atualizado com último timestamp de atividade

---

### Fluxo Principal (Happy Path)

#### Etapa 1: Participante envia mensagem

**Ator**: PO do Cliente (ou YC Analyst)

**Ação**:
1. Participante digita mensagem no campo de texto do chat
2. Sistema registra evento `user_typing_start` (com session_id, participant_id, timestamp)
3. Participante pressiona Enter ou botão de envio

**Sistema Responde**:
- Valida que o campo de texto não está vazio
- Transmite mensagem a todos os participantes conectados via broadcast (p99 ≤ 2s — TM-03)
- Registra evento `user_message_sent` (com session_id, participant_id, role, timestamp, message_id)
- Verifica papel do remetente (Roteamento de Mensagens por Papel — F21):
  - Se `role = po` ou `role = ycanalyst`: encaminha ao pipeline do Claude Agent SDK (próxima etapa)
  - Se `role = guest`: NÃO encaminha; processo encerra aqui para esta mensagem (ver Fluxo Alternativo Alt-1)

**Próximo Estado**: mensagem visível para todos; pipeline de agentes aguarda processamento (para PO/YC Analyst)

**Tempo Estimado**: < 2s (broadcast)

**Regras de Negócio**:
- RN-A1.1: Mensagens de Guest são visíveis no chat mas NÃO são consumidas pela IA — regra arquitetural invariante (Design Principle 3.1.6 / F21)
- RN-A1.2: Mensagem vazia não é enviada — validação no frontend antes de dispatch

---

#### Etapa 2: Sistema encaminha mensagem ao Claude Agent SDK

**Ator**: Sistema Ycognio (backend)

**Ação**:
- Backend empacota contexto da sessão: `session_id`, `project_path`, `participant_role`, `message_content`, histórico resumido
- Invoca Claude Agent SDK com `working_dir = project_path`
- SDK inicia processamento pelo agente ativo (ex: `@orquestrador-pm` por padrão, ou agente invocado via @mention)

**Sistema Responde**:
- Abre stream de resposta do SDK
- Inicia exibição progressiva de tokens no chat (streaming — F5)
- Exibe indicador visual de "agente respondendo" para todos os participantes

**Tempo Estimado**: primeiro token em < 5s (SLA)

**Regras de Negócio**:
- RN-A1.3: Se SDK retornar erro ou timeout, mensagem de PO/YC Analyst entra em fila de espera com indicador visual "aguardando agente" — não é descartada silenciosamente (ver Fluxo de Exceção Exc-1)
- RN-A1.4: O `working_dir` passado ao SDK é sempre o `project_path` do Projeto — nunca sobreposto pelo webchat (Design Principle 3.1.6)

---

#### Etapa 3: Agente responde em streaming

**Ator**: Agentes Claude (via SDK)

**Ação**:
- Agente processa mensagem com contexto da sessão
- Gera resposta em tokens progressivos via streaming
- Durante execução, pode ler/escrever artefatos no filesystem do Projeto (transparente para o chat)

**Sistema Responde**:
- Transmite tokens progressivamente a todos os participantes conectados (exibição em tempo real)
- Badge/prefixo identifica visualmente qual agente está respondendo (FR-VIS-01)
- Participantes com papel PO e YC Analyst veem a resposta construída token a token

**Próximo Estado**: resposta do agente completa e visível no chat

**Tempo Estimado**: variável (depende da complexidade da resposta do agente)

**Regras de Negócio**:
- RN-A1.5: Cada bolha de resposta exibe identificação visual do agente (nome/badge) — obrigatório para que PO entenda quem respondeu

---

#### Etapa 4: Sistema registra conclusão e prepara próximo ciclo

**Ator**: Sistema Ycognio (backend)

**Ação**:
- Detecta fim do streaming do SDK
- Registra evento `ai_response_complete` (com session_id, agent_name, message_id, timestamp)
- Atualiza timestamp de última atividade da sessão

**Sistema Responde**:
- Remove indicador "agente respondendo"
- Campo de texto do chat fica habilitado para nova mensagem
- Painel do PRD em Construção (F14) reflete eventuais artefatos atualizados pelo agente

**Próximo Estado**: chat pronto para próximo ciclo de mensagem

**Tempo Estimado**: < 500ms

---

### Fluxos Alternativos

---

#### Alt-1: Mensagem enviada por Guest

**Quando**: Participante com papel `guest` envia mensagem no chat

**Etapa 1 (alternativa)**:

**Ator**: Guest

**Ação**:
1. Guest digita e envia mensagem

**Sistema Responde**:
- Transmite mensagem a todos os participantes via broadcast (mesma exibição visual)
- NÃO registra evento `ai_request_sent` nos logs
- NÃO encaminha ao Claude Agent SDK
- NÃO gera resposta de agente

**Próximo Estado**: mensagem visível para humanos; IA permanece no estado anterior

**Regras de Negócio**:
- RN-A1.6: Ausência de evento `ai_request_sent` após `user_message_sent` com `role=guest` é o critério verificável de conformidade (FR-CHT-03)

---

#### Alt-2: Invocação direta de agente via @mention

**Quando**: PO ou YC Analyst envia mensagem com `@nome-do-agente` (F4)

**Etapa 1-2 (alternativa)**:

**Ator**: PO ou YC Analyst

**Ação**:
1. Participante digita `@sofia Qual o próximo passo?` (ou qualquer agente disponível em `.claude/agents/`)

**Sistema Responde**:
- Detecta padrão `@nome-do-agente` no início da mensagem
- Roteia ao agente específico em vez do agente ativo padrão
- Resposta é gerada pelo agente invocado explicitamente
- Badge da resposta identifica o agente invocado pelo nome

**Próximo Estado**: agente específico respondeu; fluxo retorna ao normal

**Regras de Negócio**:
- RN-A1.7: Apenas PO e YC Analyst podem invocar agentes via @mention — Guest não tem esta permissão (F21 / FR-CHT-04)
- RN-A1.8: Agente invocado deve existir em `.claude/agents/` do Projeto — se não existir, SDK retorna erro tratado pelo sistema (ver Exc-2)

---

#### Alt-3: PO acessa Painel do PRD em Construção

**Quando**: PO ou YC Analyst deseja visualizar o PRD em construção sem interromper o chat (F14)

**Paralelo à conversação**:

**Ator**: PO ou YC Analyst

**Ação**:
1. Participante aciona botão "Ver PRD" (ou aba/painel equivalente)

**Sistema Responde**:
- Abre painel dedicado separado do canal de mensagens
- Exibe conteúdo atual do PRD em construção (leitura do filesystem do Projeto)
- Chat permanece ativo em paralelo; participante pode alternar entre painel e chat

**Próximo Estado**: painel visível sem interromper conversa

**Regras de Negócio**:
- RN-A1.9: Painel do PRD é somente-leitura para participantes — escrita é exclusiva dos agentes via SDK

---

### Fluxos de Exceção

---

#### Exc-1: Claude Agent SDK indisponível ou timeout

**Quando**: Sistema tenta encaminhar mensagem ao SDK mas recebe erro de conexão ou timeout (> 30s sem primeiro token)

**Etapa 2 (exceção)**:

**Sistema Responde**:
- Exibe indicador visual "aguardando agente" no chat para o participante
- Mantém mensagem em fila de espera (não descarta)
- Tenta reconexão ao SDK em intervalos de 10s (máximo 3 tentativas)
- Se todas as tentativas falharem: exibe mensagem no chat "Agente temporariamente indisponível. Tente novamente." e remove da fila

**Próximo Estado**: sessão ativa; mensagem não processada; participante pode reenviar

**Regras de Negócio**:
- RN-A1.10: Falha no SDK NÃO encerra a sessão — apenas interrompe processamento da mensagem específica

---

#### Exc-2: Agente invocado via @mention não existe

**Quando**: Participante invoca `@agente-inexistente` que não está em `.claude/agents/`

**Sistema Responde**:
- SDK retorna erro de agente não encontrado
- Sistema exibe mensagem no chat: "Agente '@agente-inexistente' não encontrado neste projeto."
- Sem geração de resposta

**Próximo Estado**: chat aguarda nova mensagem do participante

---

#### Exc-3: Link de Acesso expirado durante sessão ativa

**Quando**: TTL do Link de Acesso expira enquanto participante está na sala

**Sistema Responde**:
- Bloqueia novos participantes de entrar via link expirado
- Participantes já conectados: NÃO são desconectados imediatamente — sessão continua ativa para quem já está na sala
- Exibe aviso visual (banner/notificação) para participantes ativos: "O link de acesso expirou. Novos participantes não podem mais entrar."
- Registra evento `LinkExpirado`

**Próximo Estado**: sessão continua para participantes já conectados; link bloqueado para novos entrantes

**Regras de Negócio**:
- RN-A1.11: Expiração de TTL bloqueia entradas, não desconecta ativos — comportamento de segurança sem penalizar sessão em curso (FR-ACC-04)

---

### Regras de Negócio Específicas

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| RN-A1.1 | Isolamento de mensagens Guest | Mensagens de Guest são visíveis no chat mas jamais encaminhadas à IA | Obrigatória |
| RN-A1.2 | Mensagem vazia bloqueada | Campo de texto vazio não dispara envio | Obrigatória |
| RN-A1.3 | Fila de espera SDK | Mensagem de PO/YC Analyst não é descartada silenciosamente em caso de indisponibilidade do SDK | Obrigatória |
| RN-A1.4 | working_dir imutável | O webchat não pode sobrepor o `project_path` passado ao SDK | Obrigatória |
| RN-A1.5 | Identificação visual do agente | Toda resposta de agente exibe badge com nome do agente respondente | Obrigatória |
| RN-A1.6 | Ausência de ai_request_sent para Guest | Verificável via log de eventos — critério de conformidade FR-CHT-03 | Obrigatória |
| RN-A1.7 | @mention exclusivo de PO/YC Analyst | Guest não pode invocar agentes diretamente | Obrigatória |
| RN-A1.8 | Agente @mention deve existir | Agente invocado deve estar em `.claude/agents/` do Projeto | Obrigatória |
| RN-A1.9 | Painel PRD somente-leitura | Participantes não escrevem no PRD diretamente — escrita é dos agentes | Obrigatória |
| RN-A1.10 | Falha SDK não encerra sessão | Indisponibilidade do SDK não mata a sessão — apenas suspende processamento da mensagem | Obrigatória |
| RN-A1.11 | TTL expira entradas, não desconecta ativos | Participantes já conectados não são ejetados por expiração de TTL | Obrigatória |

---

### Eventos de Negócio Gerados

| Evento | ID Técnico | Quando Ocorre | Payload |
|--------|------------|---------------|---------|
| Mensagem Enviada | `MensagemEnviada` | Participante envia mensagem (qualquer papel) | `{session_id, participant_id, role, message_id, timestamp}` |
| Mensagem Encaminhada aos Agentes | `MensagemEncaminhadaAgentes` | Mensagem de PO ou YC Analyst encaminhada ao SDK | `{session_id, message_id, agent_target, timestamp}` |
| Resposta de Agente Completa | `RespostaAgenteCompleta` | Streaming do agente encerrado | `{session_id, agent_name, message_id, timestamp}` |
| Link Expirado | `LinkExpirado` | TTL do Link de Acesso atinge zero | `{link_id, expired_at}` |

---

### Diagrama BPMN Narrativo

```
[START] Participante com sessão ativa envia mensagem

→ [TASK: Validar mensagem não vazia]
  ↓ (vazia)
  → [END: Bloquear envio — exibir erro inline]

  ↓ (não vazia)
→ [TASK: Broadcast mensagem a todos os participantes]
→ [EVENT: MensagemEnviada]
→ [TASK: Registrar evento user_message_sent com telemetria]

→ [GATEWAY Exclusive: Papel do remetente?]

  ↓ BRANCH 1: Guest
  → [END: Mensagem exibida — sem encaminhamento à IA]

  ↓ BRANCH 2: PO ou YC Analyst (sem @mention)
  → [TASK: Encaminhar ao Claude Agent SDK (agente ativo padrão)]
  → [EVENT: MensagemEncaminhadaAgentes]
  → [TASK: Exibir indicador "agente respondendo"]
  → [GATEWAY Exclusive: SDK disponível?]

    ↓ SDK indisponível
    → [TASK: Colocar em fila; tentar 3x em intervalos 10s]
      ↓ (3 falhas)
      → [TASK: Exibir "Agente temporariamente indisponível"]
      → [END: Mensagem não processada — participante pode reenviar]

    ↓ SDK disponível
    → [TASK: Receber e transmitir tokens em streaming]
    → [TASK: Exibir badge do agente respondente]
    → [TASK: Registrar evento ai_response_complete]
    → [EVENT: RespostaAgenteCompleta]
    → [TASK: Atualizar timestamp de atividade da sessão]
    → [END: Ciclo de mensagem concluído]

  ↓ BRANCH 3: PO ou YC Analyst (com @mention)
  → [TASK: Detectar padrão @nome-do-agente]
  → [GATEWAY Exclusive: Agente existe em .claude/agents/?]

    ↓ Não existe
    → [TASK: Exibir "Agente não encontrado"]
    → [END]

    ↓ Existe
    → [Continua em BRANCH 2 com agente específico em vez do padrão]
```

---

### Integrações com Sistemas Externos

| Sistema | Quando Chamado | Dados Enviados | Dados Recebidos | Timeout | Retry Policy |
|---------|----------------|----------------|-----------------|---------|--------------|
| Claude Agent SDK | Etapa 2 (toda mensagem de PO/YC Analyst) | `{project_path, session_id, message_content, role, context_summary}` | Streaming de tokens (resposta do agente) | 30s sem primeiro token | 3 tentativas (10s intervalo); após falhar, mensagem marcada como não processada |

---

### Métricas e Monitoramento

| Métrica | Target | Como Medir |
|---------|--------|------------|
| Latência de broadcast | p99 ≤ 2s | Eventos `user_message_sent` → renderização no cliente B (TM-03) |
| Primeiro token do agente | < 5s | Delta entre `MensagemEncaminhadaAgentes` e primeiro token recebido (BM-01) |
| Taxa de mensagens de Guest sem encaminhamento | 100% | Ausência de `ai_request_sent` após `user_message_sent` com `role=guest` (FR-CHT-03) |
| Taxa de respostas de agente com badge identificado | 100% | Teste E2E verifica atributo `data-agent-name` em bolhas de resposta (FR-VIS-01) |

---

## Processo A.2: Checkpoint e Encerramento

---

### Metadados do Processo

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `checkpointencerramento` |
| **Nome de Negócio** | Checkpoint e Encerramento de Sessão |
| **Módulo** | `ycognio` |
| **Tipo** | Semi-automático (ação humana dispara execução automática do agente + commit Git) |
| **Frequência** | 1 a N vezes por sessão (checkpoint pode ser acionado múltiplas vezes; encerramento é único por sessão) |
| **Tempo Médio** | 2 a 5 minutos (do comando ao commit confirmado) |
| **SLA** | Artefatos commitados em 100% das sessões encerradas (TM-02) |
| **Responsável Principal** | YC Analyst (pode acionar checkpoint/encerramento); PO do Cliente (pode acionar encerramento) |
| **Link para FR** | FR-PER-01, FR-PER-02, FR-PER-03, FR-FBK-01 |
| **Link para Journey** | A.1, A.2, B.1 |

---

### Objetivo do Processo

Garantir que o trabalho produzido durante uma sessão seja persistido no repositório Git via commit do Ycognio Bot, seja por checkpoint intermediário (sem encerrar sessão) ou por encerramento formal. O encerramento também protege contra perda acidental de trabalho ao exigir confirmação antes de fechar — e aciona o NPS pós-sessão do PO ao final.

---

### Participantes (Atores)

| Ator | Papel | Responsabilidades no Processo |
|------|-------|-------------------------------|
| `po` | PO do Cliente | Pode acionar encerramento de sessão; responde NPS pós-sessão |
| `ycanalyst` | Analista Ycodify | Pode acionar checkpoint e encerramento; é o responsável principal pela persistência |
| `sistema` | Sistema Ycognio (backend) | Detectar acionamento; interceptar tentativa de fechar sem checkpoint; executar commit via GitHub API |
| `agente` | Agentes Claude (via SDK — `@orquestrador-pm`) | Consolidar estado dos artefatos; gerar mensagem de commit; orquestrar o encerramento |
| `ycogniobot` | Ycognio Bot | Executar o commit Git no repositório do Projeto (`ycognio@ycodify.com`) |

---

### Pré-condições

- Sessão ativa (SessaoIniciada)
- Participante com papel `po` ou `ycanalyst` presente na sala
- Ao menos 1 artefato gerado na sessão (condição ideal; commit vazio é permitido mas registrado como alerta)
- Repositório Git do Projeto acessível via GitHub API (Assumption A2 da Seção 3)
- Token do Ycognio Bot configurado no backend

---

### Pós-condições (Sucesso)

- Artefatos da sessão commitados no repositório Git (ArtefatoCommitado)
- Sessão marcada como encerrada (SessaoEncerrada) no caso de encerramento formal
- Hash do commit registrado no log da sessão
- NPS pós-sessão exibido ao PO (se encerramento formal — FR-FBK-01)
- Participantes informados do encerramento via mensagem no chat

---

### Fluxo Principal (Happy Path) — Checkpoint Manual

#### Etapa 1: YC Analyst solicita checkpoint

**Ator**: Analista Ycodify

**Ação**:
1. YC Analyst envia mensagem no chat: `@orquestrador-pm checkpoint` (ou formulação equivalente)

**Sistema Responde**:
- Registra evento `CheckpointSolicitado`
- Encaminha ao Claude Agent SDK com sinal de checkpoint
- Exibe indicador "Checkpoint em andamento..."

**Próximo Estado**: agente processando consolidação dos artefatos

**Regras de Negócio**:
- RN-A2.1: Checkpoint pode ser acionado a qualquer momento durante a sessão — não interrompe sessão ativa

---

#### Etapa 2: Agente consolida artefatos

**Ator**: Agente Claude (`@orquestrador-pm`)

**Ação**:
- Agente verifica estado atual de todos os artefatos no filesystem do Projeto (`project_path`)
- Confirma quais arquivos foram modificados desde o último commit
- Gera mensagem de commit descritiva com autoria rastreável

**Formato da mensagem de commit**:
```
[YC Analyst: <nick>] checkpoint: <projeto>, sessão <N> — <resumo do estado atual>
```

**Sistema Responde**:
- Prepara lista de arquivos a commitar
- Invoca GitHub API via Ycognio Bot

**Tempo Estimado**: 30 a 60 segundos

---

#### Etapa 3: Ycognio Bot realiza commit no repositório

**Ator**: Ycognio Bot (`ycognio@ycodify.com`)

**Ação**:
- Executa `git add`, `git commit`, `git push` via GitHub API
- Identidade do committer: `Ycognio Bot <ycognio@ycodify.com>`
- Autoria humana rastreada na mensagem de commit (não na identidade do committer)

**Sistema Responde**:
- Recebe hash do commit da GitHub API
- Registra hash no log da sessão
- Exibe no chat: "Checkpoint realizado. Commit: `<hash_curto>`"
- Registra evento `ArtefatoCommitado`

**Próximo Estado**: artefatos persistidos; sessão continua ativa

**Regras de Negócio**:
- RN-A2.2: Ycognio Bot é a ÚNICA identidade que faz commits — nunca credenciais pessoais de participantes (Seção 3.1.3(c))
- RN-A2.3: Autoria humana é rastreada na MENSAGEM de commit, não na identidade do committer
- RN-A2.4: Hash do commit deve ser registrado no log — é o mecanismo de auditoria (FR-PER-03)

---

### Fluxo Principal (Happy Path) — Encerramento Formal

#### Etapa 1: Participante aciona encerramento

**Ator**: PO do Cliente ou YC Analyst

**Via A — Comando via chat**:
1. Participante envia `@orquestrador-pm encerrar sessão` (ou formulação equivalente)

**Via B — Botão "Encerrar" na interface**:
1. Participante clica no botão "Encerrar" da sala

**Sistema Responde (para Via B)**:
- **Intercepta clique no botão** antes de executar
- Verifica se houve checkpoint desde a última modificação de artefato
- **Se NÃO houve checkpoint**: exibe modal de confirmação com aviso (ver Fluxo Alternativo Alt-1)
- **Se houve checkpoint recente**: exibe modal simples de confirmação de encerramento

**Regras de Negócio**:
- RN-A2.5: O botão "Encerrar" NUNCA encerra a sessão diretamente sem confirmação — há sempre um guard de confirmação
- RN-A2.6: Se houver trabalho sem checkpoint, o guard alerta explicitamente o participante antes de prosseguir

---

#### Etapa 2: Agente consolida e prepara encerramento

**Ator**: Agente Claude (`@orquestrador-pm`)

**Ação**:
- Consolida estado final dos artefatos
- Gera mensagem de commit de encerramento:
  ```
  [PO: <nick> / YC Analyst: <nick>] encerramento: <projeto>, sessão <N> — <resumo final>
  ```
- Atualiza metadata de sessão (data/hora de encerramento, duração)

**Sistema Responde**:
- Invoca Ycognio Bot para commit final

---

#### Etapa 3: Ycognio Bot commita estado final

**Ator**: Ycognio Bot

**Ação**: Idêntica ao checkpoint (Etapa 3 do Checkpoint Manual), com mensagem de commit de encerramento

**Sistema Responde**:
- Hash do commit registrado
- Evento `ArtefatoCommitado` registrado
- Prossegue para encerramento formal da sessão

---

#### Etapa 4: Sistema encerra sessão

**Ator**: Sistema Ycognio (backend)

**Ação**:
- Marca sessão como encerrada no banco
- Registra timestamp de encerramento
- Registra duração total da sessão

**Sistema Responde**:
- Evento `SessaoEncerrada` registrado
- Exibe no chat: "Sessão encerrada. Artefatos commitados: `<hash_curto>`"
- Se papel `po` presente: exibe **NPS pós-sessão** (FR-FBK-01): *"De 0 a 10, como você avalia a clareza da condução desta sessão?"* (ver Fluxo Alternativo Alt-2 para NPS)

**Próximo Estado**: sessão encerrada; artefatos no Git; sala pode ser visualizada mas não mais interativa

---

### Fluxos Alternativos

---

#### Alt-1: Encerramento via botão sem checkpoint prévio

**Quando**: Participante clica "Encerrar" sem ter feito checkpoint desde última modificação de artefato

**Etapa 1 (alternativa)**:

**Sistema Responde**:
- Exibe modal com aviso: "Você tem trabalho não salvo nesta sessão. Deseja fazer checkpoint antes de encerrar?"
- Opções no modal:
  - **"Salvar e encerrar"**: executa checkpoint + encerramento em sequência (fluxo normal)
  - **"Encerrar sem salvar"**: encerra sessão sem commit (perda de trabalho — requer confirmação adicional "Tem certeza?")
  - **"Cancelar"**: fecha modal, sessão continua ativa

**Regras de Negócio**:
- RN-A2.7: "Encerrar sem salvar" requer dupla confirmação (modal + confirmação secundária) — protege contra clique acidental
- RN-A2.8: O ato de "Encerrar sem salvar" é registrado em log com participante e timestamp para auditoria

---

#### Alt-2: NPS pós-sessão respondido pelo PO

**Quando**: Sessão encerrada com PO presente na sala (FR-FBK-01)

**Etapa 4 (alternativa — após encerramento)**:

**Sistema Responde**:
- Exibe modal/overlay com NPS: *"De 0 a 10, como você avalia a clareza da condução desta sessão de elicitação?"*
- Escala 0-10 clicável (NPS padrão)
- Campo opcional de comentário livre
- Botão "Enviar" e link "Pular" (NPS é Should-Have — não bloqueia encerramento)

**PO**:
1. Seleciona nota 0-10
2. (Opcional) Preenche comentário
3. Clica "Enviar"

**Sistema Responde**:
- Registra resposta de NPS com `session_id`, `participant_role=po`, `score`, `comment`, `timestamp`
- Evento `FeedbackRespondido` registrado
- Fecha modal; sala exibe estado de sessão encerrada

**Regras de Negócio**:
- RN-A2.9: NPS pós-sessão é exibido ao PO — NÃO ao YC Analyst nem ao Guest
- RN-A2.10: Pular o NPS é permitido — não bloqueia fluxo de encerramento

---

### Fluxos de Exceção

---

#### Exc-1: Falha na GitHub API durante commit

**Quando**: Ycognio Bot tenta executar commit mas GitHub API retorna erro (4xx/5xx ou timeout)

**Etapa 3 (exceção)**:

**Sistema Responde**:
- Registra erro em log: "Commit falhou para sessão `<session_id>`: `<erro_github>`"
- Tenta novamente: 3 tentativas com intervalo de 30s
- Se todas falharem:
  - Exibe no chat: "Não foi possível salvar os artefatos no repositório Git. Tente checkpoint novamente em instantes."
  - Artefatos permanecem no filesystem local (não perdidos)
  - Sessão NÃO é marcada como encerrada até commit bem-sucedido

**Próximo Estado**: artefatos locais íntegros; commit pendente; sessão aguarda retentativa

**Regras de Negócio**:
- RN-A2.11: Sessão não é encerrada formalmente (SessaoEncerrada) enquanto commit não for confirmado
- RN-A2.12: Falha na GitHub API NÃO destrói artefatos locais — filesystem do Projeto é a fonte primária durante falha

---

### Regras de Negócio Específicas

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| RN-A2.1 | Checkpoint não encerra sessão | Checkpoint persiste trabalho mas mantém sessão ativa | Obrigatória |
| RN-A2.2 | Ycognio Bot é o único committer | Nenhuma credencial pessoal de participante é usada em operações Git | Obrigatória |
| RN-A2.3 | Autoria na mensagem de commit | Autoria humana (nick + papel) rastreada na mensagem, não na identidade do committer | Obrigatória |
| RN-A2.4 | Hash do commit registrado | Todo commit tem hash registrado em log da sessão para auditoria | Obrigatória |
| RN-A2.5 | Guard obrigatório no botão "Encerrar" | Botão nunca age diretamente — sempre exibe confirmação primeiro | Obrigatória |
| RN-A2.6 | Alerta de trabalho sem checkpoint | Guard informa explicitamente sobre trabalho não salvo antes de encerrar | Obrigatória |
| RN-A2.7 | Dupla confirmação para "Encerrar sem salvar" | Ação destrutiva exige confirmação dupla | Obrigatória |
| RN-A2.8 | Log de "Encerrar sem salvar" | Ação é auditada com participante e timestamp | Obrigatória |
| RN-A2.9 | NPS apenas para PO | NPS pós-sessão exibido exclusivamente ao PO — não ao YC Analyst nem Guest | Obrigatória |
| RN-A2.10 | NPS não bloqueia encerramento | PO pode pular NPS; encerramento prossegue | Obrigatória |
| RN-A2.11 | Sessão não encerrada sem commit | SessaoEncerrada só é registrado após commit bem-sucedido | Obrigatória |
| RN-A2.12 | Filesystem local preservado em falha Git | Artefatos locais não são deletados em caso de falha na GitHub API | Obrigatória |

---

### Eventos de Negócio Gerados

| Evento | ID Técnico | Quando Ocorre | Payload |
|--------|------------|---------------|---------|
| Checkpoint Solicitado | `CheckpointSolicitado` | YC Analyst ou PO aciona checkpoint | `{session_id, participant_id, role, timestamp}` |
| Artefato Commitado | `ArtefatoCommitado` | Ycognio Bot completa commit com sucesso | `{session_id, commit_hash, files_committed, author_nick, timestamp}` |
| Sessão Encerrada | `SessaoEncerrada` | Sistema marca sessão como encerrada após commit final | `{session_id, project_id, duration_minutes, commit_hash, timestamp}` |
| Feedback Respondido | `FeedbackRespondido` | PO submete NPS pós-sessão | `{session_id, participant_role, nps_score, comment, timestamp}` |

---

### Diagrama BPMN Narrativo

```
[START A — Checkpoint Manual]
Participante envia "@orquestrador-pm checkpoint"

→ [EVENT: CheckpointSolicitado]
→ [TASK: Agente consolida artefatos modificados]
→ [TASK: Gerar mensagem de commit rastreável]
→ [TASK: Ycognio Bot executa commit via GitHub API]
  ↓ (falha)
  → [TASK: Tentar novamente 3x (30s intervalo)]
    ↓ (3 falhas)
    → [TASK: Exibir erro no chat; artefatos locais preservados]
    → [END: Commit pendente — sessão ativa]

  ↓ (sucesso)
→ [EVENT: ArtefatoCommitado]
→ [TASK: Exibir hash do commit no chat]
→ [END: Checkpoint concluído — sessão continua ativa]

---

[START B — Encerramento via chat]
Participante envia "@orquestrador-pm encerrar sessão"
→ Continua em [TASK: Agente consolida] acima; após ArtefatoCommitado:
→ [TASK: Marcar sessão como encerrada]
→ [EVENT: SessaoEncerrada]
→ Continua em [GATEWAY: PO presente?] abaixo

[START C — Encerramento via botão]
Participante clica botão "Encerrar"
→ [GATEWAY Exclusive: Há trabalho sem checkpoint?]

  ↓ Não há
  → [TASK: Exibir modal de confirmação simples]
  → [GATEWAY Exclusive: Confirmou?]
    ↓ Não → [END: Modal fechado, sessão ativa]
    ↓ Sim → [Continua em Consolidação igual ao START B]

  ↓ Há trabalho sem checkpoint
  → [TASK: Exibir modal com aviso de trabalho não salvo]
  → [GATEWAY Exclusive: Escolha do participante?]

    ↓ "Salvar e encerrar"
    → [Executa checkpoint (START A)] → [Após ArtefatoCommitado → Encerramento]

    ↓ "Encerrar sem salvar"
    → [TASK: Exibir confirmação secundária "Tem certeza?"]
      ↓ Não → [END: Modal fechado, sessão ativa]
      ↓ Sim → [TASK: Registrar em log; Encerrar sem commit]
      → [EVENT: SessaoEncerrada sem ArtefatoCommitado]

    ↓ "Cancelar"
    → [END: Modal fechado, sessão ativa]

---

[GATEWAY: PO presente na sala?]
  ↓ Não → [END: Sala exibe estado encerrado]

  ↓ Sim
  → [TASK: Exibir NPS pós-sessão ao PO (0-10)]
  → [GATEWAY Exclusive: PO responde ou pula?]

    ↓ Responde
    → [TASK: Registrar NPS com session_id e score]
    → [EVENT: FeedbackRespondido]
    → [END: Sala exibe estado encerrado]

    ↓ Pula
    → [END: Sala exibe estado encerrado]
```

---

### Integrações com Sistemas Externos

| Sistema | Quando Chamado | Dados Enviados | Dados Recebidos | Timeout | Retry Policy |
|---------|----------------|----------------|-----------------|---------|--------------|
| GitHub API | Etapa 3 (checkpoint e encerramento) | `{files_content, commit_message, author_bot_token}` | `{commit_hash, status}` | 30s | 3 tentativas (30s intervalo); falha registrada em log; artefatos locais preservados |

---

### Métricas e Monitoramento

| Métrica | Target | Como Medir |
|---------|--------|------------|
| Taxa de sessões encerradas com commit | 100% (TM-02) | Proporção de `SessaoEncerrada` com `ArtefatoCommitado` correspondente |
| Tempo de checkpoint (comando → confirmação) | < 5 minutos | Delta entre `CheckpointSolicitado` e `ArtefatoCommitado` |
| Taxa de NPS pós-sessão respondido | > 70% das sessões com PO | (FeedbackRespondido para papel po) / (SessaoEncerrada com po presente) |
| Falhas na GitHub API | < 2% dos commits | (Tentativas falhadas) / (Total de tentativas) — log de erros |

---

## Processo A.3: Aprovação de PRD e Feedback

---

### Metadados do Processo

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `aprovacaoprd` |
| **Nome de Negócio** | Aprovação de PRD e Feedback |
| **Módulo** | `ycognio` |
| **Tipo** | Semi-automático (ação humana dispara sequência automática: commit + geração de PDF + envio de email via MCP + coleta de NPS) |
| **Frequência** | 1 vez por Projeto (última sessão, quando PRD é considerado pronto) |
| **Tempo Médio** | 5 a 15 minutos (do checkbox à confirmação final) |
| **SLA** | PDF gerado e email enviado ao PO + Arquiteto Receptor em até [A DEFINIR em deploy] após aprovação |
| **Responsável Principal** | PO do Cliente (aprova o PRD); Sistema (aciona geração de PDF + envio de email) |
| **Link para FR** | FR-FBK-01, FR-FBK-02, FR-FBK-03, FR-PER-01 |
| **Link para Journey** | A.1, A.2, B.1 |

---

### Objetivo do Processo

Registrar formalmente a aprovação do PO sobre o PRD produzido, gerar o PDF do documento, entregá-lo por email ao PO e ao Arquiteto Receptor da Ycodify, e coletar os formulários de feedback (NPS do PO e NPS do Arquiteto Receptor). É o processo de fechamento do ciclo de elicitação — do chat ao artefato entregue e avaliado.

---

### Participantes (Atores)

| Ator | Papel | Responsabilidades no Processo |
|------|-------|-------------------------------|
| `po` | PO do Cliente | Marcar checkbox de aprovação do PRD; responder formulário de feedback (F9 + F10); confirmar que PRD reflete o negócio |
| `sistema` | Sistema Ycognio (backend) | Detectar evento de aprovação; acionar agente para geração de PDF; orquestrar envio de email via MCP |
| `agente` | Agentes Claude (via SDK — `@orquestrador-pm`) | Compilar PRD final em PDF via ferramenta shell (pandoc ou similar); coordenar envio via MCP de email |
| `ycogniobot` | Ycognio Bot | Commitar artefatos finais no repositório Git |
| `ycognioemailmcp` | Servidor MCP de Email (ycognio-email-mcp) | Enviar email com PDF para PO e Arquiteto Receptor — remetente e template `[A DEFINIR em deploy]` |
| `arquitetoreceptor` | Arquiteto Receptor (Ycodify) | Receber email com PRD; acessar link de NPS no email; responder formulário NPS (F11) |

---

### Pré-condições

- PRD considerado completo (100% das 10 seções sem `[A PREENCHER]`) — avaliação dos agentes
- Sessão ativa na última sessão do Projeto
- PO presente na sala
- Repositório Git com artefatos atualizados (último checkpoint recente)
- Servidor MCP de email configurado e acessível pelo backend
- Email do PO e email do Arquiteto Receptor disponíveis para envio `[A DEFINIR — configuração por projeto]`

---

### Pós-condições (Sucesso)

- PRD aprovado formalmente (PRDAprovado registrado)
- Artefatos finais commitados no repositório Git
- PDF do PRD gerado e armazenado no filesystem do Projeto
- Email com PDF enviado ao PO e ao Arquiteto Receptor via MCP de email
- Formulário de feedback do PO (F9 + F10) respondido ou pulado
- Link de NPS enviado ao Arquiteto Receptor (F11) no mesmo email
- Projeto marcado como concluído

---

### Fluxo Principal (Happy Path)

#### Etapa 1: PO marca checkbox de aprovação do PRD

**Ator**: PO do Cliente

**Ação**:
1. PO está na última sessão; agentes apresentaram o PRD completo para revisão final
2. PO revisa o PRD no Painel do PRD em Construção (F14) ou no chat
3. PO marca checkbox "PRD aprovado" na interface (ou envia confirmação equivalente via chat)

**Sistema Responde**:
- Detecta evento de aprovação
- Registra evento `PRDAprovado` com `{project_id, session_id, participant_id, timestamp}`
- Inicia sequência automática de pós-aprovação:
  - (a) Aciona `@orquestrador-pm` com sinal "PRD aprovado — gere o PDF e envie por email"
  - (b) Exibe indicador "Processando aprovação..." no chat

**Próximo Estado**: aprovação registrada; agente processando PDF e email

**Regras de Negócio**:
- RN-A3.1: Apenas PO pode marcar o checkbox de aprovação — YC Analyst e Guest não têm esta permissão
- RN-A3.2: O sistema é apenas o dispatcher do evento "checkbox marcado" — toda lógica de geração de PDF e envio de email é executada pelo agente (Design Principle 3.1.6)

---

#### Etapa 2: Agente compila PRD final e gera PDF

**Ator**: Agente Claude (`@orquestrador-pm`)

**Ação**:
1. Agente executa compilação do PRD via `scripts/compile-prd.sh` (gera `PRD_COMPILED.md`)
2. Converte `PRD_COMPILED.md` em PDF via ferramenta shell (pandoc ou equivalente configurado no ambiente)
3. Salva PDF no filesystem do Projeto: `artifacts/PRD_<project_name>_<data>.pdf`

**Sistema Responde**:
- PDF disponível no filesystem
- Agente confirma geração no chat: "PDF gerado: `PRD_ycognio_2026-04-18.pdf`"

**Tempo Estimado**: 1 a 3 minutos (dependendo do tamanho do PRD)

**Regras de Negócio**:
- RN-A3.3: PDF é gerado via comando ao agente — não é gerado automaticamente pelo sistema web sem mediação do agente
- RN-A3.4: PDF deve conter o PRD completo compilado das 10 seções + ANEXOS A, B, C

---

#### Etapa 3: Agente commita artefatos finais via Ycognio Bot

**Ator**: Agente Claude + Ycognio Bot

**Ação**:
1. Agente solicita commit final com todos os artefatos (PRD compilado + PDF + ANEXOS)
2. Ycognio Bot executa commit via GitHub API

**Formato da mensagem de commit**:
```
[PO: <nick>] aprovacao: PRD <projeto> aprovado — versão final commitada
```

**Sistema Responde**:
- Hash do commit registrado
- Evento `ArtefatoCommitado` com `{tipo: "aprovacao_final"}`

---

#### Etapa 4: Agente envia email via MCP de email

**Ator**: Agente Claude + Servidor MCP de Email (`ycognio-email-mcp`)

**Ação**:
1. Agente invoca ferramenta MCP de email com os parâmetros:
   - Destinatário 1: email do PO `[A DEFINIR — configuração por projeto]`
   - Destinatário 2: email do Arquiteto Receptor `[A DEFINIR — configuração por projeto]`
   - Anexo: PDF do PRD gerado na Etapa 2
   - Corpo/template: `[A DEFINIR em deploy]`
   - Conteúdo especial no email do Arquiteto Receptor: **link para formulário NPS** (F11 — formulário de 4 perguntas: 1 NPS escala 0-10 + 3 complementares qualitativas)

**Sistema Responde** (via MCP):
- Email enviado para ambos os destinatários
- Agente confirma no chat: "Email enviado ao PO e ao Arquiteto Receptor com o PRD em PDF."

**Regras de Negócio**:
- RN-A3.5: Email é enviado via MCP server — NÃO via SMTP direto ou chamada HTTP ao SendGrid (princípio de agência do agente via MCP)
- RN-A3.6: Link de NPS do Arquiteto Receptor (F11) deve estar no corpo do email — ao clicar, abre formulário web de 4 perguntas (1 NPS escala 0-10 + 3 complementares qualitativas — conteúdo das 3 complementares a definir em deploy)

---

#### Etapa 5: Sistema exibe formulários de feedback ao PO

**Ator**: Sistema Ycognio (backend)

**Ação**:
- Imediatamente após aprovação (Etapa 1), sem aguardar geração do PDF, o sistema exibe ao PO:

**Formulário 1 — NPS de Clareza da Condução (F9)**:
- Pergunta: *"De 0 a 10, como você avalia a clareza da condução desta sessão de elicitação?"*
- Escala 0-10 clicável
- Campo opcional de comentário

**Formulário 2 — Reconhecimento e Profundidade (F10)** (exibido após F9):
- Pergunta (a): *"O PRD reflete o que você queria construir?"* (escala 1-5)
- Pergunta (b): *"O PRD captura aspectos do seu negócio que você não teria conseguido articular sozinho?"* (escala 1-5)

**Sistema Responde** (após submissão ou skip de cada formulário):
- Registra respostas com `{project_id, session_id, participant_role=po, form_type, scores, comment, timestamp}`
- Evento `FeedbackRespondido` para cada formulário submetido

**Próximo Estado**: projeto marcado como concluído; sala em modo read-only

**Regras de Negócio**:
- RN-A3.7: F9 e F10 são obrigatoriamente exibidos ao PO após aprovação — mas podem ser pulados sem bloquear o processo
- RN-A3.8: F9 e F10 são exibidos APENAS ao PO — não ao YC Analyst, não ao Guest
- RN-A3.9: NPS do Arquiteto Receptor (F11) tem exatamente 4 perguntas (diferente dos 3 de F9+F10) — respondido via link no email, fora do chat

---

### Fluxos Alternativos

---

#### Alt-1: PO pula formulários de feedback

**Quando**: PO não deseja responder F9 ou F10

**Etapa 5 (alternativa)**:
- PO clica "Pular" em cada formulário
- Sistema registra skip com timestamp (para análise de taxa de resposta)
- Processo prossegue normalmente; projeto marcado como concluído

**Regras de Negócio**:
- RN-A3.10: Skip de feedback é registrado como dado (sem nota) — não é tratado como ausência de dados

---

#### Alt-2: Arquiteto Receptor responde NPS via link no email

**Quando**: Arquiteto Receptor recebe email e clica no link de NPS (fora do contexto do chat)

**Fora da sessão (assíncrono)**:
- Arquiteto Receptor abre link no browser
- Vê formulário web de 4 perguntas (1 NPS escala 0-10 + 3 complementares qualitativas)
- Responde e submete
- Sistema registra respostas com `{project_id, respondent_role=arquitetoreceptor, scores, timestamp}`
- Evento `FeedbackRespondido` com `form_type=nps_receptor`

**Regras de Negócio**:
- RN-A3.11: Formulário NPS do Arquiteto Receptor tem exatamente 4 perguntas (1 NPS escala 0-10 + 3 complementares qualitativas — conteúdo das 3 complementares a definir em deploy)
- RN-A3.12: Resposta do NPS receptor é obrigatória para medir BM-04 — mas o fluxo de aprovação não bloqueia em caso de não-resposta

---

### Fluxos de Exceção

---

#### Exc-1: Falha na geração do PDF

**Quando**: Agente tenta gerar PDF mas ferramenta shell (pandoc) falha ou não está disponível no ambiente

**Etapa 2 (exceção)**:

**Sistema Responde**:
- Agente exibe no chat: "Não foi possível gerar o PDF. O PRD compilado (`PRD_COMPILED.md`) está disponível no repositório Git."
- Processo prossegue: commit e email são enviados **sem** o PDF (email inclui link para o repositório Git em vez do PDF em anexo)
- Evento `PRDAprovado` já registrado — aprovação não é revertida

**Regras de Negócio**:
- RN-A3.13: Falha na geração do PDF NÃO cancela a aprovação do PRD — é degradação de experiência, não falha bloqueante

---

#### Exc-2: Falha no envio de email via MCP

**Quando**: Servidor MCP de email (`ycognio-email-mcp`) não está disponível ou retorna erro

**Etapa 4 (exceção)**:

**Sistema Responde**:
- Agente tenta 3 vezes com intervalo de 30s
- Se todas falharem: registra erro em log
- Agente exibe no chat: "Email não pôde ser enviado via MCP. O PRD está no repositório Git: `<url_repositorio>`"
- Evento `PRDAprovado` já registrado — aprovação preservada

**Regras de Negócio**:
- RN-A3.14: Falha no MCP de email NÃO reverte aprovação do PRD — o artefato está no Git independentemente do email

---

### Regras de Negócio Específicas

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| RN-A3.1 | Aprovação exclusiva do PO | Apenas PO pode marcar checkbox de aprovação — YC Analyst e Guest não têm esta permissão | Obrigatória |
| RN-A3.2 | Sistema como dispatcher | Toda lógica pós-aprovação (PDF, email) é executada pelo agente — sistema apenas despacha o evento | Obrigatória |
| RN-A3.3 | PDF via comando ao agente | PDF não é gerado automaticamente pelo sistema web sem mediação do agente | Obrigatória |
| RN-A3.4 | PDF inclui PRD completo + ANEXOS | Artefato PDF contém as 10 seções + ANEXO A, B, C compilados | Obrigatória |
| RN-A3.5 | Email via MCP server | Envio de email é operação MCP — não SMTP direto nem REST API de email | Obrigatória |
| RN-A3.6 | Link NPS receptor no email | Email do Arquiteto Receptor inclui link para formulário NPS de 4 perguntas (1 NPS 0-10 + 3 complementares qualitativas) | Obrigatória |
| RN-A3.7 | F9 e F10 exibidos ao PO | Formulários de feedback são exibidos ao PO após aprovação — podem ser pulados | Obrigatória |
| RN-A3.8 | Formulários restritos ao PO | F9 e F10 NÃO são exibidos a YC Analyst nem a Guest | Obrigatória |
| RN-A3.9 | NPS receptor tem exatamente 4 perguntas | Diferente dos formulários do PO (3 questões totais F9+F10) — 1 NPS 0-10 + 3 complementares qualitativas | Obrigatória |
| RN-A3.10 | Skip de feedback é dado | Pular é registrado — não é tratado como ausência | Desejável |
| RN-A3.11 | Número de perguntas do receptor | Exatamente 4 perguntas no NPS do Arquiteto Receptor (1 NPS 0-10 + 3 complementares qualitativas — conteúdo das 3 complementares a definir em deploy) | Obrigatória |
| RN-A3.12 | NPS receptor não bloqueia | Não-resposta do receptor não bloqueia aprovação | Obrigatória |
| RN-A3.13 | Falha de PDF não cancela aprovação | Degradação de experiência, não falha bloqueante | Obrigatória |
| RN-A3.14 | Falha de MCP não reverte aprovação | Artefato no Git é suficiente; email é canal adicional | Obrigatória |

---

### Eventos de Negócio Gerados

| Evento | ID Técnico | Quando Ocorre | Payload |
|--------|------------|---------------|---------|
| PRD Aprovado | `PRDAprovado` | PO marca checkbox de aprovação | `{project_id, session_id, participant_id, timestamp}` |
| Artefato Commitado (final) | `ArtefatoCommitado` | Ycognio Bot commita versão final com PDF | `{session_id, commit_hash, files_committed, tipo: "aprovacao_final", timestamp}` |
| Feedback Respondido (PO F9) | `FeedbackRespondido` | PO submete NPS de clareza (0-10) | `{project_id, participant_role=po, form_type=nps_clareza, score, comment, timestamp}` |
| Feedback Respondido (PO F10) | `FeedbackRespondido` | PO submete form reconhecimento (1-5 x2) | `{project_id, participant_role=po, form_type=reconhecimento, score_a, score_b, timestamp}` |
| Feedback Respondido (Receptor F11) | `FeedbackRespondido` | Arquiteto Receptor submete NPS (4 perguntas: 1 escala 0-10 + 3 qualitativas) | `{project_id, respondent_role=arquitetoreceptor, form_type=nps_receptor, nps_score, qualitative_responses[], timestamp}` |

---

### Diagrama BPMN Narrativo

```
[START] PO marca checkbox "PRD aprovado"

→ [EVENT: PRDAprovado]
→ [TASK: Sistema despacha evento para @orquestrador-pm]
→ [TASK: Exibir "Processando aprovação..." no chat]

→ [PARALLEL GATEWAY — executa simultaneamente:]

  BRANCH A — Feedback PO (imediato)
  → [TASK: Exibir NPS F9 ao PO (0-10)]
  → [GATEWAY Exclusive: PO respondeu ou pulou?]
    ↓ Respondeu → [EVENT: FeedbackRespondido (nps_clareza)]
    ↓ Pulou → [Registrar skip]
  → [TASK: Exibir F10 ao PO (2 perguntas 1-5)]
  → [GATEWAY Exclusive: PO respondeu ou pulou?]
    ↓ Respondeu → [EVENT: FeedbackRespondido (reconhecimento)]
    ↓ Pulou → [Registrar skip]
  → [END BRANCH A]

  BRANCH B — Geração PDF + Email (agente)
  → [TASK: @orquestrador-pm executa compile-prd.sh → PRD_COMPILED.md]
  → [TASK: Agente gera PDF via ferramenta shell (pandoc)]
    ↓ (falha pandoc)
    → [TASK: Registrar falha; prosseguir sem PDF]
  → [TASK: Ycognio Bot commita artefatos finais (incluindo PDF se gerado)]
  → [EVENT: ArtefatoCommitado (aprovacao_final)]
  → [TASK: Agente invoca MCP de email (ycognio-email-mcp)]
    → Destino 1: PO — PDF em anexo (ou link ao Git se PDF falhou)
    → Destino 2: Arquiteto Receptor — PDF em anexo + link NPS F11
    ↓ (falha MCP — até 3 tentativas)
    → [TASK: Registrar erro; exibir URL do repositório no chat]
  → [END BRANCH B]

[JOIN — ambas branches concluídas]
→ [TASK: Marcar Projeto como concluído]
→ [END: Sala em modo read-only; projeto encerrado]

---

ASSÍNCRONO — Fora da sessão:
[Arquiteto Receptor recebe email]
→ [Clica link NPS no email]
→ [Abre formulário web de 4 perguntas (1 NPS 0-10 + 3 complementares qualitativas)]
→ [Submete respostas]
→ [EVENT: FeedbackRespondido (nps_receptor)]
→ [END]
```

---

### Integrações com Sistemas Externos

| Sistema | Quando Chamado | Dados Enviados | Dados Recebidos | Timeout | Retry Policy |
|---------|----------------|----------------|-----------------|---------|--------------|
| GitHub API | Etapa 3 (commit final) | `{files_content, commit_message, bot_token}` | `{commit_hash, status}` | 30s | 3 tentativas (30s intervalo) |
| MCP de Email (`ycognio-email-mcp`) | Etapa 4 (envio pós-aprovação) | `{destinatarios[], assunto, corpo, anexo_pdf, link_nps_receptor}` | `{status_envio, message_id}` | 30s | 3 tentativas (30s intervalo); falha logada; URL do repositório exibida no chat como fallback |

> **Nota**: O servidor MCP de email (`ycognio-email-mcp`) é a integração primária para envio de emails no Ycognio. Remetente, templates de corpo e formato do assunto são `[A DEFINIR em deploy]`. Esta integração é mapeada em detalhe no **ANEXO C**.

---

### Métricas e Monitoramento

| Métrica | Target | Como Medir |
|---------|--------|------------|
| Taxa de PRDs aprovados com email enviado | > 95% | (PRDAprovado com email confirmado) / (total PRDAprovado) |
| Taxa de NPS F9 respondido | > 70% | (FeedbackRespondido nps_clareza) / (PRDAprovado) |
| Taxa de NPS F10 respondido | > 70% | (FeedbackRespondido reconhecimento) / (PRDAprovado) |
| Taxa de NPS F11 respondido (Arquiteto Receptor) | > 50% (BM-04) | (FeedbackRespondido nps_receptor) / (emails enviados ao receptor) |

---

## Rastreabilidade

| Processo neste Anexo | FRs no PRD | Jornadas no PRD | NFRs Relacionados |
|---------------------|-----------|-----------------|-------------------|
| A.1: Conversação no Chat | FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-VIS-01, FR-VIS-02, FR-TEL-01, FR-TEL-02 | A.1, A.2, B.1, C.1 | NFR-TM-03 (broadcast ≤2s), NFR-BM-01 (primeiro token <5s) |
| A.2: Checkpoint e Encerramento | FR-PER-01, FR-PER-02, FR-PER-03, FR-FBK-01 | A.1, A.2, B.1 | NFR-TM-02 (persistência 100%) |
| A.3: Aprovação de PRD e Feedback | FR-FBK-01, FR-FBK-02, FR-FBK-03, FR-PER-01 | A.1, A.2, B.1 | NFR-BM-04 (NPS receptor ≥50), NFR-UM-01, NFR-UM-02 |

---

## Glossário de Termos Técnicos de Processo

| Termo | Definição |
|-------|-----------|
| **Happy Path** | Fluxo principal quando tudo funciona perfeitamente, sem erros ou exceções |
| **Fluxo Alternativo** | Cenário válido que desvia do happy path (ex: usuário escolhe pular NPS) |
| **Fluxo de Exceção** | Cenário de erro técnico que interrompe fluxo normal (ex: timeout do SDK, falha no GitHub API) |
| **Checkpoint** | Persistência incremental de artefatos via commit Git sem encerrar sessão ativa |
| **Guard** | Interceptação de ação destrutiva (ex: fechar sessão) para exigir confirmação explícita |
| **MCP Tool** | Ferramenta exposta por servidor MCP que o agente Claude aciona programaticamente (ex: envio de email) |
| **Dispatcher** | O sistema Ycognio detecta evento (ex: checkbox marcado) e aciona o agente — não executa lógica de negócio diretamente |
| **Streaming** | Transmissão de tokens de resposta progressivamente à medida que o SDK gera, sem aguardar resposta completa |
| **Roteamento por Papel** | Regra F21: mensagens de PO/YC Analyst vão para IA; mensagens de Guest ficam no chat sem acionar IA |

---

**Versão**: 1.0
**Data**: 2026-04-18
**Responsável**: Analista de Negócio (Sofia)
**Consumidores**: Arquiteto de Processos (para gerar `spec_processos.json` — BPMN 2.0)
