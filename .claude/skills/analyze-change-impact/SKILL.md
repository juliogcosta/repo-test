---
name: analyze-change-impact
description: >
  Analisa impacto de mudanças em requisitos via BFS traversal do RTM.yaml. Executa
  impact-analysis.sh para calcular artefatos afetados downstream e usa LLM para estimar
  esforço e gerar recomendações. Gera IMPACT_REPORT.md. Invocável por Orquestrador (CIA capability)
  ou manualmente. Workflow manual-only (disable-model-invocation: true).
user-invocable: true
disable-model-invocation: true
allowed-tools:
  - Read
  - Write
  - Bash
---

# Análise de Impacto de Mudanças

## Objetivo

Calcular quais artefatos serão afetados por mudança em um requisito e estimar esforço necessário.

---

## CRITICAL LLM INSTRUCTIONS

- **MANDATORY**: Execute ALL steps IN EXACT ORDER
- DO NOT skip steps or change sequence
- HALT immediately when halt-conditions are met
- Script MUST run before LLM analysis (script-first architecture)

---

## INPUT ESPERADO

- **`changed_id`**: ID do requisito que será modificado (ex: "UJ-04-001")
- **`change_description`**: Descrição da mudança proposta (ex: "Adicionar aprovação de compliance")
- **`project_root`**: Caminho para raiz do projeto
- **`output_report`**: Caminho para salvar IMPACT_REPORT.md (opcional)

---

## FLOW

### Step 1: Validar Input

**Action 1.1**: Verificar que `changed_id` foi fornecido

**Halt Condition**: Se `changed_id` vazio, retornar erro com mensagem de uso

**Action 1.2**: Verificar que RTM.yaml existe

```bash
test -f {project_root}/RTM.yaml
```

**Halt Condition**: Se RTM.yaml não existe, retornar erro: "RTM.yaml not found. Run scripts/generate-rtm.sh first."

---

### Step 2: Executar BFS Traversal (Script)

**Action 2.1**: Executar `scripts/impact-analysis.sh`

```bash
bash scripts/impact-analysis.sh {changed_id} {project_root}
```

**Output esperado**: Lista de IDs afetados com profundidade

**Halt Condition**: Se exit code != 0 (ID não existe), retornar erro: "ID '{changed_id}' not found in RTM"

**Action 2.2**: Parsear output do script

Extrair:
- `max_depth`: Profundidade máxima do grafo
- `total_affected`: Total de artefatos afetados
- `affected_by_depth`: Map de depth → [IDs]

---

### Step 3: Classificar Artefatos (LLM)

**Action 3.1**: Para cada ID afetado, determinar tipo de artefato

```python
def classify_artifact(id):
    if id.startswith("UJ-"):
        return "User Journey", "PRD Section 4", "20-30 min"
    elif id.startswith("FR-"):
        return "Functional Requirement", "PRD Section 8", "20-30 min"
    elif id.startswith("PROC-"):
        return "Process", "ANEXO A", "45-60 min"
    elif id.startswith("DOC-"):
        return "Document", "ANEXO B", "45-60 min"
    elif id.startswith("INV-"):
        return "Invariant", "ANEXO B", "30-45 min"
    else:
        return "Unknown", "Unknown", "Unknown"
```

**Action 3.2**: Identificar artefatos críticos (profundidade 3+)

- Profundidade 3+ geralmente indica specs (spec_documentos.json, spec_processos.json)
- Regeneração de specs é cara: 1-2h por spec + validação QA

---

### Step 4: Estimar Esforço Total

**Action 4.1**: Calcular esforço por profundidade

```python
effort_by_depth = {}

for depth, ids in affected_by_depth.items():
    total_effort_min = 0

    for id in ids:
        artifact_type, location, avg_effort = classify_artifact(id)
        total_effort_min += parse_effort_min(avg_effort)

    effort_by_depth[depth] = total_effort_min
```

**Action 4.2**: Calcular esforço total

```python
total_effort_min = sum(effort_by_depth.values())

# Add spec regeneration overhead if depth >= 3
if max_depth >= 3:
    spec_count = count(ids where depth == 3 and type == spec)
    total_effort_min += spec_count * 120  # 2h per spec
```

**Action 4.3**: Converter para horas e formatar

