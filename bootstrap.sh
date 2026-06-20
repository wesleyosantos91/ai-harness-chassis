#!/usr/bin/env bash
# ============================================================================
# AI Harness chassis — bootstrap
# Aplica o harness (Claude Code + Codex + quality gates Java 25 + MCP +
# LocalStack lab) em um repositório ALVO. Idempotente; por padrão NÃO
# sobrescreve arquivos existentes. Não instala dependência global (isso é feito
# pelo postCreateCommand do DevContainer ao abrir o projeto).
# ============================================================================
set -euo pipefail

CHASSIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$CHASSIS_DIR/template"

FORCE=0
DO_GIT=0
BASE_PACKAGE=""
PROJECT_NAME=""
TARGET=""

usage() {
  cat <<EOF
Uso: bootstrap.sh [opções] <diretório-alvo>

Copia o harness do chassi para <diretório-alvo> e substitui placeholders.

Opções:
  --base-package <pkg>   Base package Java (default: com.example)
  --name <nome>          Nome do projeto (default: nome da pasta alvo)
  --force                Sobrescreve arquivos já existentes no alvo
  --git                  Roda 'git init' no alvo se ainda não for repo
  -h, --help             Mostra esta ajuda

Exemplos:
  bootstrap.sh ~/projetos/meu-servico
  bootstrap.sh --base-package com.acme.orders --name orders ~/projetos/orders
  bootstrap.sh --force --git ~/projetos/existente
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --base-package) BASE_PACKAGE="${2:-}"; shift 2 ;;
    --name)         PROJECT_NAME="${2:-}"; shift 2 ;;
    --force)        FORCE=1; shift ;;
    --git)          DO_GIT=1; shift ;;
    -h|--help)      usage; exit 0 ;;
    -*)             echo "Opção desconhecida: $1" >&2; usage; exit 2 ;;
    *)              TARGET="$1"; shift ;;
  esac
done

[ -d "$TEMPLATE" ] || { echo "ERRO: payload não encontrado em $TEMPLATE" >&2; exit 1; }
[ -n "$TARGET" ]   || { echo "ERRO: informe o diretório alvo." >&2; usage; exit 2; }

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
PROJECT_NAME="${PROJECT_NAME:-$(basename "$TARGET")}"
BASE_PACKAGE="${BASE_PACKAGE:-com.example}"

echo "Chassi:        $CHASSIS_DIR"
echo "Alvo:          $TARGET"
echo "Projeto:       $PROJECT_NAME"
echo "Base package:  $BASE_PACKAGE"
echo "Sobrescrever:  $([ "$FORCE" -eq 1 ] && echo sim || echo não)"
echo

cp_flags="-rn"; [ "$FORCE" -eq 1 ] && cp_flags="-rf"

# Copia cada item de topo do template (inclui dotfiles), exceto o gitignore do chassi.
shopt -s dotglob
for item in "$TEMPLATE"/*; do
  name="$(basename "$item")"
  [ "$name" = "gitignore.chassis" ] && continue
  cp $cp_flags "$item" "$TARGET/" 2>/dev/null || cp $cp_flags "$item" "$TARGET/"
done
shopt -u dotglob
echo "[1/5] Arquivos do harness copiados (cp $cp_flags)."

# Substitui placeholders apenas em arquivos de texto do alvo (exclui .git e binários).
mapfile -t files < <(grep -rlI -e '__BASE_PACKAGE__' -e '__PROJECT_NAME__' "$TARGET" --exclude-dir=.git 2>/dev/null || true)
for f in "${files[@]:-}"; do
  [ -n "$f" ] || continue
  sed -i "s/__BASE_PACKAGE__/${BASE_PACKAGE//\//\\/}/g; s/__PROJECT_NAME__/${PROJECT_NAME//\//\\/}/g" "$f"
done
echo "[2/5] Placeholders substituídos (__BASE_PACKAGE__, __PROJECT_NAME__)."

# Permissões de execução nos scripts.
find "$TARGET/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
[ -f "$TARGET/.devcontainer/install-tools.sh" ] && chmod +x "$TARGET/.devcontainer/install-tools.sh" || true
echo "[3/5] Scripts marcados como executáveis."

# .gitignore: cria a partir do chassi, ou anexa bloco marcado se já existir.
MARK_BEGIN="# >>> ai-harness chassis (managed) >>>"
MARK_END="# <<< ai-harness chassis (managed) <<<"
if [ ! -f "$TARGET/.gitignore" ]; then
  { echo "$MARK_BEGIN"; cat "$TEMPLATE/gitignore.chassis"; echo "$MARK_END"; } > "$TARGET/.gitignore"
  echo "[4/5] .gitignore criado a partir do chassi."
elif ! grep -qF "$MARK_BEGIN" "$TARGET/.gitignore"; then
  { echo ""; echo "$MARK_BEGIN"; cat "$TEMPLATE/gitignore.chassis"; echo "$MARK_END"; } >> "$TARGET/.gitignore"
  echo "[4/5] Bloco do chassi anexado ao .gitignore existente."
else
  echo "[4/5] .gitignore já contém o bloco do chassi (sem mudança)."
fi

# git init opcional.
if [ "$DO_GIT" -eq 1 ] && [ ! -d "$TARGET/.git" ]; then
  git -C "$TARGET" init -q && echo "[5/5] git init concluído."
else
  echo "[5/5] git init pulado (use --git para inicializar)."
fi

cat <<EOF

✅ Harness aplicado em: $TARGET

Próximos passos:
  1. Abra o projeto no DevContainer (VS Code: "Reopen in Container" ou
     'devcontainer up --workspace-folder "$TARGET"').
     O postCreateCommand instala Claude Code, Codex, RTK, OpenSpec, Repomix,
     uv e registra os MCPs do Codex automaticamente.
  2. Claude Code: na 1ª vez, aprove os MCPs do projeto ('claude' → aprovar .mcp.json).
  3. LocalStack/AWS (opcional): 'cp .env.example .env' e defina LOCALSTACK_AUTH_TOKEN
     no .env (NUNCA commite o token; .env já está no .gitignore).
  4. Ajuste o pacote-base se necessário (usei: $BASE_PACKAGE) em AGENTS.md / CLAUDE.md /
     .ai/harness.yaml e crie 'src/main/java/${BASE_PACKAGE//.//}/'.
  5. Quality gates Java: copie os plugins de 'config/pom-quality-plugins.example.xml'
     para o seu pom.xml (valide versões) e rode 'bash scripts/quality/verify-all.sh --fast'.

Validação rápida:
  bash "$TARGET/scripts/ai/detect-project.sh"
  bash "$TARGET/scripts/ai/validate-claude-agents.sh"
  bash "$TARGET/scripts/ai/validate-codex-agents.sh"
  bash "$TARGET/scripts/ai/validate-skills.sh"
EOF
