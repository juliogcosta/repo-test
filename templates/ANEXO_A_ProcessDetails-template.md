---
# Frontmatter
anexo_type: "process_details"
parent_document: "PRD.md"
created_at: null
last_updated: null
version: "1.0"

# ========================================
# RASTREABILIDADE DE REQUISITOS (v3.2)
# ========================================
# Adicione IDs estruturados para cada processo documentado abaixo.
# Formato de ID: PROC-{bc_id}-XXX (conforme ID_SCHEMA.yaml)
# Exemplo:
#   processes:
#     - id: "PROC-lic-001"
#       title: "Workflow de Aprovação de Edital"
#       bounded_context: "licitacao"
#       linked_frs: ["FR-010"]
#       linked_journeys: ["UJ-04-001"]
#       linked_documents: ["DOC-lic-Edital"]
#       type: "Semi-automático"

processes:
  - id: "PROC-{bc_id}-001"  # PREENCHER bc_id: Ex: PROC-lic-001
    title: "Processo 1 - [Preencher com título do primeiro processo]"
    bounded_context: "{bc_id}"  # PREENCHER: Ex: "licitacao" (^[a-z]+$)
    linked_frs: []  # PREENCHER: Ex: ["FR-010"]
    linked_journeys: []  # PREENCHER: Ex: ["UJ-04-001"]
    linked_documents: []  # PREENCHER: Ex: ["DOC-lic-Edital"]
    type: "Manual"  # Manual | Automático | Semi-automático
    frequency: ""  # Ex: "20-30x por mês"
    avg_duration: ""  # Ex: "15 minutos"
    sla: ""  # Ex: "Aprovar em até 24 horas"
    notes: "Preencher após escrever Processo A.1"

  - id: "PROC-{bc_id}-002"  # PREENCHER bc_id
    title: "Processo 2 - [Preencher com título do segundo processo]"
    bounded_context: "{bc_id}"
    linked_frs: []
    linked_journeys: []
    linked_documents: []
    type: "Manual"
    frequency: ""
    avg_duration: ""
    sla: ""
    notes: "Preencher após escrever Processo A.2"

  - id: "PROC-{bc_id}-003"  # PREENCHER bc_id
    title: "Processo 3 - [Preencher com título do terceiro processo]"
    bounded_context: "{bc_id}"
    linked_frs: []
    linked_journeys: []
    linked_documents: []
    type: "Automático"
    frequency: ""
    avg_duration: ""
    sla: ""
    notes: "Preencher após escrever Processo A.3"

  # Adicionar mais processos conforme necessário
  # IMPORTANTE: bc_id deve seguir naming convention Forger (^[a-z]+$, sem acentos/espaços)
---

# ANEXO A: Process Details — {PROJECT_ALIAS}

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Detalhar processos de negócio mapeados, etapas, responsáveis, regras
> **Consumidores**: Arquiteto de Processos (gera spec_processos.json - BPMN)

---

## Instruções de Uso

Este anexo detalha os **processos de negócio** identificados nas **User Journeys (Seção 4 do PRD)**.

**Diferença entre User Journey e Process**:
- **User Journey** (PRD Seção 4): Foca na **experiência do usuário** (needs, pains, outcomes)
- **Process Details** (este anexo): Foca na **execução operacional** (etapas, sistemas, regras, BPMN)

**Exemplo**:
- Journey 4.1: "Gerente aprova licitação" → **o quê o usuário vive**
- Process A.1: "Workflow de Aprovação de Edital" → **como o sistema executa**

---

## Processo A.1: {Nome do Processo}

**Exemplo**: Processo A.1: Workflow de Aprovação de Edital

---

### Metadados do Processo

| Campo | Valor |
|-------|-------|
| **ID Técnico** | {process_id} (ex: `aprovacao_edital`) |
| **Nome de Negócio** | {Nome completo} (ex: "Aprovação de Edital de Licitação") |
| **Módulo** | {modulo_id} (ex: `licitacao`) |
| **Tipo** | {Manual / Automático / Semi-automático} |
| **Frequência** | {Ex: 20-30x por mês} |
| **Tempo Médio** | {Ex: 15 minutos} |
| **SLA** | {Ex: Aprovar em até 24 horas} |
| **Responsável Principal** | {Papel} (ex: Gerente de Compras) |
| **Link para FR** | {FR-XXX} (ex: FR-010) |
| **Link para Journey** | {Journey X.Y} (ex: Journey 4.1) |

---

### Objetivo do Processo

{Descreva em 1-2 frases o que este processo alcança}

**Exemplo**:
> Validar edital criado por Analista, garantir conformidade com Lei de Licitações, e publicar automaticamente se aprovado.

