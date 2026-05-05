# ANEXO A — Process Details
# Ycodify CRM - Service
# Versao: 1.0 (passagem 1 — fechado)
# Ultima atualizacao: 2026-04-30

---

## Indice de Processos

| # | Processo | Bounded Context | Status |
|---|----------|-----------------|--------|
| P-01 | Captura e Qualificacao de Lead | comercial | APROVADO |
| P-02 | Pipeline de Vendas / Oportunidade | comercial | APROVADO |
| P-03 | Historico de Vendas | comercial | APROVADO |
| P-04 | Tickets Pos-Venda | posvenda | FASE 2 — fora do MVP |
| P-05 | Solicitacao de Substituicao de Vendedor | comercial | APROVADO |

---

## P-01 — Captura e Qualificacao de Lead

### Visao Geral

| Campo | Valor |
|-------|-------|
| **Bounded Context** | comercial |
| **Atores** | Vendedor, Gerente Comercial, Sistema (origem web) |
| **Trigger** | Formulario web submetido OU Vendedor/Gerente inicia entrada manual |
| **Pre-condicao** | — |
| **Pos-condicao** | Lead em estado Convertido (gera Conta + Oportunidade) ou Descartado |

---

### Estados do Lead

```
Novo --> EmContato --> Qualificado --> Convertido
                    --> Descartado
         EmContato --> Descartado
```

| Estado | Descricao |
|--------|-----------|
| **Novo** | Lead recem-criado. Ainda sem interacao registrada. |
| **EmContato** | Vendedor iniciou contato (ex: ligacao, e-mail). |
| **Qualificado** | Lead confirmado como potencial cliente. Pronto para conversao. |
| **Convertido** | Lead convertido em Conta + Oportunidade. Permanece como historico. |
| **Descartado** | Lead descartado. Permanece como historico. |

> Leads Convertidos e Descartados NAO sao excluidos. Permanecem como registro historico com estado final.

---

### Fluxo Principal

```
[INICIO]
    |
    +-- (Origem: Formulario Web) --> [Sistema cria Lead com estado = Novo]
    |                                    Autoria: Sistema (origem web)
    |
    +-- (Origem: Manual)         --> [Vendedor OU Gerente Comercial cria Lead manualmente]
                                         Autoria: usuario logado (Vendedor | Gerente Comercial)
                                         Estado inicial: Novo
    |
    v
[Lead: Novo]
    |
    +--> Vendedor registra primeiro contato --> [Lead: EmContato]
    |
    v
[Lead: EmContato]
    |
    +--> Vendedor qualifica o Lead --> [Lead: Qualificado]
    |
    +--> Vendedor descarta o Lead  --> [Lead: Descartado] --> [FIM — historico preservado]
    |
    v
[Lead: Qualificado]
    |
    +--> Vendedor OU Gerente Comercial converte o Lead
         |
         v
    [Sistema cria Conta + Oportunidade automaticamente]
         |
         v
    [Lead: Convertido] --> [FIM — historico preservado]
```

---

### Regras de Negocio

| ID | Regra | Ator Impactado |
|----|-------|---------------|
| RN-L01 | Lead sem nenhuma interacao registrada ha **5 dias corridos** dispara notificacao automatica. | Gerente Comercial + Vendedor responsavel pelo Lead |
| RN-L02 | Lead Convertido e Descartado sao preservados como historico (nao excluidos). | — |
| RN-L03 | Quando origem e formulario web, o campo "responsavel" pode ser atribuido manualmente pelo Gerente Comercial. [A DEFINIR — PA-L01] | Gerente Comercial |
| RN-L04 | A transicao Qualificado → Convertido dispara criacao automatica de Conta e Oportunidade. | Sistema |

---

### Perguntas Abertas (pendentes para ciclo futuro)

| ID | Pergunta | Prioridade |
|----|----------|------------|
| PA-L01 | Quando um Lead chega via formulario web, e automaticamente atribuido a algum Vendedor ou fica em fila para o Gerente distribuir? | Alta |
| PA-L02 | O timeout de 5 dias conta a partir da criacao do Lead ou da ultima interacao registrada? | Alta |
| PA-L03 | O Lead descartado pode ser "reaberto"? Se sim, retorna a qual estado? | Media |

---

## P-02 — Pipeline de Vendas / Oportunidade

### Visao Geral

| Campo | Valor |
|-------|-------|
| **Bounded Context** | comercial |
| **Atores** | Vendedor, Gerente Comercial, Sistema |
| **Trigger** | Criacao automatica por conversao de Lead OU Gerente Comercial cria diretamente |
| **Pre-condicao** | Conta existente |
| **Pos-condicao** | Oportunidade em estado Ganha (evento OportunidadeGanha disparado) ou Perdida |

---

### Estados da Oportunidade

```
PropostaEnviada --> Negociacao --> Fechamento --> Ganha
                                               --> Perdida
```

