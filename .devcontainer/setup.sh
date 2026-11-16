#!/usr/bin/env bash
set -e

# 1. Install minimal system tools (32-bit x86 support, QEMU & GDB for ARM/MIPS, tmux)
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  gdb gdb-multiarch qemu-user libc6-i386 tmux python3-venv unzip file curl
sudo rm -rf /var/lib/apt/lists/*

# 2. Install pwntools & ropper inside a clean venv (avoids Ubuntu Python PEP 668 errors)
python3 -m venv "$HOME/.venv"
"$HOME/.venv/bin/pip" install --no-cache-dir --upgrade pip
"$HOME/.venv/bin/pip" install --no-cache-dir pwntools ropper

# Add venv to both bash and zsh PATH
echo 'export PATH="$HOME/.venv/bin:$PATH"' >> "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && echo 'export PATH="$HOME/.venv/bin:$PATH"' >> "$HOME/.zshrc"

# 3. Install GEF (lightweight ~300KB GDB plugin, works on x86/ARM/MIPS in <2s)
wget -O "$HOME/.gdbinit-gef.py" -q https://gef.blah.cat/py
echo "source $HOME/.gdbinit-gef.py" >> "$HOME/.gdbinit"
