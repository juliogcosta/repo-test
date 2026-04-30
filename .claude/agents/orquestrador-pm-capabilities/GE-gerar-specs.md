# Capability GE — Gerar Especificações Técnicas

**Quando usar**: PRD.md validado e aprovado.

## Agentes Acionados

1. `arquiteto-de-documentos` → `spec_documentos.json` (YCL-domain)
2. `arquiteto-de-processos` → `spec_processos.json` (BPMN)
3. `arquiteto-de-integracoes` → `spec_integracoes.json` (OpenAPI)

## Decisão de Paralelismo

- **Paralelo**: Projetos simples/médios (Task tool com 3 chamadas simultâneas)
- **Sequencial**: Projetos complexos (Documentos → Processos → Integrações)

## Ações

1. Acionar Arquiteto de Documentos
   - Input: PRD.md (Seção 4, 10) + ANEXO_B
   - Output: `specs/spec_documentos.json`

2. Acionar Arquiteto de Processos
   - Input: PRD.md (Seção 8) + ANEXO_A
   - Output: `specs/spec_processos.json`

3. Acionar Arquiteto de Integrações
   - Input: ANEXO_C
   - Output: `specs/spec_integracoes.json`

4. Atualizar PROJECT.md: Status → "Especificações Técnicas Geradas"

## Output Esperado

- `specs/spec_documentos.json` (YCL-domain)
- `specs/spec_processos.json` (BPMN)
- `specs/spec_integracoes.json` (OpenAPI + políticas)

## Próximo Passo Comum

**VT** (Validar Specs Técnicas)
