# Neon Heist MVP Plan

## Prototype Status

The initial Godot scaffold targets the PRD Phase 1 prototype: movement, camera behavior, procedural rooms, one biome, enemies, hacking, extraction, and VFX feedback.

## MVP Gap List

- Biomes: only the Financial Mainframe palette/feel exists. Add Quantum Archive as the second MVP biome.
- Programs: ten programs are cataloged, but only EMP Blast, Chain Lightning, and Time Slow have full cast behavior.
- Progression: credits and runs persist locally; class/cosmetic unlock flows still need UI and rules.
- Soundtrack: no dynamic music system yet.
- Saves: local save exists, but encryption is not implemented.
- iOS: project uses mobile renderer/orientation settings, but needs export preset and device profiling.

## Recommended Next Slice

Build collision-aware vault geometry and extraction flow polish first. That will make every later system easier to tune because movement, pressure, and readability depend on the map having real boundaries.