```python
total_hours = total_effort_min / 60
formatted = f"{int(total_hours)}h {total_effort_min % 60}min"
```

---

### Step 5: Avaliar Risco

**Action 5.1**: Determinar nível de risco baseado em métricas

```python
def assess_risk(max_depth, total_affected):
    if max_depth >= 3 and total_affected >= 5:
        return "ALTO", "Mudança afeta specs + múltiplos artefatos"
    elif max_depth >= 3:
        return "MÉDIO", "Mudança afeta specs (requer regeneração + QA)"
    elif total_affected >= 10:
        return "MÉDIO", "Mudança afeta muitos artefatos (10+)"
    elif total_affected >= 5:
        return "BAIXO", "Mudança afeta poucos artefatos (5-9)"
    else:
        return "BAIXO", "Mudança afeta poucos artefatos (<5)"
```

---

### Step 6: Gerar Recomendações

**Action 6.1**: Gerar lista de recomendações baseada em profundidade e risco

```python
recommendations = []

# Always recommend
recommendations.append("Executar mudança em branch separado (ex: feature/change-{changed_id})")

# If total_affected > 0
if total_affected > 0:
    recommendations.append(f"Regenerar apenas {total_affected} artefatos afetados (não tudo!)")
    recommendations.append("Após mudança, executar `/validate-traceability` para verificar consistência")

# If max_depth >= 3
if max_depth >= 3:
    recommendations.append("QA deve validar specs afetadas contra PRD atualizado")
    recommendations.append("Executar testes de integração após regeneração de specs")

# If risk == ALTO
if risk == "ALTO":
    recommendations.append("⚠️  Solicitar aprovação PM antes de prosseguir (mudança de alto impacto)")
    recommendations.append("Considerar quebrar mudança em iterações menores")
```

---

### Step 7: Gerar Relatório de Impacto

**Action 7.1**: Estruturar relatório em markdown

```markdown
## Análise de Impacto: {changed_id}

**Data**: {timestamp}
**Mudança Proposta**: {change_description}

---

### Resumo Executivo

- **Profundidade Máxima**: {max_depth}
- **Total Afetado**: {total_affected} artefatos
- **Esforço Estimado**: {total_effort_formatted}
- **Nível de Risco**: {risk_level}
- **Razão**: {risk_reason}

---

### Artefatos Impactados

{Para cada depth de 1 a max_depth:}

#### Profundidade {depth} (Dependências {Diretas | Indiretas | Specs})

{Para cada ID afetado nesta profundidade:}

- **{id}**: {artifact_type} ({location})
  - **Esforço estimado**: {avg_effort}
  - **Ação**: {descrição da ação necessária}

{Exemplo:}
- **FR-001**: Functional Requirement (PRD Section 8)
  - **Esforço estimado**: 20 min
  - **Ação**: Revisar texto + frontmatter

- **INV-001**: Invariant (ANEXO B)
  - **Esforço estimado**: 45 min
  - **Ação**: Atualizar invariante + rastreability table

- **spec_documentos.json (Edital)**: YCL-domain spec
  - **Esforço estimado**: 2h
  - **Ação**: Regenerar spec + validação cruzada com PRD

---

### Resumo de Esforço

| Profundidade | Artefatos | Esforço |
|--------------|-----------|---------|
{Para cada depth:}
| {depth} | {count} | {effort_formatted} |

**Total**: {total_affected} artefatos, **{total_effort_formatted}**

---

### Análise de Risco

**Nível**: {⚠️ ALTO | 🔶 MÉDIO | ✅ BAIXO}

**Razão**: {risk_reason}

{Se ALTO:}
⚠️  **ATENÇÃO**: Mudança de alto impacto. Requer aprovação PM e planejamento cuidadoso.

{Se max_depth >= 3:}
**Artefatos Críticos** (profundidade 3+): {count}
- Specs afetadas requerem regeneração + validação QA
- Testes de integração obrigatórios

---

### Recomendações

{Para cada recommendation:}
{n}. {recommendation}

---

### Next Steps

1. **Revisar este relatório** com PM/BA
2. **Aprovar mudança** (se ALTO risco) ou prosseguir
3. **Criar branch**: `feature/change-{changed_id}`
4. **Fazer mudança** no {changed_id}
5. **Validar rastreabilidade**: `/validate-traceability`
6. **Regenerar artefatos afetados** (usar lista acima)
7. **Validar specs** (se max_depth >= 3)
8. **Merge** após validação completa

---

**Assinatura**: analyze-change-impact v1.0
**RTM Hash**: {sha256 of RTM.yaml}
```

