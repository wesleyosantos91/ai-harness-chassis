# AI Harness Chassis (Java 25 · Claude Code + Codex)

Chassi reutilizável para iniciar **novos projetos Java** já com o harness de IA
completo: agentes/skills/commands, quality gates (Spotless · Checkstyle Java 25 ·
JaCoCo 90% · PIT 90% · ArchUnit), OpenSpec/SDD, DevContainer Linux, MCPs (Claude
Code + Codex) e um lab LocalStack/AWS.

> Extraído de `poc-devcontainer`. Este chassi é **independente**: aplicá-lo num
> projeto novo não toca no repositório de origem.

## Estrutura

```
ai-harness-chassis/
├── README.md          # este guia
├── bootstrap.sh       # aplica o harness num repositório alvo
└── template/          # payload reutilizável (o que é copiado)
    ├── .devcontainer/        # imagem + features + install-tools.sh (instala CLIs e MCPs)
    ├── .ai/                  # rules, prompts, references, templates, harness.yaml
    ├── .claude/              # agents, commands, skills, settings.example.json
    ├── .codex/               # agents, skills, config.example.toml, mcp.*.example.toml
    ├── .agents/skills/       # skills para Codex
    ├── scripts/              # ai/, quality/, hooks/, lib/, mcp/
    ├── config/               # checkstyle, spotless, archunit, pitest, pom-*.example.xml
    ├── docs/ai-harness/      # documentação do harness
    ├── docs/product/         # PRD.template.md
    ├── infra/localstack/     # Terraform do lab LocalStack
    ├── compose.yaml          # LocalStack via docker compose
    ├── .mcp.json             # MCPs do Claude Code
    ├── .env.example          # variáveis (placeholders; nunca commitar .env real)
    ├── openspec/config.yaml  # config do OpenSpec
    ├── RTK.md, repomix.config.json
    ├── AGENTS.md, CLAUDE.md   # instruções dos agentes (com placeholders)
    └── gitignore.chassis      # bloco a aplicar no .gitignore do alvo
```

Placeholders no template: `__BASE_PACKAGE__` e `__PROJECT_NAME__` (o `bootstrap.sh`
substitui pelos valores do projeto novo).

## Uso

### Projeto novo

```bash
~/projetos/ai-harness-chassis/bootstrap.sh \
  --base-package com.acme.orders \
  --name orders \
  --git \
  ~/projetos/orders
```

Isso copia o harness, substitui placeholders, marca scripts como executáveis,
configura o `.gitignore` e (com `--git`) inicializa o repositório.

### Projeto existente

```bash
~/projetos/ai-harness-chassis/bootstrap.sh --base-package com.acme.app ~/projetos/app
```

Por padrão **não sobrescreve** arquivos existentes (merge seguro). Use `--force`
para sobrescrever (ex.: atualizar o harness depois de evoluir o chassi).

### Opções

| Opção | Efeito |
|---|---|
| `--base-package <pkg>` | Base package Java (default `com.example`) |
| `--name <nome>` | Nome do projeto (default = nome da pasta alvo) |
| `--force` | Sobrescreve arquivos existentes |
| `--git` | `git init` no alvo se ainda não for repo |

## Depois do bootstrap

1. **Abra no DevContainer** (VS Code "Reopen in Container" ou
   `devcontainer up --workspace-folder <alvo>`). O `postCreateCommand` instala
   Claude Code, Codex, RTK, OpenSpec, Repomix e `uv`, e **registra os MCPs do Codex**.
2. **Claude Code**: aprove os MCPs do projeto na 1ª vez (são project-scoped em `.mcp.json`).
3. **Secrets**: `cp .env.example .env` e preencha (ex.: `LOCALSTACK_AUTH_TOKEN`).
   Nunca commite `.env` (já ignorado).
4. **Código Java**: crie `src/main/java/<base-package>/` seguindo
   `.ai/rules/package-organization.md`.
5. **Quality gates no build**: copie os plugins de
   `config/pom-quality-plugins.example.xml` para o `pom.xml` (valide versões) — veja
   `docs/ai-harness/java-25-quality.md` (no Java 25, Spotless usa Eclipse JDT).

## O que NÃO vem no chassi (de propósito)

- Código de aplicação (`src/`, `pom.xml`, `mvnw`) — cada projeto traz o seu.
- Estado gerado/local: `.ai/reports/*`, `.claude/settings.local.json`,
  `.codex/config.toml`, `infra/**/.terraform/`.
- Qualquer secret. Tokens/credenciais vêm sempre de variáveis de ambiente.

## MCPs incluídos

`context7`, `springdocs`, `aws-docs`, `terraform-registry`, `aws-pricing-sandbox`,
`localstack-lab` — para Claude Code (`.mcp.json`) e Codex (registrados pelo
`install-tools.sh`). Detalhes e como habilitar/remover em `docs/ai-harness/mcp-setup.md`.

## Atualizar o chassi

Evoluiu o harness no `poc-devcontainer` (ou em outro projeto)? Recopie os arquivos
reutilizáveis para `template/`, regenere os placeholders e use `--force` ao reaplicar
nos projetos.
