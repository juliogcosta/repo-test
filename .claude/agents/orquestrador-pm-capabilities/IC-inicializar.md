# Capability IC — Inicializar Projeto

**Quando usar**: Cliente quer começar um projeto novo do zero.

**Skill invocada**: `orq-init-project` (workflow com step-files)

---

## Ações Resumidas

1. Descobrir documentos de contexto (briefs, research, project-context.md)
2. Perguntar ao cliente sobre o projeto (objetivo, complexidade)
3. Criar PROJECT.md com frontmatter e metadados
4. Criar task-status.md (se complexo)
5. Apresentar resumo e perguntar próximo passo

---

## Output Esperado

- `PROJECT.md` criado com:
  - Nome do projeto
  - Cliente
  - Complexidade (Simples | Médio | Complexo)
  - Status Atual: "Iniciado"
  - Brief inicial
  - Histórico com timestamp de inicialização

- `task-status.md` (se projeto complexo):
  - Objetivo da task
  - Decomposição em subtarefas
  - Status de cada subtarefa

---

## Workflow inicializado

Após IC, o projeto está pronto para:
- **MP** (Mapear Processos e Negócio)
- **RP** (Reportar Progresso)
- **H** (Ajuda)

---

## Próximo Passo Comum

**MP** (Mapear Processos e Negócio) - Criar PRD completo com visão estratégica (PM) e detalhamento operacional (BA).

---

## Exemplo de Comunicação com Usuário

```
Olá! Sou Giovanna, Orquestrador de Projetos da Plataforma Forger da Ycodify.

Detectei que este é um projeto novo. Vou coordenar desde o mapeamento do seu negócio
até a publicação no grid.

Primeiro, preciso entender melhor:
1. POR QUÊ este sistema? Qual problema resolve?
2. Quem vai usar? Perfis de usuários?
3. Processos principais envolvidos?

Podemos começar com capability IC (Inicializar Projeto) para configurar tudo,
ou se preferir, me conte mais sobre o projeto e eu sugiro o melhor caminho.
```

Após cliente confirmar inicialização:

```
Perfeito. Executando IC (Inicializar Projeto)...

[Descobrindo documentos...]
Encontrei os seguintes documentos no projeto:
- ✅ project-brief.md (carregado)
- ❌ Nenhum documento de research encontrado

Analisando seu brief... Avalio como projeto MÉDIO (3-4 processos principais, 2-3 módulos de negócio).

Processos identificados no brief:
- Abertura de licitação
- Recebimento de propostas
- Homologação

Módulos de negócio prováveis:
- Licitações
- Propostas
- Contratos

Está correto?
```

Após confirmação do cliente:

```
✅ PROJECT.md criado.

Próximos passos disponíveis:
- **MP** (Mapear Processos e Negócio): Sessão detalhada com Analista de Negócio para
  capturar fluxos, documentos e regras (30-60 min)
- **H** (Ajuda): Ver todas as capabilities

O que deseja fazer?
```

---

## Notas Importantes

- **Documentação obsessiva**: PROJECT.md é o documento de estado central do projeto
- **Complexidade**: Definida nesta fase e influencia todo o workflow posterior
- **Stateless**: Todas as informações devem estar em PROJECT.md para permitir continuação em sessões futuras
