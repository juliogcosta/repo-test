# Guia de ANEXOS — Detalhamento Técnico

Este arquivo contém o guia detalhado para elicitação e documentação dos ANEXOS A, B e C.

Os ANEXOS são independentes do modo PRD (monolithic/fragmented) — sempre são escritos como arquivos separados na raiz do projeto.

---

## ANEXO A — Process Details

**Propósito**: Documentar processos de negócio com nível de detalhe suficiente para permitir que o Arquiteto de Processos gere `spec_processos.json` (BPMN).

**Template de referência** (READ): `templates/ANEXO_A_ProcessDetails-template.md`
**Output file** (WRITE): `ANEXO_A_ProcessDetails.md` (raiz do projeto)

---

### Quando Elicitar

- Durante **Step 4** do workflow (após mapear User Journeys)
- Quando cliente solicita documentação de processo específico (modo `anexo_a_only`)
- Quando Arquiteto de Processos reportar gap informacional

---

### O Que Elicitar

Para cada processo principal (≥3 processos no mínimo):

1. **Quem participa deste processo?** (atores/papéis)
   - Ex: Pregoeiro, Sistema, Fornecedor, Gerente de Compras

2. **Quais as etapas do fluxo principal (happy path)?**
   - Listar sequencialmente (numerado)
   - Foco em ações concretas
   - Ex: "1. Sistema exibe lista de editais", "2. Pregoeiro seleciona edital", etc.

3. **Pré-condições**
   - O que deve ser verdade ANTES do processo começar?
   - Ex: "Edital deve estar no status 'Rascunho'", "Usuário deve ter permissão de Pregoeiro"

4. **Pós-condições**
   - O que muda DEPOIS do processo terminar?
   - Ex: "Edital muda para status 'Publicado'", "Histórico de publicação registrado"

5. **Regras de negócio por etapa**
   - Validações ou constraints aplicadas
   - Ex: "RN-001: Apenas Pregoeiro pode publicar edital", "RN-002: Edital não pode ser editado após publicação"

6. **Fluxos alternativos** (caminhos válidos mas não principais)
   - Variações do happy path que ainda levam ao sucesso
   - Ex: "Alt-1: Se edital já foi publicado antes, sistema exibe histórico de versões"

7. **Fluxos de exceção** (erros técnicos, validações falham)
   - O que acontece quando algo dá errado?
   - Ex: "Exc-1: Se sessão expira durante publicação, sistema salva rascunho e notifica Pregoeiro"

8. **Que eventos importantes acontecem neste processo?**
   - Eventos de domínio que disparam outras operações
   - Ex: "EditalPublicado" (dispara processo de notificação de fornecedores)

9. **Este processo integra com sistemas externos?**
   - Se sim, documentar no ANEXO C (Integrations)

---

### Estrutura de Output (Padrão)

```markdown
# ANEXO A: Process Details

## Processo A.1: [Nome do Processo]

**Atores**:
- [Ator 1] (papel principal)
- [Ator 2] (papel secundário)

### Pré-condições
- [Pré-condição 1]
- [Pré-condição 2]

### Fluxo Principal (Happy Path)
1. [Passo 1]
2. [Passo 2]
3. [Passo 3]
...

### Pós-condições
- [Pós-condição 1]
- [Pós-condição 2]

### Regras de Negócio
- **RN-001**: [Descrição da regra]
- **RN-002**: [Descrição da regra]

### Fluxos Alternativos
- **Alt-1**: [Descrição do fluxo alternativo]

### Fluxos de Exceção
- **Exc-1**: [Descrição da exceção e como lidar]

### Eventos de Domínio
- **[NomeEvento]**: Disparado quando [condição]

### Integrações
- [Sistema externo] (documentado em ANEXO C)
```

---

### Validação com Cliente

Após documentar cada processo:
1. Apresentar resumo em formato de lista numerada
2. Perguntar: "Esqueci alguma etapa? Algum detalhe importante?"
3. Validar regras de negócio: "Há outras restrições ou validações?"

---

## ANEXO B — Data Models

**Propósito**: Documentar estrutura de documentos/dados com detalhes suficientes para permitir que o Arquiteto de Documentos gere `spec_documentos.json` (YCL-domain).

**Template de referência** (READ): `templates/ANEXO_B_DataModels-template.md`
**Output file** (WRITE): `ANEXO_B_DataModels.md` (raiz do projeto)

---

### Quando Elicitar

- Durante **Step 5** do workflow (após mapear processos)
- Quando cliente solicita documentação de documento específico (modo `anexo_b_only`)
- Quando Arquiteto de Documentos reportar gap informacional

