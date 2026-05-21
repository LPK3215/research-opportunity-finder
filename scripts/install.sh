#!/bin/bash
# Research Innovation Scout - multi-tool installer
# Primary targets: Claude Code, Codex/OpenAI Skills, Cursor.
# Compatibility targets remain available for users who need them.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_PROJECT="${RIS_TARGET_PROJECT:-$PWD}"
SKILLS_ROOT="$PROJECT_DIR/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${CYAN}[*]${NC} $1"; }
err()  { echo -e "${RED}[X]${NC} $1"; }

TARGET_TOOL=""
LANGUAGE="${RIS_LANG:-en}"

usage() {
    echo "Usage: ./scripts/install.sh [--tool <name>] [--lang en|zh-CN]"
    echo "  Primary tools: claude-code | codex | cursor"
    echo "  Compatibility: codebuddy | copilot | aider | windsurf | general"
    echo "  Default language: en (override with RIS_LANG or --lang)"
    echo "  Target project: current directory (override with RIS_TARGET_PROJECT)"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --tool)
            if [ $# -lt 2 ] || [ -z "$2" ]; then
                err "Missing value for --tool"
                usage
                exit 1
            fi
            TARGET_TOOL="$2"
            shift 2
            ;;
        --lang|--language)
            if [ $# -lt 2 ] || [ -z "$2" ]; then
                err "Missing value for $1"
                usage
                exit 1
            fi
            LANGUAGE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        claude|claude-code|codex|cursor|codebuddy|copilot|aider|windsurf|general)
            TARGET_TOOL="$1"
            shift
            ;;
        *)
            err "Unknown argument: $1"
            usage
            exit 1
            ;;
    esac
done

case "$LANGUAGE" in
    en)
        PROMPT_SRC="$PROJECT_DIR/CLAUDE.md"
        SKILLS_SRC="$SKILLS_ROOT/en"
        OFFICIAL_SKILL_NAME="research-innovation-scout"
        ;;
    zh-CN|zh)
        LANGUAGE="zh-CN"
        PROMPT_SRC="$PROJECT_DIR/CLAUDE_zh-CN.md"
        SKILLS_SRC="$SKILLS_ROOT/zh-CN"
        OFFICIAL_SKILL_NAME="research-innovation-scout-zh-cn"
        ;;
    *)
        err "Unsupported language: $LANGUAGE"
        echo "  Supported: en | zh-CN"
        exit 1
        ;;
esac

CODEX_SKILL_SRC="$SKILLS_ROOT/codex/$OFFICIAL_SKILL_NAME"
CLAUDE_SKILL_SRC="$PROJECT_DIR/.claude/skills/$OFFICIAL_SKILL_NAME"
CURSOR_RULE_SRC="$PROJECT_DIR/.cursor/rules/$OFFICIAL_SKILL_NAME.mdc"
PLAIN_ENTRY_SRC="$SKILLS_SRC/research-innovation-scout.md"

require_file() {
    if [ ! -f "$1" ]; then
        err "Required file not found: $1"
        exit 1
    fi
}

require_dir() {
    if [ ! -d "$1" ]; then
        err "Required directory not found: $1"
        exit 1
    fi
}

require_file "$PROMPT_SRC"
require_file "$PLAIN_ENTRY_SRC"
require_dir "$SKILLS_SRC"
require_dir "$CODEX_SKILL_SRC"
require_dir "$CLAUDE_SKILL_SRC"
require_file "$CURSOR_RULE_SRC"

copy_skill_dir() {
    local src="$1"
    local dest="$2"
    if [ -d "$dest" ]; then
        warn "Already exists: $dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    cp -R "$src" "$dest"
}

# -- Claude Code ------------------------------------------------------------
install_claude_code() {
    info "Installing Claude Code project skill..."
    local dest="$TARGET_PROJECT/.claude/skills/$OFFICIAL_SKILL_NAME"
    copy_skill_dir "$CLAUDE_SKILL_SRC" "$dest"
    log "$OFFICIAL_SKILL_NAME -> $dest"

    local memory="$TARGET_PROJECT/CLAUDE.md"
    if [ ! -f "$memory" ]; then
        cp "$PROMPT_SRC" "$memory"
        log "Lightweight CLAUDE.md -> $memory"
    else
        warn "CLAUDE.md already exists at $memory; leaving it unchanged."
    fi

    echo "     Usage: claude, then ask naturally for research innovation directions."
}

# -- Codex / OpenAI Skill ---------------------------------------------------
install_codex() {
    info "Installing Codex/OpenAI skill..."
    local skill_home="${CODEX_HOME:-$HOME/.codex}"
    local dest="$skill_home/skills/$OFFICIAL_SKILL_NAME"
    copy_skill_dir "$CODEX_SKILL_SRC" "$dest"
    log "$OFFICIAL_SKILL_NAME -> $dest"
    echo "     Usage: ask Codex to use \$$OFFICIAL_SKILL_NAME."
}

