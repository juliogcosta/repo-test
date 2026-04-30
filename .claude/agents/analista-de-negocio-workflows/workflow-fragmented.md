# Workflow v3.1 — Fragmented (PRD_MODE="fragmented")

**Quando usar**: Quando `PRD_MODE="fragmented"` no `.claude-context`.

**Output**: Seções separadas em `sections/PRD_XX_*.md` + ANEXOS na raiz.

---

## ⚠️ CRÍTICO: Context Management Rules

**NO MODO FRAGMENTED, você DEVE**:
- ✅ Ler APENAS seções específicas necessárias
- ✅ Consultar `PRD_index.md` para navegação e status
- ✅ Escrever em arquivos separados (PRD_04_*.md, PRD_05_*.md, etc.)
- ✅ **LIMPAR tool_uses após cada Write** (chamando outras tools para "flush")
- ✅ Atualizar status no `PRD_index.md` após completar seção

**NO MODO FRAGMENTED, você NÃO DEVE**:
- ❌ Ler `PRD_COMPILED.md` (arquivo derivado, não fonte da verdade)
- ❌ Ler todas as seções de uma vez (context bloat)
- ❌ Manter contexto desnecessário entre seções
- ❌ Escrever no PRD.md monolítico (ele não existe neste modo)

**Benefícios do Modo Fragmented**:
- 70% menos contexto por operação (200-400 linhas vs 1700 linhas)
- 30% mais rápido (LLMs performam melhor com contexto focado)
- Git diffs limpos e focados
- Trabalho paralelo possível (PM e BA simultaneamente)

---

## Arquivos Gerados (Modo Fragmented)

**Sua responsabilidade**:
1. `sections/PRD_04_UserJourneys.md` (Seção 4)
2. `sections/PRD_05_DomainRequirements.md` (Seção 5)
3. `sections/PRD_07_ProjectTypeRequirements.md` (Seção 7)
4. `sections/PRD_10_Metadata.yaml` (Seção 10)
5. `ANEXO_A_ProcessDetails.md` (raiz do projeto)
6. `ANEXO_B_DataModels.md` (raiz do projeto)
7. `ANEXO_C_Integrations.md` (raiz do projeto)

**Atualizar status**:
- `PRD_index.md` (marcar seções como completed após escrever)

**Leitura permitida** (seções escritas pelo PM):
- `sections/PRD_01_Overview.md` (Seção 1 — Target Users)
- `sections/PRD_08_FunctionalRequirements.md` (Seção 8 — para referenciar FRs)
- `sections/PRD_09_NonFunctionalRequirements.md` (Seção 9 — para colaboração)

---

## Sequência de Elicitação (Fragmented)

**A elicitação com o cliente é IDÊNTICA ao modo monolithic** (mesmas perguntas, mesma ordem). A ÚNICA diferença é onde você escreve o output.

---

### Step 1: User Journeys (Seção 4)

**Template de referência** (READ): `templates/sections/PRD_04_UserJourneys-template.md`
**Output file** (WRITE): `sections/PRD_04_UserJourneys.md`

**Elicitação**: [Mesmo processo do Workflow v3.0 — perguntar sobre jornadas, needs, pains, outcome]

**Actions**:
1. Read `templates/sections/PRD_04_UserJourneys-template.md` para entender estrutura
2. Write output em `sections/PRD_04_UserJourneys.md` (NÃO em templates/!)
3. NUNCA modificar template original!
4. Preencher frontmatter YAML:
   ```yaml
   ---
   section: 4
   title: "User Journeys"
   responsible: "BA (Analista de Negócio)"
   estimated_lines: 300-400
   dependencies: [1]
   related_sections: [8]
   status: "completed"  # Após escrever
   ---
   ```
5. **LIMPAR CONTEXTO**: Após Write, chamar outra tool (ex: ler PROJECT.md) para limpar tool_uses
6. **ATUALIZAR STATUS**: Editar `PRD_index.md`, marcar Seção 4 como `[x] completed`

---

### Step 2: Domain Requirements (Seção 5)

**Template de referência** (READ): `templates/sections/PRD_05_DomainRequirements-template.md`
**Output file** (WRITE): `sections/PRD_05_DomainRequirements.md`

