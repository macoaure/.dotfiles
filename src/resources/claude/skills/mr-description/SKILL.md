---
name: mr-description
description: Gera descrição completa de Merge Request comparando duas branches — inclui contexto, motivação, diagramas ASCII e exemplos. Pergunta as branches antes de iniciar.
---

# Skill Design

## Complexity Level: **Level 1 — Instruction-only**

A skill:
- Faz perguntas antes de começar
- Analisa diff entre duas branches
- Gera markdown rico, pronto para colar no MR/PR
- Não cria commits, não faz merges

---

# Purpose

Produzir uma descrição de Merge Request que vá além de "o que mudou" — explicando **por que** a mudança existe, **como** funciona, com diagramas ASCII e exemplos concretos.

---

# When to use

Use quando:
- Vai abrir um MR/PR e precisa de uma descrição clara
- A mudança envolve múltiplos arquivos ou contexto não óbvio
- Quer documentar arquitetura, fluxo ou comportamento no próprio MR
- Precisa comunicar para o time o impacto do que está sendo proposto

---

# Steps

## 1. Perguntar as branches

Antes de qualquer análise, perguntar obrigatoriamente:

```
Qual é a branch de origem (source)? (a branch com as mudanças)
Qual é a branch de destino (target)? (ex: main, develop)
```

Aguardar resposta antes de continuar.

---

## 2. Inspecionar as mudanças

Com `<source>` e `<target>` definidos, executar:

```bash
git log <target>..<source> --oneline
git diff <target>...<source> --stat
git diff <target>...<source>
```

Mapear:
- Quais arquivos foram modificados e como
- Quantos commits existem na branch
- Quais domínios/módulos foram tocados
- Se há breaking changes (remoção de exports, mudança de assinatura, alteração de schema)
- Se há arquivos de config, migration, test, doc

---

## 3. Inferir contexto

A partir do diff, inferir:

- **Motivação**: por que essa mudança foi feita? (bug, feature, refactor, perf, débito técnico)
- **Escopo**: qual parte do sistema é afetada?
- **Impacto**: essa mudança afeta outros times, APIs públicas, banco, CI?
- **Complexidade**: é uma mudança cirúrgica ou estrutural?

---

## 4. Gerar a descrição (FORMATO OBRIGATÓRIO)

Produzir o markdown abaixo, preenchendo cada seção:

---

```markdown
## Contexto

<!-- Por que esse MR existe? Qual problema resolve ou qual melhoria traz?
     Escrever como se explicando para alguém que não acompanhou o desenvolvimento. -->

## O que foi feito

<!-- Lista das mudanças principais em alto nível — não um dump do diff.
     Agrupar por intenção, não por arquivo. -->

-
-

## Como funciona

<!-- Explicar o comportamento novo ou alterado. Usar diagramas ASCII quando o fluxo
     ou arquitetura ajuda a entender. Incluir exemplos de entrada/saída quando relevante. -->

## Diagrama (se aplicável)

<!-- Usar ASCII art para representar: fluxo de dados, sequência de chamadas,
     arquitetura antes/depois, state machine, etc. -->

## Exemplos

<!-- Mostrar exemplos concretos do comportamento — chamadas de API, payloads,
     outputs esperados, comparações antes/depois. -->

## Breaking changes

<!-- Listar explicitamente qualquer mudança que quebre compatibilidade.
     Se não houver, escrever: Nenhum. -->

## Notas para revisão

<!-- Pontos de atenção para o revisor: decisões de design não óbvias,
     trade-offs feitos, o que foi intencionalmente deixado de fora. -->

## Checklist

- [ ] Testes adicionados/atualizados
- [ ] Documentação atualizada
- [ ] Breaking changes comunicadas
- [ ] Funciona em ambiente de staging
```

---

## 5. Regras para diagramas ASCII

Usar diagramas quando a mudança envolve:
- Fluxo entre serviços ou módulos
- Sequência de operações
- Arquitetura antes/depois
- Relações entre entidades

### Fluxo / Sequência

