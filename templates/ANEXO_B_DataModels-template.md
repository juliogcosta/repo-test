---
# Frontmatter
anexo_type: "data_models"
parent_document: "PRD.md"
created_at: null
last_updated: null
version: "1.0"

# ========================================
# RASTREABILIDADE DE REQUISITOS (v3.2)
# ========================================
# Adicione IDs estruturados para cada documento e invariante documentados abaixo.
# Formato de ID Documento: DOC-{bc_id}-{TechnicalName} (conforme ID_SCHEMA.yaml)
# Formato de ID Invariante: INV-XXX (conforme ID_SCHEMA.yaml)
# Exemplo:
#   documents:
#     - id: "DOC-lic-Edital"
#       negocio: "Edital de Licitação"
#       tecnico_id: "Edital"
#       bounded_context: "licitacao"
#       linked_frs: ["FR-002", "FR-003", "FR-010"]
#       linked_journeys: ["UJ-04-001", "UJ-04-002"]
#       type: "Aggregate Root"
#
#   invariants:
#     - id: "INV-001"
#       description: "Edital.data_abertura < Edital.data_encerramento"
#       severity: "CRITICAL"
#       linked_documents: ["DOC-lic-Edital"]
#       linked_frs: ["FR-002"]

documents:
  - id: "DOC-{bc_id}-{TechnicalName}"  # PREENCHER: Ex: DOC-lic-Edital
    negocio: "Documento 1 - [Preencher com nome de negócio]"
    tecnico_id: "{TechnicalName}"  # PREENCHER PascalCase: Ex: "Edital"
    bounded_context: "{bc_id}"  # PREENCHER: Ex: "licitacao" (^[a-z]+$)
    linked_frs: []  # PREENCHER: Ex: ["FR-002", "FR-003"]
    linked_journeys: []  # PREENCHER: Ex: ["UJ-04-001"]
    linked_processes: []  # PREENCHER: Ex: ["PROC-lic-001"]
    type: "Aggregate Root"  # Aggregate Root | Entity | Value Object
    notes: "Preencher após escrever Documento B.1"

  - id: "DOC-{bc_id}-{TechnicalName}"  # PREENCHER
    negocio: "Documento 2 - [Preencher com nome de negócio]"
    tecnico_id: "{TechnicalName}"
    bounded_context: "{bc_id}"
    linked_frs: []
    linked_journeys: []
    linked_processes: []
    type: "Aggregate Root"
    notes: "Preencher após escrever Documento B.2"

  - id: "DOC-{bc_id}-{TechnicalName}"  # PREENCHER
    negocio: "Documento 3 - [Preencher com nome de negócio]"
    tecnico_id: "{TechnicalName}"
    bounded_context: "{bc_id}"
    linked_frs: []
    linked_journeys: []
    linked_processes: []
    type: "Entity"
    notes: "Preencher após escrever Documento B.3"

  # Adicionar mais documentos conforme necessário
  # IMPORTANTE: bc_id e TechnicalName devem seguir naming convention Forger

invariants:
  - id: "INV-001"
    description: "[Preencher com invariante 1 - regra que sempre deve ser verdadeira]"
    severity: "CRITICAL"  # CRITICAL | HIGH | MEDIUM | LOW
    linked_documents: []  # PREENCHER: Ex: ["DOC-lic-Edital"]
    linked_frs: []  # PREENCHER: Ex: ["FR-002"]
    validation_type: "structural"  # structural | business_rule | constraint
    notes: "Preencher conforme tabela de invariantes no texto"

  - id: "INV-002"
    description: "[Preencher com invariante 2]"
    severity: "HIGH"
    linked_documents: []
    linked_frs: []
    validation_type: "business_rule"
    notes: "Preencher conforme tabela de invariantes no texto"

  - id: "INV-003"
    description: "[Preencher com invariante 3]"
    severity: "CRITICAL"
    linked_documents: []
    linked_frs: []
    validation_type: "constraint"
    notes: "Preencher conforme tabela de invariantes no texto"

  # Adicionar mais invariantes conforme necessário
  # Os IDs INV-XXX devem corresponder aos IDs usados nas tabelas de invariantes no texto abaixo
---

# ANEXO B: Data Models — {PROJECT_ALIAS}

> **Responsável**: Analista de Negócio (Sofia)
> **Objetivo**: Detalhar documentos/entidades de dados, campos, relacionamentos, regras de validação
> **Consumidores**: Arquiteto de Documentos (gera spec_documentos.json - YCL-domain)

---

## Instruções de Uso

Este anexo detalha as **estruturas de dados** (documentos, entidades) identificados nas **User Journeys** e **FRs do PRD**.

**Nível de detalhe**: Este anexo é **técnico** mas usa **linguagem de negócio**. Arquiteto traduzirá para YCL-domain (aggregates, entities, value objects).

