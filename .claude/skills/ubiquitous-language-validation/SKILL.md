---
name: ubiquitous-language-validation
description: >
  Skill standalone para validação semântica de termos contra glossário UBIQUITOUS_LANGUAGE.yaml.
  Valida conformidade terminológica de documentos, conversações ou specs. Detecta forbidden synonyms,
  termos novos e ambiguidades. Gera relatório detalhado com taxa de conformidade. Invocada pelo
  Guardião, Analista de Negócio, QA de Specs ou manualmente via /ubiquitous-language-validation.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
---

# Validação de Linguagem Ubíqua
## Skill para validação semântica contra glossário

> **Objetivo**: Validar se termos usados em texto/documento/conversação estão conformes com o glossário UBIQUITOUS_LANGUAGE.yaml, detectar forbidden synonyms, termos novos, e ambiguidades.

---

## CRITICAL LLM INSTRUCTIONS

- **MANDATORY:** Execute ALL steps in the flow section IN EXACT ORDER
- DO NOT skip steps or change the sequence
- HALT immediately when halt-conditions are met
- Each action within a step is a REQUIRED action to complete that step

---

## INPUT ESPERADO

- **`text_to_validate`**: Texto, documento ou transcrição de conversação
- **`glossary_path`**: Caminho para UBIQUITOUS_LANGUAGE.yaml
- **`current_bc`**: Bounded Context atual (opcional, se aplicável)
- **`validation_mode`**: "strict" | "permissive" | "advisory"

---

## FLOW

### Step 1: Carregar Glossário

**Action 1.1: Ler UBIQUITOUS_LANGUAGE.yaml**
- Buscar arquivo em `{glossary_path}`
- Se não existir → ERRO: "Glossário não encontrado em {path}"
- Carregar estrutura completa em memória

**Action 1.2: Indexar termos**
- Criar índice de:
  - global_terms
  - bounded_context_terms[current_bc] (se `current_bc` fornecido)
  - forbidden_synonyms (de todos os termos)
  - ambiguous_terms

---

### Step 2: Extrair Termos do Texto

**Action 2.1: Parsear texto**
- Ler `text_to_validate`
- Extrair substantivos, verbos, frases nominais relevantes
- Filtrar stopwords genéricas ("o", "a", "de", etc)

**Action 2.2: Normalizar termos**
- Converter para formato consistente (PascalCase para Aggregates, etc)
- Agrupar variações (singular/plural)

---

### Step 3: Validar Cada Termo

**Action 3.1: Para cada termo extraído, aplicar algoritmo de validação**

```python
def validar_termo(termo, current_bc):
    # 1. Verificar se está em global_terms
    if termo in global_terms:
        return {
            "status": "CONFORME",
            "source": "global_terms",
            "definition": get_definition(termo)
        }

    # 2. Verificar se está em bounded_context_terms do BC atual
    if current_bc and termo in bounded_context_terms[current_bc]:
        return {
            "status": "CONFORME",
            "source": f"bounded_context_terms[{current_bc}]",
            "definition": get_definition(termo)
        }

    # 3. Verificar se está em forbidden_synonyms
    for term_obj in all_terms:
        if termo in term_obj.forbidden_synonyms:
            return {
                "status": "FORBIDDEN",
                "correct_term": term_obj.term,
                "reason": f"'{termo}' é sinônimo proibido de '{term_obj.term}'"
            }

    # 4. Verificar se está em ambiguous_terms
    if termo in ambiguous_terms:
        return {
            "status": "AMBÍGUO",
            "reason": get_ambiguity_description(termo),
            "requires_resolution": True
        }

    # 5. Termo não encontrado
    return {
        "status": "NOVO_TERMO",
        "action": "Solicitar definição"
    }
```

**Action 3.2: Compilar resultados**
- Agrupar por status: CONFORME, FORBIDDEN, AMBÍGUO, NOVO_TERMO
- Contar ocorrências de cada termo