```
Cliente          API            Serviço         Banco
   │                │                │              │
   │── POST /x ────▶│                │              │
   │                │── valida() ───▶│              │
   │                │                │── query() ──▶│
   │                │                │◀─ resultado ─│
   │                │◀── resposta ───│              │
   │◀── 200 OK ─────│                │              │
```

### Antes / Depois

```
ANTES                          DEPOIS
─────────────────────          ─────────────────────
Controller                     Controller
    │                              │
    └──▶ Service                   └──▶ Service
             │                             │
             └──▶ Repository              ├──▶ Repository
                                           └──▶ Cache
```

### State machine

```
[idle] ──trigger──▶ [processing] ──success──▶ [done]
                          │
                       failure
                          │
                          ▼
                       [error] ──retry──▶ [processing]
```

---

## 6. Regras de escrita

- **Contexto**: escrever em prosa, sem bullet points — é a seção mais importante
- **O que foi feito**: máximo 7 itens; agrupar por intenção
- **Exemplos**: usar blocos de código com linguagem definida (` ```json `, ` ```bash `, etc.)
- **Tom**: direto, técnico, sem floreios
- **Idioma**: mesmo idioma do repositório (detectar pelo histórico de commits)
- **Comprimento**: suficiente para um revisor entender sem precisar ler o diff completo

---

## 7. Seções opcionais

Omitir seções que não se aplicam:
- Se não há breaking changes → manter a seção com "Nenhum"
- Se não há diagrama óbvio → omitir a seção de diagrama
- Se a mudança é trivial → "Exemplos" pode ser omitido
- "Notas para revisão" só incluir se houver algo relevante

---

# Output Format

Entregar:

1. Um resumo de 2-3 linhas do que foi encontrado no diff
2. O markdown completo da descrição, pronto para copy-paste

---

# Examples

## Input

- source: `feat/recurring-campaigns`
- target: `develop`

## Output

> Encontrei 8 commits, 12 arquivos modificados. A mudança adiciona suporte a campanhas recorrentes no módulo de campaigns, com nova entidade de recorrência e endpoint de criação. Sem breaking changes identificadas.

```markdown
## Contexto

O produto precisava suportar campanhas que disparam automaticamente em intervalos
configurados (diário, semanal, mensal), eliminando a necessidade de o usuário
recriar a campanha manualmente a cada ciclo. Esta mudança implementa a fundação
dessa funcionalidade no backend.

## O que foi feito

- Adicionada entidade `CampaignRecurrence` com campos de intervalo e data de próximo disparo
- Novo endpoint `POST /campaigns/:id/recurrence` para configurar recorrência
- Job agendado que verifica campanhas com recorrência pendente a cada hora
- Testes de integração cobrindo os ciclos diário e semanal

## Como funciona

Ao criar uma recorrência, o sistema calcula a `next_run_at` com base no intervalo
configurado. Um worker verifica a cada hora quais campanhas têm `next_run_at <= now`
e dispara uma cópia da campanha original, atualizando o `next_run_at` para o
próximo ciclo.

## Diagrama

```
POST /campaigns/:id/recurrence
          │
          ▼
   CampaignService
          │
          ├──▶ cria CampaignRecurrence
          │         (interval, next_run_at)
          │
          └──▶ retorna 201


[RecurrenceWorker — a cada hora]
          │
          ▼
  busca campanhas onde
  next_run_at <= now
          │
          ▼
  para cada uma:
  ├── clona campanha original
  ├── dispara envio
  └── atualiza next_run_at
```

## Exemplos

Criar recorrência semanal:

```json
POST /campaigns/42/recurrence
{
  "interval": "weekly",
  "start_at": "2025-04-01T09:00:00Z"
}
```

Resposta:

```json
{
  "id": "rec_01J...",
  "campaign_id": 42,
  "interval": "weekly",
  "next_run_at": "2025-04-01T09:00:00Z"
}
```

## Breaking changes

Nenhum.

## Notas para revisão

O cálculo de `next_run_at` usa UTC internamente. A conversão para o timezone
do tenant acontece apenas na camada de apresentação — confirmar se isso é
consistente com o restante do sistema.
```
