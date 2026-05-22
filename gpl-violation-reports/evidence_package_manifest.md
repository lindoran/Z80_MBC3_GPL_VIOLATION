# Evidence Package Manifest

This manifest lists the core files to include in a portable evidence package for submission or archival.

Recommended inclusions (relative paths):

- `LICENSE`
- `NOTICE.md`
- `README.md`
- `EVIDENCE/binaries/SHA256SUMS.txt`
- `EVIDENCE/binaries/suspect_IOS-S40427.hex`
- `EVIDENCE/binaries/suspect_IOS-S40427.bin`
- `EVIDENCE/binaries/reference_Z80-MBC2.hex`
- `EVIDENCE/binaries/reference_Z80-MBC2.bin`
- `EVIDENCE/iload_payload_match.txt`
- `EVIDENCE/opcode_verification.txt`
- `EVIDENCE/strings/common_strings_annotated.txt`
- `EVIDENCE/provenance/Willem_Vrieze_Facebook_20230103.png`
- `REFERENCE_SOURCE/S220718-R290823_IOS-Z80-MBC2.ino`
- `REPORT/Z80_MBC3_GPL_VIOLATION.md`
- `gpl-violation-reports/evidence_package_manifest.md`
- `gpl-violation-reports/verification_memo.md`

Notes:
- Preserve file timestamps and SHA256 sums where possible.
- Do not alter or re-encode the binary files; provide raw `.bin` and `.hex` files.
- Include `LICENSE` and `NOTICE.md` so the GPLv3-covered reference material and repository-specific attribution notes travel with the package.
- Include proof of the upstream GPLv3 license declaration when submitting externally, such as an archived copy of the upstream GitHub repository license page or the Just4Fun Z80-MBC2 licensing section.
