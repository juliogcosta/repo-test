# Workflow v3.0 — Monolithic/Legado (PRD_MODE="monolithic")

**Quando usar**: Quando `PRD_MODE="monolithic"` no `.claude-context`.

**Output**: PRD.md único (~1700 linhas) com Seções 4-10 + ANEXOS A, B, C separados.

---

## Sequência de Elicitação (Full Mapping)

### Step 1: User Journeys (Seção 4 do PRD)

**Template de referência** (READ): `templates/PRD-template.md` (Seção 4)
**Output file** (WRITE): `PRD.md` (adicionar Seção 4)

**Elicitação**:
- Ler Seção 1 do PRD (Target Users escrito pelo PM)
- Para cada persona identificada pelo PM:
  1. Perguntar: "Qual o objetivo principal de [persona] ao usar o sistema?"
  2. Perguntar: "Quais etapas [persona] precisa seguir para alcançar esse objetivo?"
  3. Elicitar: Necessidades (needs), Dores (pains), Resultado esperado (outcome)
  4. Identificar se jornada vincula a quais FRs (se FRs já estiverem definidos)

**Estrutura de output**:
```markdown
## 4. User Journeys

### Journey 4.1: [Persona] — [Objetivo]

**Persona**: [Nome da persona]
**Objetivo**: [O que quer alcançar]
**Frequência**: [Diária, Semanal, Mensal]

**Steps**:
1. [Passo 1]
2. [Passo 2]
...

**Needs (Necessidades)**:
- [Necessidade 1]
- [Necessidade 2]

**Pains (Dores Atuais)**:
- [Dor 1 — o que frustra hoje]
- [Dor 2]

**Expected Outcome**:
- [Resultado esperado ao completar jornada]

**Linked FRs**: FR-XXX, FR-YYY
```

**Actions**:
1. Read `PRD.md` (Seção 1 escrita pelo PM)
2. Edit `PRD.md` (adicionar Seção 4)
3. Apresentar resumo e validar com cliente

---

### Step 2: Domain Requirements (Seção 5 do PRD)

**Template de referência** (READ): `templates/PRD-template.md` (Seção 5)
**Output file** (WRITE): `PRD.md` (adicionar Seção 5)

**Elicitação**:
- Identificar setor do cliente (GovTech, Fintech, HealthTech, E-commerce, etc.)
- Perguntar: "Há regulamentações ou leis específicas que este sistema precisa seguir?"
- Auto-detect (se possível):
  - **GovTech**: Lei de Licitações (8.666/93, 14.133/21), LGPD, transparência pública
  - **Fintech**: PCI-DSS, Bacen (Resolução 4.658), Open Banking, prevenção lavagem de dinheiro
  - **HealthTech**: HIPAA (USA), LGPD, ANVISA, CFM, privacidade prontuários
  - **E-commerce**: CDC (Código Defesa Consumidor), LGPD, PCI-DSS
- Classificar requisitos como:
  - **Mandatory** (obrigatório por lei/regulamento)
  - **Desirable** (boas práticas do setor, não obrigatório)

**Estrutura de output**:
```markdown
## 5. Domain Requirements

**Setor**: [GovTech | Fintech | HealthTech | E-commerce | Outro]

### 5.1 Compliance Obrigatório (Mandatory)

| Regulamento | Descrição | Impacto no Sistema |
|-------------|-----------|---------------------|
| Lei 14.133/21 | Nova Lei de Licitações | Sistema deve registrar todas as etapas com rastreabilidade |
| LGPD | Proteção de dados pessoais | Consentimento explícito para dados de fornecedores |

### 5.2 Boas Práticas do Setor (Desirable)

| Prática | Descrição | Benefício |
|---------|-----------|-----------|
| Portal da Transparência | Publicar licitações em portal público | Aumenta transparência |
```

**Actions**:
1. Edit `PRD.md` (adicionar Seção 5)
2. Validar com cliente

---

### Step 3: Project-Type Requirements (Seção 7 do PRD)

