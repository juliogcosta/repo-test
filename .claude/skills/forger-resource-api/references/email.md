# Forger Resource API — Email Service

## Endpoint
`POST /v3/forger/org/{org}/project/{project}/email`

## resourceJson — campos

| Campo | Tipo | Obrigatório | Padrão | Restrições |
|-------|------|-------------|--------|------------|
| name | string | sim | — | nome identificador do serviço |
| token | string | sim | — | API token do provedor de email |
| status | enum | não | ACTIVE | ver abaixo |

## Valores válidos para `status`
- `ACTIVE` — serviço ativo (default)
- `INACTIVE` — serviço desativado

## Exemplo
```json
{
  "name": "mailersend",
  "token": "mlsn.abc123xyz",
  "status": "ACTIVE"
}
```