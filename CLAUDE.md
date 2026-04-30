# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 📋 Projeto Ycodify CRM - Service

**Status do Projeto**: 🟡 **Inicializado** _(aguardando criação do PRD)_
<!-- Status possíveis:
  🟡 Inicializado (sem PRD)
  🔵 Em Elicitação (PRD em progresso)
  🟢 PRD Completo (specs não geradas)
  🟣 Specs Geradas (aguardando QA)
  ✅ Deploy Completo
-->

**Nome Técnico**: crm
**Cliente**: Ycodify
**Complexidade**: medio
**Validation Mode**: permissive
**Template**: YC Platform v3.1 (Dual-Mode PRD: Monolithic + Fragmented)
**Inicializado**: qui 30 abr 2026 15:24:12 -03

---

## 🚀 Quick Start

### Referência Rápida

| Item | Valor |
|------|-------|
| **Working directory** | `/var/yc/specs/clients/ycodify/client-proj-03-spec` |
| **Git tracked** | ✅ Sim (repositório local) |
| **Primeiro comando** | `@orquestrador-pm Inicialize o projeto Ycodify CRM - Service` |
| **Próximo passo** | Fase MP: `@orquestrador-pm Iniciar fase MP: mapear processos` |
| **Status atual** | Veja badge acima (atualizar conforme progresso) |

### 3 Primeiros Comandos

```bash
# 1. Verificar inicialização
ls -la .claude-context && cat PROJECT.md

# 2. Inicializar com Orquestrador (no Claude Code)
@orquestrador-pm Inicialize o projeto Ycodify CRM - Service

# 3. Ver glossário v1.0
cat UBIQUITOUS_LANGUAGE.yaml | head -20
```

### Comandos Diários Essenciais

```bash
# Status
cat PROJECT.md                                    # Metadados
cat LEARNING_LOG.md                              # Lições aprendidas
ls -la artifacts/ specs/                          # Artefatos gerados

# Validação
python3 -c "import yaml; yaml.safe_load(open('UBIQUITOUS_LANGUAGE.yaml'))" && echo "✅ YAML OK"
git log --oneline --graph                         # Histórico

# Diagnóstico rápido
grep -E "PROJECT_NAME|COMPLEXITY|VALIDATION_MODE" .claude-context
ls -1 .claude/agents/*-core.md 2>/dev/null | wc -l # Agentes no padrão v3.3 core.md (esperado: 7 — os 4 antigos qa-de-specs/assistente/gerente/guardião ainda estão em .md monolítico direto, sem refactor)
ls -1 .claude/skills/ | wc -l                     # Skills (deve ser 3)
```

---

## 🎯 Como Trabalhar com Agentes

### Workflow Completo: Da Inicialização ao Deploy

#### 1️⃣ Fase IC - Inicializar Projeto

```
@orquestrador-pm Inicialize o projeto Ycodify CRM - Service
```

**O que acontece**:
- Orquestrador lê PROJECT.md e .claude-context
- Avalia complexidade (medio)
- Cria task-status.md (se complexo)
- Confirma que projeto está pronto

#### 2️⃣ Fase MP - Mapear Processos e Criar PRD

```
@orquestrador-pm Iniciar fase MP: mapear processos e negócio para criar o PRD
```

**O que acontece**:
1. **Orquestrador (PM)** escreve seções estratégicas do PRD:
   - Seção 1: Visão Geral
   - Seção 2: Objetivos de Negócio
   - Seção 3: Stakeholders
   - Seção 6: Glossário de Termos de Negócio

2. **Analista de Negócio** (acionado automaticamente) executa workflow:
   - **Step 1**: Seção 4 - User Journeys
   - **Step 2**: Seção 5 - Domain Requirements
   - **Step 3**: Seção 7 - Project-Type Requirements
   - **Step 4**: ANEXO_A_ProcessDetails.md (processos detalhados)
   - **Step 5**: ANEXO_B_DataModels.md (modelos de dados)
   - **Step 6**: ANEXO_C_Integrations.md (integrações)
   - **Step 7**: Seção 10 - Metadados YAML
   - **Step 8**: Validação final

