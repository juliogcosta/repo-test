# Capability AM — Alimentar Implementation Map

**Quando usar**:
- Após Sofia atualizar ANEXO_B com **novo aggregate** / **novo command** / **nova integração**.
- Após Arthur refinar arquitetura em nova execução de `CA` parcial.
- Após **HALT estruturado** de Bento (SM) apontando gap de mapeamento: business_term referenciado na story não existe no `IMPLEMENTATION_MAP.yaml`.
- Após **HALT estruturado** de Eduardo (Dev) apontando divergência entre paths declarados no map e estrutura real do código.
- Após **HALT estruturado** de Iuri (QA) apontando File List incompatível com IMPLEMENTATION_MAP.

**Duração estimada**: 5-20 minutos (depende do volume de mudança).

**Output**: `{PROJECT_ROOT}/IMPLEMENTATION_MAP.yaml` atualizado + bump de versão SemVer + entry em `meta.changelog`.

---

## Por que AM é separada de CA

**Decisão Q3 (2026-04-19)**: AM é capability independente (não é "re-rodar CA incremental"). Motivos:

- **Cirurgia vs. cirurgia geral**: AM é intervenção pontual (1-5 entries). CA cobre documento inteiro (dezenas de entries). Granularidade diferente.
- **Custo**: AM em minutos; CA em horas.
- **Contexto**: AM não precisa re-ler PRD/ANEXOS inteiros — só a seção modificada.
- **Log**: cada AM vira uma linha no `meta.changelog` rastreável; CA gera versão major.

---

## Pré-condições

- `IMPLEMENTATION_MAP.yaml` **já existe** (v ≥ 1.0).
- Se não existir → usuário deve executar `CA` primeiro (para versão inicial).
- `UBIQUITOUS_LANGUAGE.yaml` e `TERMINOLOGY_MAP.yaml` existem (necessários para validar `cross_refs`).

---

## Steps

### Step 1 — Identificar Trigger

Arthur recebe contexto da invocação:

- **Trigger A — Alteração em ANEXO**: usuário (ou Orquestrador) indica "ANEXO_B foi atualizado — adicione entries para o novo aggregate X".
- **Trigger B — HALT de agente downstream**:
  - Bento (SM) aponta: `business_term "Y" referenciado na story Z não existe no IMPLEMENTATION_MAP`.
  - Eduardo (Dev) aponta: `path declarado "src/foo/Bar.ts" em IMPLEMENTATION_MAP não existe no repo`.
  - Iuri (QA) aponta: `File List da story diverge do module declarado em IMPLEMENTATION_MAP`.
- **Trigger C — Refactor de arquitetura**: usuário decidiu mover módulo X para pasta Y → atualizar paths.
- **Trigger D — Correção manual**: usuário aponta erro específico.

Identificar o trigger determina o **tipo de bump SemVer**:
- PATCH: correção de paths, cross_refs, tipagem fina (Trigger C, D).
- MINOR: adicionar entry nova em categoria existente (Trigger A, B).
- MAJOR: adicionar/remover categoria, mudar schema (raríssimo; discutir antes).

---

### Step 2 — Localizar Contexto Mínimo

Dependendo do trigger, ler **apenas** o necessário:

- **Trigger A**: ler seção específica do ANEXO_B/A/C modificada.
- **Trigger B**: ler story file (para entender contexto) + seção relevante do ANEXO.
- **Trigger C**: ler `SOFTWARE_ARCHITECTURE.md §8 Source Tree` atualizada + entries afetadas no IMPLEMENTATION_MAP.
- **Trigger D**: ler apenas a entry específica apontada pelo usuário.

**Regra de eficiência**: evitar re-ler PRD inteiro / arquitetura inteira — capability AM é cirúrgica.

---

### Step 3 — Validar Ancoragem Semântica

Antes de escrever no IMPLEMENTATION_MAP, Arthur valida:

- [ ] `business_term` existe em `UBIQUITOUS_LANGUAGE.yaml`?
  - Se **não**: HALT e acionar Lexicon: `@guardiao-linguagem-ubiqua adicionar termo "X" ao glossário`.
  - Aguardar confirmação do Lexicon antes de prosseguir.

- [ ] `design_term` existe em `TERMINOLOGY_MAP.yaml`?
  - Se **não**: HALT e acionar Lexicon: `@guardiao-linguagem-ubiqua registrar termo técnico "Y"`.
  - Aguardar confirmação.

- [ ] `cross_refs.prd_section` / `anexo_*_section` são válidas (seções existem nos arquivos)?
  - Se seção inexistente: HALT e reportar inconsistência.

- [ ] `implementation.files` / `module` são paths relativos à raiz do projeto (nunca absolutos)?
- [ ] Naming das classes/funções em `public_api` segue convenções do `TERMINOLOGY_MAP.yaml` (`^[A-Z][a-zA-Z]+$` para classes, `^[a-z][a-zA-Z]+$` para funções etc.)?

---

### Step 4 — Aplicar Mudança

