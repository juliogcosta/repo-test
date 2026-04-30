# Capability VT — Validar Specs Técnicas

**Quando usar**: spec_processos.json + spec_documentos.json gerados.

**Agente acionado**: `qa-de-specs`

## Validações Cruzadas

- Documentos referenciados nos processos existem? ✅
- Ações têm métodos correspondentes nos documentos? ✅
- Regras de negócio obrigatórias respeitadas? ✅
- Conformidade com schemas do grid (BPMN 2.0, YCL-domain)? ✅

## Output Esperado

`specs/QA_REPORT.md` (Aprovado / Lista de issues)

## Ações

- **Se aprovado**: Atualizar PROJECT.md → "Especificações Validadas", prosseguir para DS
- **Se reprovado**: Re-acionar Arquitetos OU Analista

## Próximo Passo Comum

**DS** (Deploy no Grid)