---

### O Que Elicitar

Para cada documento principal (formulários, registros, entidades):

1. **Quais campos este documento tem?**

   Para cada campo:
   - **Nome do campo** (nome de negócio)
   - **Tipo de dado**: texto, número, data, booleano, UUID, enum, etc.
   - **Obrigatório ou opcional?**
   - **Validações**:
     - Formato (ex: CPF, email, UUID)
     - Range de valores (ex: > 0, entre 1-100)
     - Tamanho (ex: mínimo 10 caracteres, máximo 200)
   - **Valor padrão** (se houver)
   - **Exemplo** (valor concreto)

2. **Este documento se relaciona com quais outros?** (relacionamentos)

   Para cada relacionamento:
   - Documento destino
   - **Cardinalidade**: 1:1, 1:N, N:N
   - Descrição da relação

3. **Regras de negócio obrigatórias** (invariantes)

   Regras que SEMPRE devem ser verdadeiras:
   - Ex: "Edital não pode ser editado após publicação"
   - Ex: "Valor total da proposta deve ser menor que valor estimado do edital"
   - **Severity**: CRITICAL (impede operação) | WARN (alerta mas permite)

4. **Que ações podem ser feitas neste documento?** (operações/comandos)

   - Ex: "Criar Edital", "Publicar Edital", "Cancelar Edital"
   - Quem pode executar cada ação? (papéis)
   - Restrições (ex: "Apenas Pregoeiro pode publicar")

5. **Que eventos importantes ocorrem neste documento?** (eventos de domínio)

   - Ex: "EditalPublicado", "EditalCancelado"
   - Quando cada evento é disparado?

---

### Estrutura de Output (Padrão)

```markdown
# ANEXO B: Data Models

## Documento B.1: [Nome do Documento]

**Nome de Negócio**: [Nome]
**Nome Técnico**: [Nome normalizado — ^[a-z]+$]

### Campos

| Campo | Tipo | Obrigatório | Validações | Exemplo |
|-------|------|-------------|------------|---------|
| **id** | UUID | Sim | UUID válido | `550e8400-e29b-41d4-a716-446655440000` |
| **numero** | String | Sim | Formato: `EDI-YYYY-NNNN` | `EDI-2026-0001` |
| **titulo** | String | Sim | Tamanho: 10-200 caracteres | `Compra de Material de Escritório` |
| **valor** | Decimal | Sim | > 0, máximo 2 casas decimais | `1500.50` |
| **status** | Enum | Sim | `[Rascunho, Publicado, Cancelado]` | `Rascunho` |
| **data_criacao** | DateTime | Sim | ISO 8601 | `2026-04-17T10:30:00Z` |

### Relacionamentos

| Relacionamento | Cardinalidade | Descrição |
|----------------|---------------|-----------|
| Edital → Usuario (criador) | N:1 | Quem criou o edital |
| Edital → Departamento | N:1 | Departamento responsável |

### Invariantes (Regras de Negócio Obrigatórias)

#### INV-001: Edital não pode ser modificado após publicação
**Severity**: CRITICAL
**Descrição**: Uma vez que status muda para "Publicado", nenhum campo pode ser alterado
**Validação**: Antes de qualquer UPDATE, verificar `status != 'Publicado'`

### Comandos (Operações Permitidas)

| Comando | Descrição | Restrições |
|---------|-----------|------------|
| **CriarEdital** | Cria novo edital com status "Rascunho" | Usuário autenticado |
| **PublicarEdital** | Muda status para "Publicado" | Apenas Pregoeiro, INV-001 |
| **CancelarEdital** | Muda status para "Cancelado" | Apenas Pregoeiro, INV-001 |

### Eventos de Domínio

| Evento | Disparado Por | Descrição |
|--------|---------------|-----------|
| **EditalCriado** | CriarEdital | Novo edital registrado |
| **EditalPublicado** | PublicarEdital | Edital disponibilizado para fornecedores |
| **EditalCancelado** | CancelarEdital | Edital invalidado |
```

---

### Validação com Cliente

Após documentar cada documento:
1. Apresentar tabela de campos
2. Perguntar: "Falta algum campo importante?"
3. Validar invariantes: "Há outras restrições que SEMPRE devem ser verdadeiras?"
4. Confirmar comandos: "Há outras ações que podem ser feitas neste documento?"

---

## ANEXO C — Integrations

**Propósito**: Documentar integrações com sistemas externos com detalhes suficientes para permitir que o Arquiteto de Integrações gere `spec_integracoes.json` (OpenAPI + políticas de resiliência).

