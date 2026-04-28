---
anexo_type: "data_models"
parent_document: "PRD_index.md"
projeto: "ycognio"
cliente: "Ycodify"
responsavel: "BA (Analista de Negócio — Sofia)"
created_at: "2026-04-18"
last_updated: "2026-04-18"
version: "1.1"
ve_note: "VE-1: INV-F-05 atualizado (4 perguntas fixas no NPS_ARQUITETO_RECEPTOR — C-02); B.6 LinkAcesso reformulado como multi-uso único (M-01 — remove single-use, papelDestino, emailConvidado, usado, usadoEm, usadoPor, Consumir, LinkConsumido)"
status: "completed"
prd_mode: "fragmented"
template_version: "3.1"
documentos_completos: 4
documentos_compactos: 3
total_invariantes: 30
---

# ANEXO B: Data Models — Ycognio — Webchat de Elicitação Assistida

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Detalhar documentos/entidades de dados, campos, relacionamentos, regras de validação e ciclos de vida
> **Consumidores**: Arquiteto de Documentos (gera `spec_documentos.json` — YCL-domain)

---

## Convenções deste Anexo

- **ID Técnico**: forma normalizada `^[a-z]+$` para documentos; `PascalCase` para comandos e eventos
- **UUID**: todos os documentos usam UUID como chave primária — **nenhum ID natural é chave primária**
- **Emails**: validação RFC 5321 para todos os campos de e-mail
- **Tipo Aggregate Root**: documento que encapsula seu ciclo de vida completo; não depende de outro para existir
- **Tipo Entity**: possui identidade própria, mas vive dentro de um Aggregate
- **INV-xxx**: invariante obrigatória numerada sequencialmente por documento
- **[INFERIDO]**: regra derivada de contexto ou de consistência com outros documentos — não declarada explicitamente pelo cliente

---

## Diagrama de Relacionamentos

```
Projeto (1) ──┬── (N) Sessao ──┬── (N) Participante
              │                 ├── (N) Mensagem
              │                 └── (0..1) FormularioFeedback [tipo: NPS_PO]
              │
              ├── (N) Artefato
              │
              ├── (N) LinkAcesso ──── (0..1) Participante (associação pós-uso)
              │
              └── (0..1) FormularioFeedback [tipo: NPS_ARQUITETO_RECEPTOR]
```

---

