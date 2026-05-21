#!/bin/bash
# Research Innovation Scout — Multi-Tool Installer
# Usage: ./scripts/install.sh [--tool <name>] | ./scripts/install.sh    (auto-detect)

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_SRC="$PROJECT_DIR/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${CYAN}[*]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

TARGET_TOOL="$1"
if [ "$1" = "--tool" ] && [ -n "$2" ]; then
    TARGET_TOOL="$2"
fi

# ── Claude Code ──────────────────────────────────
install_claude_code() {
    info "Detecting Claude Code..."
    local dest="${HOME}/.claude"
    if [ -d "$dest" ]; then
        cp "$PROJECT_DIR/CLAUDE.md" "$dest/"
        log "CLAUDE.md → ~/.claude/"
    else
        mkdir -p "$dest"
        cp "$PROJECT_DIR/CLAUDE.md" "$dest/"
        log "CLAUDE.md → ~/.claude/ (created)"
    fi
    echo "     Usage: claude  # auto-loads CLAUDE.md"
}

# ── CodeBuddy ────────────────────────────────────
install_codebuddy() {
    info "Detecting CodeBuddy..."
    local dest="${PWD}/.codebuddy/skills/research-innovation-scout"
    if [ -d "$dest" ]; then
        warn "CodeBuddy skill already exists at $dest. Skipping."
        return
    fi
    cp -r "$PROJECT_DIR/.codebuddy/skills/research-innovation-scout" "$(dirname "$dest")" 2>/dev/null || {
        mkdir -p "$dest"
        mkdir -p "$dest/references"
        cp "$PROJECT_DIR/.codebuddy/skills/research-innovation-scout/SKILL.md" "$dest/"
        cp "$PROJECT_DIR/skills"/step-*.md "$dest/references/"
        cp "$PROJECT_DIR/skills/step-orchestrator.md" "$dest/references/"
    }
    log "Skill installed → .codebuddy/skills/research-innovation-scout/"
}

# ── Cursor ───────────────────────────────────────
install_cursor() {
    info "Detecting Cursor..."
    local dest="${PWD}/.cursor/rules"
    mkdir -p "$dest"
    cp "$PROJECT_DIR/CLAUDE.md" "$dest/research-innovation-scout.mdc"
    log "research-innovation-scout.mdc → .cursor/rules/"
    echo "     Usage: @research-innovation-scout 输入研究方向"
}

# ── GitHub Copilot ───────────────────────────────
install_copilot() {
    info "Detecting GitHub Copilot..."
    local dest="${PWD}/.github/agents"
    mkdir -p "$dest"
    cp "$PROJECT_DIR/CLAUDE.md" "$dest/research-innovation-scout.md"
    log "research-innovation-scout.md → .github/agents/"
}

# ── Aider ────────────────────────────────────────
install_aider() {
    info "Detecting Aider..."
    cp "$PROJECT_DIR/CLAUDE.md" "${PWD}/CONVENTIONS.md"
    log "CONVENTIONS.md → project root (Aider auto-loads)"
}

# ── Windsurf ─────────────────────────────────────
install_windsurf() {
    info "Detecting Windsurf..."
    cp "$PROJECT_DIR/CLAUDE.md" "${PWD}/.windsurfrules"
    log ".windsurfrules → project root"
}

# ── General (plain Markdown) ─────────────────────
install_general() {
    local dest="${PWD}/research-innovation-scout"
    mkdir -p "$dest"
    cp -r "$SKILLS_SRC"/* "$dest/"
    log "skills/ → $dest/"
    echo "     Usage: 将 $dest/research-innovation-scout.md 发送给任意 AI"
}

# ── Main ─────────────────────────────────────────
echo ""
echo "  Research Innovation Scout — Installer"
echo "  ─────────────────────────────────────"
echo ""

if [ -n "$TARGET_TOOL" ] && [ "$TARGET_TOOL" != "--tool" ]; then
    case "$TARGET_TOOL" in
        claude-code) install_claude_code ;;
        codebuddy)   install_codebuddy ;;
        cursor)      install_cursor ;;
        copilot)     install_copilot ;;
        aider)       install_aider ;;
        windsurf)    install_windsurf ;;
        general)     install_general ;;
        *)
            err "Unknown tool: $TARGET_TOOL"
            echo "  Supported: claude-code | codebuddy | cursor | copilot | aider | windsurf | general"
            exit 1
            ;;
    esac
else
    echo "  Auto-detecting tools..."
    echo ""

    DETECTED=0
    if [ -d "$HOME/.claude" ] || command -v claude &>/dev/null 2>&1; then
        install_claude_code && DETECTED=$((DETECTED+1))
    fi
    if [ -d "$PWD/.codebuddy" ] || [ -n "$CODEBUDDY_API_KEY" ]; then
        install_codebuddy && DETECTED=$((DETECTED+1))
    fi
    if [ -d "$PWD/.cursor" ] || command -v cursor &>/dev/null 2>&1; then
        install_cursor && DETECTED=$((DETECTED+1))
    fi

    if [ $DETECTED -eq 0 ]; then
        echo ""
        warn "No specific tools detected. Installing general version..."
        install_general
    fi
fi

echo ""
log "Done!"
echo ""