---

## Documento B.1: {Nome do Documento}

**Exemplo**: Documento B.1: Edital de Licitação

---

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | {doc_id} (ex: `Edital`) |
| **Nome de Negócio** | {Nome completo} (ex: "Edital de Licitação") |
| **Módulo** | {modulo_id} (ex: `licitacao`) |
| **Tipo** | {Aggregate Root / Entity / Value Object} |
| **Descrição** | {1-2 frases sobre o que representa} |
| **Ciclo de Vida** | {Criado → Aprovado → Publicado → Encerrado → Arquivado} |
| **Retenção de Dados** | {Ex: 5 anos após encerramento (Lei de Licitações)} |
| **Link para FR** | {FR-XXX} (ex: FR-002, FR-003, FR-010) |

**Exemplo**:

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `Edital` |
| **Nome de Negócio** | "Edital de Licitação" |
| **Módulo** | `licitacao` |
| **Tipo** | Aggregate Root (entidade principal do módulo Licitações) |
| **Descrição** | Representa um edital de licitação pública com especificações técnicas, prazos e critérios de avaliação |
| **Ciclo de Vida** | Rascunho → Aguardando Aprovação → Aprovado → Aberto → Encerrado → Arquivado |
| **Retenção de Dados** | 5 anos após encerramento (conformidade Lei nº 8.666/93) |
| **Link para FR** | FR-002 (Criar edital), FR-003 (Validações), FR-010 (Aprovação) |

---

### Estrutura de Campos

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| {campo_nome} | {tipo} | Sim/Não | {regras} | {default} | {valor exemplo} |

**Exemplo**:

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | Gerado automaticamente | - | `550e8400-e29b-41d4-a716-446655440000` |
| `numero_edital` | String | Sim (auto) | Formato: `YYYY/NNNN`, sequencial por ano | Gerado na publicação | `2026/0042` |
| `objeto` | String (Text) | Sim | Min 100 chars, Max 5000 chars | - | "Aquisição de 50 notebooks Dell Latitude 5520..." |
| `valor_estimado` | Decimal(15,2) | Sim | > 0, <= 100000000 | - | `125000.50` |
| `data_abertura` | Date | Sim (auto) | Gerada na publicação | - | `2026-04-15` |
| `data_encerramento` | Date | Sim (auto) | >= `data_abertura` + 15 dias | - | `2026-05-01` |
| `prazo_entrega_propostas_dias` | Integer | Sim | >= 15, <= 180 | `15` | `16` |
| `status` | Enum | Sim | Valores: `Rascunho`, `Aguardando Aprovação`, `Aprovado`, `Aberto`, `Encerrado`, `Cancelado` | `Rascunho` | `Aberto` |
| `categoria` | String | Sim | Lista pré-definida (ver Entidade B.5: Categoria) | - | `Equipamentos de TI` |
| `criterio_avaliacao` | Enum | Sim | Valores: `Menor Preço`, `Técnica e Preço`, `Melhor Técnica` | `Menor Preço` | `Menor Preço` |
| `documento_edital_anexo` | File (PDF) | Não | Max 10 MB, formato PDF | - | `edital_2026_0042.pdf` |
| `criado_por` | UUID (FK → Usuario) | Sim (auto) | ID do usuário (Analista) | - | `{user_id}` |
| `aprovado_por` | UUID (FK → Usuario) | Não | ID do Gerente (preenchido ao aprovar) | `null` | `{gerente_id}` |
| `created_at` | Timestamp | Sim (auto) | ISO 8601 | now() | `2026-04-15T14:30:00Z` |
| `updated_at` | Timestamp | Sim (auto) | Atualizado em toda edição | now() | `2026-04-16T09:15:00Z` |
| `publicado_at` | Timestamp | Não | Preenchido ao publicar | `null` | `2026-04-16T10:00:00Z` |

---

### Relacionamentos

{Descreva como este documento se relaciona com outros}

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| {Este Doc} → {Outro Doc} | {1:1 / 1:N / N:N} | {Explicação} | {Campo FK} |

**Exemplo**:

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Edital → Categoria | N:1 | Um edital pertence a uma categoria. Uma categoria tem muitos editais. | `categoria` (FK) |
| Edital → Proposta | 1:N | Um edital pode receber múltiplas propostas. Uma proposta pertence a um edital. | `propostas[]` (collection) |
| Edital → Contrato | 1:1 (opcional) | Um edital pode gerar um contrato após homologação. | `contrato_id` (FK, nullable) |
| Edital → Usuario (criador) | N:1 | Edital criado por um Analista. | `criado_por` (FK) |
| Edital → Usuario (aprovador) | N:1 (opcional) | Edital aprovado por um Gerente (ou null se ainda não aprovado). | `aprovado_por` (FK, nullable) |

---

### Regras de Negócio (Invariantes)

