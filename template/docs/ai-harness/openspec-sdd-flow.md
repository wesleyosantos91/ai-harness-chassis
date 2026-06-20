# OpenSpec / SDD / PRD flow

Regra: `.ai/rules/openspec-sdd.md`. Validação: `scripts/ai/openspec-validate.sh`.

## Fluxo

```text
PRD/product  ->  OpenSpec change/spec  ->  SDD/plano técnico  ->  implementação TDD
             ->  testes  ->  validação (openspec-check)  ->  relatório
```

## Estado neste repo

- **OpenSpec presente**: `openspec/` (`schema: spec-driven`), com `changes/` e `specs/`.
- Comandos OpenSpec do Claude em `.claude/commands/opsx/` (explore/propose/apply/archive/sync).
- **PRD**: não existe → use `docs/product/PRD.template.md` (não inventar requisitos).

## Antes de implementar

```bash
bash scripts/ai/opsx-context-check.sh <arquivo-da-tarefa.md>   # exige contexto mínimo
bash scripts/ai/openspec-validate.sh                            # specs vs código
```

Checklist de contexto mínimo: objetivo, requisito, spec, plano técnico, arquivos,
teste esperado, tipo de teste, critério de pronto, risco, rollback.

## Validação spec × código

`openspec-validate.sh` lista specs/changes e confronta (heurístico) endpoints/eventos
declarados vs anotações no código, gerando `.ai/reports/openspec-check.md`.
Divergências devem ser resolvidas; requisito não claro **bloqueia** a implementação.

## Regras

- Não inventar requisitos. Sem spec/PRD → documentar ausência e usar template.
- Toda implementação referencia uma spec/change.
- A spec é a fonte da verdade; código diverge → corrigir código (após revisar spec).
