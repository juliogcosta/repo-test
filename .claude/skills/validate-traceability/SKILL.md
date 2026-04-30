---
name: validate-traceability
description: >
  Valida rastreabilidade de requisitos em PRD + ANEXOS: IDs bem formados, links consistentes,
  sem órfãos. Executa scripts determinísticos (validate-ids.sh, generate-rtm.sh, validate-links.sh)
  e opcionalmente validação semântica via LLM. Gera TRACEABILITY_REPORT.md. Invocável por
  Orquestrador (VR capability), Analista de Negócio (auto-validação), ou manualmente.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
  - Glob
---

# Validação de Rastreabilidade de Requisitos

## Objetivo

Validar rastreabilidade completa de requisitos em documentos de elicitação (PRD + ANEXOS):
1. **Validação Estrutural** (scripts): IDs bem formados, únicos, links válidos
2. **Validação Semântica** (LLM, opcional): Consistência conceitual dos links

---

## CRITICAL LLM INSTRUCTIONS

- **MANDATORY**: Execute ALL steps IN EXACT ORDER
- DO NOT skip steps or change sequence
- HALT immediately when halt-conditions are met
- Scripts MUST run before LLM analysis (script-first architecture)

---

## INPUT ESPERADO

- **`mode`**: "structural_only" | "structural_and_semantic"
- **`project_root`**: Caminho para raiz do projeto (onde estão artifacts/ ou templates/)
- **`output_report`**: Caminho para salvar TRACEABILITY_REPORT.md (opcional)

---

## FLOW

### Step 1: Validação Estrutural - IDs

**Action 1.1**: Executar `scripts/validate-ids.sh`

```bash
bash scripts/validate-ids.sh {project_root}
```

**Output esperado**: Exit code 0 (sucesso) ou 1 (falha)

**Halt Condition**: Se exit code != 0, pular para Step 4 (gerar relatório preliminar com erros)

**Action 1.2**: Parsear output do script

- Extrair: Total IDs, IDs inválidos, duplicatas, erros específicos

---

### Step 2: Validação Estrutural - RTM e Links

**Action 2.1**: Executar `scripts/generate-rtm.sh`

```bash
bash scripts/generate-rtm.sh {project_root} {project_root}/RTM.yaml
```

**Output**: RTM.yaml gerado

**Action 2.2**: Executar `scripts/validate-links.sh`

```bash
bash scripts/validate-links.sh {project_root}
```

**Output esperado**: Exit code 0 (sucesso) ou 1 (orphans/isolados detectados)

**Halt Condition**: Se exit code != 0, pular para Step 4 (gerar relatório preliminar)

**Action 2.3**: Parsear output do script

- Extrair: Orphan links, nós isolados, erros específicos

---

### Step 3: Validação Semântica (Opcional, apenas se mode == "structural_and_semantic")

**Halt Condition**: Se mode == "structural_only", skip Step 3

**Action 3.1**: Ler PRD_04_UserJourneys.md

- Para cada journey com `linked_frs`, verificar semanticamente:
  - FRs listados são realmente derivados da journey?
  - Journey menciona necessidades que FRs atendem?

**Action 3.2**: Ler PRD_08_FunctionalRequirements.md

- Para cada FR com `source_journeys`, verificar:
  - FR é rastreável à journey indicada?
  - FR menciona contexto compatível com journey?

**Action 3.3**: Ler ANEXO_B_DataModels.md

- Para cada document com `linked_frs`, verificar:
  - FRs realmente usam este documento?
  - Document é relevante para FRs listados?

- Para cada invariant com `linked_frs`, verificar:
  - Invariante é aplicável aos FRs listados?
  - Faz sentido no contexto dos FRs?

**Action 3.4**: Compilar inconsistências semânticas

- Lista de pares (ID source, ID target, descrição da inconsistência)

---

### Step 4: Calcular Métricas de Cobertura

**Action 4.1**: Ler RTM.yaml gerado

**Action 4.2**: Calcular estatísticas

