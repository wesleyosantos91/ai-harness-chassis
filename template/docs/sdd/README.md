# SDDs

Este diretório contém System Design Documents derivados de PRDs.

## Regra obrigatória

Antes de criar uma SDD, leia o PRD correspondente em `docs/prd`.

Nenhuma SDD deve ser criada sem PRD de origem.

Toda SDD deve conter referência explícita ao PRD de origem.

Frontmatter obrigatório:

```md
---
title: <nome da SDD>
status: draft
source_prd: docs/prd/<nome-da-iniciativa>.md
source_prd_id: PRD-<nome-em-kebab-case>
created_at: <data atual ou [A confirmar]>
updated_at: <data atual ou [A confirmar]>
---
```

A SDD deve derivar decisões técnicas a partir de:

* problema de negócio
* objetivos do produto
* requisitos de negócio
* requisitos funcionais
* regras de negócio
* critérios de aceite
* requisitos não funcionais de produto
* dados necessários
* dependências
* riscos
* perguntas abertas

Se o PRD tiver perguntas bloqueantes, a SDD deve registrar essas lacunas e não assumir respostas como fatos.
