![License](https://img.shields.io/badge/License-Apache_2.0-green)
![Simulation](https://img.shields.io/badge/Simulation-Passing-brightgreen)
![ISA](https://img.shields.io/badge/RISC--V-RV32IM-blue)
![HDL](https://img.shields.io/badge/HDL-Verilog-orange)

<img width="100" height="100" alt="image" src="https://github.com/user-attachments/assets/0404faf8-2102-43c9-b006-a23b83a9e697" />

# Shakti-eclass-core
This is the E-class core of the SHAKTI Processor family. The core has been completely developed using BSV (Bluespec System Verilog). This is the embedded class processor, built around a 3-stage in-order core. It is aimed at low-power and low compute applications and is capable of running basic RTOSs like FreeRTOS and Zephyr (eChronos is also being ported and will be released soon). Typical market segments include: smart-cards, IoT sensors, motor-controls and robotic platforms
## Overview
This repository contains a **standalone RTL-level verification setup** for a **RISC-V RV32IM processor core derived from the SHAKTI E-Class architecture.**

SHAKTI is an **indigenous RISC-V processor initiative from India (IIT Madras)**.
In this project, the **E-Class core RTL (generated in Verilog)** is integrated with a **minimal AXI4-Lite memory model** and verified independently at the core level, without a full SoC.

👉This repository focuses on:
- Functional verification of the processor core only
- Instruction fetch and execution using real RISC-V programs
- AXI4-Lite based instruction/data memory access
- Clean and reproducible simulation flow

## Key Features
- RV32IM RISC-V core (SHAKTI E-Class based)
- AXI4-Lite instruction and data interfaces
- Bare-metal program execution via HEX file
- Simple, readable Verilog testbench
- Waveform generation (VCD)
- Compatible with open-source simulators (Icarus Verilog)
  
## Core Architecture
- ISA: RISC-V RV32IM
- Pipeline: 3-stage in-order
  - Instruction Fetch & Decode
  - Execute
  - Memory Access & Write-back
- Register File + CSR support
- AXI4-Lite interface for instruction and data access
<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/990433ea-4473-4265-b445-37536ce96f26" />

### Repository Structure
```bash
.
|-- core
|   |-- FIFO1.v
|   |-- FIFO2.v
|   |-- FIFOL1.v
|   |-- RegFile.v
|   |-- mkalu.v
|   |-- mkcsr.v
|   |-- mkcsrfile.v
|   |-- mkeclass.v
|   |-- mkeclass_axi4lite.v
|   |-- mkmuldiv.v
|   |-- mkrestoring_div.v
|   |-- mkriscv.v
|   |-- mkstage1.v
|   |-- mkstage2.v
|   |-- mkstage3.v
|   |-- module_address_valid.v
|   |-- module_chk_interrupt.v
|   |-- module_decode_word32.v
|   |-- module_decoder_func_32.v
|   |-- module_fn_alu.v
|   |-- module_fn_decompress.v
|   |-- module_fn_pmp_lookup.v
|   `-- module_singlestep.v
|-- sim
|   |-- eclass.vcd
|   |-- main.c
|   |-- main.elf
|   |-- prog.hex
|   `-- sim.out
`-- tb
    |-- axi_lite_mem.v
    `-- tb_eclass.v

3 directories, 30 files
```

### Tool Dependencies
**Required Tools**
Install the following tools before running simulation:
```bash
sudo apt update
sudo apt install -y iverilog gtkwave gcc-riscv64-unknown-elf
```
**verify Installation:**
```bash
iverilog -V
riscv64-unknown-elf-gcc --version
```
### Program Flow and Verification Method
**Program Generation**
- Bare-metal C code is compiled using the RISC-V GNU toolchain
- Linked at address ```0x00001000```
- Converted to Verilog HEX format
```bash
cd sim
```
```bash
riscv64-unknown-elf-gcc \
  -march=rv32im \
  -mabi=ilp32 \
  -nostdlib \
  -Ttext=0x00001000 \
  -o main.elf \
  main.c
```
```bash
riscv64-unknown-elf-objcopy -O verilog main.elf prog.hex
```
## Quick Start (Core Verification)
### Clone the repository
```bash
git clone https://github.com/Shikha-Tiwari-Hub/shakti-eclass-core.git
```
### Compile the RTL
```bash
cd sim
```
```bash
iverilog -g2012 \
  ../tb/tb_eclass.v \
  ../tb/axi_lite_mem.v \
  ../core/*.v \
  -o sim.out
```
👇 Files should be:
```bash
.
|-- eclass.vcd
|-- main.c
|-- main.elf
|-- prog.hex
`-- sim.out
```
### Run simulation
```bash
vvp sim.out
```
**Expected output:**\
<img width="500" height="600" alt="image" src="https://github.com/user-attachments/assets/70bdcce6-b282-415b-b091-59e046c1b941" />\
_warning is ok👌_\
👉During simulation, the core successfully fetched instructions starting from the configured reset vector (```0x00001000```), executed instructions sequentially with correct program counter increments, and interacted correctly with the AXI4-Lite memory interface.

After reaching the end of the program, execution loops as expected for a minimal bare-metal workload without an explicit halt instruction.
### View Waveforms
```bash
gtkwave eclass.vcd
```
### Waveform Analysis
<img width="1000" height="1000" alt="Screenshot 2026-02-04 140502" src="https://github.com/user-attachments/assets/26a8cf3f-2ab0-4d09-a9dd-b50212fc93d0" />

## Verification Methodology
The core is verified using a standalone Verilog testbench.
Verification approach:
- Clock and reset driven from testbench
- AXI4-Lite memory model used for instruction and data access
- Program loaded via `prog.hex`
- Simulation performed using Icarus Verilog / Verilator
- Waveforms captured using VCD dumping
  
## Verified Functionality
The following core-level features are verified:
- Proper reset and startup behavior
- Instruction fetch over AXI4-Lite interface
- Program counter sequencing (PC + 4)
- AXI read address handshake (ARVALID/ARREADY)
- Basic pipeline progression
<img width="1812" height="390" alt="shakti waveform" src="https://github.com/user-attachments/assets/9744d9fd-26f1-456f-a4f0-efa685720455" />

**The waveform shows correct AXI4-Lite instruction fetch behavior with sequential PC progression (PC+4) and valid ARVALID/ARREADY handshakes after reset.**

## Conclusion
- SHAKTI E-Class RISC-V core successfully compiled and simulated.
- Program loaded via AXI-Lite memory using prog.hex.
- Instruction fetch and AXI handshakes verified through logs and GTKWave.
- Core functionality confirmed at RTL level.

<p align="center">
  🔹 End of Lab 🔹
</p>

