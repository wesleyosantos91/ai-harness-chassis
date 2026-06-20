# Skills

Skills operacionais amarradas aos scripts/gates locais. Disponíveis para Claude
(`.claude/skills/<nome>/SKILL.md`) e Codex (`.agents/skills/<nome>/SKILL.md`).

## Catálogo (9)

| Skill | Objetivo | Script central |
|---|---|---|
| `java-quality-gate` | Rodar/interpretar gates | `scripts/quality/verify-all.sh` |
| `tdd-implementation` | Implementar via TDD | `scripts/quality/test-unit.sh` |
| `openspec-validation` | Validar spec×código | `scripts/ai/openspec-validate.sh` |
| `package-architecture-review` | SOLID, pacotes e isolamento do domínio | `scripts/quality/package-rules.sh` |
| `mutation-testing-review` | Mutantes sobreviventes | `scripts/quality/mutation-test.sh` |
| `api-contract-review` | Breaking changes | `git diff` + openspec-validate |
| `pre-pr-review` | Checklist pré-PR | `scripts/quality/verify-all.sh --fast` |
| `adr-generation` | Gerar ADR | template `.ai/templates/adr-template.md` |
| `context-pack` | Empacotar contexto | `scripts/ai/context-pack.sh` |

Cada SKILL.md tem: frontmatter, objetivo, quando usar / quando NÃO usar, inputs,
workflow, comandos, saída esperada, critérios de qualidade e nota de segurança
(bloqueio de comandos destrutivos).

As skills de **OpenSpec** (`openspec-explore/propose/apply/archive/sync`) já existentes
permanecem e não foram alteradas.

## Validação

```bash
bash scripts/ai/validate-skills.sh
```

## Codex

Registre as skills em `.codex/config.example.toml` (cópia manual para `.codex/config.toml`).
