---
name: gitmoji-commits
description: guia de boas práticas para mensagens de commit usando gitmoji e conventional commits
---


# skill: commit-message-pattern

## objetivo

orientar a geração de mensagens de commit claras, padronizadas e rastreáveis, utilizando gitmoji como prefixo visual e conventional commits como estrutura textual.

---

## formato obrigatório

```
<gitmoji> <tipo>(<escopo>): <descrição curta>

[corpo opcional]

[rodapé opcional]
```

### regras gerais

- a linha de assunto (subject) deve ter no máximo **72 caracteres**
- usar **tempo verbal imperativo** na descrição: "adiciona", "remove", "corrige" (português)
- o escopo é opcional mas recomendado: nome do módulo, feature ou arquivo afetado
- o corpo é obrigatório quando a mudança não é autoexplicativa
- breaking changes devem ser marcadas no rodapé com `BREAKING CHANGE:`

### regras de corpo — arquivos modificados

- todo commit que inclua arquivos anexados deve listar cada arquivo modificado com uma linha no corpo da mensagem, no formato:
  ```
  - <caminho/do/arquivo>: <descrição da mudança>
  ```
- arquivos do tipo **lock** (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `composer.lock`, `Cargo.lock`, `poetry.lock`, etc.) **nunca** devem ser listados individualmente — representá-los com a linha:
  ```
  - package manager atualizado
  ```

---

## tipos aceitos

| tipo       | quando usar                                                    |
|------------|----------------------------------------------------------------|
| `feat`     | nova funcionalidade                                            |
| `fix`      | correção de bug                                                |
| `hotfix`   | correção crítica em produção                                   |
| `refactor` | refatoração sem mudança de comportamento                       |
| `perf`     | melhoria de performance                                        |
| `test`     | adição ou atualização de testes                                |
| `build`    | mudanças em scripts de build, dependências ou ferramentas      |
| `ci`       | mudanças no pipeline de CI/CD                                  |
| `docs`     | documentação                                                   |
| `chore`    | tarefas de manutenção sem impacto em código de produção        |
| `revert`   | reversão de commit anterior                                    |
| `wip`      | trabalho em progresso (nunca deve ir para main/master diretamente) |

---

## gitmoji por tipo

### funcionalidades e correções

| emoji | código           | uso                                              |
|-------|------------------|--------------------------------------------------|
| ✨    | `:sparkles:`     | `feat` — nova feature                            |
| 🐛    | `:bug:`          | `fix` — correção de bug                          |
| 🚑️   | `:ambulance:`    | `hotfix` — correção crítica                      |
| 💥    | `:boom:`         | breaking change                                  |
| 🩹    | `:adhesive_bandage:` | fix simples para problema não crítico        |
| 🥅    | `:goal_net:`     | captura de erros                                 |

### qualidade e testes

| emoji | código              | uso                                           |
|-------|---------------------|-----------------------------------------------|
| ✅    | `:white_check_mark:` | `test` — adicionar ou atualizar testes       |
| 🧪    | `:test_tube:`       | `test` — adicionar teste que falha (TDD)      |
| 🏷️   | `:label:`           | adicionar ou atualizar types/tipagens         |
| 🦺    | `:safety_vest:`     | adicionar ou atualizar validações             |

### refatoração e estrutura

| emoji | código       | uso                                                   |
|-------|--------------|-------------------------------------------------------|
| ♻️    | `:recycle:`  | `refactor` — refatoração de código                    |
| 🎨    | `:art:`      | `refactor` — melhorar estrutura/formato do código     |
| ⚡️   | `:zap:`      | `perf` — melhoria de performance                      |
| 🔥    | `:fire:`     | remoção de código ou arquivos                         |
| ⚰️    | `:coffin:`   | remoção de código morto                               |
| 💩    | `:poop:`     | código ruim que precisa ser melhorado depois          |
| 👔    | `:necktie:`  | adicionar ou atualizar lógica de negócio              |

### infraestrutura e build

| emoji | código                       | uso                                          |
|-------|------------------------------|----------------------------------------------|
| 🧱    | `:bricks:`                   | mudanças de infraestrutura                   |
| 🏗️   | `:building_construction:`    | mudanças de arquitetura                      |
| 🔧    | `:wrench:`                   | adicionar/atualizar arquivos de configuração |
| 🔨    | `:hammer:`                   | adicionar/atualizar scripts de dev           |
| 👷    | `:construction_worker:`      | `ci` — adicionar/atualizar CI build system   |
| 💚    | `:green_heart:`              | `ci` — corrigir CI build                     |
| 📦️   | `:package:`                  | `build` — compilados ou pacotes              |
| ➕    | `:heavy_plus_sign:`          | `build` — adicionar dependência              |
| ➖    | `:heavy_minus_sign:`         | `build` — remover dependência                |
| ⬆️    | `:arrow_up:`                 | `build` — upgrade de dependências            |
| ⬇️    | `:arrow_down:`               | `build` — downgrade de dependências          |
| 📌    | `:pushpin:`                  | `build` — fixar versão de dependência        |

