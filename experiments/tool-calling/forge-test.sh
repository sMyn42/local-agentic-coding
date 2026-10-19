#!/usr/bin/env bash
set -euo pipefail

# Configuration
SUITE_DIR="tool-calling-suite"
MODEL="qwen2.5-coder:3b"
BASE_ENDPOINT="http://localhost:8887/v1"
FORGE_ENDPOINT="http://127.0.0.1:8081/v1"
BASELINE_OUT="results/baseline.json"
FORGE_OUT="results/with-forge.json"
FORGE_PORT="8081"
FORGE_BACKEND="http://localhost:8887"

# Ensure results directory exists
mkdir -p results

echo "=== Step 1: Baseline (no Forge) ==="
callprobe run --suite "$SUITE_DIR" --model "$MODEL" --endpoint "$BASE_ENDPOINT" --out "$BASELINE_OUT"

FORGE_PID=""
if lsof -i :"$FORGE_PORT" > /dev/null 2>&1; then
    echo "=== Step 2: Port $FORGE_PORT already in use — reusing existing Forge ==="
    lsof -i :"$FORGE_PORT"
else
    echo "=== Step 2: Starting Forge proxy on port $FORGE_PORT ==="
    python -m forge.proxy --backend-url "$FORGE_BACKEND" --port "$FORGE_PORT" &
    FORGE_PID=$!

    # Wait briefly for Forge to be ready
    sleep 3

    # Only clean up the instance we started
    cleanup() {
        if [[ -n "$FORGE_PID" ]] && kill -0 "$FORGE_PID" 2>/dev/null; then
            echo "Stopping Forge (PID $FORGE_PID) that this script started..."
            kill "$FORGE_PID"
            wait "$FORGE_PID" 2>/dev/null || true
        fi
    }
    trap cleanup EXIT
fi

echo "=== Step 3: With Forge ==="
callprobe run --suite "$SUITE_DIR" --model "$MODEL" --endpoint "$FORGE_ENDPOINT" --out "$FORGE_OUT"

echo "=== Step 4: Comparison ==="
callprobe compare "$BASELINE_OUT" "$FORGE_OUT" --format markdown > results/comparison.md
cat results/comparison.md
