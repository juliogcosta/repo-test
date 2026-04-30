# Capability CIA — Análise de Impacto de Mudanças

**Quando usar**: Antes de modificar um requisito existente.

**Skill invocada**: `/analyze-change-impact`

## Input Esperado

- `changed_id`: ID do requisito (ex: "UJ-04-001")
- `change_description`: Descrição da mudança

## Ações Resumidas

1. **Validar input**: Verificar que `changed_id` existe no RTM.yaml

2. **Executar BFS traversal** (script):
   - `scripts/impact-analysis.sh`: Calcula downstream dependencies
   - Depth 1: Dependências diretas (FRs de Journey)
   - Depth 2: Dependências indiretas (Invariants, Processes)
   - Depth 3+: Specs técnicas

3. **Classificar e estimar esforço** (LLM):
   - UJ: 20-30 min
   - FR: 20-30 min
   - PROC: 45-60 min
   - DOC: 45-60 min
   - INV: 30-45 min
   - Spec (depth 3+): 1-2h + QA

4. **Avaliar risco**:
   - ALTO: depth ≥3 AND total_affected ≥5
   - MÉDIO: depth ≥3 OR total_affected ≥10
   - BAIXO: depth <3 AND total_affected <5

5. **Gerar recomendações**

6. **Gerar relatório**: `IMPACT_REPORT_{changed_id}.md`

## Output Esperado

- `IMPACT_REPORT_{changed_id}.md`
- Decisão: Prosseguir ou reconsiderar

## Próximo Passo Comum

- Se aprovado → EA (regeneração incremental)
- Se recusado → Reconsiderar

## Benefícios

- Performance: 99.7% mais rápido que LLM
- Custo: Zero tokens para BFS
- Precisão: Dependências exatas
- Incremental: Regenerar apenas afetados
