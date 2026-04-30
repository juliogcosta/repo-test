# ANEXO C — Integrations
# Ycodify CRM - Service
# Versao: 1.0 (passagem 1 — fechado)
# Ultima atualizacao: 2026-04-30

---

## Indice de Integracoes

| # | ID | Nome | Tipo | MVP? | Status |
|---|-----|------|------|------|--------|
| INT-01a | emailengenharia | E-mail para Engenharia (OportunidadeGanha) | Saida — notificacao | **Sim (MVP)** | ESPECIFICADO |
| INT-01b | sistemaengenharia | Sistema da Engenharia (integracao sistemica) | Saida — evento | Nao (Pos-MVP) | FUTURO |
| INT-02 | formularioweb | Formulario Web de Captura de Lead | Entrada | Sim | PENDENCIAS |
| INT-03 | emailtransacional | Servico de E-mail Transacional | Notificacao de saida | Sim | ESPECIFICADO |

---

## INT-01a — E-mail para Engenharia (MVP)

### Descricao

Ao fechar uma Oportunidade como **Ganha**, o CRM envia automaticamente um e-mail para a equipe de Engenharia da Ycodify com um snapshot dos dados da oportunidade. Este e o mecanismo MVP enquanto a integracao sistemica (INT-01b) nao e desenvolvida.

### Tipo

Integracao de saida — notificacao por e-mail. Canal: servico de e-mail transacional (INT-03).

### Trigger

Evento de dominio `OportunidadeGanha` (ver ANEXO A — P-02, estado Ganha).

### Payload do E-mail (snapshot da Oportunidade Ganha)

| Campo | Descricao | Origem |
|-------|-----------|--------|
| oportunidade_id | ID unico da oportunidade | Oportunidade.id |
| titulo | Descricao curta da oportunidade | Oportunidade.titulo |
| conta_razao_social | Nome da conta / empresa | Conta.razao_social |
| contato_principal_nome | Nome do contato principal | Contato[principal=true].nome |
| contato_principal_email | E-mail do contato principal | Contato[principal=true].email |
| vendedor_nome | Nome do vendedor responsavel | Usuario.nome |
| valor_estimado | Valor estimado do negocio (R$) | Oportunidade.valor_estimado |
| fechado_em | Data/hora do fechamento | Oportunidade.fechado_em |

### Pendencias

| ID | Descricao | Prioridade |
|----|-----------|------------|
| PD-C01 | Destinatario(s) do e-mail para Engenharia (endereco ou lista de distribuicao) | Alta |
| PD-C02 | Template do e-mail para Engenharia | Media |

---

## INT-01b — Sistema da Engenharia (Pos-MVP)

### Descricao

Integracao sistemica futura: o CRM notificara o sistema interno da Engenharia via mecanismo programatico (webhook, fila de mensagens ou API REST) para iniciar automaticamente o fluxo de elicitacao/especificacao.

### Tipo

Integracao de saida — evento programatico. Canal e contrato a definir.

### Trigger

Evento de dominio `OportunidadeGanha` (mesmo trigger do INT-01a).

### Pendencias (Pos-MVP)

| ID | Descricao | Prioridade |
|----|-----------|------------|
| PD-C03 | Mecanismo de notificacao (webhook, fila de mensagens, API REST) | Media |
| PD-C04 | Payload e contrato do evento (schema, versionamento) | Media |
| PD-C05 | Autenticacao e seguranca da integracao | Media |

---

## INT-02 — Formulario Web de Captura de Lead

### Descricao

Formulario externo (pagina web da Ycodify ou landing page) que submete dados de um potencial cliente, gerando automaticamente um Lead no CRM com estado `Novo`.

### Tipo

Integracao de entrada — origem externa cria Lead no CRM.

### Trigger

Submissao do formulario web pelo visitante.

### Pendencias

| ID | Descricao | Prioridade |
|----|-----------|------------|
| PD-C06 | Arquitetura do formulario (hospedado no CRM vs sistema externo via API) | Alta |
| PD-C07 | Campos capturados pelo formulario (nome, e-mail, empresa, telefone, mensagem?) | Alta |
| PD-C08 | Regra de duplicidade — Lead com mesmo e-mail ja existe? | Media |
| PD-C09 | Regra de atribuicao de Leads vindos do formulario (automatica vs fila para Gerente) | Alta |

---

## INT-03 — Servico de E-mail Transacional

### Descricao

Servico de envio de e-mails transacionais utilizado pelo CRM para todas as notificacoes automaticas. Infraestrutura base para INT-01a.

### Tipo

Notificacao de saida — CRM envia via servico de e-mail.

### Eventos que Disparam E-mail

| Evento | Destinatario(s) | Regra |
|--------|----------------|-------|
| Lead sem interacao ha 5 dias | Gerente Comercial + Vendedor responsavel | RN-L01 (ANEXO A — P-01) |
| OportunidadeGanha | Equipe de Engenharia | RN-O03 (ANEXO A — P-02) + INT-01a |

### Pendencias

| ID | Descricao | Prioridade |
|----|-----------|------------|
| PD-C10 | Provedor de e-mail (SMTP proprio, SendGrid, AWS SES, outro?) | Media |
| PD-C11 | Templates de e-mail para cada tipo de notificacao | Media |

---

## Notas Gerais

- INT-01a (e-mail para Engenharia) e o mecanismo MVP. INT-01b (sistemica) e Pos-MVP.
- INT-03 e a infraestrutura de e-mail base, usada por INT-01a e pela notificacao de alerta de Lead (5 dias).
- Nao ha integracoes com CRMs externos — esta plataforma substitui ferramentas externas.
- O fluxo apos o encaminhamento para Engenharia (entrevistas, agente de IA, especificacao) e responsabilidade de outro sistema e esta fora do escopo do CRM.