---

### Step 4: Gerar Relatório de Conformidade

**Action 4.1: Calcular estatísticas**
```python
total_termos = len(termos_extraidos)
conformes = count(termos where status == "CONFORME")
nao_conformes = total_termos - conformes
conformity_rate = (conformes / total_termos) * 100
```

**Action 4.2: Estruturar relatório em markdown**

```markdown
## Relatório de Conformidade Semântica

**Data**: {timestamp}
**Glossário**: {glossary_path} (versão {version})
**Bounded Context**: {current_bc}
**Validation Mode**: {validation_mode}

---

### Status Geral
- ✅ **Conforme**: {conformity_rate}% ({conformes}/{total_termos} termos)
- ⚠️ **Não Conforme**: {100-conformity_rate}% ({nao_conformes}/{total_termos} termos)

---

### Detalhes de Não Conformidade

#### ❌ Forbidden Synonyms ({count})
{Para cada termo FORBIDDEN:}
- **Termo usado**: "{termo}"
- **Localização**: linha {N} (se disponível)
- **Termo correto**: "{correct_term}"
- **Definição**: "{definition}"
- **Ação**: Substituir todas as ocorrências

#### ⚠️ Termos Ambíguos ({count})
{Para cada termo AMBÍGUO:}
- **Termo usado**: "{termo}"
- **Problema**: {ambiguity_description}
- **Ação**: Esclarecer contexto ou usar termo específico

#### ℹ️ Termos Novos (não no glossário) ({count})
{Para cada NOVO_TERMO:}
- **Termo usado**: "{termo}"
- **Ocorrências**: {count}x
- **Ação**: Definir e adicionar ao glossário

---

### Termos Conformes (amostra)
{Listar primeiros 10 termos conformes}
✅ {termo} ({source}, definição: {definition_excerpt})

---

### Ações Requeridas

**Validation Mode: {validation_mode}**
{Se strict:}
- 🚫 **BLOQUEIO**: Documento não pode prosseguir até correções
- **Prazo**: Corrigir {nao_conformes} termos não conformes

{Se permissive:}
- ⚠️ **ALERTA**: Recomendado corrigir, mas não bloqueia workflow
- **Prioridade**: Corrigir termos FORBIDDEN (crítico), revisar AMBÍGUOS (importante)

{Se advisory:}
- ℹ️ **SUGESTÃO**: Correções opcionais para melhor clareza semântica

---

**Assinatura**: ubiquitous-language-validation v1.0
**Glossário Hash**: {sha256_hash}
```

---

### Step 5: Aplicar Validation Mode

**Action 5.1: Decidir ação conforme mode**

```python
if validation_mode == "strict":
    if nao_conformes > 0:
        return BLOCK_WORKFLOW + relatório
    else:
        return APPROVE + relatório

elif validation_mode == "permissive":
    return WARN + relatório  # Não bloqueia

elif validation_mode == "advisory":
    return SUGGEST + relatório  # Apenas informa
```

---

## OUTPUT

**Formato**: Markdown report

**Conteúdo**:
1. Estatísticas de conformidade
2. Lista de termos não conformes (FORBIDDEN, AMBÍGUO, NOVO_TERMO)
3. Amostra de termos conformes
4. Ações requeridas conforme validation_mode
5. Assinatura digital + hash do glossário

**Arquivo de saída** (opcional):
- Se solicitado, salvar relatório em `{output_path}/conformity-report-{timestamp}.md`

---

## VALIDATION RULES (Aplicadas)

1. **VR-001**: Termo deve estar no glossário (global ou BC-específico)
2. **VR-002**: Forbidden synonyms não podem ser usados
3. **VR-003**: Termos ambíguos requerem esclarecimento de contexto
4. **VR-004**: Termos de BC1 não podem ser usados em BC2 sem tradução (via context_mappings)

---

