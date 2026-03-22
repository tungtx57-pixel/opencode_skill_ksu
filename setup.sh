#!/bin/bash

set -e

SKILLS_DIR="${HOME}/.opencode/skills/ksu"
TEMP_DIR="/tmp/opencode_ksu_$$"

echo "Installing KSU Skills for OpenCode..."

rm -rf "${TEMP_DIR}"
git clone https://github.com/DinhQuangDoi/opencode_skill_ksu.git "${TEMP_DIR}"

mkdir -p "${SKILLS_DIR}"
cp -r "${TEMP_DIR}/skills/"* "${SKILLS_DIR}/"

rm -rf "${TEMP_DIR}"

echo "Done! Skills installed to ${SKILLS_DIR}"