**Template de referência** (READ): `templates/PRD-template.md` (Seção 7)
**Output file** (WRITE): `PRD.md` (adicionar Seção 7)

**Elicitação**:
- Perguntar: "Este sistema será usado em quais plataformas?" (Web, Mobile, Desktop)
- Perguntar: "Quais navegadores os usuários usam?" (Chrome, Firefox, Safari, Edge)
- Perguntar: "Como os usuários farão login?" (Email/senha, SSO, OAuth, biometria)
- Perguntar: "Há necessidade de funcionar offline?"

**Estrutura de output**:
```markdown
## 7. Project-Type Requirements

**Tipo de Aplicação**: Web App | Mobile App | Desktop | API | Híbrido

### 7.1 Plataforma e Compatibilidade

| Aspecto | Requisito |
|---------|-----------|
| **Navegadores Suportados** | Chrome 90+, Firefox 88+, Safari 14+, Edge 90+ |
| **Dispositivos Móveis** | Responsive design (mobile-first) |
| **Offline Support** | Não necessário (sempre requer internet) |

### 7.2 Autenticação e Autorização

| Aspecto | Requisito |
|---------|-----------|
| **Método de Login** | Email/senha + 2FA via SMS |
| **SSO** | Integração com Azure AD (para usuários internos) |
| **Sessão** | Timeout após 30 minutos de inatividade |

### 7.3 Internacionalização (i18n)

| Aspecto | Requisito |
|---------|-----------|
| **Idiomas Suportados** | Português (BR) no MVP, Inglês na Growth Phase |
| **Timezone** | BRT (UTC-3) |
| **Formato de Data** | DD/MM/YYYY |
| **Moeda** | BRL (R$) |
```

**Actions**:
1. Edit `PRD.md` (adicionar Seção 7)
2. Validar com cliente

---

### Step 4: Anexo A — Process Details

**Template de referência** (READ): `templates/ANEXO_A_ProcessDetails-template.md`
**Output file** (WRITE): `ANEXO_A_ProcessDetails.md` (raiz do projeto)

**Elicitação**:
- Ler Seção 4 (User Journeys) para identificar processos mencionados
- Para cada processo principal (≥3 processos no mínimo):
  1. Perguntar: "Quem participa deste processo?" (atores/papéis)
  2. Perguntar: "Quais as etapas do fluxo principal (happy path)?"
  3. Elicitar: Pré-condições, Pós-condições, Regras de negócio por etapa
  4. Elicitar: Fluxos alternativos (caminhos válidos mas não principais)
  5. Elicitar: Fluxos de exceção (erros técnicos, validações falham)
  6. Perguntar: "Que eventos importantes acontecem neste processo?"
  7. Perguntar: "Este processo integra com sistemas externos?"

**Actions**:
1. Read `templates/ANEXO_A_ProcessDetails-template.md` para entender estrutura
2. Write output em `ANEXO_A_ProcessDetails.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!
4. Apresentar resumo de cada processo e validar com cliente

---

### Step 5: Anexo B — Data Models

**Template de referência** (READ): `templates/ANEXO_B_DataModels-template.md`
**Output file** (WRITE): `ANEXO_B_DataModels.md` (raiz do projeto)

**Elicitação**:
- Ler Seção 4 (User Journeys) e ANEXO A (processos) para identificar documentos/dados mencionados
- Para cada documento principal (formulários, registros, entidades):
  1. Perguntar: "Quais campos este documento tem?"
  2. Para cada campo:
     - Tipo de dado (texto, número, data, booleano, etc.)
     - Obrigatório ou opcional?
     - Validações (formato, range de valores, tamanho)
     - Valor padrão (se houver)
     - Exemplo
  3. Perguntar: "Este documento se relaciona com quais outros?" (relacionamentos)
     - Cardinalidade (1:1, 1:N, N:N)
  4. Elicitar: Regras de negócio obrigatórias (invariantes)
     - Ex: "Edital não pode ser editado após publicação"
     - Ex: "Valor total da proposta deve ser menor que valor estimado do edital"
  5. Perguntar: "Que ações podem ser feitas neste documento?" (operações/comandos)
     - Ex: "Criar Edital", "Publicar Edital", "Cancelar Edital"
  6. Perguntar: "Que eventos importantes ocorrem neste documento?"
     - Ex: "EditalPublicado", "EditalCancelado"

**Actions**:
1. Read `templates/ANEXO_B_DataModels-template.md` para entender estrutura
2. Write output em `ANEXO_B_DataModels.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!
4. Validar estrutura de cada documento com cliente

