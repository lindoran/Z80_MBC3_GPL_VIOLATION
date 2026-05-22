# Verification Memo — Z80-MBC3 / IOS-S40427

Date: 2026-05-20

Subject: Independent technical verification of evidence in the `Z80_MBC3_GPL_VIOLATION` repository.

## Summary of Checks Performed

- SHA256 verification: Confirmed declared hashes in `EVIDENCE/binaries/SHA256SUMS.txt` match the binary files in `EVIDENCE/binaries/`.
- iLoad payload match: Extracted `boot_A_[]` (618 bytes) from `REFERENCE_SOURCE/S220718-R290823_IOS-Z80-MBC2.ino` and found an exact byte-for-byte match (618/618) at offset `0x440D` in `EVIDENCE/binaries/suspect_IOS-S40427.bin`.
- Strings: Extracted printable ASCII strings (>=8 chars) and confirmed 25 common extractor entries, including 24 meaningful non-whitespace string matches; see `EVIDENCE/strings/common_strings_annotated.txt` for offsets and list. The distinctive stamp `iLoad - Intel-Hex Loader - S200718` appears in both binaries.
- Opcode constants: Reviewed `EVIDENCE/opcode_verification.txt` — 29 of 30 virtual I/O opcode constants from the reference appear in AVR `CPI` comparison instructions in the suspect binary (only `0x89 SYSIRQ` absent). This is supporting evidence and should be read alongside the stronger payload and string evidence.

## Conclusions

The technical checks above confirm the repository's central claims: the suspect `IOS-S40427` firmware contains a direct copy of the Z80 iLoad payload, shares a large set of verbatim strings (including version stamps), and contains nearly the full virtual I/O opcode vocabulary (29/30 constants). Together with the documented developer admission, these findings support the report's conclusion that the suspect firmware is a derivative of the GPLv3-licensed Z80-MBC2 project.

## Relevant Files

Paths are relative to the repository root.

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

Signed-off-by: Automated verification script and review