---

### Participantes (Atores)

| Ator | Papel | Responsabilidades no Processo |
|------|-------|-------------------------------|
| {actor_id} | {Nome do Papel} | {O que faz?} |

**Exemplo**:

| Ator | Papel | Responsabilidades no Processo |
|------|-------|-------------------------------|
| `analista_licitacoes` | Analista de Licitações | Criar rascunho, preencher campos, submeter para aprovação |
| `gerente_compras` | Gerente de Compras | Revisar edital, aprovar ou solicitar correção |
| `sistema` | Sistema (automático) | Publicar edital, enviar notificações, atualizar status |

---

### Pré-condições

{O que DEVE ser verdade antes do processo iniciar?}

**Exemplo**:
- Analista autenticado e autorizado (role = `analista_licitacoes`)
- Edital em status "Rascunho" ou "Devolvido"
- Campos obrigatórios preenchidos (validação FR-003)

---

### Pós-condições (Sucesso)

{O que SERÁ verdade se processo completar com sucesso?}

**Exemplo**:
- Edital em status "Aberto" (se aprovado) OU "Rascunho" (se devolvido)
- Notificações enviadas para atores relevantes (FR-001)
- Log de auditoria registrado (NFR-006)

---

### Fluxo Principal (Happy Path)

{Descreva o fluxo passo a passo quando tudo funciona perfeitamente}

**Formato**:
```
[Ator] → [Ação] → [Sistema Responde] → [Próximo Estado]
```

**Exemplo**:

#### **Etapa 1: Analista Submete Edital para Aprovação**

**Ator**: Analista de Licitações

**Ação**:
1. Acessa tela de edital (status "Rascunho")
2. Revisa campos preenchidos
3. Clica botão "Submeter para Aprovação"

**Sistema Responde**:
- Valida campos obrigatórios (FR-003)
- Se validação OK:
  - Muda status: "Rascunho" → "Aguardando Aprovação"
  - Gera evento: `EditalSubmetidoParaAprovacao`
  - Envia notificação para Gerente (FR-001)
  - Registra log de auditoria (NFR-006)
  - Exibe mensagem: "Edital submetido com sucesso. Gerente foi notificado."

**Próximo Estado**: Edital aguardando aprovação

**Tempo Estimado**: 30 segundos

**Regras de Negócio**:
- RN-001: Campos obrigatórios devem estar preenchidos
- RN-002: Analista não pode submeter edital de outra pessoa (ownership validation)

---

#### **Etapa 2: Gerente Recebe Notificação**

**Ator**: Sistema (automático)

**Ação**:
- Evento `EditalSubmetidoParaAprovacao` dispara notificação

**Sistema Responde**:
- Envia email para Gerente com:
  - Assunto: "Novo edital aguardando aprovação: {numero_edital}"
  - Corpo: Resumo executivo (número, objeto, valor, prazo)
  - Link: Acesso direto ao edital no sistema
- Registra notificação enviada (log)

**Tempo Estimado**: < 5 minutos (SLA de notificação)

---

#### **Etapa 3: Gerente Revisa Edital**

**Ator**: Gerente de Compras

**Ação**:
1. Acessa email, clica no link
2. Visualiza edital completo
3. Revisa: objeto, valor, prazo, critérios técnicos, documentos anexos

**Sistema Responde**:
- Carrega tela de detalhe do edital em < 2 segundos (NFR-001)
- Exibe botões: "Aprovar" e "Solicitar Correção"

**Tempo Estimado**: 5-15 minutos

---

#### **Etapa 4: Gerente Aprova Edital**

**Ator**: Gerente de Compras

**Ação**:
1. Clica botão "Aprovar"
2. Confirma em modal de confirmação

**Sistema Responde**:
- Valida: user role = `gerente_compras` (authorization)
- Muda status: "Aguardando Aprovação" → "Aprovado"
- Gera evento: `EditalAprovado`
- Dispara publicação automática (próxima etapa)
- Registra log de auditoria (NFR-006)

**Próximo Estado**: Edital aprovado (pronto para publicação)

**Tempo Estimado**: 10 segundos

---

#### **Etapa 5: Sistema Publica Edital Automaticamente**

**Ator**: Sistema (automático)

**Ação**:
- Evento `EditalAprovado` dispara publicação

**Sistema Responde**:
- Muda status: "Aprovado" → "Aberto"
- Gera `numero_edital` (formato YYYY/NNNN)
- Define `data_abertura` = now()
- Define `data_encerramento` = data_abertura + prazo configurado
- Gera evento: `EditalPublicado`
- Envia notificações:
  - Email para Analista: "Seu edital foi aprovado e publicado"
  - Email para Fornecedores cadastrados na categoria: "Novo edital disponível"