{Regras que SEMPRE devem ser verdadeiras para este documento}

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| {INV-XXX} | {Nome} | {Descrição técnica} | {⚠️ Obrigatória / ✅ Desejável} |

**Exemplo**:

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-001 | Imutabilidade pós-publicação | Edital com status `Aberto` ou `Encerrado` NÃO pode ter campos `objeto`, `valor_estimado`, `prazo_entrega_propostas_dias` editados. Apenas `status` pode mudar (para `Cancelado`). | ⚠️ Obrigatória (Lei de Licitações) |
| INV-002 | Valor positivo | `valor_estimado` SEMPRE > 0 | ⚠️ Obrigatória |
| INV-003 | Prazo mínimo legal | `data_encerramento` >= `data_abertura` + 15 dias corridos | ⚠️ Obrigatória (Lei de Licitações) |
| INV-004 | Transições de status válidas | Apenas transições permitidas: `Rascunho` → `Aguardando Aprovação` → `Aprovado` → `Aberto` → `Encerrado`. `Cancelado` pode vir de qualquer estado. | ⚠️ Obrigatória |
| INV-005 | Aprovador obrigatório | Se status = `Aprovado`, então `aprovado_por` NÃO pode ser `null` | ⚠️ Obrigatória |

---

### Ações/Operações (Commands)

{O que pode ser FEITO com este documento?}

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| {CommandNome} | {O que faz?} | {Role} | {Estados válidos} | {Mudanças} |

**Exemplo**:

| Command | Descrição | Quem Pode Executar | Pré-condições | Efeitos |
|---------|-----------|-------------------|---------------|---------|
| `CriarRascunhoEdital` | Criar novo edital em rascunho | Analista de Licitações | Usuário autenticado | Cria edital com status `Rascunho`, `criado_por` = user_id |
| `EditarEdital` | Modificar campos do edital | Analista (dono) | Status = `Rascunho` OU `Aguardando Aprovação` | Atualiza campos, `updated_at` = now() |
| `SubmeterParaAprovacao` | Enviar para Gerente aprovar | Analista (dono) | Status = `Rascunho`, campos obrigatórios preenchidos | Status → `Aguardando Aprovação`, dispara evento `EditalSubmetidoParaAprovacao` |
| `AprovarEdital` | Aprovar edital | Gerente de Compras | Status = `Aguardando Aprovação` | Status → `Aprovado`, `aprovado_por` = gerente_id, dispara `EditalAprovado` → publica automaticamente |
| `SolicitarCorrecao` | Devolver para Analista corrigir | Gerente de Compras | Status = `Aguardando Aprovação` | Status → `Rascunho`, dispara `EditalDevolvidoParaCorrecao` |
| `PublicarEdital` | Publicar edital (automático) | Sistema | Status = `Aprovado` | Status → `Aberto`, gera `numero_edital`, `data_abertura` = now(), `data_encerramento` = now() + prazo, dispara `EditalPublicado` |
| `CancelarEdital` | Cancelar licitação | Gerente de Compras | Status != `Encerrado` | Status → `Cancelado`, registra motivo (auditoria) |

---

### Eventos de Negócio Relacionados

{Eventos disparados por operações neste documento}

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| {EventoNome} | {Trigger} | {Dados} |

**Exemplo**:

| Evento | Quando Ocorre | Payload |
|--------|---------------|---------|
| `EditalCriado` | `CriarRascunhoEdital` executado | `{edital_id, criado_por, timestamp}` |
| `EditalSubmetidoParaAprovacao` | `SubmeterParaAprovacao` executado | `{edital_id, analista_id, timestamp}` |
| `EditalAprovado` | `AprovarEdital` executado | `{edital_id, gerente_id, timestamp}` |
| `EditalDevolvidoParaCorrecao` | `SolicitarCorrecao` executado | `{edital_id, gerente_id, comentarios, timestamp}` |
| `EditalPublicado` | `PublicarEdital` executado | `{edital_id, numero_edital, data_abertura, data_encerramento}` |
| `EditalCancelado` | `CancelarEdital` executado | `{edital_id, cancelado_por, motivo, timestamp}` |

---

### Índices e Performance

{Campos que precisam de índices para queries frequentes}

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| {campo} | {Unique / Index / Composite} | {Por quê?} |

**Exemplo**:

| Campo(s) | Tipo de Índice | Justificativa |
|----------|----------------|---------------|
| `id` | Primary Key (Unique) | Identificador único |
| `numero_edital` | Unique Index | Número sequencial deve ser único, buscas frequentes por número |
| `status` | Index | Filtros frequentes por status (ex: listar editais "Abertos") |
| `categoria` | Index | Filtros por categoria (ex: fornecedores buscam editais de "TI") |
| `(status, data_encerramento)` | Composite Index | Dashboard de editais pendentes ordenados por prazo (FR-005) |
| `criado_por` | Index | Analista busca "meus editais" |