---

### Step 6: Anexo C — Integrations

**Template de referência** (READ): `templates/ANEXO_C_Integrations-template.md`
**Output file** (WRITE): `ANEXO_C_Integrations.md` (raiz do projeto)

**Elicitação**:
- Ler ANEXO A (processos) para identificar integrações mencionadas
- Para cada sistema externo:
  1. Perguntar: "Qual sistema externo?" (nome, fornecedor)
  2. Perguntar: "O que precisamos buscar/enviar para este sistema?"
  3. Perguntar: "Eles têm API? Documentação disponível?"
  4. Elicitar:
     - Tipo de integração (REST API, SOAP, GraphQL, Database, Batch file, Webhook)
     - Direção (nós chamamos eles? eles chamam nós? bidirecional?)
     - Criticidade (Alta = bloqueia funcionalidade core, Média = degrada experiência, Baixa = secundário)
     - Autenticação (OAuth, API Key, JWT, etc.)
  5. Se API REST:
     - URL base
     - Endpoints utilizados (GET/POST/PUT/DELETE, path, parâmetros)
     - Request/Response schemas (exemplos)
     - Códigos de erro possíveis
  6. Perguntar: "O que fazer se este sistema estiver fora do ar?" (fallback)

**Actions**:
1. Read `templates/ANEXO_C_Integrations-template.md` para entender estrutura
2. Write output em `ANEXO_C_Integrations.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!
4. Validar cada integração com cliente

---

### Step 7: Metadados YAML (Seção 10 do PRD)

**Template de referência** (READ): `templates/PRD-template.md` (Seção 10)
**Output file** (WRITE): `PRD.md` (adicionar Seção 10)

**Elicitação**:
- Criar mapeamento de termos de negócio → IDs técnicos
- Normalizar nomes (remover espaços, acentos, hífen → `^[a-z]+$`)

**Estrutura de output**:
```yaml
modulos:
  - negocio: "Licitações"
    tecnico_id: "licitacao"
    bounded_context: true

documentos:
  - negocio: "Edital de Licitação"
    tecnico_id: "Edital"
    aggregate: true
    modulo: "licitacao"

processos:
  - negocio: "Workflow de Aprovação de Edital"
    tecnico_id: "workflow_aprovacao_edital"
    modulo: "licitacao"

comandos:
  - negocio: "Publicar Edital"
    tecnico_id: "PublicarEdital"
    documento: "Edital"

eventos:
  - negocio: "Edital Publicado"
    tecnico_id: "EditalPublicado"
    documento: "Edital"

integracoes:
  - negocio: "Consulta CNPJ na SEFAZ"
    tecnico_id: "sefaz_cnpj_api"
    tipo: "REST_API"

papeis:
  - negocio: "Pregoeiro"
    tecnico_id: "pregoeiro"
    permissoes:
      - "criar_edital"
      - "publicar_edital"

nfr_mapping:
  - nfr_id: "NFR-001"
    metrica: "api_response_time_p95"
    target: "200ms"
    medida_por: "Application Performance Monitoring (APM)"
