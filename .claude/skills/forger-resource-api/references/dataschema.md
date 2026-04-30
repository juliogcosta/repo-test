- # Forger Resource API — DataSchema
   
   ## Endpoint
   `POST /org/{org}/project/{project}/database/{databaseId}/dataschema`
   
   ## resourceJson — campos
   
   | Campo                | Tipo    | Obrigatório | Padrão   | Restrições |
   | -------------------- | ------- | ----------- | -------- | ---------- |
   | name                 | string  | sim         | —        | ^[a-z]+$   |
   | alias                | string  | não         | —        | —          |
   | description          | string  | não         | —        | —          |
   | status               | enum    | não         | MODELING | ver abaixo |
   | dbsqlminimumconnidle | integer | não         | 0        | —          |
   | dbsqlmaximumpoolsize | integer | não         | 2        | —          |
   
   ## Valores válidos para `status`
   Confirmar com o back-end os valores exatos do enum. Esperado:
   - `MODELING` — dataschema em modelagem (default)
   - `RUNNING` — dataschema com modelo em execução
   - `INACTIVE` — desativado
   
   ## O que capturar da resposta
   O campo `tenantid` no JSON de retorno é o `tenant_id` — UUID que identifica este Bounded Context. Repassar ao Orquestrador associado ao nome de negócio do Bounded Context correspondente.
   
   ## Exemplo mínimo
   ```json
   {"name":"financeiro","status":"MODELING"}
   ```
   
   ## Exemplo completo
   ```json
   {
     "name": "financeiro",
     "alias": "Financeiro - Produção",
     "description": "Bounded Context de gestão financeira",
     "status": "ACTIVE",
     "dbsqlminimumconnidle": 2,
     "dbsqlmaximumpoolsize": 10
   }
   ```
   
   ## Nota
   Verificar com o back-end se há campos adicionais suportados
   pela BNF `create-dataschema-request.bnf`.
