# Capability EP — Criar Epics e Stories

**Quando usar**: Arthur IR = PASS; usuário quer gerar backlog inicial (ou regenerar após correct-course).

**Duração estimada**: 20-60 minutos.

**Output**: `{ARTIFACTS_DIR}/epics.md` com:
- Epics numerados (1, 2, 3, ...).
- Stories enumeradas (`1.1`, `1.2`, `2.1`, ...) em BDD.
- Source hints: `[Source: PRD §X]` / `[Source: ANEXO_B DOC-Y]` / `[Source: SOFTWARE_ARCHITECTURE §Z]` em cada story.

---

## Pré-condições

- `{ARTIFACTS_DIR}/PRD.md` aprovado e completo.
- `{ARTIFACTS_DIR}/ANEXO_A_ProcessDetails.md`, `ANEXO_B_DataModels.md`, `ANEXO_C_Integrations.md` existem.
- `{ARTIFACTS_DIR}/SOFTWARE_ARCHITECTURE.md` existe e `stepsCompleted` completo (todas as 15 seções).
- `{ARTIFACTS_DIR}/FRONTEND_ARCHITECTURE.md` existe (conteúdo completo OU "N/A — sem UI").
- `{ARTIFACTS_DIR}/READINESS_REPORT.md` status = PASS (desejável; WARN aceitável mediante confirmação; FAIL bloqueia).
- `{PROJECT_ROOT}/IMPLEMENTATION_MAP.yaml` v ≥ 1.0 existe.

**Se pré-condição falhar**: HALT + handoff específico.

---

## Steps

### Step 1 — Validar Pré-requisitos

1. Ler frontmatter de `SOFTWARE_ARCHITECTURE.md` — confirmar 15 seções em `stepsCompleted`.
2. Ler `READINESS_REPORT.md`:
   - PASS → prosseguir.
   - WARN → perguntar ao usuário se aceita prosseguir com débito técnico registrado.
   - FAIL → HALT + listar bloqueios + recomendar `@arquiteto-de-software CA` para refinar.
3. Confirmar que `IMPLEMENTATION_MAP.yaml` tem entries em categorias essenciais (domain_entities mínimo).

---

### Step 2 — Design de Epics

**Princípio**: epics agrupam stories por **valor de usuário entregue**, não por camada técnica.

1. Ler PRD §4 (User Journeys) + §7 (Project-Type Requirements) + §8 (FRs).
2. Mapear FRs a journeys. Cada epic representa uma journey completa ou subconjunto coerente.
3. Ler `modulos` em PRD §10 (metadados YAML) para alinhar epics com módulos declarados.
4. Sugerir 3-10 epics; apresentar ao usuário para validação:
   ```
   Sugiro os seguintes epics, {user_name}:

   1. Epic 1: {Nome do Epic 1} (cobre jornada J-01, FRs 001-005)
      Valor: {descrição curta}

   2. Epic 2: {Nome do Epic 2} (cobre jornada J-02, FRs 006-010)
      Valor: {descrição curta}

   ...

   Alguma alteração? Adicionar/remover/renomear/reordenar?
   ```
5. Aguardar aprovação explícita.

---

### Step 3 — Criação de Stories por Epic

Para cada epic aprovado:

1. Decompor FRs + AC em **stories atômicas** (critério: 1 story = 1-3 dias de Dev agent; se maior, subdividir).
2. Numerar como `{epic_num}.{story_num}` (ex.: `1.1`, `1.2`, `2.1`).
3. Para cada story, escrever:

   ```markdown
   ### Story {epic_num}.{story_num}: {Título da Story}

   **Como** {role},
   **quero** {action},
   **para que** {benefit}.

   **Acceptance Criteria**:
   1. **Given** {contexto}, **when** {ação}, **then** {resultado esperado}.
   2. **Given** {contexto}, **when** {ação}, **then** {resultado esperado}.
   ...

   **Source Hints** (para Bento preencher Dev Notes depois):
   - `[Source: PRD.md §8 FR-001]`
   - `[Source: ANEXO_B_DataModels.md §2.3 DOC-lic-Edital]`
   - `[Source: SOFTWARE_ARCHITECTURE.md §4 Components → EditalService]`
   - `[Source: IMPLEMENTATION_MAP.yaml domain_entities#"Edital de Licitação"]`

   **Dependências** (opcional):
   - Requer story `{epic}.{prev_story}` concluída.

   **Frontend-aware**: {sim|não} (heurística: menciona UI, form, tela, dashboard)

   **Estimativa**: {1-3 dias} (Dev agent com TDD).
   ```

4. **Regra**: cada story deve ter pelo menos 2 source hints (um do PRD/ANEXO, um da arquitetura) — caso contrário, não está suficientemente ancorada.

---

### Step 4 — Final Validation (Inventário)

1. Confirmar que **todos** os FRs do PRD §8 estão cobertos por pelo menos 1 story.
2. Confirmar que **todas** as jornadas do PRD §4 estão representadas em pelo menos 1 epic.
3. Confirmar que não há **órfãos** (stories sem FR/AC/source hint).
4. Validar com usuário: apresentar tabela sumário:
   ```
   Epic | Stories | FRs cobertos | Jornadas
   -----|---------|--------------|----------
   1    | 4       | FR-001..004  | J-01
   2    | 3       | FR-005..007  | J-02
   ...
   ```

---

### Step 5 — Escrever `epics.md`

1. Template em `templates/epics-template.md` (se existir) ou estrutura padrão:
   ```markdown
   # Epics — {project_name}

   **Gerado por**: Bento (scrum-master) capability EP
   **Data**: {iso_date}
   **Fontes**: PRD.md, ANEXO_A/B/C.md, SOFTWARE_ARCHITECTURE.md, FRONTEND_ARCHITECTURE.md
   **Total**: {N} epics, {M} stories

   ---

   ## Epic 1: {Nome}

   **Valor**: {descrição}
   **Jornadas cobertas**: J-01, J-03
   **FRs cobertos**: FR-001, FR-002, FR-003

   ### Story 1.1: {Título}
   ...

   ### Story 1.2: {Título}
   ...

   ---

   ## Epic 2: {Nome}
   ...
   ```

2. Frontmatter YAML:
   ```yaml
   ---
   template_version: "1.0"
   stepsCompleted: [step-1-validation, step-2-epic-design, step-3-stories, step-4-inventory]
   currentStatus: approved
   lastUpdated: {iso}
   totalEpics: {N}
   totalStories: {M}
   ---
   ```

3. Escrever via Write (primeira criação) ou Edit (refinamento).

---

### Step 6 — Handoff para SP

Sugerir ao usuário:
```
Epics.md gerado com {N} epics e {M} stories.

Próximo passo: `@scrum-master SP` para inicializar sprint-status.yaml.
```

---

## Halt Conditions

- READINESS_REPORT status = FAIL → HALT + acionar Arthur.
- PRD §8 (FRs) vazio ou sem numeração → HALT + acionar Sofia.
- Arquitetura com `[A DEFINIR]` bloqueantes → HALT + acionar Arthur.
- Usuário recusa estrutura de epics 3 vezes consecutivas → HALT + propor sessão de brainstorming.

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md §5 EP`.
- `bmad/agents/bmad-create-epics-and-stories/workflow.md` V6.
- `bmad/agents/bmad-create-epics-and-stories/templates/` (se existir).
