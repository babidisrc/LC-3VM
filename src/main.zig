const std = @import("std");

const MEMORY_MAX = 1 << 16; // 65536
// store the memory in an array
var memory: [MEMORY_MAX]u16 = std.mem.zeroes([MEMORY_MAX]u16);

const Registers = enum { R0, R1, R2, R3, R4, R5, R6, R7, R_PC, R_COND, R_COUNT };

// store the registers in an array
var reg: [Registers.R_COUNT]u16 = std.mem.zeroes([Registers.R_COUNT]u16);

const Opcodes = enum {
    OP_BR, // branch
    OP_ADD, // add
    OP_LD, // load
    OP_ST, // store
    OP_JSR, // jump register
    OP_AND, // bitwise and
    OP_LDR, // load register
    OP_STR, // store register
    OP_RTI, // unused
    OP_NOT, // bitwise not
    OP_LDI, // load indirect
    OP_STI, // store indirect
    OP_JMP, // jump
    OP_RES, // reserved (unused)
    OP_LEA, // load effective address
    OP_TRAP, // execute trap
};

const Flags = struct {
    pub const FL_POS: u8 = 1 << 0; // 1
    pub const FL_ZRO: u8 = 1 << 1; // 2
    pub const FL_NEG: u8 = 1 << 2; // 4
};

pub fn main() void {
    reg[Registers.R_COUNT] = Flags.FL_ZRO;
}
