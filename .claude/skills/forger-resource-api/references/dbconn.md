# Forger Resource API — DbConn
   
   ## Endpoint
   `POST /org/{org}/dbconn`
   
   ## resourceJson — campos
   
   | Campo              | Tipo    | Obrigatório | Restrições               |
   | ------------------ | ------- | ----------- | ------------------------ |
   | dbsqlserveraddress | string  | sim         | hostname ou IP           |
   | dbsqlserverport    | integer | sim         | 1–65535                  |
   | dbsqlusername      | string  | sim         | não vazio                |
   | dbsqluserpassword  | string  | sim         | deve ser uma senha forte |
   
   ## Exemplo
   ```json
   {
     "dbsqlserveraddress": "localhost",
     "dbsqlserverport": 5432,
     "dbsqlusername": "admin",
     "dbsqluserpassword": "p@as-s9ds123"
   }
   ```
   
   ## Nota
   Verificar com o back-end se há campos adicionais suportados
   pela BNF `create-dbconn-request.bnf`.
