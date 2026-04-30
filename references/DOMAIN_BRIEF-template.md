# DOMAIN_BRIEF: [Nome do Projeto]

> **Versão**: 1.0
> **Data**: [YYYY-MM-DD]
> **Analista de Domínio**: [Nome ou "AI Agent"]
> **Status**: [Draft | Em Revisão | Aprovado]

---

## 1. Contexto de Negócio

### 1.1 Objetivo do Sistema
**Problema de Negócio**:
[Descrever qual problema o sistema resolve]

**Objetivo Principal**:
[Descrever o que o sistema deve alcançar]

**Escopo**:
- ✅ **Incluído**: [O que está dentro do escopo]
- ❌ **Excluído**: [O que NÃO está no escopo]

---

### 1.2 Usuários e Atores

| Ator | Papel | Responsabilidades |
|------|-------|-------------------|
| [Nome do Ator] | [Papel] | [O que este ator faz no sistema] |
| ... | ... | ... |

---

### 1.3 Ciclo de Vida (Narrativa)

[Descrever em narrativa o fluxo típico de uso do sistema, do início ao fim]

**Exemplo**:
> "Um cliente acessa o portal → realiza login → busca produtos → adiciona ao carrinho → finaliza compra → recebe confirmação por email → aguarda entrega."

---

### 1.4 Integrações e Dependências

#### Sistemas Externos
| Sistema | Finalidade | Tipo de Integração |
|---------|------------|-------------------|
| [Nome do Sistema] | [Para que serve] | [API REST / SOAP / Webhook / etc] |
| ... | ... | ... |

#### Sistemas Legados
| Sistema | Responsabilidade | Observações |
|---------|------------------|-------------|
| [Nome] | [O que faz] | [Restrições, status, etc] |

---

## 2. Event Storming Summary

> Seção gerada pela skill `domain-elicitation-event-storming`

### 2.1 Eventos de Domínio

| # | Evento de Domínio | Disparado por (Comando) | Executado por (Ator) | Sistema Externo |
|---|-------------------|-------------------------|---------------------|-----------------|
| 1 | [Nome do Evento] | [Comando] | [Ator] | [Se aplicável] |
| 2 | ... | ... | ... | ... |

---

### 2.2 Fluxos de Processo

#### Processo: [Nome do Processo]

**Narrativa**:
[Descrever o fluxo em linguagem natural, mencionando eventos ordenados]

**Eventos Sequenciais**:
1. [Evento 1]
2. [Evento 2]
3. [Evento 3]
   ...

**Decisões (Gateways)**:
- **[Ponto de Decisão]**:
  - ✅ Se [condição] → [Caminho A]
  - ❌ Senão → [Caminho B]

**Paralelismo**:
- [Se aplicável: descrever processos que executam em paralelo]

**Exceções**:
- [Evento de erro 1] → [Como tratar]
- [Evento de erro 2] → [Como tratar]

---

#### Processo: [Nome do Processo 2]
[Repetir estrutura acima para cada processo identificado]

---

### 2.3 Mapeamento Ator → Comando → Evento

| Ator | Comando | Evento Resultante | Observações |
|------|---------|-------------------|-------------|
| [Ator] | [Comando] | [Evento] | [Condições, regras] |
| ... | ... | ... | ... |

---

## 3. DDD Model (Domain-Driven Design)

> Seção gerada pela skill `domain-elicitation-bounded-contexts`

### 3.1 Bounded Contexts

#### Contexto: [Nome do Contexto]
**Nome Normalizado**: `[nome_normalizado]` (^[a-z]+$)
**Responsabilidade**: [Descrever área de responsabilidade deste contexto]
**Eventos Relacionados**: [Lista de eventos que pertencem a este contexto]

---

##### Aggregate: [Nome do Aggregate]

**Descrição**: [O que este Aggregate representa no domínio]

**Atributos**:
- `id` (UUID): Identificador único
- `[atributo1]` ([tipo]): [Descrição]
- `[atributo2]` ([tipo]): [Descrição]
- `status` (enum): [Valores possíveis]
- `createdAt` (timestamp): Data de criação
- `updatedAt` (timestamp): Última modificação

**Entidades Filhas** (que só existem dentro deste Aggregate):
- **[Nome da Entidade Filha]**
  - `id` (UUID): Identificador único
  - `[atributo]` ([tipo]): [Descrição]

**Relações com Outros Aggregates** (via ID):
- `[relatedAggregateId]` (UUID): Referência para [Nome do Aggregate]

**Invariantes de Negócio**:
1. [Invariante 1]: [Regra que nunca pode ser violada]
2. [Invariante 2]: [Regra que nunca pode ser violada]
   ...

**Comandos (Métodos do Aggregate)**:
| Comando | Evento Resultante | Validações |
|---------|-------------------|------------|
| `[comando1]` | [Evento] | [Quais invariantes são verificadas] |
| `[comando2]` | [Evento] | [Quais invariantes são verificadas] |

**Value Objects Utilizados**:
- [Nome do Value Object]: [Descrição]

---

##### Aggregate: [Nome do Aggregate 2]
[Repetir estrutura acima]

---

#### Contexto: [Nome do Contexto 2]
[Repetir estrutura acima para cada Bounded Context]

---

### 3.2 Value Objects

