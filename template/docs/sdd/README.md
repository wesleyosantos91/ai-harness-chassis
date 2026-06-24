# SDDs

Este diretório contém System Design Documents derivados de PRDs.

## Posição no fluxo (OpenSpec)

Este projeto usa **OpenSpec**. A SDD é o **plano técnico** que vem depois da spec:

```text
PRD (docs/prd/)  ->  OpenSpec change/spec (openspec/)  ->  SDD/plano (docs/sdd/)  ->  TDD
```

A SDD pode morar aqui (`docs/sdd/<iniciativa>.md`) ou no `design.md` da OpenSpec change;
em ambos os casos deriva do PRD e da spec, e referencia o PRD de origem. Valide com
`scripts/ai/openspec-validate.sh` antes de implementar.

## Regra obrigatória

Antes de criar uma SDD, leia o PRD correspondente em `docs/prd` (e a OpenSpec change/spec, se houver).

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
