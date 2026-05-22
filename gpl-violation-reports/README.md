# Evidence Package Helpers

This directory contains a formal verification memo and an evidence packaging helper for the Z80-MBC3 GPLv3 compliance investigation.

- `verification_memo.md`: concise verification memo summarizing the checks performed and results.
- `evidence_package_manifest.md`: list of evidence files and recommended inclusions.
- `create_package.sh`: helper script to assemble a tarball containing the core evidence files.

To build a portable evidence tarball, run:

```bash
./create_package.sh
```

The script will create `gpl-violation-evidence-<YYYYMMDD>.tar.gz` in the repository root and stage the copied package contents in `gpl-violation-reports/package-<YYYYMMDD>/`.