- Registra log de auditoria (NFR-006)

**Próximo Estado**: Edital aberto (recebendo propostas)

**Tempo Estimado**: < 30 segundos

**Regras de Negócio**:
- RN-010: Edital publicado torna-se read-only (não pode ser editado)
- RN-011: Fornecedores podem enviar propostas até `data_encerramento`

---

### Fluxos Alternativos

{Descreva cenários que desviam do happy path}

---

#### **Alt-1: Gerente Solicita Correção**

**Quando**: Gerente identifica erro ou incompletude no edital

**Etapa 4 (alternativa)**:

**Ator**: Gerente de Compras

**Ação**:
1. Clica botão "Solicitar Correção"
2. Preenche campo de comentários (obrigatório, min 20 chars)
3. Confirma

**Sistema Responde**:
- Valida: comentário não vazio
- Muda status: "Aguardando Aprovação" → "Rascunho"
- Gera evento: `EditalDevolvidoParaCorrecao`
- Envia notificação para Analista com comentários do Gerente (FR-001)
- Registra log de auditoria (NFR-006)

**Próximo Estado**: Edital devolvido para Analista corrigir

**Analista**:
- Recebe notificação
- Acessa edital, vê comentários do Gerente
- Corrige campos
- Re-submete (volta para Etapa 1)

---

#### **Alt-2: Validação Falha na Submissão**

**Quando**: Analista tenta submeter edital com campos obrigatórios faltando

**Etapa 1 (alternativa)**:

**Ator**: Analista de Licitações

**Ação**:
1. Clica "Submeter para Aprovação"

**Sistema Responde**:
- Valida campos (FR-003)
- Detecta: campo `objeto` vazio (obrigatório)
- **NÃO** muda status
- Exibe mensagem de erro inline: "Campo 'Objeto' é obrigatório. Mínimo 100 caracteres."
- Foca campo com erro

**Próximo Estado**: Edital continua em "Rascunho"

**Analista**: Corrige campo, tenta submeter novamente

---

### Fluxos de Exceção

{Descreva cenários de erro técnico}

---

#### **Exc-1: Falha no Envio de Notificação**

**Quando**: Sistema tenta enviar email mas serviço de email está indisponível

**Etapa 2 (exceção)**:

**Sistema Responde**:
- Tenta enviar email
- Timeout após 30 segundos
- Registra erro em log: "Notificação falhou para {email_gerente}"
- Adiciona notificação em fila de retry (tentar novamente em 5 min, max 3 tentativas)
- **NÃO bloqueia processo** (edital continua em "Aguardando Aprovação")

**Gerente**:
- Pode não receber email imediatamente
- Pode acessar dashboard manualmente e ver edital pendente (FR-005)

---

### Regras de Negócio Específicas

{Liste regras que se aplicam a este processo}

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| {RN-XXX} | {Nome da Regra} | {Descrição} | {Obrigatória / Desejável} |

**Exemplo**:

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| RN-001 | Campos obrigatórios | Edital só pode ser submetido se todos os campos obrigatórios estão preenchidos | ⚠️ Obrigatória |
| RN-010 | Imutabilidade pós-publicação | Edital com status "Aberto" ou "Encerrado" não pode ter campos editados (apenas cancelamento permitido) | ⚠️ Obrigatória |
| RN-015 | Prazo mínimo | `data_encerramento` >= `data_abertura` + 15 dias (Lei de Licitações) | ⚠️ Obrigatória |
| RN-020 | Autorização de aprovação | Apenas usuários com role `gerente_compras` podem aprovar editais | ⚠️ Obrigatória |

---

### Eventos de Negócio Gerados

{Liste domain events que este processo dispara}

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| {EventoNome} | {Trigger} | {Dados do evento} |

**Exemplo**:

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `EditalSubmetidoParaAprovacao` | Analista clica "Submeter" e validação passa | `{edital_id, analista_id, timestamp}` |
| `EditalAprovado` | Gerente clica "Aprovar" | `{edital_id, gerente_id, timestamp}` |
| `EditalDevolvidoParaCorrecao` | Gerente clica "Solicitar Correção" | `{edital_id, gerente_id, comentarios, timestamp}` |
| `EditalPublicado` | Sistema publica após aprovação | `{edital_id, numero_edital, data_abertura, data_encerramento}` |

---

### Diagrama BPMN Narrativo

{Descreva fluxo em formato textual BPMN-like para Arquiteto de Processos traduzir}

