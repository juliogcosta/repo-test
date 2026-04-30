# Questionário de Elicitação de Domínio
## Para geração de especificações BPMN + DDD no Grid de Interpretação

> **Objetivo**: Este questionário estrutura a elicitação de requisitos para sistemas baseados em metadados interpretados. O output é um `DOMAIN_BRIEF.md` que alimentará os agentes **Arquiteto de Processos** (BPMN) e **Arquiteto de Domínio** (DDD).

---

## BLOCO A: Contexto de Negócio

### A1. Objetivo do Sistema
**Pergunta**: Qual o objetivo principal deste sistema? Que problema de negócio ele resolve?

**Por quê?**: Define o escopo e permite identificar os processos críticos.

**Exemplo de resposta**:
> "Sistema de gestão de licitações públicas. Resolve o problema de rastreabilidade de propostas, prazos e conformidade legal."

---

### A2. Usuários e Atores
**Pergunta**: Quem são os usuários/atores principais? Descreva seus papéis (não pessoas específicas).

**Por quê?**: Atores se tornam **Lanes** no BPMN e podem definir **Bounded Contexts** no DDD.

**Exemplo de resposta**:
> - Licitante (empresa que submete proposta)
> - Gestor Público (aprova/reprova propostas)
> - Auditor (fiscaliza conformidade)

---

### A3. Ciclo de Vida
**Pergunta**: Qual o ciclo de vida típico de uma operação neste domínio? (narrativa, não diagrama)

**Por quê?**: Identifica o **happy path** do processo principal.

**Exemplo de resposta**:
> "Uma licitação é criada → empresas submetem propostas → gestor avalia → proposta é aprovada ou rejeitada → vencedor é notificado → contrato é formalizado."

---

### A4. Integrações e Dependências
**Pergunta**: Existem sistemas legados ou integrações externas críticas? (APIs, bancos de dados, serviços de terceiros)

**Por quê?**: Define **External Systems** no BPMN e pode exigir **Anti-Corruption Layers** no DDD.

**Exemplo de resposta**:
> - API do SICONV (governo federal) para validação de CNPJs
> - Sistema legado de protocolo (importar documentos)

---

## BLOCO B: Processos e Eventos (Event Storming)

### B1. Processos de Negócio
**Pergunta**: Quais são os **processos de negócio principais**? Descreva em narrativa, não fluxograma.

**Por quê?**: Cada processo vira um **BPMN Process** no `bpmn_spec.json`.

**Exemplo de resposta**:
> 1. **Submissão de Proposta**: Empresa preenche formulário → sistema valida CNPJ → proposta é registrada
> 2. **Avaliação de Proposta**: Gestor acessa lista → seleciona proposta → aprova ou rejeita com justificativa
> 3. **Notificação de Resultado**: Sistema envia email ao vencedor → gera protocolo

---

### B2. Eventos de Domínio
**Pergunta**: Quais **eventos de domínio** acontecem? (verbos no passado, ex: "Pedido Criado", "Pagamento Aprovado")

**Por quê?**: Eventos são **End Events** no BPMN e fundamentais para modelagem Event-Driven no DDD.

**Exemplo de resposta**:
> - Proposta Submetida
> - CNPJ Validado
> - Proposta Aprovada
> - Proposta Rejeitada
> - Vencedor Notificado
> - Contrato Gerado

---

### B3. Comandos
**Pergunta**: Que **comandos** disparam esses eventos? (verbos no imperativo, ex: "Criar Pedido", "Aprovar Pagamento")

**Por quê?**: Comandos viram **Service Tasks** no BPMN e métodos nos **Aggregates** do DDD.

**Exemplo de resposta**:
> - Submeter Proposta → dispara "Proposta Submetida"
> - Validar CNPJ → dispara "CNPJ Validado" ou "CNPJ Inválido"
> - Aprovar Proposta → dispara "Proposta Aprovada"
> - Rejeitar Proposta → dispara "Proposta Rejeitada"

---

### B4. Processos Complexos
**Pergunta**: Há processos que envolvem múltiplos atores, aprovações ou sistemas?

**Por quê?**: Indica necessidade de **Subprocesses**, **Gateways** (XOR, Parallel) e **Message Events** no BPMN.

**Exemplo de resposta**:
> - "Avaliação de Proposta" envolve Gestor (aprovação técnica) E Auditor (aprovação jurídica). Ambos devem aprovar para prosseguir (AND Gateway).

---

## BLOCO C: Bounded Contexts e Aggregates (DDD)

### C1. Contextos de Negócio
**Pergunta**: Quais **contextos de negócio** (áreas de responsabilidade) você identifica?

**Por quê?**: Cada contexto vira um **Bounded Context** no DDD e um **dataschema** no Grid.

**Exemplo de resposta**:
> - **Licitação** (gestão de processos licitatórios)
> - **Proposta** (submissão e avaliação de propostas)
> - **Contrato** (formalização de contratos)
> - **Notificação** (envio de emails e alertas)

**Convenção de Naming**: Lembre que `name` deve ser `^[a-z]+$` (apenas minúsculas, sem acento/espaço).
> licitacao, proposta, contrato, notificacao

