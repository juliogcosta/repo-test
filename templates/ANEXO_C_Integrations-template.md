# ANEXO C: Integrations & External Systems

**Documento**: ANEXO_C_Integrations-template.md
**Versão**: 1.0
**Responsável**: BA escreve, PM revisa
**Consumido por**: Arquiteto de Integrações → `spec_integracoes.json`

---

## Propósito deste Anexo

Este anexo documenta **todas as integrações** do sistema com:
- Sistemas externos (APIs de terceiros, serviços cloud)
- Sistemas legados internos (ERP, CRM, banco de dados legados)
- Fontes de dados externas (APIs públicas, feeds, webhooks)
- Serviços de infraestrutura (autenticação, pagamento, email, SMS)

**Objetivo**: Fornecer informações suficientes para que o **Arquiteto de Integrações** gere `spec_integracoes.json` com:
- Contratos de API (OpenAPI/Swagger)
- Mapeamento de dados (request/response schemas)
- Políticas de retry, timeout, circuit breaker
- Autenticação/autorização
- Monitoramento e alertas

---

## Estrutura por Integração

Para cada integração externa, documente:

### Integração C.{N}: {Nome do Sistema Externo}

#### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `{integration_id}` (ex: `sefaz_api`) |
| **Nome de Negócio** | {Nome do sistema externo} (ex: "SEFAZ — Consulta de CNPJ") |
| **Módulo** | {Módulo que usa esta integração} (ex: "Licitações") |
| **Tipo de Integração** | REST API / SOAP / GraphQL / Batch / Webhook / Database / Message Queue |
| **Direção** | Outbound (nós chamamos) / Inbound (eles chamam) / Bidirectional |
| **Criticidade** | Alta / Média / Baixa (impacto se indisponível) |
| **SLA do Fornecedor** | {Uptime contratado} (ex: 99.5%) |
| **Link para FR** | {Lista de FRs que dependem desta integração} (ex: FR-003, FR-012) |

#### Descrição

{1-2 sentenças descrevendo o propósito da integração}

**Exemplo**:
*"Integração com SEFAZ para consulta de CNPJ em tempo real durante cadastro de fornecedores. Valida situação fiscal e razão social."*

---

#### Contrato de API

**Base URL**: `{URL base}` (ex: `https://api.sefaz.gov.br/v2`)
**Ambiente de Homologação**: `{URL staging}` (ex: `https://staging.api.sefaz.gov.br/v2`)
**Documentação**: [{Link para docs do fornecedor}]

##### Endpoints Utilizados

###### Endpoint 1: {Nome da operação}

**Método HTTP**: GET / POST / PUT / DELETE / PATCH
**Path**: `{path}` (ex: `/cnpj/{cnpj}`)
**Descrição**: {O que faz} (ex: "Consulta dados cadastrais de CNPJ")

**Headers Obrigatórios**:
```http
Authorization: Bearer {token}
Content-Type: application/json
X-Request-ID: {uuid} (para rastreamento)
```

**Query Parameters**:
| Parâmetro | Tipo | Obrigatório? | Descrição | Exemplo |
|-----------|------|--------------|-----------|---------|
| `cnpj` | string | Sim | CNPJ sem pontuação | `12345678000199` |

**Request Body** (se POST/PUT/PATCH):
```json
{
  "campo1": "valor",
  "campo2": {
    "nested": "valor"
  }
}
```

**Response (Sucesso — 200 OK)**:
```json
{
  "cnpj": "12345678000199",
  "razao_social": "Empresa Exemplo LTDA",
  "situacao_fiscal": "ATIVA",
  "data_consulta": "2025-04-15T10:30:00Z"
}
```

**Response (Erro — 404 Not Found)**:
```json
{
  "error": "CNPJ_NOT_FOUND",
  "message": "CNPJ não encontrado na base SEFAZ",
  "timestamp": "2025-04-15T10:30:00Z"
}
```

**Códigos de Status Possíveis**:
| Status | Significado | Ação do Sistema |
|--------|-------------|-----------------|
| 200 | Sucesso | Processar resposta |
| 400 | CNPJ inválido | Exibir erro ao usuário |
| 401 | Token expirado | Renovar token e retry |
| 404 | CNPJ não encontrado | Exibir mensagem "CNPJ não cadastrado" |
| 429 | Rate limit excedido | Esperar 60s e retry |
| 500 | Erro interno SEFAZ | Retry com backoff exponencial |
| 503 | SEFAZ indisponível | Circuit breaker (fallback para cache) |

