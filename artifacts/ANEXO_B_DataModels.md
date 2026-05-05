# ANEXO B — Data Models
# Ycodify CRM - Service
# Versao: 1.0 (passagem 1 — fechado)
# Ultima atualizacao: 2026-04-30

---

## Bounded Contexts

| BC | Nome | Aggregates / Projections | Status |
|----|------|--------------------------|--------|
| BC-01 | comercial | Lead, Conta, Oportunidade | MVP |
| BC-01 | comercial | Contato (entidade filha de Conta) | MVP |
| BC-01 | comercial | HistoricoVenda (projection — read model) | MVP |
| BC-01 | comercial | SolicitacaoSubstituicao | MVP |
| BC-02 | posvenda | Ticket | Fase 2 — fora do MVP |

---

## BC-01 — Comercial

### Aggregates e Entidades

---

#### Aggregate: Lead

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador unico |
| nome | string | Sim | Nome do lead (pessoa ou empresa) |
| email | string | Sim | E-mail de contato |
| telefone | string | Nao | Telefone de contato |
| empresa | string | Nao | Nome da empresa (B2B) |
| origem | enum | Sim | `formulario_web` ou `manual` |
| status | enum | Sim | `Novo`, `EmContato`, `Qualificado`, `Convertido`, `Descartado` |
| vendedor_responsavel_id | UUID (ref Usuario) | Nao [A DEFINIR — PA-L01] | Vendedor responsavel |
| criado_por | enum | Sim | `Vendedor`, `Gerente`, `Sistema` — quem/o-que criou o lead |
| criado_por_id | UUID (ref Usuario) | Condicional | Preenchido quando criado_por != Sistema |
| criado_em | datetime | Sim | Data/hora de criacao |
| ultima_interacao_em | datetime | Nao | Data/hora da ultima interacao registrada (base do alerta de 5 dias) |
| convertido_em | datetime | Nao | Data/hora da conversao (se Convertido) |
| conta_id | UUID (ref Conta) | Nao | Preenchido apos conversao |
| oportunidade_id | UUID (ref Oportunidade) | Nao | Preenchido apos conversao |

**Invariantes**:
- Lead `Convertido` e `Descartado` nao podem mudar de estado.
- `ultima_interacao_em` e atualizado a cada interacao registrada.
- `conta_id` e `oportunidade_id` so sao preenchidos quando status = `Convertido`.
- Alerta disparado quando `(agora - ultima_interacao_em) >= 5 dias` E status nao e `Convertido` nem `Descartado`.

**Eventos de dominio**:
- `LeadCriado` — ao criar Lead (qualquer origem)
- `LeadConvertido` — ao mover para Convertido (dispara criacao de Conta + Oportunidade)
- `LeadDescartado` — ao mover para Descartado
- `LeadSemInteracaoAlertado` — ao atingir 5 dias sem interacao

---

#### Aggregate: Conta

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador unico |
| razao_social | string | Sim | Razao social ou nome da empresa |
| cnpj | string | Nao | CNPJ (opcional — [A DEFINIR ciclo futuro]) |
| segmento | string | Nao | Segmento de mercado |
| website | string | Nao | Site da empresa |
| vendedor_responsavel_id | UUID (ref Usuario) | Sim | Vendedor responsavel pela conta |
| criado_por_id | UUID (ref Usuario) | Sim | Usuario que criou |
| criado_em | datetime | Sim | |
| lead_origem_id | UUID (ref Lead) | Nao | Lead que originou esta Conta (se via conversao) |

**Invariantes**:
- Uma Conta pode ter N Contatos (cardinalidade 1:N).
- Uma Conta pode ter N Oportunidades ao longo do tempo.

**Eventos de dominio**:
- `ContaCriada`

---

#### Entidade: Contato

> Entidade filha da Conta (nao e Aggregate Root independente).

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador unico |
| conta_id | UUID (ref Conta) | Sim | Conta a qual pertence |
| nome | string | Sim | Nome completo |
| cargo | string | Nao | Cargo na empresa |
| email | string | Sim | E-mail de contato |
| telefone | string | Nao | Telefone de contato |
| principal | boolean | Sim | Se e o contato principal da Conta |
| criado_em | datetime | Sim | |

**Cardinalidade**: 1 Conta : N Contatos

**Pendencia Ciclo Futuro**: Suporte a Contato sem Conta (pessoa fisica / modelo B2C) — nao definido na passagem 1.

---

#### Aggregate: Oportunidade

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador unico |
| titulo | string | Sim | Descricao curta da oportunidade |
| conta_id | UUID (ref Conta) | Sim | Conta associada |
| vendedor_responsavel_id | UUID (ref Usuario) | Sim | Vendedor responsavel |
| estagio | enum | Sim | `PropostaEnviada`, `Negociacao`, `Fechamento`, `Ganha`, `Perdida` |
| valor_estimado | decimal (R$) | **Sim** | Valor estimado da Oportunidade. Obrigatório. |
| motivo_perda | string (texto livre) | **Sim se estagio = Perdida** | Motivo do nao-fechamento. Texto livre. Obrigatorio quando estagio = Perdida. |
| lead_origem_id | UUID (ref Lead) | Nao | Lead que originou (se via conversao) |
| criado_por_id | UUID (ref Usuario) | Sim | Usuario que criou |
| criado_em | datetime | Sim | Data de abertura da oportunidade |
| fechado_em | datetime | Nao | Data de fechamento (Ganha ou Perdida) |

**Invariantes**:
- `valor_estimado` e sempre obrigatorio (nao pode ser nulo ou zero).
- Oportunidade `Ganha` ou `Perdida` nao pode mudar de estagio.
- `motivo_perda` obrigatorio quando e somente quando `estagio = Perdida`.
- `fechado_em` so e preenchido quando `estagio = Ganha` ou `estagio = Perdida`.
- `estagio` na criacao deve ser `PropostaEnviada` (valor fixo inicial obrigatorio).

