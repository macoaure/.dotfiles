---
name: git-commit-planner
description: Analyze pending git changes and produce a commit plan where each commit message strictly follows the gitmoji and conventional commit pattern.
---

# Skill Design

## Complexity Level: **Level 1 — Instruction-only**

Mesmo com o padrão rígido de commit fornecido, a skill:
- Apenas **planeja commits** (não executa)
- Produz saída **humana, estruturada**, não consumida por máquina
- Usa regras definidas na skill `gitmoji-commits` como referência canônica

👉 Portanto, **não precisa de script** — apenas instruções claras + formatação consistente.

---

## Design Decisions

- **Instruction-only**: toda a lógica é interpretativa (diff + agrupamento + escrita)
- **Foco exclusivo em planejamento** (não inclui comandos git)
- **Output já no formato final de commit message**
- **Segue estritamente o padrão da skill `gitmoji-commits` (gitmoji + conventional commits + corpo por arquivo)**
- **Sem overengineering**: nada de schema complexo, validação automática ou parsing

---

# Purpose

Gerar um plano de commits a partir das mudanças atuais, onde cada commit já vem escrito no formato final correto (gitmoji + conventional commits + corpo por arquivo).

A skill NÃO executa commits — apenas planeja.

> **Dependência**: esta skill usa a skill `gitmoji-commits` como referência canônica de padrão. Ao iniciar, carregue o conteúdo de `gitmoji-commits/SKILL.md` como contexto para garantir consistência total na escolha de emoji, tipo, escopo e formato.

---

# When to use

Use quando:
- Há muitas mudanças misturadas
- Você quer commits limpos e padronizados
- Vai abrir PR e precisa de histórico claro
- Quer seguir rigorosamente o padrão de commit do projeto

---

# Steps

## 1. Inspecionar mudanças

Analisar:
- `git status`
- `git diff`
- `git diff --staged`

Mapear:
- arquivos modificados
- tipo de mudança em cada arquivo

---

## 2. Agrupamento (primeira passada)

Agrupar por tipo (seguindo padrão gitmoji-commits):
- feat
- fix
- hotfix
- refactor
- perf
- test
- build
- ci
- docs
- chore
- etc.

---

## 3. Reagrupamento (segunda passada)

Refinar:
- separar mudanças independentes no mesmo arquivo
- isolar mudanças de risco
- separar formatação de lógica
- garantir **um propósito por commit**

---

## 4. Mapeamento contextual

Para cada grupo:
- listar arquivos
- descrever mudança por arquivo
- entender intenção real

---

## 5. Gerar plano de commits (FORMATO OBRIGATÓRIO)

Cada commit deve ser escrito EXATAMENTE assim:

```
<gitmoji> <tipo>(<escopo>): <descrição curta>

- <arquivo>: <descrição>
- <arquivo>: <descrição>
```

Regras obrigatórias:

- usar gitmoji correto (ref: gitmoji-commits skill)
- usar tipo válido (feat, fix, refactor, etc.)
- descrição em português no imperativo
- até 72 caracteres
- escopo baseado no domínio (ou arquivo se necessário)

---

## 6. Regras especiais

### Arquivos lock

NUNCA listar individualmente. Usar:

```
- package manager atualizado
```

---

## 7. Ordenação dos commits

Ordenar para legibilidade:

1. refactor
2. fix
3. feat
4. outros (docs, chore, build, test…)

---

# Output Format

## Commit Plan

### Commit 1
```
<mensagem completa>
```

### Commit 2
```
<mensagem completa>
```

---

# Examples

## Input

- rename function
- fix bug
- add feature
- update lock file

## Output

### Commit 1
```
♻️ refactor(utils): renomeia função de formatação

- src/utils/format.ts: renomeia função formatPhone para formatE164
```

### Commit 2
```
🐛 fix(api): corrige validação de payload

- src/api/handler.ts: ajusta validação de campos obrigatórios
```

### Commit 3
```
✨ feat(campaigns): adiciona criação de campanha recorrente

- src/campaigns/service.ts: implementa lógica de recorrência
- src/campaigns/controller.ts: expõe endpoint de criação
```

### Commit 4
```
📦️ build(deps): atualiza dependências do projeto

- package manager atualizado
```

---

# Notes

- A saída já deve estar pronta para copy-paste no git
- Nunca misturar múltiplas intenções no mesmo commit
- Quando em dúvida, dividir commits
- Clareza > quantidade mínima de commits
- Sempre validar contra o padrão gitmoji-commits para consistência
