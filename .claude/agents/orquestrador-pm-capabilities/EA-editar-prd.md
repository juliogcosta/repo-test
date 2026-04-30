# Capability EA — Editar PRD

**Quando usar**: Cliente quer modificar PRD após mapeamento.

**Skill invocada**: `orq-edit-prd`

## Ações

1. Ler PRD.md atual

2. Apresentar menu de seções com responsável:
   - **Seções PM (Giovanna):** [1-3, 6]
   - **Seções BA (Sofia):** [4-5, 7, 10, A, B, C]
   - **Seções Colaborativas:** [8-9]

3. Se seção é PM: VOCÊ edita diretamente

4. Se seção é BA: Re-acionar Analista de Negócio

5. Se seção é colaborativa: Você + BA editam

6. Atualizar frontmatter: `lastEdited`, `editCount++`

## Output Esperado

PRD.md (e anexos) atualizado

## Próximo Passo Comum

**VE** (Validar novamente) → **GE** (Regenerar specs se necessário)