**Tempo de Resposta Esperado**: {p95} (ex: 500ms p95, 2s p99)

---

#### Autenticação e Autorização

**Método de Autenticação**: OAuth 2.0 / API Key / JWT / mTLS / Basic Auth / SAML

**Fluxo de Autenticação**:
1. {Passo 1} (ex: "Sistema obtém token via POST /oauth/token com client_id + client_secret")
2. {Passo 2} (ex: "Token JWT válido por 1 hora")
3. {Passo 3} (ex: "Renovação automática 5 minutos antes de expirar")

**Credenciais Necessárias**:
| Credencial | Tipo | Onde Armazenar | Rotação |
|------------|------|----------------|---------|
| `client_id` | string | Azure Key Vault | Não rotaciona |
| `client_secret` | secret | Azure Key Vault | Rotação anual |
| `api_key` | secret | Azure Key Vault | Rotação semestral |

**Scopes/Permissões Necessários**: `{lista de scopes}` (ex: `cnpj:read`, `empresa:read`)

---

#### Mapeamento de Dados

**Sistema Externo → Nosso Sistema**:
| Campo Externo | Tipo | Campo Nosso | Transformação |
|---------------|------|-------------|---------------|
| `cnpj` | string | `Fornecedor.cnpj` | Remove caracteres não-numéricos |
| `razao_social` | string | `Fornecedor.razaoSocial` | Trim + uppercase |
| `situacao_fiscal` | enum | `Fornecedor.statusFiscal` | Map: ATIVA→REGULAR, SUSPENSA→IRREGULAR |

**Nosso Sistema → Sistema Externo**:
| Campo Nosso | Tipo | Campo Externo | Transformação |
|-------------|------|---------------|---------------|
| `Edital.numero` | string | `licitacao_id` | Prefixo "LIC-" + número |

---

#### Políticas de Resiliência

**Timeout**:
- **Connection Timeout**: {tempo} (ex: 5s)
- **Read Timeout**: {tempo} (ex: 10s)
- **Total Request Timeout**: {tempo} (ex: 15s)

**Retry Policy**:
- **Retry em**: Erros 5xx, 429 (rate limit), timeouts, connection errors
- **Não retry em**: Erros 4xx (exceto 429), 401 (após renovar token)
- **Tentativas**: {N} (ex: 3 tentativas)
- **Estratégia**: Exponential backoff (1s, 2s, 4s) com jitter
- **Max Backoff**: {tempo máximo entre retries} (ex: 30s)

**Circuit Breaker**:
- **Threshold de Falhas**: {N falhas consecutivas} (ex: 5 falhas)
- **Timeout de Circuito Aberto**: {tempo} (ex: 60s)
- **Half-Open**: Testa com 1 request após timeout
- **Fallback**: {O que fazer quando circuito aberto} (ex: "Retornar dados do cache com aviso ao usuário")

**Rate Limiting (do nosso lado)**:
- **Limite**: {N requests por segundo} (ex: 10 req/s)
- **Burst**: {N requests simultâneos} (ex: 20 req)
- **Por**: Por tenant / global / por usuário

---

#### Monitoramento e Alertas

**Métricas a Coletar**:
| Métrica | Target | Alerta se |
|---------|--------|-----------|
| **Latência p95** | < 500ms | > 2s por 5 minutos |
| **Taxa de Sucesso** | > 99% | < 95% por 5 minutos |
| **Taxa de Erro 5xx** | < 0.5% | > 2% por 5 minutos |
| **Circuit Breaker Aberto** | 0% do tempo | > 10% do tempo por 10 minutos |
| **Token Expirado** | 0 ocorrências | > 5 ocorrências em 1 hora |

**Logs Obrigatórios** (para cada request):
```json
{
  "timestamp": "2025-04-15T10:30:00Z",
  "integration_id": "sefaz_api",
  "endpoint": "/cnpj/{cnpj}",
  "method": "GET",
  "request_id": "uuid",
  "user_id": "user123",
  "tenant_id": "tenant456",
  "status_code": 200,
  "latency_ms": 450,
  "retry_count": 0,
  "error": null
}
```

