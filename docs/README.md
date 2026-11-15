# Docs

This directory is never _stowed_!

## ~Secret~ life of standalone scripts

1. If an LLM writes a standalone script, it should be placed inside
   `in/litter/`. This is LLM's shit box. Unverified and potentially horrifying
   scripts exist here.
1. Once a human verifies the script (usually a quick glance to detailed
   inspection/understanding) scripts can move to `in/`. These are still a
   **Work In progress** and it would be unwise to rely on them for serious use.
1. If a script inside `in/` has proved its utility it goes to _valhalla_ at
   `scripts/.local/bin/` or `scripts/misc/bin/` depending on its usage
   frequency. Fish functions go to `fish/.config/fish/functions`.