| Estado | Descricao |
|--------|-----------|
| **PropostaEnviada** | Proposta comercial enviada à Conta (para o Contato principal). |
| **Negociacao** | Negociacao em andamento (valores, escopo, prazo). |
| **Fechamento** | Acordo proximo. Ultima fase antes de resultado final. |
| **Ganha** | Oportunidade fechada com sucesso. Dispara evento OportunidadeGanha. |
| **Perdida** | Negociacao encerrada sem fechamento. Campo motivo_perda obrigatorio (texto livre). |

---

### Fluxo Principal

```
[INICIO]
    |
    +-- (Via conversao de Lead) --> [Sistema cria Oportunidade]
    |                                   responsavel = Vendedor do Lead
    |                                   valor_estimado = obrigatorio (R$)
    |
    +-- (Criacao direta)        --> [Gerente Comercial cria Oportunidade para Conta existente]
    |                                   valor_estimado = obrigatorio (R$)
    |
    v
[Oportunidade: PropostaEnviada]
    |
    +--> Vendedor/Gerente avanca  --> [Oportunidade: Negociacao]
    |
    v
[Oportunidade: Negociacao]
    |
    +--> Vendedor/Gerente avanca  --> [Oportunidade: Fechamento]
    |
    v
[Oportunidade: Fechamento]
    |
    +--> GANHA --> [Sistema dispara evento: OportunidadeGanha]
    |                   |
    |                   +--> [Sistema envia e-mail para Engenharia (INT-01 MVP)]
    |                   +--> [Sistema notifica sistema da Engenharia] (INT-01 Pos-MVP)
    |                   v
    |              [FIM — Oportunidade encerrada como Ganha, preservada como historico]
    |
    +--> PERDIDA --> [motivo_perda: texto livre — OBRIGATORIO]
                     [Oportunidade: Perdida]
                     [FIM — Oportunidade encerrada como Perdida, preservada como historico]
```

---

### Regras de Negocio

| ID | Regra | Ator Impactado |
|----|-------|---------------|
| RN-O01 | O responsavel pela Oportunidade e o mesmo Vendedor do Lead de origem; quando criada diretamente, Gerente Comercial designa o responsavel. | Vendedor, Gerente Comercial |
| RN-O02 | Gerente Comercial pode redistribuir (alterar responsavel) de qualquer Oportunidade a qualquer momento. | Gerente Comercial |
| RN-O03 | A transicao para estado Ganha dispara automaticamente: (a) envio de e-mail a Engenharia, (b) notificacao ao sistema da Engenharia (integracao futura). | Sistema |
| RN-O04 | Oportunidades ganhas e perdidas sao preservadas como historico (nao excluidas). | — |
| RN-O05 | Campo `valor_estimado` (R$) e obrigatorio ao criar ou editar a Oportunidade. | Vendedor, Gerente Comercial |
| RN-O06 | A transicao para estado Perdida exige preenchimento obrigatorio do campo `motivo_perda` (texto livre). | Vendedor, Gerente Comercial |

---

### Perguntas Abertas (pendentes para ciclo futuro)

| ID | Pergunta | Prioridade |
|----|----------|------------|
| PA-O01 | Existe prazo/deadline na Oportunidade? | Baixa |
| PA-O02 | Regras detalhadas de redistribuicao de Oportunidade pelo Gerente (restricoes de momento, notificacao ao vendedor anterior, etc.)? | Media |

---

## P-03 — Historico de Vendas

### Visao Geral

| Campo | Valor |
|-------|-------|
| **Bounded Context** | comercial |
| **Atores** | Vendedor, Gerente Comercial, Gestor |
| **Trigger** | Consulta/visualizacao por usuario autenticado com permissao |
| **Pre-condicao** | Existem Oportunidades no estado Ganha |
| **Pos-condicao** | — (processo de consulta, sem alteracao de estado) |

---

### Descricao

O Historico de Vendas nao e um processo com maquina de estados propria. E uma **projecao (projection/read model)** derivada das Oportunidades Ganhas. Nao ha entidade independente — os dados sao derivados do aggregate Oportunidade filtrando `estagio = Ganha`.

O processo cobre dois modos de acesso:

1. **Registros individuais**: listagem de cada Oportunidade Ganha com dados completos (conta, valor, data de fechamento, vendedor responsavel).
2. **Metricas agregadas**: totais por periodo, por vendedor, por conta.

---

### Fluxo de Consulta

```
[Usuario acessa Historico de Vendas]
    |
    v
[Sistema aplica filtro de visibilidade por perfil]
    |
    +-- Vendedor        --> [ve apenas suas Oportunidades Ganhas]
    +-- Gerente Comercial --> [ve Oportunidades Ganhas do seu time]
    +-- Gestor          --> [ve todas as Oportunidades Ganhas]
    |
    v
[Sistema exibe:]
    |
    +-- Lista de Oportunidades Ganhas (registros individuais)
    |       campos: conta, valor, data de fechamento, vendedor
    |
    +-- Metricas agregadas
            campos: total por periodo, total por vendedor, total por conta
```

---

### Regras de Negocio