```python
# Upstream coverage
frs_with_upstream = count(FR where upstream links exist)
total_frs = count(all FRs)
upstream_coverage = (frs_with_upstream / total_frs) * 100

# Downstream coverage
frs_with_downstream = count(FR where downstream links exist)
downstream_coverage = (frs_with_downstream / total_frs) * 100

# Orphan rate
orphan_links = count(links to non-existent IDs)
total_links = count(all links)
orphan_rate = (orphan_links / total_links) * 100

# Isolation rate
isolated_nodes = count(nodes without upstream AND downstream)
total_nodes = count(all nodes)
isolation_rate = (isolated_nodes / total_nodes) * 100
```

---

### Step 5: Gerar Relatório de Rastreabilidade

**Action 5.1**: Compilar resultados dos scripts

**Action 5.2**: Adicionar achados semânticos (se aplicável)

**Action 5.3**: Estruturar relatório em markdown

```markdown
## Relatório de Rastreabilidade

**Data**: {timestamp}
**Projeto**: {project_root}
**Modo**: {structural_only | structural_and_semantic}

---

### Validação Estrutural (Scripts)

#### ✅ IDs Bem Formados: {percentage}% ({valid}/{total})

{Se erros:}
**Erros de Formato**:
- {ID}: {descrição do erro}

**Duplicatas**:
- {ID}: encontrado em {file1} e {file2}

---

#### {✅ | ⚠️} Links Válidos: {percentage}% ({valid}/{total})

{Se orphans:}
**Orphan Links** ({count}):
- {source_id} → {target_id} (target não existe)

{Se isolados:}
**Nós Isolados** ({count}):
- {id}: sem upstream nem downstream

---

#### ✅ RTM Gerado: RTM.yaml

- **Total nodes**: {count}
- **Total edges**: {count}

---

### Validação Semântica (LLM)

{Se mode == structural_only:}
**Skipped** (modo structural_only)

{Se mode == structural_and_semantic:}

#### {✅ | ⚠️} Consistência Semântica: {status}

{Se inconsistências:}
**Inconsistências Detectadas** ({count}):

1. **{source_id} ↔ {target_id}**
   - **Problema**: {descrição}
   - **Sugestão**: {correção proposta}

---

### Métricas de Cobertura

- **Upstream Coverage**: {percentage}% ({count}/{total} FRs com source_journeys)
  - Target: ≥90%
  - Status: {✅ PASS | ⚠️ WARN | ❌ FAIL}

- **Downstream Coverage**: {percentage}% ({count}/{total} FRs com links para specs)
  - Target: ≥85%
  - Status: {✅ PASS | ⚠️ WARN | ❌ FAIL}

- **Orphan Rate**: {percentage}% ({count}/{total} links)
  - Target: 0%
  - Status: {✅ PASS | ⚠️ WARN | ❌ FAIL}

- **Isolation Rate**: {percentage}% ({count}/{total} nodes)
  - Target: 0%
  - Status: {✅ PASS | ⚠️ WARN | ❌ FAIL}

---

### Status Geral

{Se PASS:}
✅ **VALIDATION PASSED**

Rastreabilidade completa e consistente. Pronto para geração de specs.

{Se WARN:}
⚠️ **VALIDATION PASSED WITH WARNINGS**

Rastreabilidade aceitável, mas com issues não-críticos:
- {lista de warnings}

Recomendado corrigir antes de geração de specs.

{Se FAIL:}
❌ **VALIDATION FAILED**

Rastreabilidade insuficiente. BLOQUEIO para geração de specs.

**Ações Requeridas**:
1. {ação 1}
2. {ação 2}

---

**Assinatura**: validate-traceability v1.0
**RTM Hash**: {sha256 of RTM.yaml}
```

**Action 5.4**: Salvar relatório em `{output_report}` (ou {project_root}/TRACEABILITY_REPORT.md)

---

## OUTPUT

**Formato**: Markdown report (TRACEABILITY_REPORT.md)

