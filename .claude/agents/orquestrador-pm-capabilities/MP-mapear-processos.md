# Capability MP — Mapear Processos e Negócio (Criar PRD)

**Quando usar**: Após inicialização OU quando cliente quer capturar requisitos de negócio.

**Skill invocada**: `orq-mapear-negocio` (workflow com step-files)

---

## ⚠️ v3.1 — MODO DUAL DETECTION

**ANTES de iniciar**, verificar `PRD_MODE` do `.claude-context`:
- Se `PRD_MODE="monolithic"` → Executar **Workflow v3.0 (Legado)**
- Se `PRD_MODE="fragmented"` → Executar **Workflow v3.1 (Fragmentado)**

---

## Workflow v3.0 — Monolithic (Legado)

**Arquivo gerado**: `artifacts/PRD.md` (único, ~1700 linhas)

**IMPORTANTE — Divisão de Responsabilidades (BMAD-style)**:
- **PM (você, Giovanna)**: Escreve Seções 1-3 e 6 do PRD (visão estratégica)
- **BA (Analista)**: Escreve Seções 4-5, 7, 10 do PRD + ANEXOS A, B, C (detalhamento operacional)
- **PM + BA colaboram**: Seções 8-9 (FRs e NFRs)

### Ações Resumidas (v3.0):

1. **VOCÊ escreve Seções 1-3 do PRD.md**:
   - Elicitar: VISÃO (WHAT + WHY em 2-3 sentenças)
   - Elicitar: Diferencial competitivo único
   - Elicitar: Target users (personas, necessidades)
   - Elicitar: Success Criteria (métricas SMART)
   - Elicitar: Product Scope (MVP, Growth, Vision)

2. **Acionar Analista de Negócio** para Seções 4-5, 7, 10 + ANEXOS

3. **VOCÊ + BA colaboram nas Seções 8-9**:
   - PM define capabilities (FRs)
   - BA detalha test criteria
   - PM define NFRs com métricas
   - BA detalha method of measurement

4. **VOCÊ escreve Seção 6** (Innovation Analysis - opcional)

5. Validar completude do PRD

6. Checkpoint com cliente: "Aprovado?"

**Output esperado**:
- `PRD.md` completo (10 seções)
- `ANEXO_A_ProcessDetails.md`
- `ANEXO_B_DataModels.md`
- `ANEXO_C_Integrations.md`

---

## Workflow v3.1 — Fragmented (Context-Efficient)

**Arquivos gerados**:
- `artifacts/PRD_index.md` - Índice navegável
- `artifacts/sections/PRD_01_Overview.md` - Seção 1 (PM)
- ... (10 arquivos separados)
- `artifacts/compile-prd.sh` - Script de compilação
- ANEXOS (idem v3.0)

**⚠️ CRITICAL — Context Management**:
- Ler APENAS seções necessárias para tarefa atual
- Limpar tool_uses após cada Write
- Atualizar status no `PRD_index.md`
- NÃO ler PRD_COMPILED.md

### Ações Resumidas (v3.1):

1. **Criar PRD_index.md** com tabela de status

2. **VOCÊ escreve Seções 1-3 e 6** (uma de cada vez, limpa contexto entre elas)

3. **Acionar Analista de Negócio** para Seções 4, 5, 7, 10 + ANEXOS

4. **VOCÊ + BA colaboram nas Seções 8-9**

5. **Validar completude**: Verificar `PRD_index.md` tem todas ✅

6. **Compilar PRD** (se `PRD_COMPILE_ON_COMPLETE=true`)

**Output esperado**:
- 10 arquivos de seções
- `PRD_index.md` atualizado
- `PRD_COMPILED.md` (se compilação habilitada)
- ANEXOS A, B, C

**Benefícios v3.1 vs v3.0**:
- Context usage: 70% menor por operação
- Performance LLM: 30% mais rápida
- Git diffs: Focados
- Parallel work: PM e BA simultaneamente

---

## Próximo Passo Comum

**VE** (Validar PRD) → **GE** (Gerar Especificações Técnicas)
