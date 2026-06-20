#!/usr/bin/env bash
#
# Instalador do agente "triagem-acordo-trabalhista" para o Claude Code.
#
# Uso:
#   ./install.sh            # instala globalmente em ~/.claude/agents/
#   ./install.sh --project  # instala no projeto atual em ./.claude/agents/
#   ./install.sh --help
#
set -euo pipefail

AGENT_FILE="triagem-acordo-trabalhista.md"
# Diretório onde este script vive (funciona mesmo se chamado de outro lugar).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/agents/${AGENT_FILE}"

usage() {
  cat <<EOF
Instalador do agente triagem-acordo-trabalhista.

Uso:
  ./install.sh            Instala globalmente em ~/.claude/agents/ (todas as pastas)
  ./install.sh --project  Instala no projeto atual em ./.claude/agents/
  ./install.sh --help     Mostra esta ajuda

Pré-requisitos (configurar separadamente):
  - Claude Code instalado
  - Servidores MCP 'pje-mni' e 'tecjustica' configurados
EOF
}

case "${1:-}" in
  -h|--help)
    usage; exit 0 ;;
  --project)
    DEST_DIR="$(pwd)/.claude/agents"
    SCOPE="projeto ($(pwd))" ;;
  "")
    DEST_DIR="${HOME}/.claude/agents"
    SCOPE="global (todas as pastas)" ;;
  *)
    echo "❌ Opção desconhecida: $1" >&2
    echo >&2
    usage >&2
    exit 1 ;;
esac

if [[ ! -f "$SRC" ]]; then
  echo "❌ Não encontrei o arquivo do agente em: $SRC" >&2
  echo "   Rode o script de dentro do repositório clonado." >&2
  exit 1
fi

DEST="${DEST_DIR}/${AGENT_FILE}"
mkdir -p "$DEST_DIR"

if [[ -f "$DEST" ]]; then
  printf "⚠️  Já existe um agente em %s. Sobrescrever? [s/N] " "$DEST"
  read -r resposta
  case "$resposta" in
    s|S|sim|Sim|y|Y) ;;
    *) echo "Instalação cancelada."; exit 0 ;;
  esac
fi

cp "$SRC" "$DEST"

echo "✅ Agente instalado — escopo: ${SCOPE}"
echo "   → ${DEST}"
echo
echo "Reinicie o Claude Code (ou abra uma nova sessão) para reconhecer o agente."
echo "Depois, peça: \"Faça a triagem para pauta de acordo do processo <CNJ>\""