**Eventos de dominio**:
- `OportunidadeCriada`
- `OportunidadeGanha` — dispara e-mail para Engenharia (MVP) + notificacao ao sistema da Engenharia (Pos-MVP)
- `OportunidadePerdida`
- `OportunidadeResponsavelAlterado` — quando Gerente redistribui

---

#### Projection: HistoricoVenda

> NAO e um Aggregate independente. E uma projecao (read model) derivada das Oportunidades com `estagio = Ganha`.
> Em termos DDD: query model / CQRS projection. Nao tem escrita propria.

**Campos derivados (da Oportunidade Ganha)**:

| Campo | Origem |
|-------|--------|
| oportunidade_id | Oportunidade.id |
| titulo | Oportunidade.titulo |
| conta_id | Oportunidade.conta_id |
| conta_razao_social | Conta.razao_social |
| vendedor_responsavel_id | Oportunidade.vendedor_responsavel_id |
| vendedor_nome | Usuario.nome |
| valor_fechado | Oportunidade.valor_estimado |
| fechado_em | Oportunidade.fechado_em |

**Metricas Agregadas Derivadas**:

| Metrica | Descricao |
|---------|-----------|
| total_por_periodo | Soma de valor_fechado filtrado por intervalo de datas |
| total_por_vendedor | Soma de valor_fechado agrupado por vendedor_responsavel_id |
| total_por_conta | Soma de valor_fechado agrupado por conta_id |

**Regras de visibilidade**:
- Vendedor: ve apenas seus proprios registros (`vendedor_responsavel_id = usuario_logado`)
- Gerente Comercial: ve registros do seu time
- Gestor: ve todos os registros

---

---

#### Aggregate: SolicitacaoSubstituicao

> Aggregate Root no BC comercial. Representa o ciclo de vida de uma solicitacao de substituicao iniciada pelo Vendedor e decidida pelo Gerente Comercial.

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador unico |
| vendedor_solicitante_id | UUID (ref Usuario) | Sim | Vendedor que solicita substituicao |
| lead_id | UUID (ref Lead) | Condicional | Lead alvo (se escopo inclui Lead ainda nao convertido) |
| oportunidade_id | UUID (ref Oportunidade) | Condicional | Oportunidade alvo (se existente) |
| motivo | text | Sim | Motivo da solicitacao (texto livre) |
| status | enum | Sim | `Pendente`, `Aprovada`, `Recusada` |
| vendedor_substituto_id | UUID (ref Usuario) | Condicional | Preenchido pelo Gerente Comercial na aprovacao |
| criado_em | timestamp | Sim | Data/hora da solicitacao |
| decidido_em | timestamp | Nao | Data/hora da decisao do Gerente Comercial |

**Invariantes**:
- `motivo` nao pode ser nulo ou vazio.
- `lead_id` ou `oportunidade_id` deve estar preenchido (pelo menos um).
- `vendedor_substituto_id` e obrigatorio quando `status = Aprovada`.
- `status` inicial = `Pendente`.
- Apenas o proprio Vendedor pode criar SolicitacaoSubstituicao para seus proprios registros.

**Eventos de dominio**:
- `SubstituicaoSolicitada` — disparado na criacao da solicitacao
- `SubstituicaoAprovada` — disparado quando Gerente Comercial aprova; aciona reatribuicao de Lead e Oportunidade vinculada
- `SubstituicaoRecusada` — disparado quando Gerente Comercial recusa; VendedorResponsavel permanece inalterado

---

### Relacionamentos (BC Comercial)

```
Lead (1) ---[conversao]---> (0..1) Conta
Lead (1) ---[conversao]---> (0..1) Oportunidade

Conta (1) <----------------> (N) Contato
Conta (1) <----------------> (N) Oportunidade

Oportunidade (N) <----------> (1) Conta
Oportunidade (N) <----------> (1) Vendedor (responsavel)

HistoricoVenda <-- projection de -- Oportunidade [estagio = Ganha]

SolicitacaoSubstituicao (N) <-----> (1) Lead [opcional — lead_id]
SolicitacaoSubstituicao (N) <-----> (1) Oportunidade [opcional — oportunidade_id]
SolicitacaoSubstituicao (N) <-----> (1) Usuario [vendedor_solicitante_id]
SolicitacaoSubstituicao (N) <-----> (0..1) Usuario [vendedor_substituto_id — preenchido na aprovacao]
```

---

## BC-02 — Pos-Venda (Fase 2 — fora do MVP)

> Aggregate **Ticket** — detalhamento adiado para ciclo pos-MVP.

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | Identificador unico |
| conta_id | UUID (ref Conta) | Conta associada |
| atendente_id | UUID (ref Usuario) | Atendente responsavel |
| status | enum | A definir na Fase 2 |
| descricao | string | Descricao do ticket |
| criado_em | datetime | |

---

## Pendencias Registradas (ciclo futuro)

| ID | Pendencia | Prioridade |
|----|-----------|------------|
| PD-B01 | CNPJ da Conta — obrigatorio ou opcional? | Baixa |
| PD-B02 | Contato sem Conta (modelo B2C / pessoa fisica) — Fase 2 | Baixa |
| PD-B03 | Criterios de qualificacao de Lead — nao detalhados na passagem 1 | Media |
| PD-B04 | Regras detalhadas de redistribuicao de Oportunidade pelo Gerente | Media |
| PD-B05 | Atribuicao de Lead vindo de formulario web (automatica vs fila para Gerente) — PA-L01 | Alta |
