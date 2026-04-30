# Capability ER — Explicar Requisito

**Quando usar**:
- **Pré-implementação**: usuário quer entender AC ambíguo antes de autorizar IS.
- **Pós-implementação**: usuário quer "me explica o que você fez" após IS/RV concluído.

**Não implementa** — só explica. Zero mudança em código ou story file.

**Duração**: 2-10 minutos.

---

## Pré-condições

- Story file existe.
- Para modo pós-implementação: Status ≥ `in-progress`.

---

## Steps (Modo pré-implementação)

### Step 1 — Carregar Story

1. Ler story file INTEGRAL.
2. Identificar task/AC/seção que o usuário quer explicado.

### Step 2 — Identificar Alvo da Explicação

O usuário normalmente aponta:
- Um AC específico (`AC-3`).
- Uma task (`Task 2.1`).
- Uma subseção de Dev Notes (`Data Models`, `File Locations`).
- Uma dúvida ampla ("o que essa story faz?").

### Step 3 — Explicar (tailored a `user_skill_level`)

**Formato tailored** baseado em `user_skill_level` (se `.claude-context` tem):
- `beginner`: explica com analogias, evita jargão não explicado, mostra diagrama textual se útil.
- `intermediate` (default): prosa técnica direta, cita sources.
- `advanced`: ultra-succinct, só file:line e sources; user já sabe contextos técnicos.

**Conteúdo obrigatório**:
1. O que a story / task / AC busca alcançar (intenção de negócio).
2. Como isso se traduz em código (se Dev Notes tem File Locations: cita).
3. Dependências / pré-requisitos.
4. Critérios de sucesso (quando considerar satisfeito).
5. Fontes citadas: `[Source: ...]` como na Dev Notes.

---

## Steps (Modo pós-implementação)

### Step 1 — Carregar Story + Código

1. Ler story file INTEGRAL (já deve ter Status `review` ou `done`).
2. Ler `Dev Agent Record → Implementation Plan` + `Completion Notes`.
3. Ler `File List`.
4. Se user especificou arquivo ou task: abrir só aqueles.

### Step 2 — Identificar Alvo

Similar ao pré-implementação, mas também:
- "Como funciona X?" (onde X é uma feature implementada).
- "Por que você escolheu Y em vez de Z?" (justificativa).
- "O que testa esse teste?" (explicar asserts).

### Step 3 — Explicar

Conteúdo obrigatório:
1. O que foi implementado (resumo tailored).
2. Onde está (file:line + File List).
3. Como testar / verificar.
4. Decisões técnicas não-óbvias (cita Dev Notes ou Implementation Plan).
5. Padrões / libs usados.

---

## Regras

1. **ER NÃO modifica nada** — nem código, nem story file. Read-only.
2. **ER NÃO implementa** — mesmo se usuário insistir, responder: "ER explica; para implementar, use IS."
3. **ER cita sempre** — cada afirmação técnica com `[Source: ...]` ou `file:line`.
4. **ER respeita user_skill_level** — adapta sem ser condescendente.

---

## Halt Conditions

- Story file inacessível → HALT.
- Alvo da explicação ambíguo → pedir clarificação antes de explicar.
- Modo pós-implementação mas Status = `ready-for-dev` (nada implementado) → redirect para modo pré-implementação.

---

## Fontes

- `bmad/investigacao/SPEC_desenvolvedor.md §11 ER`.
- V4 `dev.md` linha 480 (`*explain` — "teach me what and why you did whatever you just did in detail").
