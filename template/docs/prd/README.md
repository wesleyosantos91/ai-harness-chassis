# Índice de PRDs

Este diretório contém os PRDs do produto.

Cada PRD deve representar uma demanda, dor, oportunidade, épico ou feature do ponto de vista de negócio e produto.

## Posição no fluxo (OpenSpec)

O PRD é a fonte de verdade de negócio e **alimenta o OpenSpec**:

```text
PRD (docs/prd/)  ->  OpenSpec change/spec (openspec/)  ->  SDD/plano (docs/sdd/)  ->  TDD
```

A spec derivada é uma OpenSpec change/spec (via `openspec-propose` / `/opsx propose`);
`docs/specs/` é fallback para specs sem OpenSpec.

## Regra de rastreabilidade

Todo PRD salvo deve ser referenciado em:

- `docs/prd/README.md`
- `CLAUDE.md`
- `AGENTS.md`

Toda spec ou SDD derivada deve referenciar o PRD de origem.

## PRDs

| PRD | Status | Descrição | Arquivo | Specs relacionadas | SDDs relacionadas |
|---|---|---|---|---|---|
