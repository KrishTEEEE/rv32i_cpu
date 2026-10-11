# rv32i_cpu

A single-cycle RISC-V processor implementing the RV32I base integer ISA, written
in SystemVerilog and simulated with Verilator.

## Status

Working and verified:

- All R-type arithmetic/logic instructions: `add`, `sub`, `sll`, `slt`, `sltu`,
  `xor`, `srl`, `sra`, `or`, `and`
- All I-type arithmetic/logic instructions: `addi`, `slti`, `sltiu`, `xori`,
  `ori`, `andi`, `slli`, `srli`, `srai`

Implemented but not yet verified:

- Loads and stores (word-granularity only)

Not yet implemented:

- Branches (`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`) — `pc_src` is currently
  tied low
- Jumps (`jal`, `jalr`) and upper-immediate instructions (`lui`, `auipc`)
- Byte and halfword memory access (`lb`, `lh`, `lbu`, `lhu`, `sb`, `sh`)
- 5-stage pipelining

## Design notes

**Memory addressing.** RISC-V defines a flat byte-addressed address space, so
the PC holds byte addresses and increments by 4. Instruction and data memory are
stored as 32-bit word arrays, indexed with `addr[ADDRESS_WIDTH+1:2]` — the low
two bits are discarded. The byte-addressed interface is architectural; the
word-wide storage is an implementation choice. Misaligned accesses are ignored
rather than trapped.

**Control unit.** Two-level decode, following Harris & Harris ch. 7:
`main_decode` maps the opcode to datapath control signals plus an intermediate
`alu_op`, and `alu_decode` combines `alu_op` with `funct3`, `funct7[5]` and
`opcode[5]` to produce `alu_control`. `opcode[5]` is needed because `funct7[5]`
is a function selector for R-type but immediate data for I-type — except for
shifts, where I-type reclaims it to distinguish `srli` from `srai`.

If rebuilt, a flat single-level decoder would be preferable: the encoded
intermediate stops paying for itself once the ALU has ten operations.

**Reset.** The register file and data memory are deliberately not reset — their
contents are architecturally undefined until software writes them, and resetting
them would prevent inference of LUTRAM and cost significant area. Instead the
write enables are gated so that no architectural state changes before the first
legitimate fetch; without this, a self-referential instruction such as
`addi x1, x1, 20` at address 0 would accumulate for as long as reset is held.
A pipelined design gets this for free via per-stage valid bits.

## Repository layout

rtl/ SystemVerilog source
tb/ Verilator C++ testbenches
sim.sh build and run a given testbench

## Building and running

./sim.sh cpu

Programs are loaded into instruction memory from `ins_mem.mem` via `$readmemh` —
one 32-bit instruction per line, 8 hex characters, no prefix. Waveforms are
dumped to VCD and viewed in Surfer.

## Verification

Unit testbenches cover the ALU and data memory. The CPU-level test runs a
21-instruction program exercising every implemented R-type and I-type
instruction from two source values (`x1 = 5`, `x2 = -3`), with results checked
against hand-computed expected values — including signed/unsigned pairs
(`slt`/`sltu`) and logical/arithmetic shift pairs (`srl`/`sra`) to catch
signedness bugs.

Still to add: directed testbenches for the control unit, register file and sign
extension; branch behaviour once branches exist; and the `riscv-tests` `rv32ui`
suite.
