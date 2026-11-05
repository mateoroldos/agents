---
name: machine-tools
description: How tools get onto this machine. Use when a command is missing, before installing or upgrading any tool, and when a task needs a CLI the machine lacks.
---

# Machine tools

This machine is built from `~/dotfiles` with mise. Its README says where each kind of tool goes; read it before installing anything.

- Install only through mise. Never use apt, `npm -g`, `pip install --user`, `cargo install`, or a curl installer.
- A tool only this task needs: run it once with `mise exec <tool> -- <command>` and install nothing.
- A tool to keep: ask me first, since it changes every machine. Then make the dotfiles change and open its PR there.
