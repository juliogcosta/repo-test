# Projeto: Ycodify CRM - Service

**Nome**: crm
**Cliente**: Ycodify
**Data de Inicio**: 2026-04-30
**Complexidade**: medio
**Status Atual**: Negocio Mapeado (passagem 1)

---

## Brief Inicial

Sistema para atender demandas de captacao de clientes, suporte a vendas e relacionamento com clientes da Ycodify

---

## Artefatos Gerados

- [x] PRD.md (Product Requirements Document) — passagem 1 completa
- [x] ANEXO_A_ProcessDetails.md — passagem 1 completa
- [x] ANEXO_B_DataModels.md — passagem 1 completa
- [x] ANEXO_C_Integrations.md — passagem 1 completa
- [ ] spec_documentos.json (YCL-domain)
- [ ] spec_processos.json (BPMN)
- [ ] spec_integracoes.json (OpenAPI + politicas)
- [ ] QA_REPORT.md

---

## Bounded Contexts Provisionados

| BC | Nome | Escopo | Aggregates |
|----|------|--------|------------|
| BC-01 | comercial | MVP | Lead, Conta, Oportunidade (+ Contato entidade, HistoricoVenda projection) |
| BC-02 | posvenda | Fase 2 | Ticket |

---

## Resumo Passagem 1

- **FRs definidos**: 14 (FR-001 a FR-014)
- **Aggregates (MVP)**: 3 (Lead, Conta, Oportunidade) + 1 entidade (Contato) + 1 projection (HistoricoVenda)
- **Integracoes**: 4 (emailengenharia MVP, sistemaengenharia Pos-MVP, formularioweb MVP, emailtransacional MVP)
- **Processos documentados**: 3 (P-01 Lead, P-02 Pipeline/Oportunidade, P-03 HistoricoVenda)
- **Secoes PRD em rascunho PM**: 1, 2, 3, 6, 8 (criterios), 9 (NFRs)

---

## Historico

- **2026-04-30**: Projeto inicializado a partir do template YC Platform v3.3 (Layer Architecture)
- **2026-04-30**: Sessao MP — passagem 1 concluida. PRD + ANEXOS A/B/C + Glossario gerados.

---

## Configuracao

- **Validation Mode**: permissive
- **Agentes Habilitados**: orquestrador-pm, analista-de-negocio, diagrama-designer, assistente-de-projeto, guardiao-linguagem-ubiqua, qa-de-specs
- **Template Version**: YC Platform v3.3 (Layer Architecture)

---

**Template Source**: /home/julio/Codes/YC/yc-platform-v3/template-project
**Initialized By**: julio
**Initialized At**: qui 30 abr 2026 15:24:12 -03
