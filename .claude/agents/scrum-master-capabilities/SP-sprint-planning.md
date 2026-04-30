# Capability SP — Sprint Planning

**Quando usar**:
- Depois de EP (gerou epics.md) e antes da primeira CS.
- OU para regenerar sprint-status após correct-course que mudou epics.md.

**Duração estimada**: 5-10 minutos.

**Output**: `{ARTIFACTS_DIR}/sprint-status.yaml` inicializado com todas as entries em `backlog` (preservando status já existentes se re-execução).

---

## Pré-condições

- `{ARTIFACTS_DIR}/epics.md` existe e `currentStatus: approved`.
- Sprint-status.yaml pode existir (re-execução) ou não (primeira vez).

---

## Steps

### Step 1 — Parse de epics.md

1. Ler `epics.md` integralmente.
2. Extrair padrões:
   - `## Epic N: {Nome}` → chave `epic-N`.
   - `### Story N.M: {Título}` → chave `N-M-{slug-kebab}` (título convertido para kebab-case).
3. Regra de conversão de slug:
   - Lowercase.
   - Espaços → hífen.
   - Acentos removidos (NFD normalization).
   - Caracteres especiais descartados (manter `[a-z0-9-]`).
   - Exemplo: "User Authentication" → `user-authentication`.
   - Exemplo: "Cadastro de Clientes" → `cadastro-de-clientes`.

---

### Step 2 — Build Structure

Construir estrutura YAML:

```yaml
development_status:
  epic-1: backlog
  1-1-{story1-slug}: backlog
  1-2-{story2-slug}: backlog
  epic-1-retrospective: optional

  epic-2: backlog
  2-1-{story1-slug}: backlog
  epic-2-retrospective: optional

  ...
```

Ordem: epics sequenciais, stories dentro de cada epic em ordem (`N-1`, `N-2`, `N-3`...), retrospective sempre no final de cada epic.

---

### Step 3 — Status Intelligence (só em re-execução)

Se `sprint-status.yaml` já existe:

1. Ler arquivo existente preservando todos os comentários (STATUS DEFINITIONS header etc.).
2. Para cada story em `epics.md`:
   - Se chave existe em sprint-status: **preservar status atual** (nunca downgrade).
   - Se chave nova (não existe em sprint-status): adicionar como `backlog`.
3. Para stories em sprint-status mas **não** em epics.md (órfãs):
   - Se status ∈ `{backlog, optional}`: remover (silently).
   - Se status ∈ `{ready-for-dev, in-progress, review, done}`: **manter** + flaggar em report "orphan — consider correct-course".
4. Detectar **upgrade automático**: se story file existe em `{ARTIFACTS_DIR}/stories/{key}.md`, upgrade status mínimo para `ready-for-dev`.

---

### Step 4 — Adicionar `depends_on` (decisão Q6 — 2026-04-19)

Para cada story que tenha dependência declarada no epics.md (campo `Dependências: Requer story X.Y`):
- Adicionar ao sprint-status.yaml:
  ```yaml
  1-3-feature-b:
    status: backlog
    depends_on: ["1-2-feature-a"]
  ```
- Se dependência não existe → HALT + reportar inconsistência.

**Nota**: para stories **sem** dependências, manter formato flat (só status):
```yaml
1-1-feature-a: backlog
```

(Mistura de formatos aceitável; SS detecta e trata.)

---

### Step 5 — Escrever sprint-status.yaml

1. Usar `templates/sprint-status-template.yaml` como base.
2. Substituir:
   - `{project_name}` → valor de `.claude-context`.
   - `{iso_date}` → data atual.
   - `{story_location}` → `artifacts/stories`.
3. Popular `development_status` com entries extraídas (Steps 2-4).
4. Escrever via Write (se novo) ou Edit (preservando comentários em re-execução).

---

### Step 6 — Reportar

```
Sprint-status.yaml inicializado, {user_name}.

Projeto: {project_name}
Total: {N} epics, {M} stories
Status atual: todos em `backlog` (0 ready-for-dev, 0 in-progress, 0 done)

Próximo passo: `@scrum-master CS` para criar a primeira story
            OU `@scrum-master SS` para ver sumário.
```

---

## Halt Conditions

- `epics.md` ausente ou `currentStatus ≠ approved` → HALT + acionar EP.
- Dependência declarada aponta para story inexistente → HALT + pedir correção no epics.md.
- Write falha (permissão, disco cheio) → HALT + reportar erro.

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md §5 SP + §9 template`.
- `bmad/agents/bmad-sprint-planning/workflow.md` V6.
- `bmad/agents/bmad-sprint-planning/sprint-status-template.yaml` V6.
