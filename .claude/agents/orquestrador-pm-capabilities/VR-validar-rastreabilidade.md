# Capability VR — Validar Rastreabilidade

**Quando usar**: Após PRD completo ou antes de gerar specs técnicas.

**Skill invocada**: `/validate-traceability`

## Modos Disponíveis

- **structural_only**: Validação rápida via scripts (~5 segundos)
- **structural_and_semantic**: Validação completa incluindo LLM (~2-3 minutos)

## Ações Resumidas

1. **Validação estrutural** (scripts):
   - `scripts/validate-ids.sh`: Formato e unicidade de IDs
   - `scripts/generate-rtm.sh`: Gera RTM.yaml
   - `scripts/validate-links.sh`: Detecta orphan links

2. **Validação semântica** (opcional, se mode == "structural_and_semantic"):
   - LLM verifica consistência conceitual
   - Valida se FRs derivam das Journeys
   - Valida aplicabilidade de Invariantes

3. **Calcular métricas de cobertura**:
   - Upstream Coverage: % FRs com source_journeys (Target: ≥90%)
   - Downstream Coverage: % FRs com links para specs (Target: ≥85%)
   - Orphan Rate: % links inexistentes (Target: 0%)
   - Isolation Rate: % nós isolados (Target: <5%)

4. **Gerar relatório**: `TRACEABILITY_REPORT.md`

## Output Esperado

- `RTM.yaml`: Requirements Traceability Matrix
- `TRACEABILITY_REPORT.md`: Relatório completo
- Status: PASS/WARN/FAIL

## Próximo Passo Comum

- Se PASS → GE
- Se WARN → GE ou EA
- Se FAIL → EA (bloqueio para specs)

## ⚠️ IMPORTANTE

- Script-first: 99% validação por scripts
- LLM opcional: Cara (tokens)
- Incremental: Validar após cada edição