# -- Cursor -----------------------------------------------------------------
install_cursor() {
    info "Installing Cursor project rule..."
    local dest_dir="$TARGET_PROJECT/.cursor/rules"
    local dest="$dest_dir/$OFFICIAL_SKILL_NAME.mdc"
    mkdir -p "$dest_dir"
    if [ -f "$dest" ]; then
        warn "Already exists: $dest"
    else
        cp "$CURSOR_RULE_SRC" "$dest"
        log "$OFFICIAL_SKILL_NAME.mdc -> $dest_dir/"
    fi
    echo "     Usage: @${OFFICIAL_SKILL_NAME} <research direction>"
}

# -- CodeBuddy compatibility ------------------------------------------------
install_codebuddy() {
    info "Installing CodeBuddy compatibility skill..."
    local dest="$TARGET_PROJECT/.codebuddy/skills/$OFFICIAL_SKILL_NAME"
    if [ -d "$dest" ]; then
        warn "Already exists: $dest"
        return 0
    fi
    mkdir -p "$dest/references"
    cp "$CODEX_SKILL_SRC/SKILL.md" "$dest/SKILL.md"
    cp "$CODEX_SKILL_SRC"/references/*.md "$dest/references/"
    log "$OFFICIAL_SKILL_NAME -> $dest"
}

# -- GitHub Copilot compatibility ------------------------------------------
install_copilot() {
    info "Installing GitHub Copilot compatibility prompt..."
    local dest="$TARGET_PROJECT/.github/agents"
    mkdir -p "$dest"
    cp "$PLAIN_ENTRY_SRC" "$dest/research-innovation-scout.md"
    log "research-innovation-scout.md -> $dest/"
}

# -- Aider compatibility ----------------------------------------------------
install_aider() {
    info "Installing Aider compatibility prompt..."
    cp "$PLAIN_ENTRY_SRC" "$TARGET_PROJECT/CONVENTIONS.md"
    log "CONVENTIONS.md -> $TARGET_PROJECT/"
}

# -- Windsurf compatibility -------------------------------------------------
install_windsurf() {
    info "Installing Windsurf compatibility prompt..."
    cp "$PLAIN_ENTRY_SRC" "$TARGET_PROJECT/.windsurfrules"
    log ".windsurfrules -> $TARGET_PROJECT/"
}

# -- Plain Markdown ---------------------------------------------------------
install_general() {
    info "Installing plain Markdown skill pack..."
    local dest="$TARGET_PROJECT/research-innovation-scout"
    if [ -d "$dest" ]; then
        warn "Already exists: $dest"
        return 0
    fi
    mkdir -p "$dest"
    cp -R "$SKILLS_SRC"/* "$dest/"
    log "$LANGUAGE Markdown pack -> $dest/"
    echo "     Usage: give research-innovation-scout.md to any AI with web/search access."
}

echo ""
echo "  Research Innovation Scout - Installer"
echo "  --------------------------------------"
echo "  Language: $LANGUAGE"
echo "  Target project: $TARGET_PROJECT"
echo ""

if [ -n "$TARGET_TOOL" ]; then
    case "$TARGET_TOOL" in
        claude|claude-code) install_claude_code ;;
        codex)              install_codex ;;
        cursor)             install_cursor ;;
        codebuddy)          install_codebuddy ;;
        copilot)            install_copilot ;;
        aider)              install_aider ;;
        windsurf)           install_windsurf ;;
        general)            install_general ;;
        *)
            err "Unknown tool: $TARGET_TOOL"
            usage
            exit 1
            ;;
    esac
else
    echo "  Auto-detecting primary tools first..."
    echo ""

    DETECTED=0
    if [ -d "$HOME/.claude" ] || command -v claude >/dev/null 2>&1; then
        install_claude_code && DETECTED=$((DETECTED+1))
    fi
    if [ -n "$CODEX_HOME" ] || command -v codex >/dev/null 2>&1; then
        install_codex && DETECTED=$((DETECTED+1))
    fi
    if [ -d "$TARGET_PROJECT/.cursor" ] || command -v cursor >/dev/null 2>&1; then
        install_cursor && DETECTED=$((DETECTED+1))
    fi
    if [ -d "$TARGET_PROJECT/.codebuddy" ] || [ -n "$CODEBUDDY_API_KEY" ]; then
        install_codebuddy && DETECTED=$((DETECTED+1))
    fi

    if [ "$DETECTED" -eq 0 ]; then
        echo ""
        warn "No supported tool detected. Installing the plain Markdown pack..."
        install_general
    fi
fi

echo ""
log "Done."
echo ""
