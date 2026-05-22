# Z80-MBC3 GPL Violation — Evidence Archive

**Subject:** Willem Vrieze / Z80-MBC3 project  
**Claim:** IOS firmware (`IOS-S40427`) is a derivative of the GPLv3-licensed Z80-MBC2 IOS firmware by SuperFabius, distributed without source code in apparent violation of the GPLv3.

---

## Start Here

**`REPORT/Z80_MBC3_GPL_VIOLATION.md`** — The unified, fully verified analysis report. All addresses independently confirmed. Read this first.

## License Notice

This repository contains GPLv3-covered Z80-MBC2 reference material, preserved suspect firmware evidence, and original analysis/reporting. The GPLv3 license text is included as `LICENSE`, and repository-specific attribution and scope notes are in `NOTICE.md`.

---

## Archive Structure

```
LICENSE                           GNU GPLv3 license text
NOTICE.md                         License scope, attribution, and evidence notes

REPORT/
  Z80_MBC3_GPL_VIOLATION.md      Unified report — all findings, corrected addresses,
                                  legal analysis, and recommendations
  how z80-mbc3 violates the GPL.odt
                                  Narrative/community-facing version of the report

EVIDENCE/
  binaries/
    suspect_IOS-S40427.hex        Suspect firmware as distributed by Willem Vrieze
    suspect_IOS-S40427.bin        Converted to raw binary for analysis
    reference_Z80-MBC2.hex        GPL reference firmware (with bootloader)
    reference_Z80-MBC2.bin        Converted to raw binary for analysis
    SHA256SUMS.txt                Cryptographic hashes for chain of custody

  disassembly/
    suspect_IOS-S40427.asm        Full AVR disassembly of suspect binary
    reference_Z80-MBC2.asm        Full AVR disassembly of reference binary

  strings/
    suspect_strings.txt           All printable strings from suspect binary
    reference_strings.txt         All printable strings from reference binary
    common_strings.txt            Strings present in both binaries (raw)
    common_strings_annotated.txt  Common strings with verified suspect offsets

  iload_payload_match.txt         618-byte Z80 payload hex dump + 100% match proof
  opcode_verification.txt         All 30 opcodes searched; 29/30 found with addresses

  provenance/
    Willem_Vrieze_Facebook_20230103.png
                                  Developer explicitly states source "was never
                                  published and won't be in the future"

REFERENCE_SOURCE/
  S220718-R290823_IOS-Z80-MBC2.ino   GPL reference source (main sketch)
  pff.cpp / pff.h / pffconf.h        PetitFS SD card library
  avr_mmcp.cpp / diskio.h            Disk I/O layer
  integer.h / PetitFS.h / pffArduino.h
```

---

## Key Findings

| Evidence | Result |
|---|---|
| Developer's public statement | Explicit written refusal to provide source |
| Z80 iLoad payload (618 bytes) | 100% byte-for-byte match |
| I/O opcode constants (30 entries) | 29/30 constants found in suspect comparisons |
| String literals | 24 meaningful verbatim matches including MBC2 version stamp |
| Bus handshake logic | Structurally identical (verified at 0x193C) |

---

## SHA256 Hashes

```
suspect_IOS-S40427.hex:
  0b81edbc7452574985b5314a98527da184dbb3e0ed9a95f232ebe9fdcdce54b5

suspect_IOS-S40427.bin:
  f00ea7582b732cdd6044beafc94cf91ffbd91af9cfe20f7849a584dae340e24a

reference_Z80-MBC2.hex:
  b8c0ceaf91551cf8bd870d8d1754ca2578766b6e0b1162ef4ed9a6c8d3f867d5

reference_Z80-MBC2.bin:
  45f536c8af0907d2b3419a6f6829ddfe23dcab6efa26bfd1c466be5690444692
```

---

## Reporting Contacts

- **SuperFabius** (copyright holder) — Z80-MBC2 GitHub repository
- **Software Freedom Conservancy** — https://sfconservancy.org/copyleft-compliance/
- **gpl-violations.org** — https://gpl-violations.org
