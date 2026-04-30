# Capability RP — Reportar Progresso

**Quando usar**: Cliente quer status detalhado do projeto.

**Skill invocada**: `orq-report-progress`

## Output Gerado

```markdown
## Relatório de Progresso — {PROJECT_ALIAS}

**Status Atual**: {Status do PROJECT.md}
**Última Atualização**: {timestamp}

### Fases Completadas
- ✅ Fase 0: Intake e Avaliação
- ✅ Fase 1: Mapeamento de Negócio
- 🔄 Fase 2: Geração de Specs (em andamento)
- ⏸️ Fase 3: Validação (pendente)
- ⏸️ Fase 4: Deploy (pendente)

### Artefatos Gerados
- ✅ PROJECT.md
- ✅ PRD.md (v1.2, editado 2x)
- 🔄 spec_documentos.json (em geração)
- ⏸️ spec_processos.json (pendente)

### Próximos Passos
1. Finalizar spec_documentos.json
2. Gerar spec_processos.json
3. Checkpoint com cliente

### Bloqueios
- Nenhum

**Tempo estimado**: 2-3 horas
```

## Próximo Passo Comum

Cliente decide próxima ação
