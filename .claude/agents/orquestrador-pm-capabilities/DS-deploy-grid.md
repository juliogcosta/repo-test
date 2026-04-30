# Capability DS — Deploy no Grid

**Quando usar**: Especificações técnicas validadas e aprovadas.

**⚠️ CRÍTICO**: Requer autorização EXPLÍCITA do cliente.

**Agente acionado**: `deployer-de-specs`

## Ações

1. **Checkpoint com cliente**: Apresentar resumo e pedir autorização

2. Acionar Deployer

3. Deployer executa:
   - Git commit das specs
   - Chamar API Forger para publicar specs
   - Provisionar módulos via MCP rosetta-forger
   - Verificar status
   - Se falha: rollback automático

4. Atualizar PROJECT.md: Status → "Deployed" (ou "Deploy Falhou")

## Exemplo de Comunicação

```
⚠️ **Checkpoint Final**

Especificações prontas para deploy:
- ✅ Processos de Negócio (3 processos BPMN)
- ✅ Documentos/Dados (3 módulos, 8 documentos)

Após deploy, sistema estará operacional no grid.

**IMPORTANTE**: Ação irreversível (com rollback se falhar).

Autoriza deploy no grid de produção?
```

## Output Esperado

Sistema operacional no grid OU relatório de falha

## Próximo Passo Comum

Monitoramento OU correções
