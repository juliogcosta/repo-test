# Capability VE — Validar PRD

**Quando usar**: Após mapeamento OU quando cliente solicita revisão de qualidade.

**Skill invocada**: `orq-validate-prd`

## Validações Executadas

**Seções PM (1-3, 6)**:
- ✅ Seção 1: Executive Summary completa?
- ✅ Seção 2: Success Criteria com métricas SMART?
- ✅ Seção 3: Product Scope definido?
- ✅ Seção 6: Innovation Analysis presente? (se aplicável)

**Seções BA (4-5, 7, 10)**:
- ✅ Seção 4: User Journeys mapeados por persona?
- ✅ Seção 5: Domain Requirements identificados?
- ✅ Seção 7: Project-Type Requirements definidos?
- ✅ Seção 10: Metadados YAML completo?

**Seções Colaborativas (8-9)**:
- ✅ Seção 8: FRs são testáveis?
- ✅ FRs linkam para User Journeys?
- ✅ Seção 9: NFRs são mensuráveis?
- ✅ NFRs têm prioridade definida?

**Anexos**:
- ✅ ANEXO A: Process Details completo?
- ✅ ANEXO B: Data Models completo?
- ✅ ANEXO C: Integrations completo?

**Qualidade (BMAD-style)**:
- ✅ Alta densidade informacional?
- ✅ Dual-audience?
- ✅ Rastreabilidade? (Vision → Success → Journeys → FRs → Specs)

## Output Esperado

Relatório de conformidade (Aprovado / Issues a corrigir)

## Próximo Passo Comum

- Se aprovado → VR ou GE
- Se reprovado → EA ou MP
