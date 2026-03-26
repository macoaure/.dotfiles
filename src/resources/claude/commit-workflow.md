# Commit Workflow

## Regra obrigatória: use git-commit-planner antes de qualquer commit

Sempre que for realizar um ou mais commits git, você DEVE:

1. Invocar a skill `git-commit-planner` usando a ferramenta Skill ANTES de executar qualquer `git commit`
2. A skill `git-commit-planner` carrega automaticamente `gitmoji-commits` como referência
3. Apresentar o plano de commits ao usuário
4. Aguardar aprovação (explícita ou implícita) antes de executar

**Isso se aplica a:** commits simples, múltiplos commits, commits em sequência, ou qualquer chamada a `git commit`.

**Não se aplica a:** `git add`, `git push`, `git pull`, `git status`, `git log`, `git diff` e outros comandos que não criam commits.