```

**Actions**:
1. Edit `PRD.md` (adicionar Seção 10)
2. Apresentar ao cliente: "Normalizei os nomes para o formato técnico. Está OK?"
3. Validar com cliente

---

### Step 8: Validação Final (com Auto-Validação de Rastreabilidade)

#### 8.1 Checklist de Completude (Conteúdo)

Apresentar PRD completo (Seções 4-10) + ANEXOS ao cliente.

**Checklist de completude**:
- [ ] Seção 4: ≥1 User Journey por persona
- [ ] Seção 5: Domain Requirements identificados (se aplicável)
- [ ] Seção 7: Project-Type Requirements completo
- [ ] Seção 10: Metadados YAML com mapeamento de todos os termos
- [ ] ANEXO A: ≥3 processos detalhados
- [ ] ANEXO B: ≥3 documentos principais detalhados
- [ ] ANEXO C: Todas integrações documentadas (se houver)

Pedir validação final do conteúdo.

---

#### 8.2 Auto-Validação de Rastreabilidade (Estrutural)

**⚠️ NOVO v3.2**: Antes de reportar ao Orquestrador, executar validação automática de rastreabilidade via skill.

**Quando executar**: Sempre, após validação de conteúdo aprovada pelo cliente.

**Como executar**:
1. Invocar skill `/validate-traceability` em modo `structural_only` (validação rápida via scripts, ~5 segundos)
2. Scripts executados automaticamente:
   - `validate-ids.sh`: Valida formato e unicidade de IDs (UJ-XX-XXX, FR-XXX, PROC-xxx-XXX, etc.)
   - `generate-rtm.sh`: Gera RTM.yaml (Requirements Traceability Matrix)
   - `validate-links.sh`: Detecta orphan links e nós isolados
3. Analisar relatório de validação (`TRACEABILITY_REPORT.md`)

**Se validação PASS**:
```
✅ **Auto-Validação de Rastreabilidade: PASS**

Rastreabilidade estrutural verificada:
- IDs bem formados: {percentage}% ({valid}/{total})
- Links válidos: {percentage}% ({valid}/{total})
- Upstream coverage: {percentage}%
- Downstream coverage: {percentage}%
- Orphan rate: {percentage}%

PRD está pronto para geração de especificações técnicas.
```

**Se validação WARN**:
```
⚠️ **Auto-Validação de Rastreabilidade: PASSED WITH WARNINGS**

Rastreabilidade aceitável, mas com issues não-críticos:
- {lista de warnings}

Recomendado corrigir antes de prosseguir, mas não bloqueia geração de specs.

Deseja corrigir agora ou prosseguir?
```

**Se validação FAIL**:
```
❌ **Auto-Validação de Rastreabilidade: FAILED**

Rastreabilidade insuficiente. BLOQUEIO para geração de specs.

Problemas críticos encontrados:
1. {problema 1 — ex: "5 orphan links detectados"}
2. {problema 2 — ex: "3 nós isolados sem upstream nem downstream"}
3. {problema 3 — ex: "Upstream coverage: 75% (target: ≥90%)"}

**Ações Requeridas**:
1. Revisar IDs no frontmatter dos arquivos listados
2. Corrigir links órfãos (referências a IDs inexistentes)
3. Adicionar links upstream/downstream para nós isolados

NÃO posso reportar ao Orquestrador até que validação PASS.

Vou aguardar enquanto você corrige. Quando terminar, executarei validação novamente.
```

**Ações após validação**:
- **Se PASS**: Prosseguir para Step 8.3 (Finalização)
- **Se WARN**: Perguntar ao cliente se deseja corrigir (recomendado) ou prosseguir
- **Se FAIL**: **BLOQUEIO** — aguardar correções e re-executar validação até PASS

---

#### 8.3 Finalização

Se aprovado (conteúdo + rastreabilidade):
1. Marcar PRD.md frontmatter: `currentStatus: "completed"`
2. Reportar ao Orquestrador:

```
✅ PRD Seções 4-10 + ANEXOS completos e aprovados pelo cliente.
✅ Auto-validação de rastreabilidade: PASS

Arquivos gerados:
- PRD.md (Seções 4-10)
- ANEXO_A_ProcessDetails.md
- ANEXO_B_DataModels.md
- ANEXO_C_Integrations.md
- RTM.yaml (Requirements Traceability Matrix)
- TRACEABILITY_REPORT.md (validação estrutural)

Status: Pronto para GE (Gerar Especificações Técnicas)
```

---

**Versão**: 3.3 (Layer Architecture)
**Data**: 2026-04-17
