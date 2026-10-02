#!/usr/bin/env bash

# ==============================================================================
# Midas Agent Skills Installer
# Compatible with Antigravity, Claude Code, Codex, and Cursor
# ==============================================================================

set -e

REPO_URL="https://github.com/midasism/midas-agent-skills.git"
RAW_URL="https://raw.githubusercontent.com/midasism/midas-agent-skills/main"
TARGET_DIR="${HOME}/.agents/skills"
GEMINI_DIR="${HOME}/.gemini/antigravity/skills"

SKILL_NAME="$1"

mkdir -p "$TARGET_DIR"

if [ -n "$SKILL_NAME" ]; then
  echo "📦 Installing skill: $SKILL_NAME..."
  
  # 如果当前目录下存在 skills 目录（本地 clone 安装）
  if [ -d "skills/$SKILL_NAME" ]; then
    cp -r "skills/$SKILL_NAME" "$TARGET_DIR/"
  else
    # 远程 curl 安装单个 skill 时，使用临时 clone
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
    if [ -d "$TEMP_DIR/skills/$SKILL_NAME" ]; then
      cp -r "$TEMP_DIR/skills/$SKILL_NAME" "$TARGET_DIR/"
      rm -rf "$TEMP_DIR"
    else
      echo "❌ Error: Skill '$SKILL_NAME' not found!"
      rm -rf "$TEMP_DIR"
      exit 1
    fi
  fi

  # 若存在 Antigravity 技能目录，自动创建软链接
  if [ -d "$GEMINI_DIR" ]; then
    ln -sf "$TARGET_DIR/$SKILL_NAME" "$GEMINI_DIR/$SKILL_NAME"
  fi

  echo "✅ Skill '$SKILL_NAME' installed successfully to $TARGET_DIR/$SKILL_NAME"
else
  echo "🚀 Installing all skills from midas-agent-skills..."
  
  if [ -d "skills" ]; then
    cp -r skills/* "$TARGET_DIR/"
  else
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
    cp -r "$TEMP_DIR/skills/"* "$TARGET_DIR/"
    rm -rf "$TEMP_DIR"
  fi

  if [ -d "$GEMINI_DIR" ]; then
    for skill_path in "$TARGET_DIR"/*; do
      if [ -d "$skill_path" ]; then
        name=$(basename "$skill_path")
        ln -sf "$skill_path" "$GEMINI_DIR/$name"
      fi
    done
  fi

  echo "🎉 All skills installed successfully to $TARGET_DIR"
fi

echo "💡 Your AI Agent will now automatically recognize the installed skills!"
