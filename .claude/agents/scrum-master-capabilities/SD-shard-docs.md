# Capability SD — Shard Docs

**Quando usar**: antes de EP/CS quando docs longos (PRD, arquiteturas) excedem ~2000 linhas e dificultam análise seletiva.

**Duração estimada**: 2-5 minutos por documento.

**Output**: diretório `{dirname}/{basename}/` com `index.md` + 1 arquivo por H2 do original.

---

## Pré-condições

- Documento-fonte em markdown (`.md`).
- `npx` disponível no PATH (Node.js instalado).
- Permissão de escrita no diretório destino.

---

## Steps

### Step 1 — Obter Documento Fonte

1. Perguntar ao usuário qual doc shardar (ou usar `doc_path` se fornecido como parâmetro):
   - `PRD.md`
   - `ANEXO_A_ProcessDetails.md` / `ANEXO_B_DataModels.md` / `ANEXO_C_Integrations.md`
   - `SOFTWARE_ARCHITECTURE.md`
   - `FRONTEND_ARCHITECTURE.md`
2. Verificar que o arquivo existe e é `.md`.

**Halt**: arquivo não encontrado OU não é `.md`.

---

### Step 2 — Determinar Destino

1. Destino padrão: `{dirname(src)}/{basename(src, .md)}/`
   - Ex.: `artifacts/PRD.md` → `artifacts/prd/`
2. Confirmar com usuário (`[y]` para aceitar default ou fornecer path custom).
3. Verificar permissão de escrita.

**Halt**: sem permissão de escrita.

---

### Step 3 — Executar Sharding

1. Via Bash:
   ```
   npx @kayvan/markdown-tree-parser explode {src} {dest}
   ```
2. Capturar output e erros.

**Halt**: comando falha (npx não disponível, erro parse, etc.) — reportar erro específico.

---

### Step 4 — Verificar Output

1. Checar que `{dest}/index.md` foi criado.
2. Contar arquivos gerados (um por H2 do original).

**Halt**: nenhum arquivo gerado.

---

### Step 5 — Reportar Conclusão

```
Sharding concluído, {user_name}.

Fonte:  {src}
Destino: {dest}
Arquivos criados: {N} (incluindo index.md)

Proposta: Deseja manter, arquivar ou deletar o arquivo original {src}?
- [d] Deletar (recomendado — shards podem ser recombinados se necessário)
- [m] Mover para archive/
- [k] Manter (NÃO recomendado — pode causar confusão para outros agentes)
```

---

### Step 6 — Tratar Documento Original (decisão do usuário)

- **[d] Deletar**: `rm {src}` (com autorização explícita; NUNCA automático).
- **[m] Mover**: `mv {src} {dirname(src)}/archive/{basename(src)}`.
- **[k] Manter**: avisar que `discover-inputs` protocol pode carregar versão errada.

**Regra global CLAUDE.md**: NUNCA executar `rm` sem autorização explícita do usuário. Aqui, o usuário está fornecendo autorização via escolha `[d]` — mas Bento deve confirmar 1 vez antes de executar o rm.

---

## Halt Conditions Consolidadas

- Arquivo fonte não existe ou não é `.md`.
- `npx` não disponível (Node.js não instalado no sistema).
- Comando `npx @kayvan/markdown-tree-parser explode` falha.
- Sem permissão de escrita no destino.
- Nenhum arquivo gerado (provável corrupção do fonte).

---

## Fontes

- `bmad/investigacao/SPEC_scrum-master.md §5 SD`.
- `bmad/agents/bmad-shard-doc/SKILL.md` V6 (literal).