**Elicitação**: [Mesmo processo do Workflow v3.0 — identificar compliance, regulamentações]

**Actions**:
1. Read `templates/sections/PRD_05_DomainRequirements-template.md` para entender estrutura
2. Write output em `sections/PRD_05_DomainRequirements.md` (NÃO em templates/!)
3. NUNCA modificar template original!
4. Preencher frontmatter YAML:
   ```yaml
   ---
   section: 5
   title: "Domain Requirements"
   responsible: "BA (Analista de Negócio)"
   estimated_lines: 250-350
   dependencies: [4]
   related_sections: [9]
   status: "completed"
   ---
   ```
5. **LIMPAR CONTEXTO**: Após Write, chamar outra tool
6. **ATUALIZAR STATUS**: Editar `PRD_index.md`, marcar Seção 5 como `[x] completed`

---

### Step 3: Project-Type Requirements (Seção 7)

**Template de referência** (READ): `templates/sections/PRD_07_ProjectTypeRequirements-template.md`
**Output file** (WRITE): `sections/PRD_07_ProjectTypeRequirements.md`

**Elicitação**: [Mesmo processo do Workflow v3.0 — plataforma, browsers, autenticação]

**Actions**:
1. Read `templates/sections/PRD_07_ProjectTypeRequirements-template.md` para entender estrutura
2. Write output em `sections/PRD_07_ProjectTypeRequirements.md` (NÃO em templates/!)
3. NUNCA modificar template original!
4. Preencher frontmatter YAML:
   ```yaml
   ---
   section: 7
   title: "Project-Type Requirements"
   responsible: "BA (Analista de Negócio)"
   estimated_lines: 100-150
   dependencies: [5]
   related_sections: [9]
   status: "completed"
   ---
   ```
5. **LIMPAR CONTEXTO**: Após Write, chamar outra tool
6. **ATUALIZAR STATUS**: Editar `PRD_index.md`, marcar Seção 7 como `[x] completed`

---

### Step 4: Anexo A — Process Details

**Template de referência** (READ): `templates/ANEXO_A_ProcessDetails-template.md`
**Output file** (WRITE): `ANEXO_A_ProcessDetails.md` (raiz do projeto)

**Elicitação**: [Mesmo processo do Workflow v3.0 — processos, atores, fluxos, regras]

**Actions**:
1. Read `templates/ANEXO_A_ProcessDetails-template.md` para entender estrutura
2. Write output em `ANEXO_A_ProcessDetails.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!
4. Anexos permanecem na raiz (não fragmentados)

---

### Step 5: Anexo B — Data Models

**Template de referência** (READ): `templates/ANEXO_B_DataModels-template.md`
**Output file** (WRITE): `ANEXO_B_DataModels.md` (raiz do projeto)

**Elicitação**: [Mesmo processo do Workflow v3.0 — documentos, campos, relacionamentos, invariantes]

**Actions**:
1. Read `templates/ANEXO_B_DataModels-template.md` para entender estrutura
2. Write output em `ANEXO_B_DataModels.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!

---

### Step 6: Anexo C — Integrations

**Template de referência** (READ): `templates/ANEXO_C_Integrations-template.md`
**Output file** (WRITE): `ANEXO_C_Integrations.md` (raiz do projeto)

**Elicitação**: [Mesmo processo do Workflow v3.0 — sistemas externos, APIs, autenticação, fallback]

**Actions**:
1. Read `templates/ANEXO_C_Integrations-template.md` para entender estrutura
2. Write output em `ANEXO_C_Integrations.md` (raiz do projeto, NÃO em templates/!)
3. NUNCA modificar template original!

---

### Step 7: Metadados YAML (Seção 10)

**Template de referência** (READ): `templates/sections/PRD_10_Metadata-template.yaml`
**Output file** (WRITE): `sections/PRD_10_Metadata.yaml`

**Elicitação**: [Mesmo processo do Workflow v3.0 — normalização de nomes, mapeamento negócio→técnico]