---

### C2. Aggregates (Entidades Raiz)
**Pergunta**: Dentro de cada contexto, quais são as **entidades raiz** (Aggregates)? O que tem identidade única e fronteira transacional?

**Por quê?**: Aggregates definem os limites de consistência no DDD e as tabelas principais no banco.

**Exemplo de resposta**:
> - **Contexto Licitação**: Aggregate `Licitacao` (id, número do processo, status, prazo)
> - **Contexto Proposta**: Aggregate `Proposta` (id, CNPJ licitante, valor, status)
> - **Contexto Contrato**: Aggregate `Contrato` (id, número do contrato, proposta vencedora)

---

### C3. Invariantes de Negócio
**Pergunta**: Que **invariantes de negócio** (regras que NUNCA podem ser violadas) devem sempre ser verdadeiras?

**Por quê?**: Invariantes são validadas pelos **Aggregates** antes de emitir eventos.

**Exemplo de resposta**:
> - Uma proposta só pode ser aprovada se o CNPJ foi validado
> - Uma licitação só pode ter UM vencedor
> - Proposta rejeitada NÃO pode ser reaberta (imutabilidade de status)
> - Prazo de submissão deve ser no futuro ao criar licitação

---

### C4. Linguagem Ubíqua
**Pergunta**: Há termos específicos do domínio que devem ser padronizados? (linguagem ubíqua do DDD)

**Por quê?**: Garante consistência de naming entre BPMN e DDD.

**Exemplo de resposta**:
> - "Licitante" (não "empresa participante")
> - "Proposta" (não "oferta" ou "lance")
> - "Gestor Público" (não "administrador")

---

## BLOCO D: Especificações Técnicas para o Grid

### D1. Volumetria e Performance
**Pergunta**: Há restrições de performance conhecidas? Volumetria esperada?

**Por quê?**: Pode exigir **dbsqlminimumconnidle** e **dbsqlmaximumpoolsize** customizados no `dataschema`.

**Exemplo de resposta**:
> - Média de 100 licitações/mês
> - Pico de 500 propostas/dia em períodos de alta demanda
> - Relatórios devem responder em <2s

---

### D2. Persistência
**Pergunta**: Que tipo de persistência é necessária? (transacional, eventos, leitura/escrita separada)

**Por quê?**: Define se usaremos **Event Sourcing**, **CQRS**, ou apenas transacional.

**Exemplo de resposta**:
> - Transacional para Licitação e Proposta (PostgreSQL)
> - Log de eventos para auditoria (Event Store)

---

### D3. Comunicação entre Contextos
**Pergunta**: Há necessidade de comunicação assíncrona entre Bounded Contexts?

**Por quê?**: Define se usaremos **Message Events** no BPMN e **Domain Events** entre Aggregates.

**Exemplo de resposta**:
> - Quando "Proposta Aprovada", o contexto **Contrato** deve ser notificado para gerar contrato
> - Quando "Vencedor Notificado", o contexto **Notificação** deve enviar email

---

### D4. Reutilização de Specs
**Pergunta**: O grid já tem templates de processos similares que podemos reutilizar?

**Por quê?**: Economiza tempo e garante consistência com projetos anteriores.

**Exemplo de resposta**:
> - Temos um processo de "Aprovação Multi-Nível" reutilizável do projeto Financeiro
> - Template de "Notificação por Email" já existe

---

## OUTPUT ESPERADO

Após responder este questionário, o **Analista de Domínio** gera:

**`DOMAIN_BRIEF.md`** contendo:
1. **Contexto de Negócio** (seção A)
2. **Event Storming Summary** (seção B: eventos, comandos, atores)
3. **Bounded Contexts Candidatos** (seção C: contextos, aggregates, invariantes)
4. **Requisitos Técnicos** (seção D)

Esse documento alimenta:
- **Arquiteto de Processos** → `bpmn_spec.json`
- **Arquiteto de Domínio** → `ddd_spec.json`

---

## TÉCNICAS DE ELICITAÇÃO APLICÁVEIS

Durante a elicitação, o Analista de Domínio pode aplicar:
- **Event Storming** (perguntas B2, B3, B4)
- **Domain Storytelling** (perguntas A3, B1)
- **Bounded Context Canvas** (perguntas C1, C2, C3)
- **Socratic Questioning** (via bmad-advanced-elicitation)
- **Pre-mortem Analysis** (via bmad-advanced-elicitation)

---

## NOTAS IMPORTANTES

1. **Naming Convention**: Sempre normalizar nomes para `^[a-z]+$` antes de gerar specs
   - "Gestão de RH" → `gestaoderh`
   - "E-commerce" → `ecommerce`

2. **Validação Cruzada**: O QA de Specs verificará se:
   - Todo Aggregate ID referenciado no BPMN existe no DDD
   - Todo Command no BPMN tem método correspondente no Aggregate
   - Invariantes do DDD são respeitadas nos gateways do BPMN

3. **Iteração**: Este questionário é um guia. O Analista pode adaptar perguntas conforme o contexto.

---

**Versão**: 1.0
**Data**: 2026-04-15
**Autor**: Arquitetura de Agentes YC Platform