3. **PM + Analista** (colaborativo):
   - Seção 8: Requisitos Funcionais
   - Seção 9: Requisitos Não-Funcionais

4. **Guardião** (paralelo, contínuo):
   - Monitora terminologia em tempo real
   - Enriquece UBIQUITOUS_LANGUAGE.yaml
   - Valida conformidade semântica

**Resultado**: `artifacts/PRD.md` + `artifacts/ANEXO_*.md` completos

#### 3️⃣ Fase VE - Validar PRD

```
@orquestrador-pm Validar PRD completo
```

**O que acontece**:
- Verifica PRD.md tem 10 seções
- Verifica ANEXOS A, B, C consistentes
- Valida metadados YAML (Seção 10)
- Confirma glossário atualizado

#### 4️⃣ Fase GE - Gerar Especificações Técnicas

```
@orquestrador-pm Gerar especificações técnicas a partir do PRD
```

**O que acontece** (Arquitetos futuros):
- Arquiteto de Documentos → `specs/spec_documentos.json`
- Arquiteto de Processos → `specs/spec_processos.json`
- Arquiteto de Integrações → `specs/spec_integracoes.json`

#### 5️⃣ Fase VT - Validar Specs (QA Cruzado)

```
@qa-de-specs Validar specs técnicas contra PRD e ANEXOS
```

**O que acontece**:
- Valida PRD ↔ spec_documentos.json
- Valida ANEXO_A ↔ spec_processos.json
- Valida ANEXO_C ↔ spec_integracoes.json
- Gera `specs/QA_REPORT.md`

**Status**: APROVADO ✅ ou REPROVADO ❌

#### 6️⃣ Fase DS - Deploy no Grid

```
@orquestrador-pm Deploy de specs no Grid YC
```

**O que acontece** (Orquestrador aciona @gerente-de-projeto):
1. Gerente de Projeto verifica recursos existentes (list_projects, list_dbconns)
2. Cria project → captura tenant_pid (secret)
3. Cria dbconn → database
4. Para cada Bounded Context: cria dataschema → captura tenant_id
5. Cria email service (se necessário)
6. Reporta tenant_pid e tenant_ids ao Orquestrador

### Comandos Adicionais Úteis

#### Validar Terminologia

```
@guardiao-linguagem-ubiqua Validar terminologia do PRD.md em modo permissive
```

ou via skill:

```
/ubiquitous-language-validation
```

#### Adicionar Termo ao Glossário

```
@guardiao-linguagem-ubiqua Adicionar termo "NovoTermo" ao glossário com definição "..."
```

ou via skill:

```
/ubiquitous-language-enrichment
```

#### Normalizar Naming

```
@assistente-de-projeto Normalizar estes nomes para o Grid: "Gestão de RH", "E-commerce"
```

#### Consultar API Forger

```
/forger-resource-api
```

#### Gerar Diagramas PlantUML

```
@diagrama-designer Gerar diagrama de classes a partir do ANEXO_B (Capability DC)
@diagrama-designer Gerar diagrama de estados a partir do ANEXO_A (Capability DS)
```

**Quando usar**:
- **Após ANEXO_B completo**: Para visualizar bounded contexts, aggregates, entidades e relacionamentos
- **Após ANEXO_A completo**: Para visualizar processos de negócio como máquinas de estado