```
[START] Analista submete edital

→ [TASK: Validar campos obrigatórios]
  ↓ (se validação falha)
  → [END: Exibir erro, continuar em Rascunho]

  ↓ (se validação OK)
→ [TASK: Mudar status → Aguardando Aprovação]

→ [EVENT: EditalSubmetidoParaAprovacao]

→ [TASK: Enviar notificação para Gerente]
  ↓ (retry se falhar, não bloqueia)

→ [WAIT: Aguardar ação do Gerente]

→ [GATEWAY (Exclusive): Gerente decide]

  ↓ BRANCH 1: Aprovado
  → [TASK: Mudar status → Aprovado]
  → [EVENT: EditalAprovado]
  → [TASK: Publicar edital automaticamente]
  → [TASK: Definir datas, gerar número]
  → [TASK: Mudar status → Aberto]
  → [EVENT: EditalPublicado]
  → [TASK: Notificar Analista + Fornecedores]
  → [END: Edital publicado e aberto]

  ↓ BRANCH 2: Solicitar Correção
  → [TASK: Mudar status → Rascunho]
  → [EVENT: EditalDevolvidoParaCorrecao]
  → [TASK: Notificar Analista com comentários]
  → [END: Edital devolvido para correção]
```

---

### Integrações com Sistemas Externos

{Se este processo chama APIs externas ou sistemas legados, detalhe aqui}

| Sistema | Quando Chamado | Dados Enviados | Dados Recebidos | Timeout | Retry Policy |
|---------|----------------|----------------|-----------------|---------|--------------|
| {Sistema X} | {Etapa Y} | {Payload} | {Response} | {Xs} | {N tentativas} |

**Exemplo (se aplicável)**:

| Sistema | Quando Chamado | Dados Enviados | Dados Recebidos | Timeout | Retry Policy |
|---------|----------------|----------------|-----------------|---------|--------------|
| Portal ComprasNet | Após publicação (Etapa 5) | `{numero_edital, objeto, data_encerramento}` | `{confirmacao_publicacao_id}` | 30s | 3 tentativas (5 min intervalo) |

---

### Métricas e Monitoramento

{Como este processo será medido?}

| Métrica | Target | Como Medir |
|---------|--------|------------|
| {Nome da métrica} | {Valor esperado} | {Ferramenta/método} |

**Exemplo**:

| Métrica | Target | Como Medir |
|---------|--------|------------|
| Tempo médio de aprovação | < 24 horas (SLA) | Tempo entre `EditalSubmetidoParaAprovacao` e `EditalAprovado` |
| Taxa de devolução | < 20% | (Editais devolvidos) / (Editais submetidos) |
| Taxa de notificações falhadas | < 5% | Log de erros de email service |

---

## Processo A.2: {Nome do Segundo Processo}

{Repetir estrutura acima para cada processo mapeado}

**Exemplo**: Processo A.2: Recebimento de Propostas

{Detalhar com mesma estrutura: Metadados, Objetivo, Participantes, Pré/Pós-condições, Fluxo Principal, Alternativos, Exceções, Regras, Eventos, BPMN, Integrações, Métricas}

---

## Processo A.3: {Nome do Terceiro Processo}

{Exemplo}: Processo A.3: Homologação e Geração de Contrato

---

## Glossário de Termos Técnicos de Processo

{Defina termos específicos usados neste anexo}

| Termo | Definição |
|-------|-----------|
| **Happy Path** | Fluxo principal quando tudo funciona perfeitamente, sem erros ou exceções |
| **Fluxo Alternativo** | Cenário válido que desvia do happy path (ex: usuário escolhe opção B em vez de A) |
| **Fluxo de Exceção** | Cenário de erro técnico que interrompe fluxo normal (ex: timeout, falha de sistema) |
| **Domain Event** | Evento de negócio que aconteceu e deve ser registrado (ex: EditalAprovado) |
| **BPMN Gateway** | Ponto de decisão no processo (Exclusive = escolhe 1 caminho, Parallel = executa múltiplos) |
| **SLA (Service Level Agreement)** | Compromisso de tempo máximo para completar operação |

---

## Rastreabilidade

{Mapeamento deste anexo para PRD}

| Processo neste Anexo | FR no PRD | Journey no PRD | NFR no PRD |
|---------------------|-----------|----------------|------------|
| A.1: Aprovação Edital | FR-010 | Journey 4.1 | NFR-006 (Auditoria) |
| A.2: Recebimento Propostas | FR-015 | Journey 4.3 | NFR-001 (Performance) |
| A.3: Homologação | FR-020 | Journey 4.1 | NFR-006 (Auditoria) |

---

**Versão**: 1.0
**Data**: {YYYY-MM-DD}
**Responsável**: Analista de Negócio (Sofia)
**Consumidores**: Arquiteto de Processos (para gerar spec_processos.json - BPMN 2.0)
