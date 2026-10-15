# rv32i_cpu

A single-cycle RISC-V processor implementing the RV32I base integer ISA, written
in SystemVerilog and simulated with Verilator.

## Status

Working and verified:

- All R-type arithmetic/logic instructions: `add`, `sub`, `sll`, `slt`, `sltu`,
  `xor`, `srl`, `sra`, `or`, `and`
- All I-type arithmetic/logic instructions: `addi`, `slti`, `sltiu`, `xori`,
  `ori`, `andi`, `slli`, `srli`, `srai`
- Branches: `beq`, `bne` — forward and backward, taken and not-taken

Implemented but not yet verified:

- Loads and stores (word-granularity only)

Not yet implemented:

- Remaining branches: `blt`, `bge`, `bltu`, `bgeu`
- Jumps (`jal`, `jalr`) and upper-immediate instructions (`lui`, `auipc`)
- Byte and halfword memory access (`lb`, `lh`, `lbu`, `lhu`, `sb`, `sh`)
- 5-stage pipelining

## Design notes

**Memory addressing** RISC-V defines a flat byte-addressed address space, so
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

**Branches.** The branch unit drives the ALU to subtract and tests the result,
asserting `pc_src` to select the branch target over PC+4. B-type immediates are
sign-extended with an implicit low zero, so targets are 2-byte aligned by
encoding even though RV32I requires 4-byte alignment in practice.

**Reset.** The register file and data memory are deliberately not reset — their
contents are architecturally undefined until software writes them, and resetting
them would prevent inference of LUTRAM and cost significant area. Instead the
write enables are gated so that no architectural state changes before the first
legitimate fetch; without this, a self-referential instruction such as
`addi x1, x1, 20` at address 0 would accumulate for as long as reset is held.
A pipelined design gets this for free via per-stage valid bits.

## Repository layout
