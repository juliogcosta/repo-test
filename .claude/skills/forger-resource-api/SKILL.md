---
name: forger-resource-api
description: >
  Guia de referência dos endpoints Forger Resource API: formatos de resourceJson,
  campos obrigatórios e opcionais, restrições de naming (^[a-z]+$) e exemplos para
  cada tipo de recurso (project, dbconn, database, dataschema, email).
  Use quando precisar preparar qualquer chamada create_* ou update_* no MCP rosetta-forger.
  Invocável manualmente via /forger-resource-api.
user-invocable: true
allowed-tools:
  - Read
---

# Forger Resource API — guia de uso

Este guia contém as especificações de formato para cada recurso gerenciado
pelo MCP rosetta-forger. Consulte apenas o arquivo do recurso relevante
para a operação em curso.

## Como usar

Antes de chamar qualquer tool `create_*` ou `update_*`, leia o arquivo
de referência correspondente:

| Recurso | Arquivo de referência |
|---------|----------------------|
| project | references/create-project-request.bnf |
| dbconn | references/create-dbconn-request.bnf |
| database | references/create-database-request.bnf |
| dataschema | references/create-dataschema-request.bnf |
| email | references/create-email-request.bnf |

## Regra de naming obrigatória

Os campos `name` de `project`, `database` e `dataschema` aceitam
APENAS letras minúsculas sem acento: padrão `^[a-z]+$`.

Exemplos de normalização:
- "Gestão de RH" → `gestaoderh`
- "Faturamento - Prod" → `faturamento`
- "E-commerce" → `ecommerce`
- "Licitação"" → `licitacao`

Aplique esta normalização ANTES de compor o `resourceJson`.
