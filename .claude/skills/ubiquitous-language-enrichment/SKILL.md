---
name: ubiquitous-language-enrichment
description: >
  Skill standalone para enriquecimento do glossário UBIQUITOUS_LANGUAGE.yaml.
  Adiciona novos termos identificados durante elicitação, atualiza definições existentes,
  resolve ambiguidades. Mantém changelog e versiona automaticamente. Invocada pelo Guardião
  de Linguagem Ubíqua ou manualmente via /ubiquitous-language-enrichment.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

# Enriquecimento de Linguagem Ubíqua
## Skill para adicionar/atualizar termos no glossário

> **Objetivo**: Adicionar novos termos ao UBIQUITOUS_LANGUAGE.yaml com metadados completos, atualizar definições existentes, resolver ambiguidades, manter changelog.

---

## CRITICAL LLM INSTRUCTIONS

- **MANDATORY:** Execute ALL steps in the flow section IN EXACT ORDER
- DO NOT skip steps or change the sequence
- HALT immediately when halt-conditions are met

---

## INPUT ESPERADO

- **`operation`**: "add_term" | "update_term" | "resolve_ambiguity"
- **`term`**: Nome do termo (requerido)
- **`glossary_path`**: Caminho para UBIQUITOUS_LANGUAGE.yaml
- **`term_data`**: Objeto com metadados do termo (conforme operation)

---

## FLOW

### Step 1: Carregar Glossário

**Action 1.1**: Ler UBIQUITOUS_LANGUAGE.yaml existente
**Action 1.2**: Parsear estrutura YAML completa
**Action 1.3**: Verificar versão atual

---

### Step 2: Executar Operação

#### Operation: "add_term"

**Input requerido em `term_data`**:
```yaml
term: "NovoTermo"
definition: "Definição precisa e não ambígua"
type: "Actor | Aggregate | ValueObject | Event | Command | Process | System"
bounded_context: "nome_bc" (ou null se global)
synonyms: []
forbidden_synonyms: ["termo1", "termo2"]
examples: ["Exemplo 1", "Exemplo 2"]
notes: "Observações adicionais"
```

**Actions**:
1. Validar que termo NÃO existe já (evitar duplicatas)
2. Normalizar nome do termo (PascalCase para Aggregates, etc)
3. Determinar seção correta (global_terms ou bounded_context_terms[bc])
4. Adicionar entrada com metadados completos
5. Incrementar versão do glossário
6. Adicionar entrada no changelog

---

#### Operation: "update_term"

**Input requerido em `term_data`**:
```yaml
term: "TermoExistente"
updates:
  definition: "Nova definição" (opcional)
  forbidden_synonyms: ["adicionar termo"] (opcional)
  examples: ["adicionar exemplo"] (opcional)
reason: "Por que atualização é necessária"
```

**Actions**:
1. Validar que termo EXISTE
2. Fazer backup da definição antiga
3. Aplicar updates
4. Incrementar versão do glossário (minor)
5. Adicionar entrada no changelog com before/after

---

#### Operation: "resolve_ambiguity"

**Input requerido em `term_data`**:
```yaml
ambiguous_term: "TermoAmbiguo"
resolution: "A | B | C" (conforme opções apresentadas pelo Guardião)
new_terms: [
  {term: "TermoEspecifico1", definition: "...", bc: "..."},
  {term: "TermoEspecifico2", definition: "...", bc: "..."}
] (se resolution == "B")
```

**Actions**:
1. Remover termo de `ambiguous_terms`
2. Se resolution == "A" (manter genérico): Documentar scopes específicos
3. Se resolution == "B" (criar termos distintos): Adicionar novos termos
4. Incrementar versão do glossário (minor ou major, conforme impacto)
5. Adicionar entrada no changelog

---

### Step 3: Atualizar Metadados

**Action 3.1**: Atualizar metadata section
```yaml
metadata:
  version: "{new_version}"
  last_updated: "{current_date}"
```

**Action 3.2**: Recalcular statistics
```yaml
statistics:
  total_global_terms: {count}
  total_bc_terms: {count}
  total_ambiguous_terms: {count}
  conformity_rate: {calculate}
```

---

### Step 4: Validar YAML

**Action 4.1**: Validar sintaxe YAML
**Action 4.2**: Validar schema (campos obrigatórios presentes)
**Action 4.3**: Validar não há termos duplicados

---

### Step 5: Salvar e Versionar

**Action 5.1**: Escrever UBIQUITOUS_LANGUAGE.yaml atualizado
**Action 5.2**: Git commit com mensagem descritiva
```bash
git add UBIQUITOUS_LANGUAGE.yaml
git commit -m "feat: adicionar termo '{term}' ao glossário (v{version})"
```

---

## OUTPUT

**Formato**: Confirmação estruturada

```markdown
## Enriquecimento do Glossário - Confirmação

**Operação**: {operation}
**Termo**: {term}
**Status**: ✅ Sucesso

**Detalhes**:
- **Versão anterior**: {old_version}
- **Versão nova**: {new_version}
- **Seção**: {global_terms | bounded_context_terms[bc]}
- **Git commit**: {commit_hash}

**Changelog Entry**:
{changelog_text}

**Estatísticas Atualizadas**:
- Total termos globais: {total_global_terms}
- Total termos por BC: {total_bc_terms}

✅ Glossário atualizado e versionado com sucesso!
```

---

## VALIDATION RULES

1. **Termo novo NÃO pode já existir** (nem em global_terms nem em bounded_context_terms)
2. **Definition é obrigatória** (mínimo 10 caracteres)
3. **Type deve ser enum válido**: Actor | Aggregate | ValueObject | Event | Command | Process | System
4. **Examples são obrigatórios** (mínimo 1)
5. **Forbidden_synonyms recomendados** (para prevenir drift)

---

## EXEMPLO DE EXECUÇÃO

### Input
```yaml
operation: "add_term"
term: "Homologacao"
glossary_path: ./UBIQUITOUS_LANGUAGE.yaml
term_data:
  definition: "Etapa final após aprovação onde contrato é formalizado e assinado pelas partes"
  type: "Process"
  bounded_context: "contrato"
  synonyms: []
  forbidden_synonyms: ["aprovação", "validação"]
  examples: ["Contrato passou pela Homologação e está vigente"]
  notes: "Diferente de Validação (automática) e Aprovação (decisão humana)"
```

### Output
```markdown
## Enriquecimento do Glossário - Confirmação

**Operação**: add_term
**Termo**: Homologacao
**Status**: ✅ Sucesso

**Detalhes**:
- **Versão anterior**: 1.2
- **Versão nova**: 1.3
- **Seção**: bounded_context_terms['contrato']
- **Git commit**: a7f3e9d

**Changelog Entry**:
- version: "1.3"
  date: "2026-04-15"
  author: "Guardião de Linguagem Ubíqua"
  changes: "Adicionado termo 'Homologacao' ao BC 'contrato'"
  terms_added: ["Homologacao"]

**Estatísticas Atualizadas**:
- Total termos globais: 12
- Total termos por BC: 28

✅ Glossário atualizado e versionado com sucesso!
```

---

## INTEGRATION

**Invocada por**: Guardião de Linguagem Ubíqua (primariamente)

**Típico workflow**:
1. Guardião detecta novo termo em conversação
2. Guardião solicita definição ao Analista/Cliente
3. Guardião invoca esta skill com term_data
4. Skill adiciona ao glossário e versiona
5. Guardião confirma adição ao Analista

---

**Versão**: 1.0
**Data**: 2026-04-15
**Autor**: Arquitetura de Agentes YC Platform
