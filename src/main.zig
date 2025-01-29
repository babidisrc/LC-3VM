const std = @import("std");

const MEMORY_MAX = 1 << 16; // 65536
// store the memory in an array
var memory: [MEMORY_MAX]u16 = std.mem.zeroes([MEMORY_MAX]u16);

const Registers = enum(usize) { R0, R1, R2, R3, R4, R5, R6, R7, R_PC, R_COND, R_COUNT };

// store the registers in an array
var reg: [@intFromEnum(Registers.R_COUNT)]u16 = std.mem.zeroes([@intFromEnum(Registers.R_COUNT)]u16);

const Opcodes = enum(usize) {
    OP_BR = 0x0, // branch
    OP_ADD = 0x1, // add
    OP_LD = 0x2, // load
    OP_ST = 0x3, // store
    OP_JSR = 0x4, // jump register
    OP_AND = 0x5, // bitwise and
    OP_LDR = 0x6, // load register
    OP_STR = 0x7, // store register
    OP_RTI = 0x8, // unused
    OP_NOT = 0x9, // bitwise not
    OP_LDI = 0xA, // load indirect
    OP_STI = 0xB, // store indirect
    OP_JMP = 0xC, // jump
    OP_RES = 0xD, // reserved (unused)
    OP_LEA = 0xE, // load effective address
    OP_TRAP = 0xF, // execute trap
};

const Flags = struct {
    pub const FL_POS: u8 = 1 << 0; // 1
    pub const FL_ZRO: u8 = 1 << 1; // 2
    pub const FL_NEG: u8 = 1 << 2; // 4
};

fn mem_read(address: u16) u16 {
    return memory[address];
}

fn mem_write(address: u16, val: u16) u16 {
    memory[address] = val;
}

fn update_flags(r: Registers) void {
    if (reg[r] == 0) {
        reg[@intFromEnum(Registers.R_COUNT)] = Flags.FL_ZRO; // the value in r is zero
    } else if (reg[r] >> 15) {
        reg[@intFromEnum(Registers.R_COUNT)] = Flags.FL_NEG; // the value in r is z negative number
    } else reg[@intFromEnum(Registers.R_COUNT)] = Flags.FL_POS;
}

fn signExtend(x: u16, bit_count: u16) u16 {
    if (((x >> @intCast(bit_count - 1)) & 1) == 1) { // if the bth bit of n is 1 (number is negative)
        return x | (@as(u16, 0xFFFF) << @intCast(bit_count)); // fill up with 1s the remaining bits (15)
    }
    return x; // else return the number as it is
}

// functions to extract bits
fn FIMM(comptime i: u16) u16 {
    return (i >> 5) & 1;
}

fn DR(comptime i: u16) u16 { // Destination Register
    return (i >> 9) & 0x7;
}

fn SR1(comptime i: u16) u16 { // Source Register 1
    return (i >> 6) & 0x7;
}

fn SR2(comptime i: u16) u16 { // Source Register 2
    return i & 0x7;
}

fn IMM(comptime i: u16) u16 {
    return i & 0x1F;
}

// ADD
fn add(i: u16) void {
    if (FIMM(i) == 1) { // if the 5th bit is 1
        reg[DR(i)] = reg[SR1(i)] + signExtend(i); // we sign extend IMM5 and we add it to SR1 (add2)
    } else {
        reg[DR(i)] = reg[SR1(i)] + reg[SR2(i)]; // else we add the value of SR2 to SR1 (add1)
    }

    update_flags(DR(i));
}

const Handler = *const fn () void;

const jump_table = [16]Handler{ br, add, ld, st, jsr, andp, ldr, str, rti, not, ldi, sti, jmp, res, lea, trap };

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    if (args.len < 2) {
        std.debug.print("lc3 [image-file1] ...\n", .{});
        return;
    }

    reg[@intFromEnum(Registers.R_COND)] = Flags.FL_ZRO;

    reg[@intFromEnum(Registers.R_PC)] = 0x3000; // PC START

    var running: bool = true;
    while (running) {
        running = false;
    }
}
