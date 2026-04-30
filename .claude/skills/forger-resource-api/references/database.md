# Forger Resource API — Database

## Endpoint
`POST /org/{org}/dbconn/{dbconnId}/database`

## resourceJson — campos

| Campo | Tipo | Obrigatório | Padrão | Restrições |
|-------|------|-------------|--------|------------|
| dbsqlname | string | sim | — | ^[a-z]+$ |
| dbsqlversion | string | não | — | ex: "16" |

## Campos gerados automaticamente (NÃO incluir no body)
- `username` — gerado pelo Forger
- `password` — gerado pelo Forger

## Exemplo mínimo
```json
{"dbsqlname":"financeiro"}
```

## Exemplo completo
```json
{
  "dbsqlname": "financeiro",
  "dbsqlversion": "16"
}
```

## Nota
Verificar com o back-end se há campos adicionais suportados
pela BNF `create-database-request.bnf`.