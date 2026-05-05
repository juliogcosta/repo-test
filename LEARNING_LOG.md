---
version: "1.2"
last_updated: "2026-05-05"
total_entries: 9
---

# Learning Log — Pendencias e Licoes (Projeto CRM)

**Propósito**: Registrar lacunas informacionais detectadas durante a elicitacao da passagem 1, para tratamento em ciclos futuros (VE ou proximas passagens).

---

## Entradas

### Entry 001
```yaml
id: "001"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — Bloco 2 (Jornada do Lead)"
missing_info_type: "Regra de atribuicao de Lead vindo de formulario web (automatica vs fila para Gerente)"
section_affected: "ANEXO A — P-01 (RN-L03) + ANEXO C — INT-02 (PD-C09)"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Pendencia: ao chegar via formulario, Lead e automaticamente atribuido a vendedor ou fica em fila para o Gerente distribuir? Ver PA-L01 no ANEXO A."
```

### Entry 002
```yaml
id: "002"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — Bloco 2 (Jornada do Lead)"
missing_info_type: "Contagem do timeout de 5 dias (a partir da criacao vs ultima interacao)"
section_affected: "ANEXO A — P-01 (RN-L01) + ANEXO B — Lead (ultima_interacao_em)"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Pendencia: timeout de 5 dias conta a partir da criacao do Lead ou da ultima interacao registrada? Ver PA-L02 no ANEXO A."
```

### Entry 003
```yaml
id: "003"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — escopo"
missing_info_type: "Suporte a Contato sem Conta (pessoa fisica / modelo B2C)"
section_affected: "ANEXO B — Entidade Contato (PD-B02)"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Passagem 1 define apenas B2B (Contato sempre vinculado a Conta). Suporte B2C adiado para Fase 2."
```

### Entry 004
```yaml
id: "004"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — ANEXO C (INT-01b)"
missing_info_type: "Mecanismo e contrato da integracao sistemica com Sistema da Engenharia"
section_affected: "ANEXO C — INT-01b"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "MVP usa apenas e-mail (INT-01a). Integracao sistemica (webhook/fila/API) e Pos-MVP. Mecanismo, payload e seguranca a definir."
```

### Entry 005
```yaml
id: "005"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — Secao 9 (NFRs)"
missing_info_type: "NFRs: performance, compliance/LGPD, disponibilidade, auditoria"
section_affected: "PRD Secao 9 — Non-Functional Requirements"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Cliente informou 'sem restricoes' na passagem 1. NFRs registrados como [A DEFINIR] para refinamento no ciclo VE."
```

### Entry 006
```yaml
id: "006"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — escopo Fase 2"
missing_info_type: "Atividades, Historico de Interacoes, Tickets pos-venda e jornada do Atendimento"
section_affected: "PRD Secao 4 (Jornada Atendimento) + ANEXO A P-04 + ANEXO B BC-02"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Escopo total inclui Atividades, Historico de Interacoes e Tickets. Todos adiados para Fase 2. Persona Atendimento sem jornada detalhada no MVP."
```

### Entry 007
```yaml
id: "007"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — Bloco 4 (MotivoPerda)"
missing_info_type: "Lista fixa de motivos de perda (possivel refinamento futuro)"
section_affected: "ANEXO B — Oportunidade (motivo_perda) + UBIQUITOUS_LANGUAGE (MotivoPerda)"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Passagem 1 define texto livre. Lista fixa (preco, concorrente, timing, sem fit) e possivel refinamento para ciclo futuro."
```

### Entry 008
```yaml
id: "008"
date_first_occurred: "2026-04-30"
date_last_occurred: "2026-04-30"
frequency: 1
context: "Elicitacao passagem 1 — regras de negocio"
missing_info_type: "Criterios de qualificacao de Lead + regras detalhadas de redistribuicao de Oportunidade pelo Gerente"
section_affected: "ANEXO A — P-01 e P-02 + ANEXO B — Lead e Oportunidade"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: "Criterios que tornam um Lead 'Qualificado' nao foram detalhados (decisao do Vendedor, sem regra sistematica). Regras de redistribuicao (notificacao ao vendedor anterior, restricoes de momento) nao detalhadas."
```

### Entry 009
```yaml
id: "009"
date_first_occurred: "2026-05-05"
date_last_occurred: "2026-05-05"
frequency: 1
context: "Analise pos-MP passagem 1 — artefatos PRD.md, ANEXO_A, ANEXO_B, ANEXO_C"
missing_info_type: "DRIFT-CORRECTION: drift semantico leve detectado por Lexicon (forbidden patterns, inconsistencia de casing, lacunas no glossario)"
section_affected: "PRD.md (Secao 1), ANEXO_A_ProcessDetails.md (P-02), ANEXO_B_DataModels.md (Aggregate Oportunidade), UBIQUITOUS_LANGUAGE.yaml"
projects_affected:
  - "crm"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
notes: |
  Correcoes aplicadas: DRIFT-01 (Proposta Enviada — contexto de Conta), DRIFT-02 (forbidden pattern 'negocio'),
  DRIFT-04 (motivoPerda → motivo_perda), DRIFT-05 (valorEstimado → valor_estimado),
  DRIFT-06 (Em Contato → EmContato em enums), DRIFT-07 (Proposta Enviada → PropostaEnviada em enums),
  INC-02 (invariante estagio inicial Oportunidade), INC-03 (synonym HistoricoVenda).
  Glossario enriquecido v1.1 → v1.2 com 9 novos termos (Roles + Domain Events ausentes).
  Pendencias abertas: INC-01 (Jornada 1 omite Gerente como ator de conversao — corrigir em ciclo 2),
  INC-05 (base de calculo regra 5 dias — decisao pendente cliente).
  INC-04 resolvida via ContaCriada notes.
  Aprendizado: Catalogar Roles e Domain Events no glossario ANTES de redigir ANEXOS evita drift de casing e inconsistencias entre artefatos.
```

---

## Estatisticas

**Total de Pendencias Registradas**: 9
**Pendencias Promovidas para Questionario**: 0
**Ciclo de Refinamento Previsto**: VE (Validacao de Especificacao)

**Grupos de Pendencias**:
1. Regras de negocio nao detalhadas (3 entradas: 001, 002, 008)
2. Escopo Fase 2 (2 entradas: 003, 006)
3. Integracoes nao detalhadas (1 entrada: 004)
4. NFRs (1 entrada: 005)
5. Refinamentos opcionais (1 entrada: 007)
6. Correcoes de drift semantico pos-passagem 1 (1 entrada: 009)

---

## Changelog

- **2026-04-30**: Estrutura inicial criada (v1.0) — template vazio
- **2026-04-30**: v1.1 — 8 pendencias registradas ao final da passagem 1 da sessao MP
- **2026-05-05**: v1.2 — Entry 009 adicionada (correcoes de drift Lexicon, glossario v1.2)
