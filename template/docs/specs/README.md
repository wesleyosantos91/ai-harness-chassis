# Specs

Este diretório contém specs derivadas de PRDs.

## Regra obrigatória

Antes de criar uma spec, leia o PRD correspondente em `docs/prd`.

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
