# Z80-MBC3 GPL Violation: Unified Analysis Report

**Subject:** Z80-MBC3 IOS Firmware (`IOS-S40427`) by Willem Vrieze  
**Reference project:** Z80-MBC2 IOS Firmware (`S220718-R290823`) by SuperFabius (GPLv3 licensed)  
**Analysis:** Binary reverse engineering — no MBC3 source available  
**Status:** All addresses and claims independently verified

---

## Correction Notice

An earlier draft of this analysis (produced by Gemini) contained a **systematic +0x0200 (512-byte) offset error** in every cited binary address. This arose from treating a padded Intel HEX view as raw binary offsets rather than converting to raw binary first. All addresses in this document are verified against the correctly converted binary. All substantive findings from the Gemini draft were confirmed as genuine; only the addresses required correction.

---

## 1. Executive Summary

The **Z80-MBC3** project distributes a closed-source ATmega4809 firmware binary that is demonstrably a derivative work of the GPLv3-licensed **Z80-MBC2** project. Evidence includes a 618-byte byte-for-byte identical Z80 machine code payload, 29 of 30 matching virtual I/O opcode constants, 24 meaningful verbatim string matches including the upstream project's own version stamp, and a structurally identical Z80 bus handshake. The developer has publicly and explicitly refused to release source code while selling hardware, creating an apparent GPLv3 compliance violation.

---

## 2. Provenance: Written Admission by the Developer

The following is the developer's own statement (Willem Vrieze, Facebook, January 3, 2023), in response to a user asking where to find the IOS source code. Screenshot preserved at `EVIDENCE/provenance/Willem_Vrieze_Facebook_20230103.png`.

> *"The firmware for the ATmega4809 IOS controller is only available as a hex file, which can be downloaded from the Z80-MBC3 page on Github. The current version (S10425) has not changed since it's release. It was published in case the ATmega chip needs to be reprogrammed over the serial port. **The source code of the IOS firmware was never published and won't be in the future.** The Z80-MBC3 is a hobby computer designed to experiment with Z80 applications solely. So it is not intended for development of alternative firmware for the Atmega4809."*

A follow-up reply in the same thread:

> *"There is only support for people who have ordered one from me."*

This is a timestamped, public, first-person admission that:
- Binary firmware is distributed without source code
- Source code will deliberately never be released
- Hardware is sold commercially incorporating this firmware

---

## 3. Project Context

| Property | Z80-MBC2 (Reference) | Z80-MBC3 (Suspect) |
|---|---|---|
| Author | SuperFabius | Willem Vrieze |
| MCU | ATmega32A | ATmega4809 |
| Firmware file | `S220718-R290823_IOS-Z80-MBC2.ino` | `IOS-S40427/IOS.hex` |
| Binary size | 32 KB (with bootloader) | 18 KB |
| Source available | Yes (GitHub, GPL) | No — explicitly refused |
| License declared | GPLv3 | None identified |
| Version string | `Z80-MBC2 - A040618 / IOS - S220718-R290823` | `Z80-MBC3. IOS (ATmega4809) - release S40427` |

Both projects implement an **I/O Subsystem (IOS)** — an AVR microcontroller that acts as a peripheral manager for a Z80 CPU, handling serial I/O, SD card access, RTC, and bootloading via a virtual opcode interface over the Z80 data bus. This is a highly specific architecture not found in standard Arduino projects.

**License provenance:** The upstream Z80-MBC2 GitHub repository identifies the project as **GPL-3.0 licensed** and includes a `LICENSE` file. The author's project page also states: "All the project files (SW & HW) are licensed under GPL v3." These public license declarations are the basis for the GPLv3 compliance analysis below.

---

## 4. Evidence

### 4.1 Embedded Z80 Payload — 618-Byte Exact Match

The Z80-MBC2 source defines a PROGMEM-stored Z80 machine code payload (`boot_A_[]`) implementing the `iLoad` Intel-Hex loader utility for the Z80 CPU. This is raw Z80 machine code — not AVR machine code — embedded as a static data array.

