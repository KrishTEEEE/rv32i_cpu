#!/usr/bin/env bash
# Build a module with Verilator, run its testbench, and open the waveform in Surfer.
# Usage: ./sim.sh <module> [--no-wave]
# Expects <module>.sv and <module>_tb.cpp somewhere in the repo, and the testbench
# to write <module>.vcd. Submodules are looked up in the same folder as <module>.sv.
set -euo pipefail

MOD=${1:?usage: ./sim.sh <module> [--no-wave]}
ROOT=$(git rev-parse --show-toplevel)

# locate exactly one file by name, ignoring build output
find_one() {
    local hits
    hits=$(find "$ROOT" -name "$1" -not -path "*/build/*" -not -path "*/obj_dir*")
    [ -n "$hits" ] || { echo "error: $1 not found" >&2; exit 1; }
    [ "$(echo "$hits" | wc -l)" -eq 1 ] || { echo -e "error: multiple $1:\n$hits" >&2; exit 1; }
    echo "$hits"
}

SV=$(find_one "$MOD.sv")
TB=$(find_one "${MOD}_tb.cpp")
SVDIR=$(dirname "$SV")
OUT="$ROOT/build/$MOD"

# build: -y lets Verilator find submodules (counter -> counter.sv) next to the top file
verilator -Wall -Wno-fatal --cc --trace --exe --build -j 0 \
    --top-module "$MOD" -y "$SVDIR" --Mdir "$OUT" "$SV" "$TB"

# run from the RTL folder so relative paths like $readmemh("x.mem") resolve,
# then move the VCD into build/ so it doesn't clutter the source tree
(cd "$SVDIR" && "$OUT/V$MOD")
mv "$SVDIR/$MOD.vcd" "$OUT/$MOD.vcd"
echo "waveform: $OUT/$MOD.vcd"

[ "${2:-}" = "--no-wave" ] || surfer "$OUT/$MOD.vcd" >/dev/null 2>&1 &
