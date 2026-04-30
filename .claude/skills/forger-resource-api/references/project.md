# Forger Resource API — Project
  
   ## Endpoint
   `POST /org/{org}/project`
   
   ## resourceJson — campos
   
   | Campo       | Tipo   | Obrigatório | Padrão   | Restrições |
   | ----------- | ------ | ----------- | -------- | ---------- |
   | name        | string | sim         | —        | ^[a-z]+$   |
   | alias       | string | não         | —        | —          |
   | description | string | não         | —        | —          |
   | status      | enum   | não         | MODELING | ver abaixo |
   
   ## Valores válidos para `status`
   Confirmar com o back-end os valores exatos do enum. Esperado:
   - `MODELING` — projeto em modelagem (default)
   - `RUNNING` — projeto com modelo em execução
   - `INACTIVE` — desativado
   
   ## Campos gerados automaticamente (NÃO incluir no body)
   - `secret` — gerado pelo Forger; é o `tenant_pid` do projeto
   
   ## Exemplo mínimo
   ```json
   {"name":"comercial","status":"MODELING"}
   ```
   
   ## Exemplo completo
   ```json
   {
     "name": "comercial",
     "alias": "Sistema Comercial",
     "description": "Plataforma de gestão comercial",
     "status": "MODELING"
   }
   ```
   
   ## O que capturar da resposta
   O campo `secret` no JSON de retorno é o `tenant_pid` — repassar ao Orquestrador com esse nome explícito.