**Actions**:
1. Read `templates/sections/PRD_10_Metadata-template.yaml` para entender estrutura
2. Write output em `sections/PRD_10_Metadata.yaml` (NÃO em templates/!)
3. NUNCA modificar template original!
4. **ATENÇÃO**: Este arquivo é YAML puro (não tem frontmatter markdown)
5. Estrutura:
   ```yaml
   # ============================================================================
   # Seção 10: Metadados Técnicos (Uso Interno)
   # ============================================================================
   section: 10
   title: "Metadados Técnicos (Mapeamento Negócio → Técnico)"
   responsible: "BA (Analista de Negócio)"
   estimated_lines: 50-100
   dependencies: [4, 5, 7, 8, 9]
   status: "completed"

   modulos:
     - negocio: "Licitações"
       tecnico_id: "licitacao"
       bounded_context: true
       ...
   ```
6. **LIMPAR CONTEXTO**: Após Write, chamar outra tool
7. **ATUALIZAR STATUS**: Editar `PRD_index.md`, marcar Seção 10 como `[x] completed`

---

### Step 8: Validação Final (Fragmented — com Auto-Validação de Rastreabilidade)

#### 8.1 Checklist de Completude (Arquivos)

- [ ] `sections/PRD_04_UserJourneys.md` (status: completed)
- [ ] `sections/PRD_05_DomainRequirements.md` (status: completed)
- [ ] `sections/PRD_07_ProjectTypeRequirements.md` (status: completed)
- [ ] `sections/PRD_10_Metadata.yaml` (status: completed)
- [ ] `ANEXO_A_ProcessDetails.md` (≥3 processos)
- [ ] `ANEXO_B_DataModels.md` (≥3 documentos)
- [ ] `ANEXO_C_Integrations.md` (todas integrações)
- [ ] `PRD_index.md` atualizado (checkboxes marcados)

**Validação de conteúdo** (IDÊNTICA ao v3.0):
- [ ] Seção 4: ≥1 User Journey por persona
- [ ] Seção 5: Domain Requirements identificados
- [ ] Seção 7: Project-Type Requirements completo
- [ ] Seção 10: Metadados YAML com nomes normalizados
- [ ] ANEXO A: ≥3 processos detalhados
- [ ] ANEXO B: ≥3 documentos principais
- [ ] ANEXO C: Todas integrações documentadas

---

#### 8.2 Auto-Validação de Rastreabilidade (Estrutural)

**⚠️ NOVO v3.2**: Antes de reportar ao Orquestrador, executar validação automática de rastreabilidade via skill.

**Quando executar**: Sempre, após validação de conteúdo aprovada pelo cliente.

**Como executar**: [IDÊNTICO ao modo monolithic — ver workflow-monolithic.md Step 8.2]

**Ações após validação**: [IDÊNTICO ao modo monolithic]
- **Se PASS**: Prosseguir para Step 8.3 (Finalização)
- **Se WARN**: Perguntar ao cliente se deseja corrigir (recomendado) ou prosseguir
- **Se FAIL**: **BLOQUEIO** — aguardar correções e re-executar validação até PASS

---

#### 8.3 Finalização

1. Pedir confirmação final do cliente (conteúdo + rastreabilidade)
2. Se `PRD_COMPILE_ON_COMPLETE="true"`: Executar `bash scripts/compile-prd.sh` para gerar `PRD_COMPILED.md`
3. Reportar ao Orquestrador:

```
✅ PRD Seções 4-10 + ANEXOS completos (modo fragmented).
✅ Auto-validação de rastreabilidade: PASS

Arquivos gerados:
- sections/PRD_04_UserJourneys.md
- sections/PRD_05_DomainRequirements.md
- sections/PRD_07_ProjectTypeRequirements.md
- sections/PRD_10_Metadata.yaml
- ANEXO_A_ProcessDetails.md
- ANEXO_B_DataModels.md
- ANEXO_C_Integrations.md
- RTM.yaml (Requirements Traceability Matrix)
- TRACEABILITY_REPORT.md (validação estrutural)
{Se compilação habilitada: - PRD_COMPILED.md}

Status: Pronto para GE (Gerar Especificações Técnicas)
```

---

**Versão**: 3.3 (Layer Architecture)
**Data**: 2026-04-17