**Para cada entry a adicionar/modificar**:

1. Localizar categoria correta (`domain_entities` / `business_processes` / `integrations` / `data_models` / `ui_components` / `infrastructure` / `domain_events`).
2. Se **adicionar**: inserir entry no final da lista `entries` da categoria (mantém ordem cronológica de adição).
3. Se **modificar**: usar `Edit` apontando o bloco YAML específico da entry (via `business_term:` como chave única).
4. **Preservar** todas as outras entries e categorias (nunca sobrescrever o arquivo inteiro).

**Formato de entry canônico** (espelha `DRAFT_IMPLEMENTATION_MAP.yaml`):

```yaml
    - business_term: "Edital de Licitação"
      design_term: "DOC-lic-Edital"
      implementation:
        module: "src/modules/licitacao/domain/edital"
        files:
          - "src/modules/licitacao/domain/edital/Edital.ts"
          - "src/modules/licitacao/domain/edital/EditalInvariants.ts"
        tests:
          - "src/modules/licitacao/domain/edital/__tests__/Edital.spec.ts"
        public_api:
          - "Edital"
          - "Edital.publicar()"
      cross_refs:
        ubiquitous_language: "Edital de Licitação"
        terminology_map: "DOC-lic-Edital"
        prd_section: "PRD §8 FR-001"
        anexo_b_section: "ANEXO_B §3.1"
        architecture_section: "SOFTWARE_ARCHITECTURE §4 Components"
```

---

### Step 5 — Bump SemVer e Changelog

1. Ler `meta.version` atual (ex.: `"1.0.0"`).
2. Determinar tipo de bump:
   - PATCH: `1.0.0` → `1.0.1` (correção de paths, cross_refs).
   - MINOR: `1.0.1` → `1.1.0` (nova entry, categoria inalterada).
   - MAJOR: `1.1.0` → `2.0.0` (nova categoria, breaking change — raro).
3. Atualizar `meta.version` e `meta.last_updated` (ISO date).
4. Adicionar entry em `meta.changelog`:

```yaml
  changelog:
    - version: "1.1.0"
      date: "2026-04-19"
      author: "arquiteto-de-software"
      trigger: "HALT de scrum-master — story L-021 referenciou aggregate DOC-lic-Impugnacao inexistente"
      changes:
        - "ADD domain_entities.entries: DOC-lic-Impugnacao"
        - "ADD data_models.entries: impugnacao table schema"
    - version: "1.0.0"
      date: "2026-04-19"
      author: "arquiteto-de-software"
      note: "Initial creation from PRD+ANEXOS+SOFTWARE_ARCHITECTURE."
```

---

### Step 6 — Retornar Controle

Dependendo do trigger, Arthur retorna:

- **Trigger A (Sofia atualizou ANEXO)**: report ao Orquestrador; usuário decide se precisa re-executar `IR`.
- **Trigger B (HALT de downstream)**:
  - SM Bento: retornar com novo business_term disponível; Bento retoma `CS` da story bloqueada.
  - Dev Eduardo: retornar com path corrigido; Eduardo retoma `IS`.
  - QA Iuri: retornar com module alinhado; Iuri retoma `RV`.
- **Trigger C (refactor)**: reportar impacto potencial no Dev (stories em andamento podem ter paths desatualizados — avisar Bento).
- **Trigger D (correção)**: confirmar ao usuário.

---

## Halt Conditions

- `IMPLEMENTATION_MAP.yaml` inexistente → HALT + direcionar usuário para executar `CA` primeiro.
- `business_term` não validado pelo Lexicon → HALT + acionar Lexicon.
- `design_term` não validado pelo Lexicon → HALT + acionar Lexicon.
- Path declarado não existe no repositório (Trigger C) **e** usuário não confirmou que path será criado → HALT + pedir confirmação.
- Conflict merge em YAML (duas entries com mesmo `business_term`) → HALT + reportar; usuário decide como resolver.
- Schema inválido (parse YAML falha) → HALT + reportar linha do erro; usuário corrige manualmente.

---

## Regras Invioláveis

1. **AM NUNCA apaga entries silenciosamente** — toda remoção requer autorização explícita do usuário (MAJOR bump).
2. **AM NUNCA muda schema do arquivo** — se for necessário mudar schema, escalar para usuário (decisão arquitetural).
3. **AM SEMPRE atualiza `meta.changelog`** — mudança sem changelog é inaceitável.
4. **AM SEMPRE valida cross_refs** — entry sem `cross_ref` para UBIQUITOUS OU TERMINOLOGY é recusada.
5. **Dev NUNCA pode invocar AM diretamente** — apenas via HALT estruturado que escala para Arthur.

---

## Fontes

- `bmad/investigacao/SPEC_arquiteto-de-software.md` §3.1 (capability AM descrição).
- `bmad/investigacao/DRAFT_IMPLEMENTATION_MAP.yaml` (formato canônico + regras).
- Regra SemVer: https://semver.org/lang/pt-BR/ (política adotada pelo projeto).