**Conteúdo**:
1. Resultados de validação estrutural (scripts)
2. Resultados de validação semântica (se aplicável)
3. Métricas de cobertura
4. Status geral (PASS/WARN/FAIL)
5. Ações requeridas (se FAIL)

---

## VALIDATION RULES

1. **VR-TR-001**: upstream_coverage ≥ 90% para PASS
2. **VR-TR-002**: downstream_coverage ≥ 85% para PASS
3. **VR-TR-003**: orphan_rate == 0% para PASS
4. **VR-TR-004**: isolation_rate < 5% para PASS (WARN se ≥5%, FAIL se ≥10%)
5. **VR-TR-005**: Sem erros de formato de IDs para PASS
6. **VR-TR-006**: Sem duplicatas para PASS

---

## INTEGRATION

**Invocada por**:

1. **Orquestrador-PM** (capability VR - Validar Rastreabilidade)
   - Após MP (Mapear Processos) completo
   - Antes de GE (Gerar Especificações)

2. **Analista de Negócio** (Step 8 - Auto-validação)
   - Após completar PRD + ANEXOS
   - Modo: structural_only (validação rápida)

3. **QA de Specs** (Step 0 - Pré-validação)
   - Antes de validar specs
   - Modo: structural_and_semantic (validação completa)

4. **Manual** (usuário invoca diretamente)
   - `/validate-traceability`

---

## EXEMPLO DE EXECUÇÃO

### Input

```yaml
mode: "structural_and_semantic"
project_root: "/home/user/projects/my-project"
output_report: "/home/user/projects/my-project/TRACEABILITY_REPORT.md"
```

### Step 1: Validação de IDs

```bash
$ bash scripts/validate-ids.sh /home/user/projects/my-project

========================================
ID Validation Report
========================================
Total IDs found: 45
Invalid format: 0
Duplicates: 0

✅ VALIDATION PASSED
```

### Step 2: RTM + Links

```bash
$ bash scripts/generate-rtm.sh /home/user/projects/my-project

Total nodes: 45
Total edges: 78 (upstream: 40, downstream: 38)

✅ RTM Generated Successfully

$ bash scripts/validate-links.sh /home/user/projects/my-project

Orphan links: 2
Isolated nodes: 1

❌ VALIDATION FAILED
Errors:
  ✗ Orphan downstream link: FR-010 -> UJ-04-999 (target does not exist)
  ✗ Isolated node: FR-050 (no upstream or downstream links)
```

### Step 3: Validação Semântica (LLM)

```
Checking FR-005 ↔ UJ-04-001...
⚠️  INCONSISTENCY: FR-005 ("Aprovar Edital") references Journey UJ-04-001 ("Submeter Proposta")
    Problem: Journey is about submission, not approval
    Suggestion: Check if correct link is UJ-04-003 ("Avaliar Propostas")
```

### Step 4: Métricas

```yaml
upstream_coverage: 95.5% (43/45 FRs with source_journeys)
downstream_coverage: 87.0% (39/45 FRs with downstream)
orphan_rate: 4.4% (2/45 links)
isolation_rate: 2.2% (1/45 nodes)
```

### Step 5: Relatório Gerado

```markdown
## Relatório de Rastreabilidade

**Status Geral**: ❌ **VALIDATION FAILED**

**Ações Requeridas**:
1. Corrigir 2 orphan links (FR-010 → UJ-04-999, remover ou criar UJ-04-999)
2. Adicionar links para FR-050 (nó isolado)
3. Investigar inconsistência semântica FR-005 ↔ UJ-04-001
```

---

## NOTAS

1. **Script-first**: 99% da validação é feita por scripts (fast, deterministic, zero cost)
2. **LLM opcional**: Validação semântica é cara (tokens), usar apenas quando necessário
3. **Idempotente**: Mesma entrada produz mesmo output
4. **Non-blocking**: WARN não bloqueia workflow, apenas FAIL bloqueia

---

**Versão**: 1.0
**Data**: 2026-04-17
**Autor**: Arquitetura de Agentes YC Platform