| ID | Regra | Ator Impactado |
|----|-------|---------------|
| RN-HV01 | Visibilidade segue a mesma matriz de perfis: Vendedor ve os seus; Gerente Comercial ve o time; Gestor ve tudo. | Todos |
| RN-HV02 | Historico de Vendas e somente leitura — nenhuma alteracao e permitida por este processo. | — |
| RN-HV03 | Dados derivados de Oportunidades Ganhas (estagio = Ganha). Nao ha entidade separada. | — |

---

## P-04 — Tickets Pos-Venda (Fase 2 — fora do MVP)

> Detalhamento adiado para ciclo pos-MVP. Bounded Context: posvenda.
> Persona envolvida: Atendimento (jornada Fase 2).

---

## P-05 — Solicitacao de Substituicao de Vendedor

### Visao Geral

| Campo | Valor |
|-------|-------|
| **Bounded Context** | comercial |
| **Atores** | Vendedor (solicitante), Gerente Comercial (decisor) |
| **Trigger** | Vendedor seleciona Lead ou Oportunidade da qual deseja ser substituido |
| **Pre-condicao** | Lead ou Oportunidade com VendedorResponsavel definido |
| **Pos-condicao** | SolicitacaoSubstituicao em estado Aprovada (Lead + Oportunidade reatribuidos) ou Recusada (responsavel inalterado) |
| **FRs relacionados** | FR-015, FR-016 |
| **Distinção com P-02/FR-014** | FR-014 e redistribuicao por iniciativa do Gerente. P-05/FR-015 e solicitacao por iniciativa do proprio Vendedor. Fluxos distintos que coexistem. |

---

### Estados da SolicitacaoSubstituicao

```
Pendente --> Aprovada
         --> Recusada
```

| Estado | Descricao |
|--------|-----------|
| **Pendente** | Solicitacao submetida. Aguardando decisao do Gerente Comercial. Lead/Oportunidade permanecem com Vendedor atual. |
| **Aprovada** | Gerente aprovou. Lead + Oportunidade vinculada reatribuidos ao VendedorSubstituto. |
| **Recusada** | Gerente recusou. VendedorResponsavel permanece inalterado. |

---

### Fluxo Principal

```
[INICIO]
    |
    v
1. Vendedor seleciona Lead ou Oportunidade da qual deseja ser substituido

2. Vendedor preenche motivo (texto livre, obrigatorio) e confirma solicitacao
    |
    v
3. [Sistema dispara evento: SubstituicaoSolicitada]
    |
4. [Sistema notifica Gerente Comercial com:]
    - Dados do Lead/Oportunidade
    - VendedorResponsavel atual
    - Motivo informado
    |
    v
5. Gerente Comercial avalia solicitacao e escolhe VendedorSubstituto
    |
    +-- [APROVACAO] ------------------------------------------------------+
    |   Gerente aprova                                                    |
    |   --> Sistema reatribui Lead ao VendedorSubstituto                  |
    |   --> Sistema reatribui Oportunidade vinculada ao VendedorSubstituto|
    |   --> [Sistema dispara evento: SubstituicaoAprovada]                |
    |   --> Sistema notifica Vendedor solicitante e VendedorSubstituto     |
    |   --> [FIM — SolicitacaoSubstituicao: Aprovada]                     |
    |                                                                     |
    +-- [RECUSA] --------------------------------------------------------+
        Gerente recusa
        --> VendedorResponsavel permanece inalterado
        --> [Sistema dispara evento: SubstituicaoRecusada]
        --> Sistema notifica Vendedor solicitante (com justificativa — opcional)
        --> [FIM — SolicitacaoSubstituicao: Recusada]
```

---

### Regras de Negocio

| ID | Regra | Ator Impactado |
|----|-------|---------------|
| RN-P05-01 | Motivo e obrigatorio para submeter solicitacao — campo nao pode ser nulo ou vazio. | Vendedor |
| RN-P05-02 | Apenas o proprio Vendedor pode iniciar solicitacao de sua substituicao. Nao e possivel solicitar substituicao de outro Vendedor. | Vendedor |
| RN-P05-03 | Transferencia afeta ambos: Lead (se ainda nao convertido) E Oportunidade vinculada (se existente). | Sistema |
| RN-P05-04 | Enquanto SolicitacaoSubstituicao esta em estado Pendente, Lead e Oportunidade permanecem com o Vendedor atual. | Sistema |

---

### Perguntas Abertas (pendentes para ciclo futuro)

| ID | Pergunta | Prioridade |
|----|----------|------------|
| PA-P05-01 | Um Vendedor pode ter mais de uma SolicitacaoSubstituicao Pendente simultaneamente (para Leads/Oportunidades diferentes)? | Media |
| PA-P05-02 | Ha prazo para o Gerente decidir sobre a solicitacao? Se sim, qual e o comportamento apos o prazo? | Media |
| PA-P05-03 | A justificativa do Gerente ao recusar e obrigatoria ou opcional? (Especificacao atual: opcional) | Baixa |