**Template de referência** (READ): `templates/ANEXO_C_Integrations-template.md`
**Output file** (WRITE): `ANEXO_C_Integrations.md` (raiz do projeto)

---

### Quando Elicitar

- Durante **Step 6** do workflow (após mapear processos e dados)
- Quando processo menciona sistema externo
- Quando cliente solicita documentação de integração específica (modo `anexo_c_only`)
- Quando Arquiteto de Integrações reportar gap informacional

---

### O Que Elicitar

Para cada sistema externo:

1. **Qual sistema externo?** (nome, fornecedor)
   - Ex: "SEFAZ API", fornecedor: "Secretaria da Fazenda do Estado"

2. **O que precisamos buscar/enviar para este sistema?**
   - Operações: consulta CNPJ, enviar nota fiscal, etc.

3. **Eles têm API? Documentação disponível?**
   - URL da documentação
   - Versão da API

4. **Tipo de integração**
   - REST API, SOAP, GraphQL, Database, Batch file, Webhook

5. **Direção**
   - Nós chamamos eles? (síncrono/assíncrono)
   - Eles chamam nós? (webhook)
   - Bidirecional?

6. **Criticidade**
   - **Alta**: Bloqueia funcionalidade core do sistema
   - **Média**: Degrada experiência mas não bloqueia
   - **Baixa**: Funcionalidade secundária

7. **Autenticação**
   - OAuth, API Key, JWT, Basic Auth, Certificado Digital

8. **Se API REST**:
   - URL base (ex: `https://api.sefaz.gov.br/v1`)
   - Endpoints utilizados:
     - Método (GET/POST/PUT/DELETE)
     - Path (ex: `/cnpj/{cnpj}`)
     - Parâmetros (query, path, body)
     - Request schema (exemplo)
     - Response schema (exemplo)
     - Códigos de erro possíveis (ex: 404 = CNPJ não encontrado)

9. **O que fazer se este sistema estiver fora do ar?** (fallback)
   - Retry automático? Quantas vezes?
   - Fila para processar depois?
   - Modo degradado (funcionalidade reduzida)?
   - Bloquear operação e notificar usuário?

---

### Estrutura de Output (Padrão)

```markdown
# ANEXO C: Integrations

## Integração C.1: [Nome da Integração]

**Sistema Externo**: [Nome]
**Fornecedor**: [Empresa/Órgão]
**Tipo**: REST API | SOAP | GraphQL | Database | Batch | Webhook
**Direção**: Outbound (nós chamamos) | Inbound (eles chamam) | Bidirecional
**Criticidade**: Alta | Média | Baixa

### Propósito
[Descrição do que esta integração faz]

### Autenticação
- **Tipo**: API Key | OAuth 2.0 | JWT | Basic Auth | Certificado Digital
- **Detalhes**: [Como obter credenciais, como enviar autenticação]

### Endpoints Utilizados

#### Endpoint 1: Consultar CNPJ

**Método**: GET
**Path**: `/cnpj/{cnpj}`
**Autenticação**: API Key no header `X-API-Key`

**Path Parameters**:
- `cnpj` (string): CNPJ sem pontuação (14 dígitos)

**Response 200 (Success)**:
```json
{
  "cnpj": "12345678000190",
  "razao_social": "Empresa Exemplo LTDA",
  "situacao_cadastral": "ATIVA"
}
```

**Response 404 (CNPJ não encontrado)**:
```json
{
  "error": "CNPJ_NOT_FOUND",
  "message": "CNPJ 12345678000190 não está cadastrado"
}
```

**Response 429 (Rate limit excedido)**:
```json
{
  "error": "RATE_LIMIT_EXCEEDED",
  "message": "Limite de 100 requests/min excedido"
}
```

### Resiliência e Fallback

**Timeout**: 5 segundos

**Retry Strategy**:
- 3 tentativas com backoff exponencial (1s, 2s, 4s)
- Apenas para erros 5xx (não retry em 4xx)

**Circuit Breaker**:
- Abre após 5 falhas consecutivas
- Permanece aberto por 30 segundos

**Fallback (se sistema indisponível)**:
- Registrar erro em log
- Exibir mensagem ao usuário: "Serviço SEFAZ temporariamente indisponível. Tente novamente em alguns minutos."
- Permitir que usuário continue operação com validação manual posterior
```

---

### Validação com Cliente

Após documentar cada integração:
1. Confirmar URL da API e documentação
2. Validar criticidade: "Se este sistema cair, o que acontece?"
3. Confirmar fallback: "Como o sistema deve se comportar se a integração falhar?"

---

**Versão**: 3.3 (Layer Architecture)
**Data**: 2026-04-17