### documentação e assets

| emoji | código          | uso                                               |
|-------|-----------------|---------------------------------------------------|
| 📝    | `:memo:`        | `docs` — adicionar/atualizar documentação         |
| 💡    | `:bulb:`        | `docs` — adicionar/atualizar comentários no código|
| 📄    | `:page_facing_up:` | adicionar/atualizar licença                    |
| 🍱    | `:bento:`       | adicionar/atualizar assets                        |
| 📸    | `:camera_flash:` | adicionar/atualizar snapshots                    |

### manutenção e operação

| emoji | código                         | uso                                         |
|-------|--------------------------------|---------------------------------------------|
| 🚀    | `:rocket:`                     | deploy                                      |
| 🔖    | `:bookmark:`                   | release / version tag                       |
| ⏪️   | `:rewind:`                     | `revert` — reverter mudanças                |
| 🔀    | `:twisted_rightwards_arrows:`  | merge de branches                           |
| 🚧    | `:construction:`               | `wip` — work in progress                    |
| 🗑️   | `:wastebasket:`                | deprecar código                             |
| 🌱    | `:seedling:`                   | adicionar/atualizar seed files              |
| 🗃️   | `:card_file_box:`              | mudanças relacionadas a banco de dados      |
| 🔊    | `:loud_sound:`                 | adicionar/atualizar logs                    |
| 🔇    | `:mute:`                       | remover logs                                |
| 🩺    | `:stethoscope:`                | adicionar/atualizar healthcheck             |

### segurança e acesso

| emoji | código               | uso                                              |
|-------|----------------------|--------------------------------------------------|
| 🔒️   | `:lock:`             | corrigir issues de segurança/privacidade         |
| 🔐    | `:closed_lock_with_key:` | adicionar/atualizar secrets              |
| 🛂    | `:passport_control:` | autorização, roles e permissões                  |

### DX e outros

| emoji | código           | uso                                                  |
|-------|------------------|------------------------------------------------------|
| 🎉    | `:tada:`         | início de projeto                                    |
| 🙈    | `:see_no_evil:`  | adicionar/atualizar `.gitignore`                     |
| ✏️    | `:pencil2:`      | corrigir typos                                       |
| 🚨    | `:rotating_light:` | corrigir warnings de linter/compiler              |
| 🧑‍💻  | `:technologist:` | melhorar developer experience                        |
| 🚚    | `:truck:`        | mover/renomear recursos (arquivos, paths, rotas)     |
| 👽️   | `:alien:`        | atualizar código por mudança em API externa          |
| 🌐    | `:globe_with_meridians:` | internacionalização e localização          |
| 🚩    | `:triangular_flag_on_post:` | feature flags                           |
| 🧵    | `:thread:`       | código relacionado a concorrência/multithreading     |

---

## exemplos

```
✨ feat(campaigns): adiciona suporte a agendamento recorrente
```

```
🐛 fix(webhook): corrige deduplicação de eventos duplicados da zenvia
```

```
♻️ refactor(contacts): extrai lógica de normalização para domínio
```

```
✅ test(blacklist): adiciona casos de borda para opt-out por tenant
```

```
🧱 ci(deploy): atualiza pipeline para usar artifact cache do gitlab

Reduz tempo médio de build em ~40% ao cachear node_modules entre stages.
```

```
💥 feat(api): remove suporte ao campo legado `phoneRaw`

BREAKING CHANGE: o campo `phoneRaw` foi removido do payload de contatos.
Usar `phone` no formato E.164.
```

---

## regras de escopo recomendadas neste projeto

usar o nome do módulo de domínio como escopo sempre que possível:

- `campaigns` — criação, agendamento, envio e cancelamento
- `contacts` — ingestão, normalização, catálogo
- `audiences` — geração de audiência por filtros
- `templates` — sincronização e validação de templates
- `webhooks` — recebimento e processamento de webhooks
- `blacklist` — blacklist e opt-out
- `zenvia` — integração com a zenvia
- `infra` — mudanças na infraestrutura terraform
- `web-client` — mudanças no frontend vue.js
- `ci` — mudanças no pipeline
- `deps` — atualização de dependências

---

## o que nunca fazer

- não usar mensagens genéricas: `fix`, `update`, `changes`, `wip` como descrição completa
- não commitar código comentado sem justificativa no corpo
- não concentrar múltiplas mudanças não relacionadas em um único commit
- não usar `wip` em branches protegidas (main, develop)
- não omitir `BREAKING CHANGE:` no rodapé quando aplicável