| Value Object | Atributos | Validações | Uso |
|--------------|-----------|------------|-----|
| [Nome] | [atributo1, atributo2] | [Regras de validação] | [Onde é usado] |
| ... | ... | ... | ... |

---

### 3.3 Linguagem Ubíqua (Glossário)

| Termo | Definição | Contexto | Evitar (Sinônimos) |
|-------|-----------|----------|-------------------|
| [Termo1] | [Definição clara e precisa] | [BC onde é usado] | [Termos que NÃO usar] |
| [Termo2] | [Definição] | [BC] | [Sinônimos] |
| ... | ... | ... | ... |

---

### 3.4 Mapeamento Comando → Aggregate

| Comando (BPMN) | Aggregate Responsável | Bounded Context | Evento Resultante |
|----------------|----------------------|-----------------|-------------------|
| [Comando] | [Aggregate] | [BC] | [Evento] |
| ... | ... | ... | ... |

---

## 4. Requisitos Técnicos

### 4.1 Volumetria e Performance

**Volumetria Esperada**:
- [Métrica 1]: [Quantidade] por [período]
  - Exemplo: 1.000 transações/dia
- [Métrica 2]: [Quantidade] por [período]

**Requisitos de Performance**:
- [Operação 1]: Tempo de resposta < [X] segundos
- [Operação 2]: Throughput > [Y] requisições/segundo

**Picos de Demanda**:
- [Descrição de quando ocorrem picos e magnitude]

---

### 4.2 Persistência

| Bounded Context | Tipo de Persistência | Banco | Observações |
|----------------|---------------------|-------|-------------|
| [BC] | Transacional | PostgreSQL | [Pool size, etc] |
| [BC] | Event Sourcing | Event Store | [Retenção, snapshots] |
| [BC] | CQRS | Read Model separado | [Tecnologia] |

**Configurações de Pool** (por dataschema):
- `dbsqlminimumconnidle`: [valor]
- `dbsqlmaximumpoolsize`: [valor]

---

### 4.3 Comunicação entre Contextos

| Origem (BC) | Destino (BC) | Evento | Padrão | Assíncrono? |
|-------------|-------------|--------|--------|-------------|
| [BC1] | [BC2] | [Evento] | Domain Event | ✅ Sim |
| [BC3] | [BC4] | [Comando] | API Call | ❌ Não (síncrono) |

---

### 4.4 Reutilização de Specs

**Templates do Grid Disponíveis**:
- [Nome do Template]: [Descrição] → **Reutilizar para**: [Onde aplicar]
- [Nome do Template 2]: [Descrição] → **Reutilizar para**: [Onde aplicar]

**Specs de Projetos Anteriores**:
- [Projeto X]: [Padrão reutilizável]
- [Projeto Y]: [Padrão reutilizável]

---

## 5. Validações e Restrições

### 5.1 Regras de Naming (Grid)

**Obrigatório** para `project`, `database`, `dataschema`:
- Padrão: `^[a-z]+$` (apenas minúsculas, sem acento/espaço/separador)

**Bounded Contexts Normalizados**:
| Nome Original | Nome Normalizado |
|---------------|-----------------|
| [Original] | `[normalizado]` |
| ... | `...` |

---

### 5.2 Checklist de Validação Cruzada (para QA de Specs)

- [ ] Todo Aggregate ID referenciado no BPMN existe no DDD
- [ ] Todo Command no BPMN tem método correspondente em um Aggregate
- [ ] Todas as invariantes do DDD são respeitadas nos gateways do BPMN
- [ ] Todos os eventos têm pelo menos um comando que os dispara
- [ ] Todos os comandos têm um ator responsável
- [ ] Naming convention aplicada em todos os BCs
- [ ] Relações entre Aggregates são por ID (não objeto completo)

---

## 6. Próximos Passos

### 6.1 Artefatos a Gerar

1. **`bpmn_spec.json`** (Arquiteto de Processos)
   - Input: Seções 2 (Event Storming) + 3.4 (Mapeamento Comando→Aggregate)
   - Validar: Conformidade com schema do grid de interpretação

2. **`ddd_spec.json`** (Arquiteto de Domínio)
   - Input: Seção 3 (DDD Model)
   - Validar: Aggregates, BCs, invariantes

3. **Sincronização de Naming** (Assistente de Projeto)
   - Gerar `naming-registry.yaml` com todos os IDs e nomes normalizados

---

### 6.2 Aprovações Necessárias

- [ ] Cliente aprovou Contexto de Negócio (seção 1)
- [ ] Cliente validou Event Storming (seção 2)
- [ ] Cliente confirmou Bounded Contexts e Aggregates (seção 3)
- [ ] Orquestrador/PM aprovou para prosseguir para arquitetos

---

## 7. Histórico de Revisões

| Versão | Data | Autor | Mudanças |
|--------|------|-------|----------|
| 1.0 | [YYYY-MM-DD] | [Nome] | Versão inicial |
| ... | ... | ... | ... |

---

## 8. Anexos

### 8.1 Diagramas (se aplicável)
- [Link ou embed de diagramas Event Storming]
- [Link ou embed de diagramas de Bounded Contexts]

### 8.2 Referências
- [Documentação do cliente]
- [Specs de projetos similares]
- [Guidelines do grid de interpretação]

---

**Fim do DOMAIN_BRIEF**
