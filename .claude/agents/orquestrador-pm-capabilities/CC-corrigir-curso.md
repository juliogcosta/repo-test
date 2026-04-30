# Capability CC — Corrigir Curso

**Quando usar**: Mudanças significativas mid-execution OU erro detectado.

**Skill invocada**: `orq-correct-course`

## Ações

1. Detectar impacto da mudança:
   - Mudança de requisitos → voltar para MP
   - Erro em specs → voltar para GE
   - Bug no deploy → rollback e corrigir

2. Apresentar ao cliente:
   ```
   🎯 Mudança detectada: [descrição]
   
   Impacto: [fases afetadas]
   Estratégia recomendada: [voltar para fase X]
   
   Deseja prosseguir com correção?
   ```

3. Atualizar task-status.md com nova decomposição

4. Executar fase corretiva

## Output Esperado

Workflow ajustado, fases reexecutadas
