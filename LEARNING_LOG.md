---
version: "1.0"
last_updated: "2026-04-30T18:24:12Z"
total_entries: 0
---

# Learning Log — Lições Aprendidas (Global)

**Propósito**: Este arquivo acumula lições aprendidas de **TODOS os projetos** da plataforma YC para melhorar elicitação de requisitos continuamente.

**Como funciona**:
1. **Detecção automática**: Quando um Arquiteto (Documentos, Processos, Integrações) bloqueia aguardando informação adicional do cliente, o Orquestrador detecta o **gap informacional**
2. **Registro**: Orquestrador oferece registrar a lição com contexto (o que faltou, em qual seção do PRD)
3. **Frequência**: Se mesma lição ocorre ≥3 vezes em projetos diferentes, sistema recomenda promover para **questionário padrão do Analista**
4. **Melhoria contínua**: Com o tempo, elicitação se torna mais completa e Arquitetos bloqueiam menos

---

## Entradas

<!-- As entradas serão adicionadas dinamicamente conforme lições são aprendidas -->

<!-- Exemplo de estrutura de entrada:

### Entry 001
```yaml
id: "001"
date_first_occurred: "2026-04-10"
date_last_occurred: "2026-04-15"
frequency: 3
context: "Arquiteto de Documentos bloqueou aguardando regras de validação"
missing_info_type: "Regras de validação de campos (formato, range, obrigatoriedade)"
section_affected: "PRD Seção 10 (Metadados YAML) + ANEXO B (Data Models)"
projects_affected:
  - "crm"
  - "erp-vendas"
  - "licitacoes"
promoted_to_questionnaire: true
promoted_at: "2026-04-15"
promoted_question: "Para cada campo do documento, especifique: (1) Formato esperado (ex: CPF, email, número), (2) Range de valores válidos, (3) Se é obrigatório"
```

### Entry 002
```yaml
id: "002"
date_first_occurred: "2026-04-12"
date_last_occurred: "2026-04-12"
frequency: 1
context: "Arquiteto de Processos bloqueou aguardando condição de saída de loop"
missing_info_type: "Critério de saída de loops/repetições em processos"
section_affected: "ANEXO A (Process Details) — Fluxos Principais"
projects_affected:
  - "workflow-aprovacao"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
```

### Entry 003
```yaml
id: "003"
date_first_occurred: "2026-04-14"
date_last_occurred: "2026-04-15"
frequency: 2
context: "Arquiteto de Documentos bloqueou por falta de cardinalidade de relacionamentos"
missing_info_type: "Cardinalidade de relacionamentos entre documentos (1:1, 1:N, N:N)"
section_affected: "ANEXO B (Data Models) — Relacionamentos"
projects_affected:
  - "crm"
  - "licitacoes"
promoted_to_questionnaire: false
promoted_at: null
promoted_question: null
```

-->

---

## Estatísticas

**Total de Lições**: 0
**Lições Promovidas para Questionário**: 0
**Taxa de Promoção**: N/A

**Top 3 Seções com Mais Gaps**:
1. (Aguardando dados)
2. (Aguardando dados)
3. (Aguardando dados)

**Top 3 Tipos de Informação Faltante**:
1. (Aguardando dados)
2. (Aguardando dados)
3. (Aguardando dados)

---

## Notas de Uso

### Para o Orquestrador (Giovanna)

**Quando registrar uma lição**:
1. Arquiteto reporta bloqueio aguardando informação do cliente
2. Você identifica exatamente:
   - Qual informação faltou (específico)
   - Em qual seção do PRD deveria estar
   - Contexto do bloqueio (o que Arquiteto estava tentando gerar)
3. Perguntar ao cliente: "Deseja registrar essa lição para melhorar futuros projetos?"
4. Se cliente aprovar, adicionar entrada neste arquivo

**Formato de entrada**:
```yaml
### Entry {id_sequencial}
```yaml
id: "{id_sequencial_com_zeros: 001, 002, etc}"
date_first_occurred: "{YYYY-MM-DD quando ocorreu pela primeira vez}"
date_last_occurred: "{YYYY-MM-DD quando ocorreu pela última vez}"
frequency: {número de vezes que ocorreu}
context: "{Descrição concisa do bloqueio}"
missing_info_type: "{Tipo específico de informação que faltou}"
section_affected: "{Seção do PRD ou Anexo onde deveria estar}"
projects_affected:
  - "{project_alias_1}"
  - "{project_alias_2}"
promoted_to_questionnaire: {true/false}
promoted_at: "{YYYY-MM-DD ou null}"
promoted_question: "{Pergunta sugerida para questionário ou null}"
```
```

**Quando promover para questionário**:
- Quando `frequency >= 3`
- Apresentar ao cliente:
  ```
  ⚠️ **Lição Recorrente Detectada**

  Esta lição ocorreu {frequency} vezes em diferentes projetos:
  {lista de projetos afetados}

  Informação faltante: {missing_info_type}
  Seção afetada: {section_affected}

  Pergunta sugerida para adicionar ao questionário do Analista:
  "{promoted_question}"

  Deseja promover agora?
  [S] Sim, adicionar ao questionário
  [N] Não, manter apenas no log
  ```
- Se cliente aprovar: atualizar entrada (promoted_to_questionnaire: true, promoted_at, promoted_question)
- Notificar time técnico para adicionar pergunta ao skill do Analista

**Incrementar frequência**:
- Se lição já existe (mesmo `missing_info_type` + mesma `section_affected`):
  - Incrementar `frequency++`
  - Atualizar `date_last_occurred`
  - Adicionar projeto à lista `projects_affected`

---

### Para o Analista de Negócio (Sofia)

**Como usar este log**:
1. Antes de iniciar mapeamento, consultar este arquivo
2. Identificar lições promovidas (`promoted_to_questionnaire: true`)
3. Incorporar perguntas promovidas ao questionário de elicitação
4. Durante mapeamento, se cliente não souber responder pergunta promovida, documentar no PRD com flag `[PENDENTE_VALIDACAO]` e alertar Orquestrador

---

### Para Arquitetos (Documentos, Processos, Integrações)

**Como usar este log**:
1. Antes de gerar specs, consultar lições relacionadas à sua área:
   - Arquiteto de Documentos: lições em "ANEXO B" ou "Seção 10"
   - Arquiteto de Processos: lições em "ANEXO A"
   - Arquiteto de Integrações: lições em "ANEXO C"
2. Se informação crítica ainda faltando no PRD, bloquear e reportar ao Orquestrador (como sempre)
3. Orquestrador verificará se lição já existe antes de registrar novamente

---

## Changelog

- **2026-04-15**: Estrutura inicial criada (v1.0)
  - Sistema de registro de lições com frequência
  - Promoção automática para questionário quando frequency >= 3
  - Rastreamento por projeto, seção do PRD, e tipo de informação faltante
