#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root relative to script location so this works from any cwd
BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
OUTDIR="$BASEDIR/gpl-violation-reports/package-$(date +%Y%m%d)"
mkdir -p "$OUTDIR"

# List of files to copy (relative to repo root)
files=(
  "LICENSE"
  "NOTICE.md"
  "README.md"
  "EVIDENCE/binaries/SHA256SUMS.txt"
  "EVIDENCE/binaries/suspect_IOS-S40427.hex"
  "EVIDENCE/binaries/suspect_IOS-S40427.bin"
  "EVIDENCE/binaries/reference_Z80-MBC2.hex"
  "EVIDENCE/binaries/reference_Z80-MBC2.bin"
  "EVIDENCE/iload_payload_match.txt"
  "EVIDENCE/opcode_verification.txt"
  "EVIDENCE/strings/common_strings_annotated.txt"
  "EVIDENCE/provenance/Willem_Vrieze_Facebook_20230103.png"
  "REFERENCE_SOURCE/S220718-R290823_IOS-Z80-MBC2.ino"
  "REPORT/Z80_MBC3_GPL_VIOLATION.md"
  "gpl-violation-reports/evidence_package_manifest.md"
  "gpl-violation-reports/verification_memo.md"
)

for f in "${files[@]}"; do
  SRC="$BASEDIR/$f"
  if [ -e "$SRC" ]; then
    mkdir -p "$(dirname "$OUTDIR/$f")"
    cp --preserve=timestamps "$SRC" "$OUTDIR/$f"
  else
    echo "Warning: $SRC not found, skipping" >&2
  fi
done

TARNAME="$BASEDIR/gpl-violation-evidence-$(date +%Y%m%d).tar.gz"
tar -C "$OUTDIR" -czf "$TARNAME" .
echo "Created $TARNAME containing the evidence package (from $OUTDIR)"