---

## Documento B.2: {Nome do Segundo Documento}

**Exemplo**: Documento B.2: Proposta

---

### Metadados do Documento

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `Proposta` |
| **Nome de Negócio** | "Proposta de Fornecedor" |
| **Módulo** | `proposta` |
| **Tipo** | Aggregate Root |
| **Descrição** | Proposta enviada por fornecedor em resposta a edital de licitação |
| **Ciclo de Vida** | Rascunho → Enviada → Em Análise → Aprovada/Rejeitada |
| **Link para FR** | FR-015 (Upload proposta) |

---

### Estrutura de Campos

{Repetir estrutura acima}

**Exemplo**:

| Campo | Tipo | Obrigatório? | Validações | Valor Padrão | Exemplo |
|-------|------|--------------|------------|--------------|---------|
| `id` | UUID | Sim (auto) | - | - | `{uuid}` |
| `edital_id` | UUID (FK → Edital) | Sim | Edital deve ter status `Aberto` | - | `{edital_id}` |
| `fornecedor_id` | UUID (FK → Fornecedor) | Sim | Fornecedor com CNPJ ativo | - | `{fornecedor_id}` |
| `valor_proposta` | Decimal(15,2) | Sim | > 0 | - | `118000.00` |
| `arquivo_proposta` | File (PDF) | Sim | Max 10 MB, PDF only | - | `proposta_fornecedor_X.pdf` |
| `data_envio` | Timestamp | Sim (auto) | <= `edital.data_encerramento` | now() | `2026-04-30T23:59:00Z` |
| `status` | Enum | Sim | Valores: `Rascunho`, `Enviada`, `Em Análise`, `Aprovada`, `Rejeitada` | `Rascunho` | `Enviada` |

---

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição | FK / Referência |
|----------------|---------------|-----------|-----------------|
| Proposta → Edital | N:1 | Uma proposta pertence a um edital | `edital_id` (FK) |
| Proposta → Fornecedor | N:1 | Uma proposta enviada por um fornecedor | `fornecedor_id` (FK) |

---

### Regras de Negócio (Invariantes)

| ID | Regra | Descrição | Prioridade |
|----|-------|-----------|-----------|
| INV-010 | Imutabilidade pós-envio | Proposta com status `Enviada` NÃO pode ser editada (read-only) | ⚠️ Obrigatória |
| INV-011 | Prazo de envio | `data_envio` <= `edital.data_encerramento` | ⚠️ Obrigatória (Lei de Licitações) |
| INV-012 | CNPJ ativo obrigatório | Fornecedor só pode enviar proposta se CNPJ situação = "Ativa" (integração Receita Federal) | ⚠️ Obrigatória |

---

## Documento B.3: Fornecedor (Value Object / Entity)

{Repetir estrutura}

---

## Documento B.4: Contrato (Aggregate Root)

{Repetir estrutura}

---

## Documento B.5: Categoria (Value Object / Enumeration)

{Repetir estrutura}

---

## Diagrama ERD Narrativo

{Descreva relacionamentos em formato textual para Arquiteto traduzir}

```
[Edital] 1 ----< N [Proposta]
   |                  |
   | N                | N
   v                  v
   1                  1
[Categoria]      [Fornecedor]

[Edital] 1 ---- 1 [Contrato] (opcional, após homologação)

[Edital] N ----< 1 [Usuario] (criador: Analista)
[Edital] N ----< 1 [Usuario] (aprovador: Gerente)
```

**Descrição**:
- Um **Edital** pertence a uma **Categoria** (N:1)
- Um **Edital** pode receber múltiplas **Propostas** (1:N)
- Uma **Proposta** é enviada por um **Fornecedor** (N:1)
- Um **Edital** pode gerar um **Contrato** após homologação (1:1 opcional)
- Um **Edital** é criado por um **Usuario** (Analista) e aprovado por outro **Usuario** (Gerente)

---

## Rastreabilidade

{Mapeamento deste anexo para PRD}

| Documento neste Anexo | FR no PRD | Journey no PRD | Metadados (Seção 10 PRD) |
|----------------------|-----------|----------------|--------------------------|
| B.1: Edital | FR-002, FR-003, FR-010 | Journey 4.1, 4.2 | `documentos[0]: Edital` |
| B.2: Proposta | FR-015 | Journey 4.3 | `documentos[1]: Proposta` |
| B.4: Contrato | FR-020 (Growth) | Journey 4.1 | `documentos[2]: Contrato` |

---

**Versão**: 1.0
**Data**: {YYYY-MM-DD}
**Responsável**: Analista de Negócio (Sofia)
**Consumidores**: Arquiteto de Documentos (para gerar spec_documentos.json - YCL-domain)