**Saída**: Arquivos `.puml` em `artifacts/diagrams/` (podem ser visualizados em https://plantuml.com ou extensões VS Code)

**Características**:
- **Fidelidade absoluta**: Agente representa EXATAMENTE o que está no ANEXO
- **Questionador**: Se houver ambiguidade, questiona antes de gerar
- **Colaborativo**: Solicita aperfeiçoamento ao @analista-de-negocio se especificação estiver incompleta

### Sessão Típica de Trabalho

```bash
# 1. Inicializar projeto
@orquestrador-pm Inicialize o projeto Ycodify CRM - Service

# 2. Criar PRD (sessão longa com cliente)
@orquestrador-pm Iniciar fase MP: mapear processos e criar PRD
# (Analista conduzirá elicitação interativa)

# 3. Revisar artefatos gerados
cat artifacts/PRD.md
cat artifacts/ANEXO_A_ProcessDetails.md
cat artifacts/ANEXO_B_DataModels.md
cat artifacts/ANEXO_C_Integrations.md

# 4. Validar PRD
@orquestrador-pm Validar PRD completo

# 5. (Opcional) Gerar diagramas PlantUML para visualização
@diagrama-designer Gerar diagrama de classes (ANEXO_B)
@diagrama-designer Gerar diagrama de estados (ANEXO_A)

# 6. Gerar specs técnicas
@orquestrador-pm Gerar especificações técnicas

# 7. QA cruzado
@qa-de-specs Validar specs contra PRD

# 8. Se QA aprovado, deploy
@orquestrador-pm Deploy no Grid
```

---

## 📝 Modos de Operação do PRD (v3.1 — Dual-Mode)

**Novo na versão 3.1**: O sistema agora suporta **dois modos** de geração de PRD, configurado via `prd.mode` no `project-config.yaml`:

### Modo Monolithic (padrão/legado)

**Configuração**: `prd.mode: "monolithic"` (default)

**Comportamento**:
- PRD.md único com ~1700 linhas (10 seções inline)
- Backward compatible com v3.0
- Artefatos gerados:
  - `artifacts/PRD.md` (arquivo único)
  - `artifacts/ANEXO_A_ProcessDetails.md`
  - `artifacts/ANEXO_B_DataModels.md`
  - `artifacts/ANEXO_C_Integrations.md`

**Quando usar**:
- Projetos pequenos/médios (< 10 FRs)
- Cliente prefere documento único
- Revisão linear completa necessária

### Modo Fragmented (novo v3.1)

**Configuração**: `prd.mode: "fragmented"`

**Comportamento**:
- PRD dividido em 10 seções independentes (200-400 linhas cada)
- Navegação via `artifacts/PRD_index.md`
- Compilação on-demand via `bash scripts/compile-prd.sh`
- Artefatos gerados:
  - `artifacts/PRD_index.md` (índice navegável)
  - `artifacts/sections/PRD_01_Overview.md` (PM)
  - `artifacts/sections/PRD_02_Objectives.md` (PM)
  - `artifacts/sections/PRD_03_ProductScope.md` (PM)
  - `artifacts/sections/PRD_04_UserJourneys.md` (BA)
  - `artifacts/sections/PRD_05_DomainRequirements.md` (BA)
  - `artifacts/sections/PRD_06_InnovationAnalysis.md` (PM, opcional)
  - `artifacts/sections/PRD_07_ProjectTypeRequirements.md` (BA)
  - `artifacts/sections/PRD_08_FunctionalRequirements.md` (PM+BA)
  - `artifacts/sections/PRD_09_NonFunctionalRequirements.md` (PM+BA)
  - `artifacts/sections/PRD_10_Metadata.yaml` (BA)
  - `artifacts/ANEXO_*.md` (permanecem na raiz)
  - `artifacts/PRD_COMPILED.md` (gerado sob demanda)

**Benefícios**:
- ✅ **70% menos contexto** por operação (200-400 linhas vs 1700 linhas)
- ✅ **30% mais rápido** (LLMs performam melhor com contexto focado)
- ✅ **Git diffs limpos** (mudanças em seção 4 não afetam diff de seção 9)
- ✅ **Trabalho paralelo** (PM e BA podem trabalhar simultaneamente em seções diferentes)
- ✅ **Iterações focadas** (revisar/editar apenas seção específica)

**Quando usar**:
- Projetos grandes (≥ 15 FRs)
- PRD com múltiplas iterações esperadas
- Cliente quer revisões incrementais por seção
- Performance de LLM é crítica

### Context Management (Modo Fragmented)

**Agentes DEVEM**:
- ✅ Ler APENAS seções específicas necessárias
- ✅ Consultar `PRD_index.md` para navegação e status
- ✅ **LIMPAR tool_uses após cada Write** (chamando outras tools para "flush")
- ✅ Atualizar status no `PRD_index.md` após completar seção

**Agentes NÃO DEVEM**:
- ❌ Ler `PRD_COMPILED.md` (arquivo derivado, não fonte da verdade)
- ❌ Ler todas as seções de uma vez (context bloat)
- ❌ Manter contexto desnecessário entre seções

### Como Compilar PRD (Modo Fragmented)

```bash
# Compilar todas as seções em PRD_COMPILED.md
bash scripts/compile-prd.sh

# Verificar arquivo compilado
cat artifacts/PRD_COMPILED.md | wc -l
```

**Quando compilar**:
- Antes de apresentação final ao cliente
- Antes de gerar specs técnicas (se Arquitetos exigirem PRD único)
- Para exportação/compartilhamento externo

**Nota**: Orquestrador e Analista detectam PRD_MODE automaticamente do `.claude-context` e executam workflow apropriado.

---

## 📐 Arquitetura (Big Picture)

### Workflow Principal

```
IC → MP → VE → GE → VT → DS
│    │    │    │    │    └─ Deploy no Grid (MCP rosetta-forger)
│    │    │    │    └────── Validar Specs (QA cruzado)
│    │    │    └─────────── Gerar Specs JSON
│    │    └──────────────── Validar PRD completo
│    └───────────────────── Mapear Processos e criar PRD
└────────────────────────── Inicializar Projeto
```

### 🤖 Agentes Disponíveis (11 na v3.2.0)

**Eixo A — Elicitação e Governança (v3.0+)**

| # | Agente | Invocação | O Que Faz | Quando Usar |
|---|--------|-----------|-----------|-------------|
| 1 | **Orquestrador-PM** (Giovanna) | `@orquestrador-pm` | Coordena workflow completo (IC→MP→VE→GE→VT→DS + AR/SM/DV/QC), escreve PRD seções 1-3,6, valida entregas | **Sempre primeiro!** Inicializar, coordenar fases, validar |
| 2 | **Analista de Negócio** (Sofia) | `@analista-de-negocio` | Elicita requisitos, escreve PRD seções 4-5,7,10, cria ANEXOS A/B/C | Mapear processos, criar PRD operacional |
| 3 | **Guardião Linguagem** (Lexicon) | `@guardiao-linguagem-ubiqua` | Valida terminologia, detecta drift semântico, enriquece UBIQUITOUS_LANGUAGE.yaml | Validar termos, resolver ambiguidades |
| 4 | **Assistente de Projeto** (Sam) | `@assistente-de-projeto` | Worker operacional: normaliza naming (^[a-z]+$), valida JSON, busca specs antigas | Naming Grid, validar schemas, tarefas técnicas |
| 5 | **QA de Specs** (Quinn) | `@qa-de-specs` | Valida consistência PRD↔Specs JSON (pré-implementação) | Após gerar specs, antes de deploy |
| 6 | **Gerente de Projeto** | `@gerente-de-projeto` | **Eixo A:** Provisiona recursos Forger via MCP rosetta-forger | Deploy Eixo A após QA aprovar specs |
| 7 | **Diagram Designer** (Diana) | `@diagrama-designer` | Gera diagramas PlantUML de classes e estado, zeloso à fidelidade | **Sob demanda** — visualizar domínio/processos |

**Eixo B — Implementation Layer (v3.2.0 NOVO)**

| # | Agente | Invocação | O Que Faz | Quando Usar |
|---|--------|-----------|-----------|-------------|
| 8 | **Arquiteto de Software** (Arthur) | `@arquiteto-de-software` | Produz SOFTWARE_ARCHITECTURE.md + FRONTEND_ARCHITECTURE.md + IMPLEMENTATION_MAP.yaml a partir de PRD+ANEXOS. Capabilities: CA / IR / AM / H. **NÃO usa Forger** | Após PRD aprovado e ANEXOS completos |
| 9 | **Scrum Master** (Bento) | `@scrum-master` | Shard de docs longos, gera epics.md, inicializa sprint-status.yaml, cria stories auto-contidas. Capabilities: SD / EP / CS / SP / SS / H | Após arquitetura aprovada (Arthur IR=PASS) |
| 10 | **Desenvolvedor** (Eduardo) | `@desenvolvedor` | Implementa story via TDD red-green-refactor, stateless. Capabilities: IS / RV / ET / ER / H. **NÃO usa Forger**, **NÃO lê PRD/arquiteturas** (tudo em Dev Notes) | Story em `ready-for-dev` |
| 11 | **QA de Código** (Iuri) | `@qa-de-codigo` | Code review pós-Dev em contexto fresco, emite veredito Approve/Changes Requested/Blocked. Capabilities: RV / VD / TR | Story em `review` |

**📂 Detalhes completos**: Ver `.claude/agents/*-core.md` + pastas `-capabilities/`.

### ⚡ Skills Disponíveis (3)

| # | Skill | Invocação | O Que Faz | Quando Usar |
|---|-------|-----------|-----------|-------------|
| 1 | **ubiquitous-language-enrichment** | `/ubiquitous-language-enrichment` | Adiciona/atualiza termos no glossário com metadados (definition, type, examples, forbidden_synonyms) | Novo termo detectado, atualizar definição |
| 2 | **ubiquitous-language-validation** | `/ubiquitous-language-validation` | Valida conformidade semântica de texto contra glossário, detecta forbidden synonyms, termos novos | Validar PRD, ANEXOS, specs antes de finalizar |
| 3 | **forger-resource-api** | `/forger-resource-api` | Guia de referência: formatos resourceJson, naming conventions (^[a-z]+$), campos obrigatórios | Preparar chamadas MCP rosetta-forger |

**📂 Detalhes completos**: Ver `.claude/skills/*/SKILL.md`

### Artefatos Chave

```
artifacts/
├── PRD.md                          # 10 seções (PM + BA)
├── ANEXO_A_ProcessDetails.md       # Processos detalhados (BA)
├── ANEXO_B_DataModels.md           # Modelos de dados (BA)
├── ANEXO_C_Integrations.md         # Integrações (BA)
└── diagrams/                       # Diagramas PlantUML (Diagram Designer)

specs/
├── spec_documentos.json            # YCL-domain schema
├── spec_processos.json             # BPMN 2.0
└── spec_integracoes.json           # OpenAPI + políticas

UBIQUITOUS_LANGUAGE.yaml            # Glossário git-tracked (v1.0+)
LEARNING_LOG.md                     # Lacunas de informação
```

---

## 🛠️ Comandos Comuns

### Validação de Projeto

```bash
# Validação Completa (One-liner)
bash -c 'echo "=== Validação Pós-Inicialização ===" && test -f .claude-context && echo "✅ .claude-context" || echo "❌ .claude-context" && test -f PROJECT.md && echo "✅ PROJECT.md" || echo "❌ PROJECT.md" && test -f UBIQUITOUS_LANGUAGE.yaml && echo "✅ Glossário" || echo "❌ Glossário" && test -d artifacts && echo "✅ artifacts/" || echo "❌ artifacts/" && test -d specs && echo "✅ specs/" || echo "❌ specs/" && python3 -c "import yaml; yaml.safe_load(open(\"UBIQUITOUS_LANGUAGE.yaml\"))" 2>&1 | grep -q "Error" && echo "❌ YAML inválido" || echo "✅ YAML válido" && ls -1 .claude/agents/ | wc -l | grep -q "7" && echo "✅ Agentes OK ($(ls -1 .claude/agents/ | wc -l))" || echo "⚠️ Agentes (esperado: 7)" && ls -1 .claude/skills/ | wc -l | grep -q "3" && echo "✅ Skills OK ($(ls -1 .claude/skills/ | wc -l))" || echo "⚠️ Skills (esperado: 3)"'

# Checklist Detalhado (passo a passo)
test -f .claude-context && echo "✅ .claude-context"
test -f PROJECT.md && echo "✅ PROJECT.md"
test -f UBIQUITOUS_LANGUAGE.yaml && echo "✅ Glossário"
test -d artifacts && echo "✅ artifacts/"
test -d specs && echo "✅ specs/"
ls -1 .claude/agents/ | wc -l | grep -q "7" && echo "✅ Agentes OK" || echo "⚠️ Agentes"
ls -1 .claude/skills/ | wc -l | grep -q "3" && echo "✅ Skills OK" || echo "⚠️ Skills"
```

### Validação Após Mudanças

```bash
# Validar YAML do glossário
python3 -c "import yaml; yaml.safe_load(open('UBIQUITOUS_LANGUAGE.yaml'))" 2>&1 | \
  grep -q "Error" && echo "❌ YAML inválido" || echo "✅ YAML válido"

# Validar frontmatter dos agentes
for agent in .claude/agents/*.md; do
  head -1 "$agent" | grep -q "^---$" && echo "✅ $(basename $agent)" || \
    echo "❌ $(basename $agent) sem frontmatter"
done

# Verificar completude do PRD (se existir)
if [ -f artifacts/PRD.md ]; then
  grep -E "^## [0-9]+\." artifacts/PRD.md | wc -l | grep -q "10" && \
    echo "✅ PRD com 10 seções" || echo "⚠️ PRD incompleto"
fi
```

### Backup Antes de Operações Críticas

```bash
# Backup do glossário antes de mudanças grandes
cp UBIQUITOUS_LANGUAGE.yaml UBIQUITOUS_LANGUAGE.yaml.bak.$(date +%Y%m%d_%H%M%S)

# Backup de artefatos antes de regeneração
tar -czf backup_artifacts_$(date +%Y%m%d_%H%M%S).tar.gz artifacts/ specs/

# Commit de segurança antes de workflow MP
git add . && git commit -m "checkpoint: antes de workflow MP"
```

### Debug e Logs

```bash
# Ver últimas entradas do LEARNING_LOG
tail -30 LEARNING_LOG.md

# Buscar termo específico no glossário
grep -A 5 "TermoDesejado:" UBIQUITOUS_LANGUAGE.yaml

# Ver workflow steps concluídos (se task-status.md existe)
[ -f task-status.md ] && grep -E "^\- \[x\]" task-status.md

# Diagnóstico completo
cat <<'EOF' | bash
echo "=== Diagnóstico: Ycodify CRM - Service ==="
echo ""
echo "📋 Config:"
grep -E "PROJECT_NAME|COMPLEXITY|VALIDATION_MODE" .claude-context
echo ""
echo "📚 Artefatos:"
find artifacts/ -type f 2>/dev/null | wc -l | xargs echo "  artifacts/:"
find specs/ -type f 2>/dev/null | wc -l | xargs echo "  specs/:"
echo ""
echo "🤖 Agentes/Skills:"
ls -1 .claude/agents/ | wc -l | xargs echo "  Agentes:"
ls -1 .claude/skills/ | wc -l | xargs echo "  Skills:"
echo ""
echo "📖 Glossário:"
grep "version:" UBIQUITOUS_LANGUAGE.yaml | head -1
EOF
```

### Git Workflow

```bash
# Ver status do repositório
git status
git log --oneline --graph --all

# Criar checkpoint antes de operações importantes
git add . && git commit -m "checkpoint: antes de [operação]"

# Ver diff de mudanças
git diff                          # Working dir vs staged
git diff --staged                 # Staged vs último commit
git diff HEAD                     # Working dir vs último commit

# Desfazer mudanças (com cuidado!)
git restore <arquivo>             # Descartar mudanças não staged
git restore --staged <arquivo>    # Unstage arquivo
git reset --soft HEAD~1           # Desfazer último commit (manter mudanças)

# Branches (se necessário)
git branch feature-xyz
git checkout feature-xyz
# ... trabalhar ...
git checkout main
git merge feature-xyz
```

**Importante**: Este projeto utiliza Git para controle de versão. Faça commits frequentes!

---

## ⚠️ Regras Críticas

### 1. Naming Convention (OBRIGATÓRIA)

**Campos `name` aceitam APENAS**: `^[a-z]+$` (minúsculas sem acento/espaço/separador)

```
"Gestão de RH"         → gestaoderh
"Faturamento - Prod"   → faturamento
"E-commerce"           → ecommerce
"Licitação"            → licitacao
```

**Onde aplica**: `project`, `database`, `dataschema` na API Forger

### 2. Sequência de Provisionamento (Fase DS)

```
1. Verificar existência:     list_projects, list_dbconns
2. Criar project        →    capturar secret (tenant_pid)
3. Criar dbconn → database
4. Criar dataschema     →    capturar tenantid (tenant_id)
5. Criar email service  →    (se necessário)
```

**NUNCA criar recurso sem verificar existência primeiro!**

### 3. Parâmetros MCP rosetta-forger

**Sempre requeridos**:
- `authorization`: UUID credential
- `username`: ForgerOne user
- `org`: Organização/cliente

**NUNCA invente valores**. Se ausentes no contexto, questione o Orquestrador.

### 4. Tratamento de Erros

```python
# Se tool MCP retornar {"error": true, ...}:
1. Registrar erro no contexto
2. NÃO tentar operações dependentes
3. Reportar ao Orquestrador com erro exato
# NUNCA contornar erros silenciosamente

# Se validação semântica falhar (strict mode):
1. Guardião bloqueia workflow
2. Solicita correção de termos não conformes
3. Aguarda correção antes de prosseguir
```

### 5. LEARNING_LOG.md

Sempre que houver lacuna de informação:

```markdown
## [2026-04-15T14:30:00] {CATEGORIA}
**Lacuna identificada**: {descrição}
**Contexto**: {onde ocorreu}
**Impacto**: {baixo|médio|alto}
**Ação tomada**: {o que foi feito}
**Aprendizado**: {como evitar no futuro}
```

**Não bloquear workflow**, apenas registrar e continuar.

---

## 📚 Referências

### Estrutura de Diretórios

```
/var/yc/specs/clients/ycodify/client-proj-03-spec/
├── .claude/
│   ├── agents/           # 7 agentes (orquestrador, BA, guardião, assistente, QA, gerente, diagram-designer)
│   └── skills/           # 3 skills (enrichment, validation, forger-api)
├── artifacts/            # PRD + ANEXOS (gerados por PM + BA)
├── specs/                # JSON specs (gerados por Arquitetos)
├── templates/            # Templates de PRD/ANEXOS (referência)
├── references/           # Specs BNF Forger API, templates
├── UBIQUITOUS_LANGUAGE.yaml
├── LEARNING_LOG.md
├── PROJECT.md
├── .claude-context       # Parâmetros para agentes
└── CLAUDE.md             # Este arquivo
```

### Arquivo .claude-context

```bash
PROJECT_NAME="crm"
PROJECT_ALIAS="Ycodify CRM - Service"
CLIENT_NAME="Ycodify"
PROJECT_ROOT="/var/yc/specs/clients/ycodify/client-proj-03-spec"
COMPLEXITY="medio"
VALIDATION_MODE="permissive"
GLOSSARY_PATH="/var/yc/specs/clients/ycodify/client-proj-03-spec/UBIQUITOUS_LANGUAGE.yaml"
ARTIFACTS_DIR="/var/yc/specs/clients/ycodify/client-proj-03-spec/artifacts"
SPECS_DIR="/var/yc/specs/clients/ycodify/client-proj-03-spec/specs"
PRD_MODE="monolithic"                          # v3.1: "monolithic" | "fragmented"
PRD_COMPILE_ON_COMPLETE="false"                # v3.1: compilar PRD ao final (fragmented mode)
TEMPLATE_VERSION="3.1"                         # v3.1: Dual-Mode PRD
INITIALIZED_AT=""
INITIALIZED_AT_FULL="qui 30 abr 2026 15:24:12 -03"
```

**Agentes leem este arquivo** para resolver placeholders e detectar modo de operação do PRD.

### Links Úteis

📖 **Template Source**: /home/julio/Codes/YC/yc-platform-v3/template-project
📖 **Agentes Detalhados**: `.claude/agents/*.md`
📖 **Skills Detalhadas**: `.claude/skills/*/SKILL.md`
📖 **Documentação YC v3.1**: Consulte template-project/
📖 **Issues/Suporte**: Contate arquitetura de agentes

---

## 🔧 Troubleshooting

### "Agentes não aparecem no @mention"

```bash
# 1. Frontmatter YAML existe?
head -10 .claude/agents/orquestrador-pm.md

# 2. Skills têm SKILL.md?
ls -la .claude/skills/*/SKILL.md

# 3. Reiniciar Claude Code
# Feche e reabra o Claude Code no diretório do projeto
```

### "Como saber se estou em projeto ou template?"

```bash
ls -la .claude-context
# Existe → Projeto concreto ✅
# Não existe → Template ⚠️ (não trabalhe aqui!)
```

### "Como atualizar agentes/skills quando template muda?"

```bash
# 1. Backup primeiro
cp -r .claude .claude.bak.$(date +%Y%m%d)

# 2. Copiar agentes/skills atualizados do template
cp /home/julio/Codes/YC/yc-platform-v3/template-project/claude/agents/*.md .claude/agents/
cp -r /home/julio/Codes/YC/yc-platform-v3/template-project/claude/skills/* .claude/skills/

# 3. NÃO sobrescrever PROJECT.md, UBIQUITOUS_LANGUAGE.yaml
```

### "Validação YAML falha"

```bash
# Diagnóstico
python3 -c "import yaml; print(yaml.safe_load(open('UBIQUITOUS_LANGUAGE.yaml')))"

# Erros comuns:
# - Indentação incorreta (use 2 espaços, não tabs)
# - Aspas não fechadas em strings
# - Listas mal formatadas (- item, não -item)
```

---

## 📄 Referência Rápida de Arquivos

| Arquivo | Modificável? | Propósito |
|---------|--------------|-----------|
| `PROJECT.md` | ✅ Sim | Metadados do projeto |
| `UBIQUITOUS_LANGUAGE.yaml` | ✅ Sim (via Guardião) | Glossário versionado |
| `LEARNING_LOG.md` | ✅ Sim (append only) | Lacunas de informação |
| `PRD.md`, `ANEXO_*.md` | ✅ Sim (gerado PM+BA) | Requisitos de negócio |
| `spec_*.json` | ✅ Sim (gerado Arquitetos) | Specs técnicas |
| `.claude-context` | ⚠️ Não | Configuração do projeto (gerado automaticamente) |
| `.claude/agents/*.md` | ⚠️ Com cuidado | Definições de agentes |
| `.claude/skills/*` | ⚠️ Com cuidado | Skills modulares |
| `templates/*`, `references/*` | ❌ Não | Referência apenas |

---

**Template Version**: 3.1 (Dual-Mode PRD: Monolithic + Fragmented)
**Initialized By**: julio
**Initialized At**: qui 30 abr 2026 15:24:12 -03