## Documento B.1: Projeto

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `projeto` |
| **Nome de Negócio** | "Projeto" |
| **Módulo** | `ycognio` |
| **Tipo** | Aggregate Root |
| **Descrição** | Representa uma pasta Git pré-existente sobre a qual o Ycognio opera. Contém os agentes Claude em `.claude/agents/` e recebe os artefatos PRD versionados. É o nível de organização mais alto — agrupa todas as sessões, artefatos, links e o feedback final do Arquiteto Receptor. |
| **Ciclo de Vida** | `em_elicitacao` → `prd_aprovado` → `pdf_enviado` |
| **Retenção de Dados** | 21 dias após último acesso (conforme Seção 5.2.4 do PRD) |
| **Link para FR** | FR-ACC-01, FR-ACC-02, FR-VIS-03, FR-PER-01, FR-PER-02, FR-FBK-02 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente (estratégia uniforme) | — | `a7b9c3e1-...` |
| `nomeProjeto` | String | Sim | 3–60 chars; `^[a-zA-Z0-9 _-]+$` | — | `ycognio-v2` |
| `organizacao` | String | Sim | Não vazio | — | `Ycodify` |
| `workingDir` | String | Sim | Caminho absoluto; não vazio; **imutável após criação** | — | `/home/julio/Codes/YC/yc-platform-v3/ycognio` |
| `repoGitHub` | String | Sim | Formato `owner/repo`; **imutável após criação** | — | `ycodify/ycognio` |
| `emailPO` | String | Não | Validação RFC 5321; obrigatório no momento da aprovação do PRD | `null` | `po@empresa.com` |
| `emailArquitetoReceptor` | String | Não | Validação RFC 5321; obrigatório no momento da aprovação do PRD | `null` | `arquiteto@ycodify.com` |
| `prdConteudo` | Text | Não | Conteúdo Markdown do PRD; deve estar preenchido para aprovação | `null` | _(conteúdo do PRD.md)_ |
| `prdAprovado` | Boolean | Sim | — | `false` | `true` |
| `prdAprovadoEm` | Timestamp | Não | ISO 8601; preenchido ao aprovar | `null` | `2026-04-18T15:30:00Z` |
| `prdAprovadoPor` | String | Não | Nick do participante PO; preenchido ao aprovar | `null` | `Ana (PO)` |
| `status` | Enum | Sim | Valores: `em_elicitacao`, `prd_aprovado`, `pdf_enviado` | `em_elicitacao` | `em_elicitacao` |
| `criadoEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-17T10:00:00Z` |
| `criadoPor` | String | Sim | Nick do participante YC Analyst que criou | — | `Julio (YC Analyst)` |
| `atualizadoEm` | Timestamp | Sim (auto) | ISO 8601; atualizado a cada mudança | `now()` | `2026-04-18T09:00:00Z` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Projeto → Sessao | 1:N | Um Projeto agrupa múltiplas Sessões ao longo do tempo | `projetoId` em Sessao (FK) |
| Projeto → Artefato | 1:N | Um Projeto acumula artefatos gerados em sessões | `projetoId` em Artefato (FK) |
| Projeto → LinkAcesso | 1:N | Um Projeto pode ter múltiplos links gerados ao longo do tempo | `projetoId` em LinkAcesso (FK) |
| Projeto → FormularioFeedback [NPS_RECEPTOR] | 1:0..1 | Um Projeto tem no máximo 1 formulário NPS do Arquiteto Receptor | `projetoId` em FormularioFeedback (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-P-01 | `workingDir` imutável | O campo `workingDir` não pode ser alterado após a criação do Projeto. O Ycognio opera sobre o repositório Git informado na criação — mudar o caminho implicaria perda de contexto dos agentes. | Obrigatória |
| INV-P-02 | `repoGitHub` imutável | O campo `repoGitHub` não pode ser alterado após a criação do Projeto. A persistência dos artefatos é amarrada a um único repositório por Projeto. | Obrigatória |
| INV-P-03 | `nomeProjeto` único por `organizacao` | Não podem existir dois Projetos com o mesmo `nomeProjeto` dentro da mesma `organizacao`. | Obrigatória |
| INV-P-04 | Pré-condições para aprovar PRD | `prdAprovado` só pode passar para `true` se: (a) existe ao menos 1 Sessao vinculada ao Projeto com `checkpointConfirmado = true`, E (b) `prdConteudo` não está vazio. | Obrigatória |
| INV-P-05 | E-mails obrigatórios na aprovação | No momento do comando `AprovarPRD`, tanto `emailPO` quanto `emailArquitetoReceptor` devem estar preenchidos com valores válidos (RFC 5321). | Obrigatória |
| INV-P-06 | Transições de status válidas | Apenas transições permitidas: `em_elicitacao` → `prd_aprovado` → `pdf_enviado`. Não há retrocesso de status. | Obrigatória |
| INV-P-07 | Encerramento de Sessao não fecha Projeto | O encerramento de uma Sessao (com ou sem checkpoint) não altera o `status` do Projeto. O Projeto só avança quando `prdAprovado = true`. | Obrigatória [INFERIDO] |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `CriarProjeto` | Registra novo Projeto a partir de repositório Git pré-existente | YC Analyst | `workingDir` e `repoGitHub` informados e válidos | Projeto criado com `status = em_elicitacao`; evento `ProjetoCriado` disparado |
| `AtualizarEmails` | Atualiza `emailPO` e/ou `emailArquitetoReceptor` | YC Analyst | Projeto em qualquer status antes de `pdf_enviado` | Campos de e-mail atualizados; `atualizadoEm = now()` |
| `AprovarPRD` | PO confirma que o PRD reflete fielmente o negócio | PO | INV-P-04 e INV-P-05 satisfeitas | `prdAprovado = true`; `prdAprovadoEm = now()`; `prdAprovadoPor = nick do PO`; `status → prd_aprovado`; evento `PRDAprovado` disparado; formulário NPS_ARQUITETO_RECEPTOR emitido |
| `GerarPDFEEnviar` | Sistema gera PDF do PRD e envia por e-mail ao PO e ao Arquiteto Receptor | Sistema (agente automático pós-aprovação) | `status = prd_aprovado` | PDF gerado; e-mails enviados; `status → pdf_enviado`; eventos `PDFGerado` e `EmailPRDEnviado` disparados |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `ProjetoCriado` | `CriarProjeto` executado | `{ projetoId, nomeProjeto, organizacao, workingDir, repoGitHub, criadoPor, criadoEm }` |
| `PRDAprovado` | `AprovarPRD` executado com sucesso | `{ projetoId, prdAprovadoPor, prdAprovadoEm }` |
| `PDFGerado` | Sistema gera PDF do PRD aprovado | `{ projetoId, artefatoId, geradoEm }` |
| `EmailPRDEnviado` | E-mails com PDF enviados ao PO e ao Arquiteto Receptor | `{ projetoId, emailPO, emailArquitetoReceptor, enviadoEm }` |

---

### Índices e Performance

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| `id` | Primary Key (Unique) | Identificador único |
| `(nomeProjeto, organizacao)` | Unique Composite | Garantia de INV-P-03 |
| `status` | Index | Filtros frequentes por status (ex: listar projetos `em_elicitacao`) |
| `organizacao` | Index | Listagem por organização |

---

## Documento B.2: Sessao

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `sessao` |
| **Nome de Negócio** | "Sessão" |
| **Módulo** | `ycognio` |
| **Tipo** | Aggregate |
| **Descrição** | Encontro de chat dentro de um Projeto em intervalo de tempo contínuo. Possui estado próprio, gera artefatos e pode ser retomada em momento posterior via resumo/status. Uma Sessão contém N Mensagens e 0..1 FormularioFeedback do tipo NPS_PO. |
| **Ciclo de Vida** | `ativa` → `encerrada` |
| **Retenção de Dados** | 21 dias após último acesso do Projeto pai (conforme Seção 5.2.4 do PRD) |
| **Link para FR** | FR-PER-04, FR-TEL-02, FR-FBK-01, FR-VIS-03, FR-VIS-05 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `b3d1e7a2-...` |
| `projetoId` | UUID (FK → Projeto) | Sim | Projeto deve existir | — | `a7b9c3e1-...` |
| `iniciadaEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T09:00:00Z` |
| `iniciadaPor` | String | Sim | Nick do participante que abriu a sessão | — | `Julio (YC Analyst)` |
| `iaAtivada` | Boolean | Sim | Irreversível — uma vez `true`, não volta a `false` na mesma sessão | `false` | `true` |
| `timeoutInatividadeAt` | Timestamp | Não | Calculado como `última mensagem + 2h`; `null` enquanto sessão não tem mensagens | `null` | `2026-04-18T11:30:00Z` |
| `encerradaEm` | Timestamp | Não | ISO 8601; obrigatório quando sessão encerrada | `null` | `2026-04-18T11:00:00Z` |
| `encerradaPor` | Enum | Não | Valores: `TIMEOUT`, `ESVAZIAMENTO`, `CHECKPOINT_CONFIRMADO`, `ENCERRAMENTO_MANUAL`; obrigatório se `encerradaEm != null` | `null` | `CHECKPOINT_CONFIRMADO` |
| `checkpointConfirmado` | Boolean | Sim | — | `false` | `true` |
| `agentesRemovidos` | Array[String] | Não | Lista de nomes de agentes removidos da sessão | `[]` | `["guardiao-linguagem-ubiqua"]` |
| `status` | Enum | Sim | Valores: `ativa`, `encerrada` | `ativa` | `encerrada` |
| `resumoStatus` | Text | Não | Resumo gerado pelos agentes ao encerrar; usado na retomada (H-B) | `null` | _(resumo gerado pelo Orquestrador)_ |
| `atualizadoEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T10:45:00Z` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Sessao → Projeto | N:1 | Uma Sessão pertence a um Projeto | `projetoId` (FK) |
| Sessao → Participante | 1:N | Uma Sessão tem múltiplos Participantes | `sessaoId` em Participante (FK) |
| Sessao → Mensagem | 1:N | Uma Sessão contém múltiplas Mensagens | `sessaoId` em Mensagem (FK) |
| Sessao → FormularioFeedback [NPS_PO] | 1:0..1 | Uma Sessão tem no máximo 1 formulário NPS do PO | `sessaoId` em FormularioFeedback (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-S-01 | Sessão ativa exige participante ativo | Sessão com `status = ativa` deve ter ao menos 1 Participante com `estaNaSala = true` e papel `PO` ou `YC_ANALYST`. Se todos os participantes não-Guest saírem, a sessão encerra por `ESVAZIAMENTO`. | Obrigatória |
| INV-S-02 | `iaAtivada` é irreversível | `iaAtivada` só muda de `false` para `true` após a primeira `@mention` (Invocação Direta de Agente) em uma sessão. Não pode voltar a `false` na mesma sessão. | Obrigatória |
| INV-S-03 | `encerradaPor` obrigatório ao encerrar | Se `encerradaEm != null`, então `encerradaPor` deve ser um dos valores válidos do enum. | Obrigatória |
| INV-S-04 | Cálculo de timeout | `timeoutInatividadeAt` é sempre calculado como `timestamp da última Mensagem da sessão + 2 horas`. Se a sessão atingir este momento sem nova Mensagem, encerra automaticamente com `encerradaPor = TIMEOUT`. | Obrigatória |
| INV-S-05 | NPS_PO antes de encerrar com checkpoint | Ao encerrar com `CHECKPOINT_CONFIRMADO`, o FormularioFeedback do tipo `NPS_PO` deve ter sido emitido para o PO presente. Se o PO não respondeu, o encerramento ainda ocorre mas o formulário permanece em aberto para resposta posterior. | Obrigatória |
| INV-S-06 | `checkpointConfirmado` exige confirmação explícita | `checkpointConfirmado` só pode ser `true` se o encerramento foi iniciado via comando `EncerrarComCheckpoint` — não é definido automaticamente por timeout ou esvaziamento. | Obrigatória |
| INV-S-07 | Múltiplas sessões por Projeto | Um Projeto pode ter N Sessões. O encerramento de uma Sessão não encerra o Projeto. O Projeto só avança ao estado `prd_aprovado` quando o PO executar `AprovarPRD`. | Obrigatória [INFERIDO — consistência com INV-P-07] |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `AbrirSessao` | Inicia nova sessão no Projeto | YC Analyst | Projeto com `status = em_elicitacao`; `workingDir` acessível | Sessão criada com `status = ativa`; evento `SalaAberta` disparado |
| `RegistrarMensagem` | Persiste mensagem de um Participante | Sistema (ao enviar mensagem) | Sessão `ativa`; Participante com `estaNaSala = true` | Mensagem salva; `timeoutInatividadeAt` atualizado; roteamento por papel executado |
| `InvocarAgente` | Marca `iaAtivada = true` e roteia mensagem a agente específico | PO ou YC Analyst | Sessão `ativa`; `iaAtivada` pode ser `false` ou `true` | Se `iaAtivada = false`: `iaAtivada → true`; evento `IAAtivada` disparado; mensagem encaminhada ao agente via SDK |
| `RemoverAgente` | Remove agente da lista de agentes ativos da sessão | YC Analyst | Sessão `ativa`; agente deve estar ativo | Agente adicionado a `agentesRemovidos`; evento `AgenteRemovido` disparado |
| `ConfirmarCheckpoint` | Sinaliza que o trabalho até o momento está validado | PO (aprovação) ou YC Analyst | Sessão `ativa` | `checkpointConfirmado = true`; artefatos commitados via GitHub API; evento `CheckpointConfirmado` disparado |
| `EncerrarPorTimeout` | Sistema encerra sessão por inatividade | Sistema (automático) | `now() >= timeoutInatividadeAt` | `status → encerrada`; `encerradaPor = TIMEOUT`; evento `SalaEncerradaPorTimeout` disparado |
| `EncerrarPorEsvaziamento` | Sistema encerra sessão quando últimos participantes não-Guest saem | Sistema (automático) | INV-S-01 violada (sem PO ou YC Analyst na sala) | `status → encerrada`; `encerradaPor = ESVAZIAMENTO`; evento `SalaEncerradaPorEsvaziamento` disparado |
| `EncerrarComCheckpoint` | Encerra sessão com checkpoint confirmado | YC Analyst | Sessão `ativa`; NPS_PO emitido (ou ausência de PO na sala) | `checkpointConfirmado = true`; artefatos commitados; NPS_PO emitido ao PO (se presente); `status → encerrada`; `encerradaPor = CHECKPOINT_CONFIRMADO`; `resumoStatus` gerado |
| `EncerrarSemCheckpoint` | Encerra sessão sem checkpoint | YC Analyst | Sessão `ativa` | `checkpointConfirmado = false`; `status → encerrada`; `encerradaPor = ENCERRAMENTO_MANUAL`; `resumoStatus` gerado |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `SalaAberta` | `AbrirSessao` executado | `{ sessaoId, projetoId, iniciadaEm, iniciadaPor }` |
| `IAAtivada` | Primeira `@mention` na sessão | `{ sessaoId, mensagemId, iniciadaPor, timestamp }` |
| `AgenteInvocado` | Mensagem `@mention` encaminhada a agente | `{ sessaoId, mensagemId, agenteNome, timestamp }` |
| `AgenteRemovido` | `RemoverAgente` executado | `{ sessaoId, agenteNome, removidoPor, timestamp }` |
| `CheckpointConfirmado` | `ConfirmarCheckpoint` executado | `{ sessaoId, projetoId, confirmadoPor, timestamp }` |
| `SalaEncerradaPorTimeout` | `EncerrarPorTimeout` executado | `{ sessaoId, projetoId, encerradaEm }` |
| `SalaEncerradaPorEsvaziamento` | `EncerrarPorEsvaziamento` executado | `{ sessaoId, projetoId, encerradaEm }` |
| `SalaEncerradaComCheckpoint` | `EncerrarComCheckpoint` executado | `{ sessaoId, projetoId, checkpointConfirmado, encerradaEm, resumoStatus }` |
| `SalaEncerradaSemCheckpoint` | `EncerrarSemCheckpoint` executado | `{ sessaoId, projetoId, encerradaEm, resumoStatus }` |

---

### Índices e Performance

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| `id` | Primary Key (Unique) | Identificador único |
| `projetoId` | Index | Busca de todas as sessões de um Projeto |
| `status` | Index | Filtro de sessões ativas (ex: identificar timeout pendente) |
| `(projetoId, status)` | Composite Index | Dashboard: sessões ativas por Projeto |
| `timeoutInatividadeAt` | Index | Job de timeout consulta sessões com `timeoutInatividadeAt <= now()` |

---

## Documento B.3: Participante

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `participante` |
| **Nome de Negócio** | "Participante" |
| **Módulo** | `ycognio` |
| **Tipo** | Entity (dentro de Sessao) |
| **Descrição** | Humano identificado na sala de um Projeto pelo nick livre informado e pelo papel selecionado no dropdown (PO, YC Analyst ou Guest). Sem cadastro formal no MVP. O papel define o roteamento de mensagens (F21) e as permissões sobre o Git. Agentes Claude também são representados como Participante do tipo AGENTE para rastreamento de mensagens. |
| **Ciclo de Vida** | `na_sala` → `fora_da_sala` |
| **Retenção de Dados** | Retido enquanto a Sessão pai existir; 21 dias após último acesso do Projeto |
| **Link para FR** | FR-ACC-03, FR-CHT-02, FR-CHT-03, FR-VIS-04, FR-PER-02 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `c2f8d4b1-...` |
| `sessaoId` | UUID (FK → Sessao) | Sim | Sessão deve existir e estar `ativa` no momento da entrada | — | `b3d1e7a2-...` |
| `papel` | Enum | Sim | Lista fechada: `PO`, `YC_ANALYST`, `GUEST`, `AGENTE`; **imutável após entrada** | — | `PO` |
| `nick` | String | Sim (se papel != AGENTE) | Não vazio; livre; não precisa ser único na sessão | — | `Ana` |
| `nomeAgente` | String | Não | Obrigatório se `papel = AGENTE`; referência ao nome do agente em `.claude/agents/` | `null` | `analista-de-negocio` |
| `email` | String | Não | Validação RFC 5321; `null` se `papel = AGENTE` ou `papel = GUEST` | `null` | `ana@empresa.com` |
| `linkAcessoId` | UUID (FK → LinkAcesso) | Não | Referência de rastreabilidade ao link usado para entrar; `null` se `papel = AGENTE` ou se YC Analyst acessa diretamente sem link | `null` | `d4e9f2c7-...` |
| `entrouEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T09:05:00Z` |
| `saiuEm` | Timestamp | Não | ISO 8601; obrigatório se `estaNaSala = false` | `null` | `2026-04-18T11:00:00Z` |
| `estaNaSala` | Boolean | Sim | — | `true` | `false` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Participante → Sessao | N:1 | Um Participante pertence a uma Sessão | `sessaoId` (FK) |
| Participante → LinkAcesso | 0..1:1 | Participante pode ter entrado via link (associação pós-uso) | `linkAcessoId` (FK, nullable) |
| Participante → Mensagem | 1:N | Um Participante envia múltiplas Mensagens | `participanteId` em Mensagem (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-PA-01 | `papel` imutável após entrada | O papel de um Participante não pode ser alterado após `EntrarNaSala`. Mudança de papel exige sair e reentrar. | Obrigatória |
| INV-PA-02 | `saiuEm` obrigatório ao sair | Se `estaNaSala = false`, então `saiuEm` deve estar preenchido. | Obrigatória |
| INV-PA-03 | Agente não tem email nem linkAcessoId | Se `papel = AGENTE`, os campos `email` e `linkAcessoId` devem ser `null`. | Obrigatória |
| INV-PA-04 | GUEST não pode invocar agentes | Participante com `papel = GUEST` não pode emitir o comando `InvocarAgente`. A regra de roteamento (F21) bloqueia suas mensagens antes de chegar ao SDK. | Obrigatória |
| INV-PA-05 | `nomeAgente` obrigatório para papel AGENTE | Se `papel = AGENTE`, `nomeAgente` deve estar preenchido com o nome canônico do agente em `.claude/agents/`. | Obrigatória |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `EntrarNaSala` | Registra entrada do participante na sessão | Humano (qualquer papel) | Sessão `ativa`; link válido (se via link) | Participante criado com `estaNaSala = true`; `linkAcessoId` associado se via link; evento `ParticipanteEntrou` disparado |
| `SairDaSala` | Registra saída do participante | Humano (qualquer papel) ou Sistema | Participante com `estaNaSala = true` | `estaNaSala = false`; `saiuEm = now()`; se era o último PO ou YC Analyst: `EncerrarPorEsvaziamento` pode ser disparado |
| `EnviarMensagem` | Envia mensagem no chat | Qualquer Participante | `estaNaSala = true` | Mensagem criada; roteamento por papel executado |
| `InvocarAgente` | Dirige mensagem a agente específico via @mention | PO ou YC Analyst | `estaNaSala = true`; `papel != GUEST` | Mensagem com `destinoAgente` preenchido; `iaAtivada` marcada na Sessão se era `false` |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `ParticipanteEntrou` | `EntrarNaSala` executado | `{ participanteId, sessaoId, papel, nick, entrouEm }` |
| `ParticipanteSaiu` | `SairDaSala` executado | `{ participanteId, sessaoId, papel, saiuEm }` |

---

### Índices e Performance

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| `id` | Primary Key (Unique) | Identificador único |
| `sessaoId` | Index | Busca de todos os participantes de uma sessão |
| `(sessaoId, estaNaSala)` | Composite Index | Verificação de INV-S-01 em tempo real |
| `(sessaoId, papel)` | Composite Index | Filtro por papel dentro da sessão |

---

## Documento B.4: Mensagem

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `mensagem` |
| **Nome de Negócio** | "Mensagem" |
| **Módulo** | `ycognio` |
| **Tipo** | Entity |
| **Descrição** | Texto enviado por um Participante no canal de chat. O roteamento para os agentes IA depende do papel do remetente (F21): mensagens de PO e YC Analyst são encaminhadas ao Claude Agent SDK; mensagens de Guest são visíveis no chat mas NÃO consumidas pela IA. Suporta conteúdo em Markdown e pode conter @mention para invocação direta de agente. Mensagens são imutáveis após registro — servem como audit log da sessão. |
| **Ciclo de Vida** | Imutável após registro |
| **Retenção de Dados** | Retida enquanto a Sessão pai existir; 21 dias após último acesso do Projeto |
| **Link para FR** | FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-TEL-02 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `e5c1a9d3-...` |
| `sessaoId` | UUID (FK → Sessao) | Sim | Sessão deve estar `ativa` | — | `b3d1e7a2-...` |
| `participanteId` | UUID (FK → Participante) | Sim | Participante deve ter `estaNaSala = true` no momento do envio | — | `c2f8d4b1-...` |
| `autorPapel` | Enum | Sim (auto) | Copiado do `papel` do Participante no momento do envio: `PO`, `YC_ANALYST`, `GUEST`, `AGENTE` | — | `PO` |
| `conteudo` | Text | Sim | Mínimo 1 char; máximo 10.000 chars; suporte a Markdown | — | `Quero construir um sistema de agendamento de consultas.` |
| `destinoAgente` | String | Não | Nome canônico do agente em `.claude/agents/`; obrigatório apenas se a mensagem contém @mention explícita | `null` | `analista-de-negocio` |
| `encaminhadaAoSDK` | Boolean | Sim | `true` apenas se `autorPapel ∈ {PO, YC_ANALYST}` E `sessao.iaAtivada = true` | `false` | `true` |
| `tipoConteudo` | Enum | Sim | Valores: `TEXTO`, `TEXTO_COM_MENTION`, `RESPOSTA_AGENTE`, `NOTIFICACAO_SISTEMA` | `TEXTO` | `TEXTO_COM_MENTION` |
| `timestampEnvio` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T09:10:00Z` |
| `timestampRecebimento` | Timestamp | Não | ISO 8601; preenchido após broadcast confirmado a todos os participantes | `null` | `2026-04-18T09:10:01Z` |
| `streamCompleto` | Boolean | Não | Relevante apenas para `tipoConteudo = RESPOSTA_AGENTE`; `true` quando o streaming do agente terminou | `null` | `true` |
| `erroInvocacao` | Boolean | Não | `true` se o SDK retornou erro ao processar esta mensagem | `null` | `false` |
| `erroDetalhes` | String | Não | Detalhes do erro retornado pelo SDK; preenchido se `erroInvocacao = true` | `null` | `SDK timeout after 30s` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Mensagem → Sessao | N:1 | Uma Mensagem pertence a uma Sessão | `sessaoId` (FK) |
| Mensagem → Participante | N:1 | Uma Mensagem é enviada por um Participante | `participanteId` (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-M-01 | Mensagem imutável | Mensagens são audit log da sessão — nenhum campo pode ser alterado após o registro. Não há update, apenas insert. | Obrigatória |
| INV-M-02 | Conteúdo não vazio | `conteudo` deve ter ao menos 1 caractere não-whitespace. | Obrigatória |
| INV-M-03 | Roteamento por papel | `encaminhadaAoSDK = true` somente se `autorPapel ∈ {PO, YC_ANALYST}` AND `sessao.iaAtivada = true`. Mensagens de GUEST nunca têm `encaminhadaAoSDK = true`. | Obrigatória |
| INV-M-04 | `destinoAgente` obrigatório em @mention | Se `tipoConteudo = TEXTO_COM_MENTION`, então `destinoAgente` deve estar preenchido com o nome canônico do agente. | Obrigatória |
| INV-M-05 | Agente só envia `RESPOSTA_AGENTE` | Se `autorPapel = AGENTE`, `tipoConteudo` deve ser `RESPOSTA_AGENTE`. | Obrigatória |
| INV-M-06 | `streamCompleto` aplicável apenas a respostas de agente | `streamCompleto` deve ser `null` se `tipoConteudo != RESPOSTA_AGENTE`. | Obrigatória [INFERIDO] |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `Registrar` | Persiste nova mensagem no chat | Sistema (ao receber envio do participante) | Sessão `ativa`; Participante com `estaNaSala = true`; `conteudo` >= 1 char | Mensagem salva; `timeoutInatividadeAt` da Sessão atualizado; roteamento por papel executado; evento `MensagemEnviada` disparado |
| `MarcarEncaminhadaAoSDK` | Marca que a mensagem foi enviada ao Claude Agent SDK | Sistema | `autorPapel ∈ {PO, YC_ANALYST}`; `sessao.iaAtivada = true` | `encaminhadaAoSDK = true`; evento `MensagemEncaminhadaAgentes` disparado |
| `AnexarRespostaStream` | Registra mensagem de resposta do agente com streaming | Sistema (ao receber chunks do SDK) | Mensagem do tipo `RESPOSTA_AGENTE` | Mensagem de resposta criada; `streamCompleto` atualizado progressivamente; evento `RespostaIAGerada` disparado ao completar |
| `RegistrarErroInvocacao` | Registra falha na comunicação com o SDK | Sistema | `encaminhadaAoSDK = true` | `erroInvocacao = true`; `erroDetalhes` preenchido; evento `ErroInvocacaoAgente` disparado |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `MensagemEnviada` | `Registrar` executado | `{ mensagemId, sessaoId, participanteId, autorPapel, timestampEnvio }` |
| `MensagemEncaminhadaAgentes` | `MarcarEncaminhadaAoSDK` executado | `{ mensagemId, sessaoId, destinoAgente, timestamp }` |
| `RespostaIAGerada` | `AnexarRespostaStream` completo (`streamCompleto = true`) | `{ mensagemId, sessaoId, agenteNome, timestampRecebimento }` |
| `ErroInvocacaoAgente` | `RegistrarErroInvocacao` executado | `{ mensagemId, sessaoId, erroDetalhes, timestamp }` |

---

### Índices e Performance

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| `id` | Primary Key (Unique) | Identificador único |
| `sessaoId` | Index | Busca de todas as mensagens de uma sessão (exibição do chat) |
| `(sessaoId, timestampEnvio)` | Composite Index | Ordenação cronológica das mensagens no chat |
| `(sessaoId, autorPapel)` | Composite Index | Filtro de mensagens por papel para roteamento |
| `encaminhadaAoSDK` | Index | Auditoria: verificar mensagens que deveriam ter sido roteadas |

---

## Documento B.5: Artefato

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `artefato` |
| **Nome de Negócio** | "Artefato" |
| **Módulo** | `ycognio` |
| **Tipo** | Entity |
| **Descrição** | Arquivo produzido pelos agentes Claude durante uma sessão e materializado no filesystem do Projeto. Commitado no repositório Git via Ycognio Bot ao final de sessão ou checkpoint manual. Imutável após commit — nova versão gera novo registro. |
| **Ciclo de Vida** | `gerado` → `commitado` |
| **Link para FR** | FR-PER-01, FR-PER-03, FR-VIS-02 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `f6b2c8e4-...` |
| `projetoId` | UUID (FK → Projeto) | Sim | — | — | `a7b9c3e1-...` |
| `tipo` | Enum | Sim | Valores: `PRD_MD`, `PRD_PDF`, `ANEXO`, `CHECKPOINT_COMMIT`, `SECAO_PRD` | — | `PRD_MD` |
| `gitCommitSHA` | String | Não | SHA-1 do commit GitHub; preenchido após commit | `null` | `abc123def456...` |
| `urlGitHub` | String | Não | URL do arquivo no GitHub; preenchido após commit | `null` | `https://github.com/ycodify/ycognio/blob/main/artifacts/PRD.md` |
| `caminhoArquivo` | String | Sim | Caminho relativo ao `workingDir` do Projeto | — | `artifacts/PRD.md` |
| `geradoEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T10:50:00Z` |
| `commitadoEm` | Timestamp | Não | ISO 8601; preenchido após commit | `null` | `2026-04-18T11:00:00Z` |
| `geradoPor` | String | Sim | Nome canônico do agente que gerou o artefato | — | `analista-de-negocio` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Artefato → Projeto | N:1 | Um Artefato pertence a um Projeto | `projetoId` (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-A-01 | Artefato imutável após commit | Uma vez commitado (`gitCommitSHA` preenchido), os campos de conteúdo não podem ser alterados. Nova versão do mesmo arquivo gera novo registro de Artefato. | Obrigatória |
| INV-A-02 | PRD_PDF exige PRD_MD | Um Artefato do tipo `PRD_PDF` só pode ser gerado se existir ao menos um Artefato do tipo `PRD_MD` commitado para o mesmo `projetoId`. | Obrigatória |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `Gerar` | Registra novo artefato gerado por agente | Sistema (agente via SDK) | Sessão `ativa`; `caminhoArquivo` válido | Artefato salvo com `gitCommitSHA = null`; evento `ArtefatoGerado` disparado |
| `Commitar` | Executa commit do artefato no GitHub via Ycognio Bot | Sistema (pós-checkpoint ou pós-encerramento) | Artefato com `gitCommitSHA = null`; GitHub API acessível | `gitCommitSHA` e `urlGitHub` preenchidos; `commitadoEm = now()`; evento `ArtefatoCommitado` disparado |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `ArtefatoGerado` | `Gerar` executado | `{ artefatoId, projetoId, tipo, caminhoArquivo, geradoPor, geradoEm }` |
| `ArtefatoCommitado` | `Commitar` executado | `{ artefatoId, projetoId, sessaoId, gitCommitSHA, urlGitHub, commitadoEm, autorNick }` — `sessaoId` e `autorNick` adicionados em EP-05.S1aa (2026-04-23) para permitir roteamento STOMP do broadcast ao tópico `/topic/sessions/{sessaoId}/checkpoint-done` e exibição do autor no toast FE (`autorNick` pode ser `null` no fluxo legado via `ArtefatoController`). [Source: `ycognio-core/.../artifacts/domain/event/ArtefatoCommitado.java`] |

---

## Documento B.6: LinkAcesso

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `linkacesso` |
| **Nome de Negócio** | "Link de Acesso" |
| **Módulo** | `ycognio` |
| **Tipo** | Entity (value object com identidade) |
| **Descrição** | URL multi-uso único com TTL que serve como ponto de entrada ao Ycognio. Uma mesma URL é compartilhada com todos os participantes do projeto e pode ser usada múltiplas vezes durante o TTL configurado. Expira apenas ao atingir o TTL — não invalida após primeiro acesso. Gerado pelo YC Analyst e compartilhado por canal externo (e-mail, mensagem direta). |
| **Ciclo de Vida** | `valido` → `expirado` |
| **Link para FR** | FR-ACC-01, FR-ACC-04 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `d4e9f2c7-...` |
| `projetoId` | UUID (FK → Projeto) | Sim | — | — | `a7b9c3e1-...` |
| `token` | UUID | Sim (auto) | Único; gerado aleatoriamente; imutável após criação | — | `8f3a1d9c-...` |
| `ttl` | Integer | Sim | Duração em horas; > 0; ex: 24 horas; imutável após criação | `24` | `24` |
| `expiracaoEm` | Timestamp | Sim (auto) | Calculado como `criadoEm + ttl horas`; ISO 8601; imutável após criação | calculado | `2026-04-19T10:00:00Z` |
| `criadoEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T10:00:00Z` |
| `criadoPor` | String | Sim | Nick do YC Analyst que gerou o link | — | `Julio (YC Analyst)` |
| `papel` | Enum (`PO`/`YC_ANALYST`/`GUEST`) | Sim | Papel que o portador do link assumirá ao entrar na sala. Adicionado em EP-04.S2 v1.2 + migration V8 (2026-04-22) para permitir que link embarque a regra de papel desde a origem; evita ambiguidade na tela de ingresso. Imutável após criação. | — | `YC_ANALYST` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| LinkAcesso → Projeto | N:1 | Um Link pertence a um Projeto | `projetoId` (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-L-01 | Multi-uso durante TTL | O link pode ser acessado por qualquer número de participantes enquanto `now() < expiracaoEm`. Não há limite de uso por número de acessos — somente o TTL invalida o link. | Obrigatória |
| INV-L-02 | Expiração por TTL | Após atingir `expiracaoEm`, o link é inválido e bloqueia novas entradas. Novo acesso exige geração de novo link pelo YC Analyst. | Obrigatória |
| INV-L-03 | Token imutável | O `token` não pode ser alterado após a criação do link. | Obrigatória |
| INV-L-04 | TTL imutável | O `ttl` (e portanto `expiracaoEm`) não pode ser alterado após a criação do link. | Obrigatória |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `Gerar` | Cria novo link de acesso para o Projeto | YC Analyst | Projeto deve existir | Link criado com `expiracaoEm` calculado; evento `LinkGerado` disparado |
| `Invalidar` | Expira o link por atingimento do TTL | Sistema (automático ao atingir `expiracaoEm`) | `now() >= expiracaoEm` | Link não aceita novos acessos; evento `LinkExpirado` disparado |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `LinkGerado` | `Gerar` executado | `{ linkId, projetoId, token, expiracaoEm, criadoPor }` |
| `LinkExpirado` | TTL atingido (`now() >= expiracaoEm`) | `{ linkId, projetoId, expiracaoEm }` |

---

## Documento B.7: FormularioFeedback

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `formulariofeedback` |
| **Nome de Negócio** | "Formulário de Feedback" |
| **Módulo** | `ycognio` |
| **Tipo** | Entity |
| **Descrição** | Componente de coleta de avaliação qualitativa com dois tipos distintos: NPS_PO (exibido ao PO ao final de cada Sessão — 1 por Sessão) e NPS_ARQUITETO_RECEPTOR (enviado via link em e-mail ao Arquiteto Receptor junto ao PDF do PRD — 1 por Projeto, gerado uma única vez). Invariante: NPS_ARQUITETO_RECEPTOR é 1 por Projeto porque o envio do PDF + link NPS ocorre uma única vez, quando o PO marca aprovação do PRD — não se repete por sessão. |
| **Ciclo de Vida** | `emitido` → `respondido` |
| **Link para FR** | FR-FBK-01, FR-FBK-02, FR-FBK-03 |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | — | `g7a3d5e1-...` |
| `tipo` | Enum | Sim | Valores: `NPS_PO`, `NPS_ARQUITETO_RECEPTOR` | — | `NPS_PO` |
| `sessaoId` | UUID (FK → Sessao) | Condicional | Obrigatório se `tipo = NPS_PO`; `null` se `tipo = NPS_ARQUITETO_RECEPTOR` | `null` | `b3d1e7a2-...` |
| `projetoId` | UUID (FK → Projeto) | Sim | — | — | `a7b9c3e1-...` |
| `perguntas` | Array[PerguntaNPS] | Sim | NPS_PO: máx 3 perguntas; NPS_ARQUITETO_RECEPTOR: máx 5 perguntas | — | _(ver estrutura abaixo)_ |
| `canal` | Enum | Sim | Valores: `MODAL_NO_CHAT`, `LINK_EM_EMAIL` | — | `MODAL_NO_CHAT` |
| `obrigatorio` | Boolean | Sim | — | `true` | `true` |
| `respondido` | Boolean | Sim | — | `false` | `true` |
| `respondidoEm` | Timestamp | Não | ISO 8601; preenchido ao responder | `null` | `2026-04-18T11:05:00Z` |
| `respondidoPor` | String | Não | Nick ou e-mail do respondente; preenchido ao responder | `null` | `Ana (PO)` |
| `respostas` | Array[RespostaNPS] | Não | Array vazio até ser respondido | `[]` | _(ver estrutura abaixo)_ |
| `emitidoEm` | Timestamp | Sim (auto) | ISO 8601 | `now()` | `2026-04-18T11:00:00Z` |

**Estrutura de PerguntaNPS**:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `ordem` | Integer | Posição da pergunta no formulário |
| `enunciado` | String | Texto da pergunta |
| `tipoResposta` | Enum | `ESCALA_0_10` ou `TEXTO` |
| `obrigatoria` | Boolean | Se resposta é obrigatória para submeter |

**Estrutura de RespostaNPS**:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `perguntaOrdem` | Integer | Referência à `ordem` da pergunta respondida |
| `valorNumerico` | Integer | Preenchido se `tipoResposta = ESCALA_0_10`; range 0–10 |
| `valorTexto` | String | Preenchido se `tipoResposta = TEXTO` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| FormularioFeedback → Sessao | N:1 (condicional) | FormularioFeedback do tipo NPS_PO pertence a uma Sessão | `sessaoId` (FK, nullable) |
| FormularioFeedback → Projeto | N:1 | Todo FormularioFeedback pertence a um Projeto | `projetoId` (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-F-01 | NPS_PO: 1 por Sessao | Não podem existir dois FormularioFeedback do tipo `NPS_PO` para a mesma `sessaoId`. | Obrigatória |
| INV-F-02 | NPS_ARQUITETO_RECEPTOR: 1 por Projeto | Não podem existir dois FormularioFeedback do tipo `NPS_ARQUITETO_RECEPTOR` para o mesmo `projetoId`. O envio ocorre uma única vez, junto ao PDF do PRD aprovado. | Obrigatória [INFERIDO — consistência com ciclo de vida do Projeto] |
| INV-F-03 | NPS_PO exige `sessaoId` | Se `tipo = NPS_PO`, o campo `sessaoId` deve estar preenchido. | Obrigatória |
| INV-F-04 | NPS_ARQUITETO_RECEPTOR via e-mail | Se `tipo = NPS_ARQUITETO_RECEPTOR`, `canal` deve ser `LINK_EM_EMAIL`. O formulário é enviado junto ao PDF do PRD, não exibido no modal do chat. | Obrigatória |
| INV-F-05 | Quantidade fixa de perguntas | NPS_PO: máximo 3 perguntas. NPS_ARQUITETO_RECEPTOR: **exatamente 4 perguntas** (1 NPS escala 0-10 + 3 complementares qualitativas — conteúdo das 3 complementares a definir em deploy). | Obrigatória |

---

### Ações/Operações (Commands)

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `Emitir` | Cria e apresenta formulário ao respondente | Sistema (automático) | Para NPS_PO: ao encerrar sessão com `CHECKPOINT_CONFIRMADO`; para NPS_ARQUITETO_RECEPTOR: ao disparar `GerarPDFEEnviar` do Projeto | Formulário criado com `respondido = false`; evento `FeedbackEmitido` disparado |
| `Responder` | Registra respostas do respondente | PO (NPS_PO) ou Arquiteto Receptor (NPS_ARQUITETO_RECEPTOR) | `respondido = false` | `respondido = true`; `respondidoEm = now()`; `respondidoPor` preenchido; `respostas` populado; evento `FeedbackRespondido` disparado |

---

### Eventos de Negócio Relacionados

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `FeedbackEmitido` | `Emitir` executado | `{ formularioId, tipo, projetoId, sessaoId, canal, emitidoEm }` |
| `FeedbackRespondido` | `Responder` executado | `{ formularioId, tipo, respondidoPor, respondidoEm, respostas[] }` |

---

## Diagrama de Relacionamentos — ERD Narrativo

```
[Projeto] (1) ──────────────────── (N) [Sessao]
    │                                      │
    │                                      ├── (N) [Participante]
    │                                      │         │
    │                                      │         └── usa ── (0..1) [LinkAcesso]
    │                                      │
    │                                      ├── (N) [Mensagem]
    │                                      │         │
    │                                      │         └── enviada por ── [Participante]
    │                                      │
    │                                      └── (0..1) [FormularioFeedback tipo:NPS_PO]
    │
    ├── (N) [Artefato]
    │
    ├── (N) [LinkAcesso]
    │
    └── (0..1) [FormularioFeedback tipo:NPS_ARQUITETO_RECEPTOR]
```

**Descrição narrativa**:

- Um **Projeto** agrupa N **Sessões** ao longo do tempo. O encerramento de uma Sessão não encerra o Projeto — o Projeto só conclui com `prdAprovado = true`.
- Uma **Sessão** contém N **Participantes** (incluindo agentes representados como Participante do tipo AGENTE), N **Mensagens** e 0..1 **FormularioFeedback** do tipo NPS_PO.
- Um **Participante** pode ter acessado via **LinkAcesso** (link de acesso do Projeto — multi-uso durante TTL; vários participantes podem usar o mesmo link).
- Uma **Mensagem** é enviada por um único **Participante** e pertence a uma única **Sessão**. Mensagens são imutáveis.
- Um **Artefato** pertence a um **Projeto** e registra cada arquivo gerado pelos agentes, com rastreabilidade ao commit GitHub.
- Um **LinkAcesso** pertence a um **Projeto** e é multi-uso único: uma mesma URL é compartilhada com todos os participantes e pode ser acessada múltiplas vezes durante o TTL. Expira exclusivamente por TTL.
- Um **FormularioFeedback** do tipo **NPS_PO** está associado a uma **Sessão** específica (1 por Sessão). O **NPS_ARQUITETO_RECEPTOR** está associado ao **Projeto** (1 por Projeto — enviado uma única vez junto ao PDF do PRD aprovado).

---

## Rastreabilidade

| Documento neste Anexo | FRs no PRD | Jornadas no PRD | Metadados (Seção 10 PRD) |
|----------------------|-----------|-----------------|--------------------------|
| B.1: Projeto | FR-ACC-01, FR-ACC-02, FR-VIS-03, FR-PER-01, FR-FBK-02 | A.1, A.2, B.1, C.1 | `documentos[0]: projeto` |
| B.2: Sessao | FR-PER-04, FR-TEL-02, FR-FBK-01, FR-VIS-03, FR-VIS-05 | A.1, A.2, B.1 | `documentos[1]: sessao` |
| B.3: Participante | FR-ACC-03, FR-CHT-02, FR-CHT-03, FR-VIS-04, FR-PER-02 | A.1, A.2, B.1, C.1 | `documentos[2]: participante` |
| B.4: Mensagem | FR-CHT-01, FR-CHT-02, FR-CHT-03, FR-CHT-04, FR-CHT-05, FR-TEL-02 | A.1, A.2, B.1, C.1 | `documentos[3]: mensagem` |
| B.5: Artefato | FR-PER-01, FR-PER-03, FR-VIS-02 | A.1, A.2, B.1 | `documentos[4]: artefato` |
| B.6: LinkAcesso | FR-ACC-01, FR-ACC-04 | A.1, A.2, B.1, C.1 | `documentos[5]: linkacesso` |
| B.7: FormularioFeedback | FR-FBK-01, FR-FBK-02, FR-FBK-03 | A.1, A.2 | `documentos[6]: formulariofeedback` |

---

**Versão**: 1.0
**Data**: 2026-04-18
**Responsável**: Analista de Negócio (Sofia)
**Consumidores**: Arquiteto de Documentos (para gerar `spec_documentos.json` — YCL-domain)