**Alertas**:
| Severidade | Condição | Canal | Ação Requerida |
|------------|----------|-------|----------------|
| CRÍTICO | Integração indisponível > 10 min | PagerDuty + Slack | Investigação imediata |
| ALTO | Taxa de erro > 5% | Slack | Investigar em 30 min |
| MÉDIO | Latência > 2s | Email | Investigar em 2h |

---

#### Dependências e Ordem de Execução

**Esta integração depende de**:
- {Lista de outras integrações ou processos que devem completar antes} (ex: "Autenticação OAuth deve completar antes")

**Outras integrações dependem desta**:
- {Lista de integrações que aguardam resultado desta} (ex: "Cadastro de Fornecedor aguarda validação SEFAZ")

**Ordem de Execução** (se integração faz parte de um fluxo):
1. {Passo 1} (ex: "Validar CNPJ via SEFAZ")
2. {Passo 2} (ex: "Consultar Receita Federal")
3. {Passo 3} (ex: "Salvar dados consolidados")

---

#### Tratamento de Erros Específicos

**Cenários de Erro**:

##### Erro 1: CNPJ Inválido (400)
- **Causa**: Usuário digitou CNPJ com formato incorreto
- **Sistema Deve**: Exibir mensagem "CNPJ inválido. Formato: 99.999.999/9999-99"
- **Não Retry**: Não

##### Erro 2: SEFAZ Indisponível (503)
- **Causa**: Sistema SEFAZ em manutenção
- **Sistema Deve**:
  - Circuit breaker abre após 5 falhas
  - Fallback: Permite cadastro parcial + flag "Pendente Validação SEFAZ"
  - Background job tenta novamente a cada 15 minutos
- **Retry**: Sim (com backoff exponencial)

##### Erro 3: Rate Limit Excedido (429)
- **Causa**: Excedemos limite de requests do SEFAZ (100 req/min)
- **Sistema Deve**:
  - Esperar tempo indicado no header `Retry-After`
  - Queue de requests com priorização (validações críticas primeiro)
- **Retry**: Sim (após esperar `Retry-After`)

---

#### Custos e SLA

**Modelo de Cobrança**: Por request / Flat fee / Tier-based
**Custo por Request**: R$ {valor} (ex: R$ 0,05 por consulta)
**Volume Estimado**: {N requests por mês} (ex: 10.000 consultas/mês)
**Custo Mensal Estimado**: R$ {valor total}

**SLA Contratado**:
- **Uptime**: {%} (ex: 99.5%)
- **Latência p95**: {tempo} (ex: < 1s)
- **Suporte**: {nível} (ex: "Suporte 8x5 com SLA de resposta de 4h")

---

#### Ambiente de Testes

**Mock/Sandbox Disponível?**: Sim / Não
**URL de Sandbox**: `{URL}`
**Diferenças do Prod**: {Lista de limitações} (ex: "Rate limit 10x menor", "Dados fictícios")

**Dados de Teste Fornecidos**:
| CNPJ de Teste | Cenário | Response Esperado |
|---------------|---------|-------------------|
| `11111111000191` | CNPJ ativo | 200 OK com razão social "Empresa Teste" |
| `99999999000199` | CNPJ inválido | 404 Not Found |
| `00000000000000` | Erro interno | 500 Internal Server Error |

---

#### Segurança e Compliance

**Dados Sensíveis Trafegados**: Sim / Não
**Tipo de Dados**: PII / Financeiros / Fiscais / Saúde
**Criptografia**:
- **Em Trânsito**: TLS 1.3
- **Em Repouso**: {Se aplicável} (ex: "Tokens criptografados no Azure Key Vault")

**Compliance**:
- **LGPD**: {Como dados pessoais são tratados} (ex: "CNPJ é dado público, razão social armazenada com consentimento")
- **PCI-DSS**: {Se aplicável}
- **SOC 2**: {Se aplicável}

**Auditoria**:
- **Log de Acesso**: Todos os requests logados com user_id + tenant_id
- **Retenção de Logs**: {Período} (ex: 90 dias)
- **Imutabilidade**: Logs enviados para Azure Monitor (append-only)

---

#### Documentação de Referência