**Action 7.2**: Salvar relatório em `{output_report}` (ou {project_root}/IMPACT_REPORT_{changed_id}.md)

---

## OUTPUT

**Formato**: Markdown report (IMPACT_REPORT_{changed_id}.md)

**Conteúdo**:
1. Resumo executivo (total afetado, esforço, risco)
2. Lista de artefatos afetados por profundidade
3. Resumo de esforço
4. Análise de risco
5. Recomendações
6. Next steps

---

## INTEGRATION

**Invocada por**:

1. **Orquestrador-PM** (capability CIA - Change Impact Analysis)
   - Antes de aceitar mudança em requisito existente
   - Quando usuário pergunta "o que acontece se eu mudar X?"

2. **Manual** (usuário invoca diretamente)
   - `/analyze-change-impact {changed_id}`
   - Requer `changed_id` como parâmetro

---

## EXEMPLO DE EXECUÇÃO

### Input

```yaml
changed_id: "UJ-04-001"
change_description: "Adicionar aprovação de compliance após aprovação do gerente"
project_root: "/home/user/projects/my-project"
output_report: "/home/user/projects/my-project/IMPACT_REPORT_UJ-04-001.md"
```

### Step 2: BFS Traversal

```bash
$ bash scripts/impact-analysis.sh UJ-04-001 /home/user/projects/my-project

========================================
Change Impact Analysis
========================================
Changed ID: UJ-04-001
RTM: /home/user/projects/my-project/RTM.yaml

Total affected artifacts: 6
Maximum depth: 3

Affected artifacts by depth:

Depth 1:
  - FR-001 (Functional Requirement)
  - FR-005 (Functional Requirement)

Depth 2:
  - INV-001 (Invariant)
  - PROC-lic-001 (Process)

Depth 3:
  - DOC-lic-Edital (Document)
  - spec_documentos.json (Spec)
```

### Step 3-4: Classificação + Esforço

```yaml
affected_by_depth:
  1: [FR-001, FR-005]    # 2 FRs × 20 min = 40 min
  2: [INV-001, PROC-lic-001]  # 1 INV × 45 min + 1 PROC × 60 min = 105 min
  3: [DOC-lic-Edital, spec_documentos.json]  # 1 DOC × 45 min + 1 spec × 120 min = 165 min

total_effort: 310 min = 5h 10min
```

### Step 5: Risco

```
max_depth = 3, total_affected = 6
→ Risk: ALTO ("Mudança afeta specs + múltiplos artefatos")
```

### Step 6: Recomendações

```markdown
1. Executar mudança em branch separado (feature/change-UJ-04-001)
2. Regenerar apenas 6 artefatos afetados (não tudo!)
3. Após mudança, executar `/validate-traceability`
4. QA deve validar specs afetadas contra PRD atualizado
5. Executar testes de integração após regeneração de specs
6. ⚠️  Solicitar aprovação PM antes de prosseguir (mudança de alto impacto)
7. Considerar quebrar mudança em iterações menores
```

### Step 7: Relatório Gerado

Arquivo: `/home/user/projects/my-project/IMPACT_REPORT_UJ-04-001.md`

```markdown
## Análise de Impacto: UJ-04-001

**Mudança Proposta**: Adicionar aprovação de compliance após aprovação do gerente

**Resumo Executivo**:
- Total Afetado: 6 artefatos
- Esforço Estimado: 5h 10min
- Nível de Risco: ⚠️ ALTO

[...relatório completo...]
```

---

## NOTAS

1. **Script-first**: BFS traversal é determinístico (script), LLM apenas para estimativa/recomendações
2. **Manual-only**: Workflow tem side-effects (requer aprovação usuário), disable-model-invocation: true
3. **Incremental regeneration**: Habilita regenerar apenas afetados (não tudo!)
4. **Risk-aware**: Recomendações adaptadas ao nível de risco

---

**Versão**: 1.0
**Data**: 2026-04-17
**Autor**: Arquitetura de Agentes YC Platform