## INTEGRATION

**Invocada por**:
- Guardião de Linguagem Ubíqua (primário)
- Analista de Negócio (após gerar seções do PRD.md + ANEXOS)
- QA de Specs (para validar spec_processos.json, spec_documentos.json, spec_integracoes.json)
- Assistente de Projeto (validação standalone)

**Input típico do Guardião**:
```
Guardião: Invocar skill ubiquitous-language-validation

Parâmetros:
- text_to_validate: {PRD.md + ANEXOS content}
- glossary_path: {project_root}/UBIQUITOUS_LANGUAGE.yaml
- current_bc: null (validar todos os BCs)
- validation_mode: strict

Aguardando relatório...
```

---

## EXEMPLO DE EXECUÇÃO

### Input
```
text_to_validate: "O licitante envia oferta para licitação. Após validação, gestor faz aprovação."
glossary_path: ./UBIQUITOUS_LANGUAGE.yaml
current_bc: proposta
validation_mode: strict
```

### Processamento
1. Carregar glossário (version 1.3)
2. Extrair termos: ["licitante", "oferta", "licitação", "validação", "gestor", "aprovação"]
3. Validar:
   - "licitante" → ✅ CONFORME (global_terms)
   - "oferta" → ❌ FORBIDDEN (substituir por "Proposta")
   - "licitação" → ✅ CONFORME (global_terms)
   - "validação" → ✅ CONFORME (BC 'proposta')
   - "gestor" → ✅ CONFORME (global_terms, tipo: Actor)
   - "aprovação" → ⚠️ AMBÍGUO (3 significados possíveis)

### Output
```markdown
## Relatório de Conformidade Semântica

**Data**: 2026-04-15 16:30:00
**Glossário**: ./UBIQUITOUS_LANGUAGE.yaml (versão 1.3)
**Bounded Context**: proposta
**Validation Mode**: strict

---

### Status Geral
- ✅ **Conforme**: 67% (4/6 termos)
- ⚠️ **Não Conforme**: 33% (2/6 termos)

---

### Detalhes de Não Conformidade

#### ❌ Forbidden Synonyms (1)
- **Termo usado**: "oferta"
- **Termo correto**: "Proposta"
- **Definição**: "Documento formal submetido por Licitante em resposta a Licitação"
- **Ação**: Substituir por "Proposta"

#### ⚠️ Termos Ambíguos (1)
- **Termo usado**: "aprovação"
- **Problema**: Termo usado com 3 significados: AprovacaoTecnica, AprovacaoJuridica, AprovacaoFinal
- **Ação**: Especificar qual tipo de aprovação (consultar UBIQUITOUS_LANGUAGE.yaml linha 145)

---

### Termos Conformes
✅ licitante (global_terms, Actor)
✅ licitação (global_terms, Aggregate)
✅ validação (BC 'proposta', ValueObject)
✅ gestor (global_terms, Actor)

---

### Ações Requeridas

**Validation Mode: strict**
- 🚫 **BLOQUEIO**: Documento não pode prosseguir até correções
- **Prazo**: Corrigir 2 termos não conformes

**Itens Críticos**:
1. Substituir "oferta" → "Proposta" (1 ocorrência)
2. Esclarecer "aprovação" (especificar tipo)

---

**Assinatura**: ubiquitous-language-validation v1.0
**Glossário Hash**: sha256:7a8f9e2c4b1d3f5e...
```

---

## NOTAS

1. **Precision vs Recall**: Skill prioriza precision (poucos falsos positivos) sobre recall
2. **Context-aware**: Leva em conta current_bc ao validar termos
3. **Non-blocking no advisory mode**: Útil para brainstorming inicial
4. **Idempotente**: Mesma validação sempre produz mesmo resultado (dado mesmo glossário)

---

**Versão**: 1.0
**Data**: 2026-04-15
**Autor**: Arquitetura de Agentes YC Platform