**Source declaration (`S220718-R290823_IOS-Z80-MBC2.ino`):**
```cpp
const byte boot_A_[] PROGMEM = {
  0x31, 0x10, 0xFD, 0x21, 0x52, 0xFD, 0xCD, 0xC6, 0xFE, 0xCD, 0x3E, 0xFF,
  0xCD, 0xF4, 0xFD, 0x3E, 0xFF, 0xBC, 0x20, 0x10, 0xBD, 0x20, 0x0D ...
  // 618 bytes total
};
```

**Verified match in suspect binary:**

| | Reference binary | Suspect binary |
|---|---|---|
| Offset | `0x0582` | `0x440D` |
| Match length | 618 bytes | 618 bytes |
| Match percentage | — | **100.0% (618/618)** |

This payload cannot arise from independent development. Z80 machine code hand-assembled or assembled from the same source would need to be the output of the same assembler pass to match byte-for-byte across 618 bytes, including internal jump offsets. It is a direct copy.

Additionally, the string `iLoad - Intel-Hex Loader - S200718` (where `S200718` is the MBC2's internal version stamp, July 2020) appears verbatim in the suspect binary at offset `0x444F`. No independently written iLoad implementation would carry this exact stamp.

### 4.2 Virtual I/O Opcode Constants — 29/30 Matching

The Z80-MBC2 defines a virtual I/O architecture: the Z80 CPU communicates with the AVR via specific numeric opcodes written to I/O ports. The full opcode table from the reference source was searched across all AVR registers in the suspect binary.

**Result: 29 of 30 opcode constants were found in AVR `CPI` comparison instructions.**

This is supporting evidence rather than the central proof by itself: a raw binary search for `CPI rX,<opcode>` can include coincidental comparisons elsewhere in the program. Its significance is the pattern: nearly the entire MBC2 virtual I/O vocabulary appears in the suspect firmware, while the one missing opcode (`0x89 SYSIRQ`) is a late MBC2 addition.

| Opcode | Function | In Suspect |
|--------|----------|-----------|
| `0x00` | USER LED | ✓ |
| `0x01` | SERIAL TX | ✓ |
| `0x03` | GPIOA Write | ✓ |
| `0x04` | GPIOB Write | ✓ |
| `0x05` | IODIRA Write | ✓ |
| `0x06` | IODIRB Write | ✓ |
| `0x07` | GPPUA Write | ✓ |
| `0x08` | GPPUB Write | ✓ |
| `0x09` | SELDISK | ✓ |
| `0x0A` | SELTRACK | ✓ |
| `0x0B` | SELSECT | ✓ |
| `0x0C` | WRITESECT | ✓ |
| `0x0D` | SETBANK | ✓ |
| `0x0E` | SETIRQ | ✓ |
| `0x0F` | SETTICK | ✓ |
| `0x10` | SETOPT | ✓ |
| `0x11` | SETSPP | ✓ |
| `0x12` | WRSPP | ✓ |
| `0x80` | USER KEY | ✓ |
| `0x81` | GPIOA Read | ✓ |
| `0x82` | GPIOB Read | ✓ |
| `0x83` | SYSFLAGS | ✓ |
| `0x84` | DATETIME | ✓ |
| `0x85` | ERRDISK | ✓ |
| `0x86` | READSECT | ✓ |
| `0x87` | SDMOUNT | ✓ |
| `0x88` | ATXBUFF | ✓ |
| `0x89` | SYSIRQ | ✗ absent |
| `0x8A` | GETSPP | ✓ |
| `0xFF` | No operation | ✓ |

**Note on SYSIRQ (0x89):** SYSIRQ was added late in the Z80-MBC2 development cycle. Its absence is consistent with the MBC3 being a port of an intermediate MBC2 revision, not the final one — which itself implies derivation from a specific known version of the MBC2 source tree.

The probability of independently designing a compatible Z80 peripheral system that happens to use all 29 of the same numeric opcode values, in the same roles, is negligible.

### 4.3 String Literals — 24 Meaningful Verbatim Matches

Of 58 strings (≥8 characters) extracted from the suspect binary, **25 extractor entries appear in both binaries**. One entry is whitespace-only padding, leaving **24 meaningful non-whitespace string matches**. Verified suspect offsets follow.

| String | Suspect Offset | Notes |
|--------|---------------|-------|
| `0: No change (` | `0x0371` | Boot/menu option text |
| `AUTOBOOT.BIN` | `0x4374` | Virtual ROM filename |
| `Address violation!` | `0x44DE` | iLoad error |
| `BASIC47.BIN` | `0x4381` | Virtual ROM filename |
| `COS.BIN` | `0x43C5` | Virtual ROM filename |
| `CPM22.BIN` | `0x4399` | Virtual ROM filename |
| `CPMLDR.COM` | `0x43AE` | Virtual ROM filename |
| `Checksum error!` | `0x44C6` | iLoad error |
| `DSxNAM.DAT` | `0x4685` | Virtual disk naming convention |
| `DSxNyy.DSK` | `0x4690` | Virtual disk naming convention |
| `Disk Set ` | `0x0486` | Disk management UI |
| `Enter your choice >` | `0x029D` | Menu prompt |
| `FORTH13.BIN` | `0x438D` | Virtual ROM filename |
| `IOS: Check SD and press a key to repeat` | `0x03B3` | SD error prompt |
| `IOS: Current ` | `0x022B` | Status/menu text |
| `IOS: Select boot mode or system parameters:` | `0x0383` | Main menu header |
| `Load error - System halted` | `0x4485` | Fatal iLoad error |
| `QPMLDR.BIN` | `0x43A3` | Virtual ROM filename |
| `Starting Address: ` | `0x4472` | iLoad prompt |
| `Syntax error!` | `0x44B8` | iLoad error |
| `UCSDLDR.BIN` | `0x43B9` | Virtual ROM filename |
| `Waiting input stream...` | `0x44A0` | iLoad status message |
| `iLoad - Intel-Hex Loader - S200718` | `0x444F` | **Carries MBC2 version date** |
| `iLoad: ` | `0x44D6` | iLoad message prefix |

The virtual disk filenames (`BASIC47.BIN`, `FORTH13.BIN`, `CPM22.BIN`, etc.) are particularly significant: these are the MBC2's custom virtual ROM image filenames. An independently written Z80 SBC firmware could use any filenames; choosing these exact names indicates direct copying of the MBC2's file access logic.

### 4.4 Z80 Bus Handshake — Identical Logic Structure

The core of both firmwares is a polling loop that monitors the Z80 bus for I/O transactions. The logic sequence in both is: check WAIT signal active → check A0 line → check WR line → read data bus.

**Z80-MBC2 source (`S220718-R290823_IOS-Z80-MBC2.ino`):**

```cpp
// Pin definitions: WAIT_=PB3, AD0=PC2, WR_=PC3
if (!digitalRead(WAIT_)) {
    if (digitalRead(A0_)) {
        if (!digitalRead(WR_)) {
            ioOpcode = PINA;           // store opcode from data bus
            digitalWrite(WAIT_, HIGH); // release WAIT
        }
    }
}
```

**Z80-MBC3 disassembly (verified at `0x193C`):**

```asm
193c:  16 99   sbic  0x02, 6   ; skip if VPORTA bit 6 (PA6/WAIT) clear
193e:  12 c0   rjmp  .+36      ; WAIT not active — loop back
1940:  11 99   sbic  0x02, 1   ; skip if VPORTA bit 1 (PA1/A0) clear
1942:  42 c0   rjmp  .+132     ; A0=0 (read cycle) — branch
1944:  8a b1   in    r24, 0x0a ; read VPORTC
194a:  83 ff   sbrs  r24, 3    ; skip if VPORTC bit 3 (PC3/WR) set
194c:  28 c1   rjmp  .+592     ; WR not active — branch
194e:  8e b1   in    r24, 0x0e ; read data bus (VPORTE = data)
1950:  80 93 6e 31  sts 0x316E,r24 ; store as ioOpcode
1954:  10 93 80 01  sts 0x0180,r17 ; release WAIT line
```

The ATmega4809 uses different physical pins and I/O register addresses than the ATmega32A, but the three-signal decision tree (WAIT → A0 → WR → read) is identical in structure. This is the signature of porting the same source code to a different MCU, not independent design.

---

## 5. Functional Map of Suspect Binary

Verified addresses in `IOS-S40427/IOS.hex` (converted to raw binary, all offsets from file start):

| Function | Verified Address | Description |
|---|---|---|
| Reset vector target | `0x0808`¹ | Entry point from AVR reset vector |
| Version string | `0x045A` | `Z80-MBC3. IOS (ATmega4809) - release S40427` |
| Main initialization | `0x1852` | `setup()` equivalent; hardware init and bootloader injection |
| Z80 bus handshake | `0x193C` | Core polling loop: WAIT/A0/WR signal monitoring |
| Opcode dispatcher | `0x19D8` | Jump table for handling I/O opcodes |
| Systick ISR | `0x2172` | Interrupt service routine for system tick (TCA0 overflow) |
| iLoad Z80 payload | `0x440D` | 618-byte Z80 machine code (100% match to MBC2 source) |
| iLoad string | `0x444F` | `iLoad - Intel-Hex Loader - S200718` |
| Virtual ROM filenames | `0x4374–0x43C5` | BASIC47.BIN, FORTH13.BIN, CPM22.BIN, etc. |
| Serial write routine | `0x3678` | Low-level serial output |
| System halt | `0x4364` | `cli` + dead loop on fatal error |

¹ The reset vector JMP instruction is at `0x0000`; its encoded target (word address `0x0404` = byte address `0x0808`) is where the startup code begins. The vector table entry at `0x0024` encodes a JMP to the Systick ISR, but due to the ATmega4809's avrxmega3 architecture being partially mis-decoded by the avr5 disassembler, the verified ISR prologue is at `0x2172` (confirmed by standard `push r1 / push r0 / in r0,SREG` ISR entry sequence) rather than `0x2372` (the raw vector table value, which reflects a word-address scaling difference in the xmega ISA).

---

## 6. Legal Analysis

**Applicable license:** GNU General Public License version 3 (GPLv3), as declared by the Z80-MBC2 project.

**Apparent compliance failures:**

**GPLv3 §6 — Corresponding Source for non-source distribution.** Conveying object code derived from GPLv3 software requires providing Corresponding Source or a valid written source offer through one of the methods allowed by GPLv3 §6. The developer's public statement says the IOS source "was never published and won't be in the future."

**GPLv3 §5 — Modified versions.** A modified or ported GPLv3 program must carry appropriate notices and the whole work must be licensed under GPLv3 when conveyed. The MBC3 IOS firmware is presented as closed-source firmware with no GPL declaration.

**GPLv3 notice and license-copy obligations.** GPLv3 requires preservation of copyright/license notices and conveyance under the license terms. No GPL notice, attribution to the Z80-MBC2 IOS, or GPL license copy has been identified with `IOS-S40427`.

**Commercial dimension.** The developer sells Z80-MBC3 hardware boards. Commercial distributors of GPL-derived software are held to the same (and arguably higher) standard of GPL compliance. The combination of commercial sale and explicit refusal to provide source is the clearest form of GPL violation.

---

## 7. Evidence Summary

| Evidence | Verified By | Strength |
|---|---|---|
| Developer's written public admission | Screenshot | **Critical** |
| 618-byte exact Z80 payload (100% match) | Python byte search | **Very Strong** |
| 29/30 matching I/O opcode constants | Python CPI search | **Supporting / Strong Pattern** |
| 24 meaningful verbatim string matches incl. MBC2 version stamp | Python string extraction | **Strong** |
| Identical Z80 bus handshake decision tree | avr-objdump | **Strong** |
| Self-identification as MBC2 successor | Binary string | **Supporting** |
| Identical virtual filesystem filename set | String extraction | **Supporting** |

---

## 8. Recommendations

1. **Notify the copyright holder.** SuperFabius (Z80-MBC2 author) holds the copyright and has primary standing to enforce the GPL. Contact them via the Z80-MBC2 GitHub repository with this report attached.

2. **File with an enforcement organization.** The [Software Freedom Conservancy](https://sfconservancy.org/copyleft-compliance/) and [gpl-violations.org](https://gpl-violations.org) both handle Arduino/embedded GPL cases. Attach: this report, both `.hex` files, the reference source, and the screenshot.

3. **Archive the evidence now.** Archive the Z80-MBC3 GitHub page (hex file, README, any download pages) and the Facebook thread before they are modified or deleted. Use the Wayback Machine or `wget --mirror`.

4. **Preserve the binary chain of custody.** Keep the original `IOS-S40427/IOS.hex` with its SHA256 hash documented:

```
# Suspect firmware
SHA256(IOS-S40427/IOS.hex) =
  0b81edbc7452574985b5314a98527da184dbb3e0ed9a95f232ebe9fdcdce54b5

SHA256(suspect_IOS-S40427.bin) =
  f00ea7582b732cdd6044beafc94cf91ffbd91af9cfe20f7849a584dae340e24a

# Reference firmware (with bootloader)
SHA256(S220718-R290823_IOS-Z80-MBC2.ino.with_bootloader_atmega32_16000000L.hex) =
  b8c0ceaf91551cf8bd870d8d1754ca2578766b6e0b1162ef4ed9a6c8d3f867d5

SHA256(reference_Z80-MBC2.bin) =
  45f536c8af0907d2b3419a6f6829ddfe23dcab6efa26bfd1c466be5690444692
```

---

## 9. Methodology Reference

### Tools Used

```bash
# AVR toolchain
apt install binutils-avr avr-libc gcc-avr

# Radare2
apt install radare2
```

### Binary Conversion

```bash
# Intel HEX → raw binary (REQUIRED before offset analysis)
avr-objcopy -I ihex -O binary suspect.hex suspect.bin
avr-objcopy -I ihex -O binary reference.hex reference.bin
```

> **Critical:** Always convert to raw binary before comparing offsets. Analyzing Intel HEX records directly introduces a systematic address error of approximately +0x200 bytes.

### Disassembly

```bash
# ATmega32A reference (avr5)
avr-objdump -m avr5 -b binary -D ref.bin > ref.asm

# ATmega4809 suspect — use avr5 as closest available approximation
# Note: ATmega4809 is avrxmega3; some JMP target addresses will be
# incorrectly scaled by the avr5 disassembler. Use string/byte search
# for ground-truth offsets; treat disassembly as approximate.
avr-objdump -m avr:5 -b binary -D suspect.bin > suspect.asm
```

### String Extraction

```python
import re

def get_strings(path, minlen=8):
    with open(path, "rb") as f:
        data = f.read()
    pattern = rb'[\x20-\x7E]{' + str(minlen).encode() + rb',}'
    return set(m.group().decode('ascii') for m in re.finditer(pattern, data))

ref_strs = get_strings("ref.bin")
sus_strs = get_strings("suspect.bin")
common   = sorted(ref_strs & sus_strs)
```

### Byte Sequence Search

```python
def find_payload(payload_hex, binary_path):
    payload = bytes.fromhex(payload_hex)
    with open(binary_path, "rb") as f:
        data = f.read()
    pos = data.find(payload)
    while pos != -1:
        print(f"Match at 0x{pos:04X}")
        pos = data.find(payload, pos + 1)

# iLoad Z80 payload fingerprint (first 14 bytes)
find_payload("3110FD2152FDCDC6FECD3EFFCDF4FD", "suspect.bin")
```

### Opcode Search

This search is a screening method for locating opcode constants in comparison instructions. Treat it as supporting evidence unless each hit is manually tied back to the dispatcher in the disassembly.

```python
with open("suspect.bin", "rb") as f:
    sus = f.read()

def find_cpi(opcode):
    """Search for CPI rX, opcode across all AVR registers r16-r31."""
    hits = []
    for reg in range(16, 32):
        d = reg - 16
        lo = (d << 4) | (opcode & 0x0F)
        hi = 0x30 | (opcode >> 4)
        pos = sus.find(bytes([lo, hi]))
        while pos != -1:
            hits.append((reg, pos))
            pos = sus.find(bytes([lo, hi]), pos + 1)
    return hits
```
