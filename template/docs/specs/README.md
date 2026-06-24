# Specs

Este diretório contém specs derivadas de PRDs.

## OpenSpec é o mecanismo padrão

Este projeto usa **OpenSpec** (`openspec/`, `schema: spec-driven`). A spec derivada de um
PRD é, por padrão, uma **OpenSpec change/spec** em `openspec/` — crie-a via a skill
`openspec-propose` ou `/opsx propose`, sempre referenciando o PRD de origem.

```text
PRD (docs/prd/)  ->  OpenSpec change/spec (openspec/)  ->  SDD/plano (docs/sdd/)  ->  TDD
```

`docs/specs/` é fallback para specs sem OpenSpec ou notas de design — e, mesmo assim,
deve referenciar o PRD de origem.

## Regra obrigatória

Antes de criar uma spec (OpenSpec ou arquivo aqui), leia o PRD correspondente em `docs/prd`.

Toda spec deve conter referência explícita ao PRD de origem.

Frontmatter obrigatório:

```md
---
title: <nome da spec>
status: draft
source_prd: docs/prd/<nome-da-iniciativa>.md
source_prd_id: PRD-<nome-em-kebab-case>
created_at: <data atual ou [A confirmar]>
updated_at: <data atual ou [A confirmar]>
---
```

Specs não devem redefinir o problema de negócio.

Specs devem derivar escopo, regras, critérios de aceite e restrições a partir do PRD.
