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

    reg[Registers.R_PC] = 0x3000;

    const running: u32 = 1;
    while (running) {
        var instr: u16 = mem_read(reg[R_PC]++);
        var op: u16 = instr >> 12;
    }

    switch (op) {
        Opcodes.OP_ADD => std.debug.print("OP_ADD\n", .{}),
        Opcodes.OP_AND => std.debug.print("OP_AND\n", .{}),
        Opcodes.OP_NOT => std.debug.print("OP_NOT\n", .{}),
        Opcodes.OP_BR => std.debug.print("OP_BR\n", .{}),
        Opcodes.OP_JMP => std.debug.print("OP_JMP\n", .{}),
        Opcodes.OP_JSR => std.debug.print("OP_JSR\n", .{}),
        Opcodes.OP_LD => std.debug.print("OP_LD\n", .{}),
        Opcodes.OP_LDI => std.debug.print("OP_LDI\n", .{}),
        Opcodes.OP_LDR => std.debug.print("OP_LDR\n", .{}),
        Opcodes.OP_LEA => std.debug.print("OP_LEA\n", .{}),
        Opcodes.OP_ST => std.debug.print("OP_ST\n", .{}),
        Opcodes.OP_STI => std.debug.print("OP_STI\n", .{}),
        Opcodes.OP_STR => std.debug.print("OP_STR\n", .{}),
        Opcodes.OP_TRAP => std.debug.print("OP_TRAP\n", .{}),
        Opcodes.OP_RES => std.debug.print("OP_RES\n", .{}),
        Opcodes.OP_RTI => std.debug.print("OP_RTI\n", .{}),
        else => std.debug.print("BAD CODE\n", .{}),
    }
}
