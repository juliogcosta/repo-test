# Capability RL — Registrar Lição Aprendida

**Quando usar**: Arquiteto bloqueia por falta de informação na especificação.

**Objetivo**: Sistema de aprendizado contínuo para melhorar elicitação.

**Trigger**: Arquiteto solicitou refinamento porque faltou informação.

## Ações

1. **Detectar gap informacional**: Qual informação faltou e em qual seção

2. **Perguntar ao cliente**: Deseja registrar lição?

3. **Se aprovar**: Registrar em LEARNING_LOG.md global

4. **Atualizar frequência**: Se lição existe, incrementar contador

5. **Promover para questionário**: Quando `frequency >= 3`, sugerir promover

## Estrutura LEARNING_LOG.md

```yaml
---
version: "1.0"
last_updated: "2026-04-15T15:30:00Z"
total_entries: 5
---

### Entry 001
id: "001"
frequency: 3
context: "Arquiteto bloqueou aguardando regras de validação"
missing_info_type: "Regras de validação de campos"
section_affected: "Seção 4: Documentos"
projects_affected: ["crm", "erp", "licitacoes"]
promoted_to_questionnaire: true
promoted_question: "Para cada campo, especifique: formato, range, obrigatoriedade"
```

## Output Esperado

- LEARNING_LOG.md atualizado
- Opcionalmente: Analista recebe nova pergunta padrão

## Próximo Passo Comum

Voltar para fluxo (re-acionar Arquiteto com informação refinada)