- **Docs Oficiais**: [{Link para documentação do fornecedor}]
- **OpenAPI/Swagger**: [{Link para spec OpenAPI}]
- **Postman Collection**: [{Link para collection}]
- **Runbook**: [{Link para runbook de troubleshooting}]
- **Contato do Fornecedor**: {Email/Slack/Telefone}

---

---

## Exemplo Completo: Integração com SEFAZ

### Integração C.1: SEFAZ — Consulta de CNPJ

#### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `sefaz_cnpj_api` |
| **Nome de Negócio** | SEFAZ — Consulta de CNPJ |
| **Módulo** | Licitações (Cadastro de Fornecedores) |
| **Tipo de Integração** | REST API |
| **Direção** | Outbound (nós chamamos) |
| **Criticidade** | Alta (impede cadastro de fornecedores) |
| **SLA do Fornecedor** | 99.5% uptime |
| **Link para FR** | FR-003 (Validação de Fornecedores) |

#### Descrição

Integração com SEFAZ para consulta de CNPJ em tempo real durante cadastro de fornecedores. Valida situação fiscal, razão social, e endereço.

---

#### Contrato de API

**Base URL**: `https://api.sefaz.gov.br/v2`
**Ambiente de Homologação**: `https://staging.api.sefaz.gov.br/v2`
**Documentação**: [https://docs.sefaz.gov.br/api/cnpj](https://docs.sefaz.gov.br/api/cnpj)

##### Endpoint 1: Consulta de CNPJ

**Método HTTP**: GET
**Path**: `/cnpj/{cnpj}`
**Descrição**: Consulta dados cadastrais de CNPJ na Receita Federal

**Headers Obrigatórios**:
```http
Authorization: Bearer {token}
Content-Type: application/json
X-Request-ID: {uuid}
```

**Path Parameters**:
| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| `cnpj` | string (14 dígitos) | CNPJ sem pontuação | `12345678000199` |

**Response (Sucesso — 200 OK)**:
```json
{
  "cnpj": "12345678000199",
  "razao_social": "Empresa Exemplo LTDA",
  "nome_fantasia": "Exemplo Corp",
  "situacao_fiscal": "ATIVA",
  "data_situacao": "2020-01-15",
  "cnae_principal": "6201-5/00",
  "endereco": {
    "logradouro": "Rua Exemplo",
    "numero": "123",
    "bairro": "Centro",
    "cidade": "São Paulo",
    "uf": "SP",
    "cep": "01234000"
  },
  "data_consulta": "2025-04-15T10:30:00Z"
}
```

**Response (Erro — 404 Not Found)**:
```json
{
  "error": "CNPJ_NOT_FOUND",
  "message": "CNPJ não encontrado na base da Receita Federal",
  "timestamp": "2025-04-15T10:30:00Z"
}
```

**Códigos de Status Possíveis**:
| Status | Significado | Ação do Sistema |
|--------|-------------|-----------------|
| 200 | Sucesso | Preencher formulário com dados SEFAZ |
| 400 | CNPJ inválido | Exibir "CNPJ inválido. Verifique o formato." |
| 401 | Token expirado | Renovar token OAuth e retry (1 tentativa) |
| 404 | CNPJ não encontrado | Exibir "CNPJ não cadastrado na Receita Federal" |
| 429 | Rate limit excedido | Esperar tempo do header `Retry-After` (max 60s) |
| 500 | Erro interno SEFAZ | Retry 3x com backoff (1s, 2s, 4s) |
| 503 | SEFAZ indisponível | Abrir circuit breaker, fallback para cadastro parcial |

**Tempo de Resposta Esperado**: 500ms (p95), 2s (p99)

---

#### Autenticação e Autorização

**Método de Autenticação**: OAuth 2.0 (Client Credentials)

**Fluxo de Autenticação**:
1. Sistema obtém token via `POST /oauth/token` com `client_id` + `client_secret`
2. Token JWT válido por 1 hora
3. Renovação automática 5 minutos antes de expirar
4. Se renovação falhar, usar token antigo até 1 minuto antes de expirar
5. Se ambos falharem, alertar CRÍTICO (integração indisponível)

**Credenciais Necessárias**:
| Credencial | Tipo | Onde Armazenar | Rotação |
|------------|------|----------------|---------|
| `client_id` | string | Azure Key Vault (`sefaz-client-id`) | Não rotaciona |
| `client_secret` | secret | Azure Key Vault (`sefaz-client-secret`) | Anual (próxima: 2026-12-31) |

**Scopes Necessários**: `cnpj:read`, `empresa:read`

---

#### Mapeamento de Dados

**SEFAZ → Nosso Sistema**:
| Campo SEFAZ | Tipo | Campo Nosso | Transformação |
|-------------|------|-------------|---------------|
| `cnpj` | string | `Fornecedor.cnpj` | Remove caracteres não-numéricos |
| `razao_social` | string | `Fornecedor.razaoSocial` | Trim + title case |
| `nome_fantasia` | string | `Fornecedor.nomeFantasia` | Trim + title case |
| `situacao_fiscal` | enum | `Fornecedor.statusFiscal` | Map: ATIVA→REGULAR, SUSPENSA→IRREGULAR, BAIXADA→INATIVA |
| `endereco.logradouro` | string | `Fornecedor.endereco.rua` | Trim |
| `endereco.cidade` | string | `Fornecedor.endereco.cidade` | Trim |
| `endereco.uf` | string (2 chars) | `Fornecedor.endereco.estado` | Uppercase |

---

#### Políticas de Resiliência

**Timeout**:
- **Connection Timeout**: 5s
- **Read Timeout**: 10s
- **Total Request Timeout**: 15s

**Retry Policy**:
- **Retry em**: 5xx, 429, timeouts, connection errors
- **Não retry em**: 4xx (exceto 429), 401 após renovar token
- **Tentativas**: 3
- **Estratégia**: Exponential backoff (1s, 2s, 4s) com jitter aleatório (±20%)
- **Max Backoff**: 30s

**Circuit Breaker**:
- **Threshold**: 5 falhas consecutivas
- **Timeout**: 60s (circuito aberto)
- **Half-Open**: Testa com 1 request após 60s
- **Fallback**:
  - Permite cadastro parcial de fornecedor com flag `pendente_validacao_sefaz = true`
  - Exibe aviso: "SEFAZ temporariamente indisponível. Validação será feita automaticamente em breve."
  - Background job tenta validação a cada 15 minutos

**Rate Limiting (nosso lado)**:
- **Limite**: 10 req/s (limite SEFAZ é 100 req/min)
- **Burst**: 20 requests simultâneos
- **Por**: Global (todas tenants somadas)

---

#### Monitoramento e Alertas

**Métricas a Coletar**:
| Métrica | Target | Alerta se |
|---------|--------|-----------|
| **Latência p95** | < 500ms | > 2s por 5 minutos |
| **Taxa de Sucesso** | > 99% | < 95% por 5 minutos |
| **Taxa de Erro 5xx** | < 0.5% | > 2% por 5 minutos |
| **Circuit Breaker Aberto** | 0% | > 10% do tempo por 10 minutos |
| **Token Expirado (falha renovação)** | 0 | > 3 ocorrências em 1 hora |

**Logs** (exemplo):
```json
{
  "timestamp": "2025-04-15T10:30:00.123Z",
  "integration_id": "sefaz_cnpj_api",
  "endpoint": "/cnpj/12345678000199",
  "method": "GET",
  "request_id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "user_789",
  "tenant_id": "tenant_abc",
  "status_code": 200,
  "latency_ms": 450,
  "retry_count": 0,
  "error": null
}
```

**Alertas**:
| Severidade | Condição | Canal | Ação |
|------------|----------|-------|------|
| CRÍTICO | Integração indisponível > 10 min | PagerDuty + Slack #incidents | Investigação imediata + comunicar clientes |
| ALTO | Taxa de erro > 5% | Slack #alerts | Investigar em 30 min |
| MÉDIO | Latência > 2s (p95) | Email | Investigar em 2h |

---

#### Tratamento de Erros Específicos

##### Erro 1: CNPJ Inválido (400)
- **Causa**: Formato incorreto (ex: letras, menos de 14 dígitos)
- **Sistema Deve**: Exibir "CNPJ inválido. Formato: 99.999.999/9999-99"
- **Retry**: Não

##### Erro 2: SEFAZ Indisponível (503)
- **Causa**: Manutenção programada SEFAZ (geralmente domingos 22h-2h)
- **Sistema Deve**:
  - Circuit breaker abre após 5 falhas
  - Fallback: Cadastro parcial + flag `pendente_validacao_sefaz`
  - Background job retry a cada 15 minutos
  - Notificar usuário: "Validação SEFAZ será feita automaticamente"
- **Retry**: Sim (via background job)

##### Erro 3: Rate Limit (429)
- **Causa**: Excedemos 100 req/min
- **Sistema Deve**:
  - Ler header `Retry-After` (ex: 60 segundos)
  - Queue de requests com priorização (validações de edital crítico primeiro)
  - Retry após `Retry-After`
- **Retry**: Sim (após esperar)

---

#### Custos e SLA

**Modelo de Cobrança**: Por request
**Custo por Request**: R$ 0,05
**Volume Estimado**: 10.000 consultas/mês
**Custo Mensal Estimado**: R$ 500,00

**SLA Contratado**:
- **Uptime**: 99.5% (downtime permitido: 3,6h/mês)
- **Latência p95**: < 1s
- **Suporte**: 8x5 (Seg-Sex 9h-18h) com SLA de resposta de 4h

---

#### Ambiente de Testes

**Mock/Sandbox**: Sim
**URL Sandbox**: `https://staging.api.sefaz.gov.br/v2`
**Diferenças do Prod**: Rate limit 10x menor (10 req/min), dados fictícios

**CNPJs de Teste**:
| CNPJ | Cenário | Response |
|------|---------|----------|
| `11111111000191` | CNPJ ativo | 200 OK com razão social "Empresa Teste LTDA" |
| `22222222000172` | CNPJ suspenso | 200 OK com `situacao_fiscal: "SUSPENSA"` |
| `99999999000199` | CNPJ inválido | 404 Not Found |
| `00000000000000` | Erro interno | 500 Internal Server Error |

---

#### Segurança e Compliance

**Dados Sensíveis**: Não (CNPJ é dado público)
**Criptografia**:
- **Em Trânsito**: TLS 1.3
- **Em Repouso**: Tokens no Azure Key Vault (AES-256)

**Compliance**:
- **LGPD**: CNPJ é dado público. Razão social armazenada com base legal "execução de contrato" (fornecedor em licitação).
- **Auditoria**: Todos os requests logados com user_id + tenant_id, retenção 90 dias, logs imutáveis no Azure Monitor.

---

#### Documentação de Referência

- **Docs Oficiais**: [https://docs.sefaz.gov.br/api/cnpj](https://docs.sefaz.gov.br/api/cnpj)
- **OpenAPI Spec**: [https://api.sefaz.gov.br/v2/openapi.json](https://api.sefaz.gov.br/v2/openapi.json)
- **Postman Collection**: [Link interno Confluence]
- **Runbook**: [Link interno Wiki - Troubleshooting SEFAZ]
- **Contato**: suporte-api@sefaz.gov.br / Slack: #parceiros-sefaz

---

---

## Exemplo 2: Integração com Sistema Legado (Database)

### Integração C.2: ERP Legado — Consulta de Orçamento

#### Metadados

| Campo | Valor |
|-------|-------|
| **ID Técnico** | `erp_legado_db` |
| **Nome de Negócio** | ERP Legado — Consulta de Orçamento Disponível |
| **Módulo** | Licitações (Aprovação de Edital) |
| **Tipo de Integração** | Database (SQL Server) |
| **Direção** | Outbound (nós lemos) |
| **Criticidade** | Alta (bloqueia aprovação de edital) |
| **SLA do Fornecedor** | N/A (interno) |
| **Link para FR** | FR-005 (Aprovação de Edital com Validação Orçamentária) |

#### Descrição

Consulta direta ao banco de dados do ERP legado para verificar orçamento disponível antes de aprovar edital. ERP não possui API, apenas acesso via JDBC.

---

#### Contrato de Database

**Tipo de Database**: SQL Server 2019
**Host**: `erp-legado.internal.ycodify.com:1433`
**Database Name**: `ERP_PRODUCAO`
**Schema**: `orcamento`

**Tabela Consultada**: `orcamento.centro_custo`

**Estrutura da Tabela**:
```sql
CREATE TABLE orcamento.centro_custo (
    id INT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL,
    descricao VARCHAR(200),
    orcamento_anual DECIMAL(15,2),
    orcamento_consumido DECIMAL(15,2),
    orcamento_disponivel AS (orcamento_anual - orcamento_consumido),
    ano INT,
    updated_at DATETIME
);
```

**Query Utilizada**:
```sql
SELECT
    codigo,
    descricao,
    orcamento_disponivel,
    updated_at
FROM orcamento.centro_custo
WHERE codigo = ? AND ano = YEAR(GETDATE())
```

**Response (Sucesso)**:
| Coluna | Tipo | Exemplo |
|--------|------|---------|
| `codigo` | VARCHAR(20) | `CC-001-2025` |
| `descricao` | VARCHAR(200) | `Departamento de Compras` |
| `orcamento_disponivel` | DECIMAL(15,2) | `150000.50` |
| `updated_at` | DATETIME | `2025-04-15 08:30:00` |

**Response (Erro — Centro de Custo Não Encontrado)**:
- Query retorna 0 linhas

**Tempo de Resposta Esperado**: 100ms (p95), 500ms (p99)

---

#### Autenticação e Autorização

**Método**: SQL Server Authentication (usuário + senha)

**Credenciais**:
| Credencial | Onde Armazenar |
|------------|----------------|
| `username` | Azure Key Vault (`erp-legado-username`) |
| `password` | Azure Key Vault (`erp-legado-password`) |

**Permissões Necessárias**: `SELECT` em `orcamento.centro_custo` (read-only)

**Connection String**:
```
Server=erp-legado.internal.ycodify.com,1433;Database=ERP_PRODUCAO;User Id={username};Password={password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=5;
```

---

#### Mapeamento de Dados

**ERP → Nosso Sistema**:
| Campo ERP | Tipo | Campo Nosso | Transformação |
|-----------|------|-------------|---------------|
| `codigo` | VARCHAR(20) | `Edital.centroCustoCodigo` | Trim |
| `orcamento_disponivel` | DECIMAL(15,2) | `Edital.orcamentoDisponivel` | Converter para centavos (int64) |
| `updated_at` | DATETIME | `Edital.orcamentoValidadoEm` | Converter para ISO 8601 UTC |

---

#### Políticas de Resiliência

**Timeout**:
- **Connection Timeout**: 5s
- **Query Timeout**: 10s

**Retry Policy**:
- **Retry em**: Connection errors, timeouts, transient SQL errors (deadlock, timeout)
- **Não retry em**: Autenticação falhou, query syntax error
- **Tentativas**: 3
- **Estratégia**: Exponential backoff (1s, 2s, 4s)

**Circuit Breaker**:
- **Threshold**: 10 falhas consecutivas
- **Timeout**: 120s
- **Fallback**: Bloquear aprovação de edital + notificar administrador

**Connection Pool**:
- **Min Connections**: 2
- **Max Connections**: 10
- **Idle Timeout**: 30s
- **Max Lifetime**: 30 minutos (reconectar a cada 30 min)

---

#### Monitoramento e Alertas

**Métricas**:
| Métrica | Target | Alerta se |
|---------|--------|-----------|
| **Latência p95** | < 100ms | > 500ms por 5 minutos |
| **Taxa de Sucesso** | > 99.5% | < 98% por 5 minutos |
| **Connection Pool Esgotado** | 0 | > 5 ocorrências em 10 minutos |
| **Dados Desatualizados** | `updated_at` < 24h | > 48h atrás |

**Alertas**:
| Severidade | Condição | Canal |
|------------|----------|-------|
| CRÍTICO | Database inacessível > 5 min | PagerDuty |
| ALTO | Dados desatualizados > 48h | Slack |
| MÉDIO | Latência > 500ms | Email |

---

#### Tratamento de Erros

##### Erro 1: Centro de Custo Não Encontrado
- **Causa**: Query retorna 0 linhas
- **Sistema Deve**: Exibir "Centro de custo '{codigo}' não encontrado no ERP. Verifique o código."
- **Retry**: Não

##### Erro 2: Database Inacessível
- **Causa**: Connection timeout, network error
- **Sistema Deve**:
  - Retry 3x com backoff
  - Se todas falharem, bloquear aprovação + alertar CRÍTICO
- **Retry**: Sim

##### Erro 3: Dados Desatualizados
- **Causa**: `updated_at` > 48h atrás
- **Sistema Deve**: Exibir aviso "Atenção: Orçamento desatualizado (última atualização: {data}). Validar manualmente com Financeiro."
- **Retry**: Não (alerta apenas)

---

#### Segurança e Compliance

**Dados Sensíveis**: Sim (orçamento é informação financeira interna)
**Criptografia**:
- **Em Trânsito**: TLS 1.2 (SQL Server Encrypt=True)
- **Em Repouso**: Database ERP tem Transparent Data Encryption (TDE)

**Compliance**:
- **Auditoria**: Todos os SELECTs logados com user_id + edital_id
- **Retenção**: 1 ano
- **Read-Only**: Usuário tem apenas SELECT (never INSERT/UPDATE/DELETE)

---

#### Documentação de Referência

- **Docs Internas**: [Link para Wiki - Schema ERP Legado]
- **Contato**: Time de Infraestrutura (infra@ycodify.com) / Slack: #infra-erp

---

---

## Checklist de Completude (por Integração)

Para cada integração, certifique-se de documentar:

- [ ] **Metadados completos** (ID técnico, módulo, criticidade, link para FR)
- [ ] **Descrição clara** (1-2 sentenças: o que faz, por que precisamos)
- [ ] **Contrato de API/Database** (endpoints, schemas, queries)
- [ ] **Request/Response schemas** com exemplos reais
- [ ] **Códigos de erro** e como tratá-los
- [ ] **Autenticação** (método, credenciais, onde armazenar, rotação)
- [ ] **Mapeamento de dados** (sistema externo ↔ nosso sistema)
- [ ] **Políticas de resiliência** (timeout, retry, circuit breaker, fallback)
- [ ] **Monitoramento** (métricas, logs, alertas com severidade)
- [ ] **Tratamento de erros específicos** (cenários + ações)
- [ ] **Custos e SLA** (se aplicável)
- [ ] **Ambiente de testes** (sandbox, dados de teste)
- [ ] **Segurança** (criptografia, compliance, auditoria)
- [ ] **Documentação de referência** (links, contatos)

---

## Instruções para Preenchimento

### Para o BA (Analista de Negócio):

1. **Para cada FR que menciona sistema externo**:
   - Identifique a integração necessária
   - Crie uma seção `Integração C.{N}` neste anexo
   - Pesquise documentação do sistema externo (APIs, schemas)
   - Se sistema legado sem docs, agende sessão com Time de Infraestrutura

2. **Priorize integrações críticas**:
   - Integrações que bloqueiam MVP devem ser detalhadas primeiro
   - Integrações "nice-to-have" podem ser documentadas posteriormente

3. **Para cada integração, documente**:
   - **Happy path** (request → response sucesso)
   - **Top 3 cenários de erro** (os mais prováveis de ocorrer)
   - **Fallback** (o que sistema faz se integração falhar)

4. **Valide com Time Técnico**:
   - Após documentar, revisar com Arquiteto de Integrações
   - Confirmar que timeouts/retries são realistas
   - Confirmar que mapeamento de dados está correto

### Para o PM:

1. **Revise criticidade** de cada integração:
   - Se integração falhar, qual impacto no negócio?
   - Alta = bloqueia funcionalidade core
   - Média = degrada experiência
   - Baixa = funcionalidade secundária

2. **Revise custos**:
   - Integrações pagas: validar se custo está dentro do orçamento
   - Considerar alternativas se custo muito alto

3. **Revise SLAs**:
   - SLA do fornecedor é compatível com nossos NFRs?
   - Ex: Se NFR exige 99.9% uptime, mas integração tem SLA 99%, há risco

---

## Consumo por Agentes Downstream

Este anexo será consumido por:

- **Arquiteto de Integrações** → Gera `spec_integracoes.json`:
  - Contratos OpenAPI/Swagger
  - Políticas de retry/circuit breaker (código Polly/Resilience4j)
  - Mapeamento de dados (AutoMapper/DTOs)
  - Monitoramento (Application Insights/Prometheus)

- **Verificador de Especificações** → Valida:
  - Todas FRs que mencionam sistema externo têm integração documentada
  - Timeouts são realistas (< 30s)
  - Retry policies não causam loops infinitos
  - Fallbacks estão definidos para integrações críticas

- **Guardião** → Traduz para cliente:
  - "Integração C.1 com SEFAZ" → "Sistema validará CNPJ automaticamente na Receita Federal"
  - "Integração C.2 com ERP Legado" → "Sistema consultará orçamento disponível no seu ERP"

---

**Fim do ANEXO_C_Integrations-template.md**
