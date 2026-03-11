// ============================================================
// 4-bit ALU Testbench
// Author  : Aravindhan
// Description: Exhaustive test cases for all 8 ALU operations
//              with automatic pass/fail checking
// ============================================================

`timescale 1ns / 1ps

module alu_tb;

    // ---- Inputs (reg so we can drive them) ----
    reg  [3:0] A;
    reg  [3:0] B;
    reg  [2:0] opcode;

    // ---- Outputs (wire) ----
    wire [4:0] result;
    wire zero_flag, carry_flag, neg_flag;

    // ---- Instantiate the ALU ----
    alu uut (
        .A          (A),
        .B          (B),
        .opcode     (opcode),
        .result     (result),
        .zero_flag  (zero_flag),
        .carry_flag (carry_flag),
        .neg_flag   (neg_flag)
    );

    // ---- Test Counter ----
    integer pass_count = 0;
    integer fail_count = 0;

    // ---- Task: check result ----
    task check;
        input [4:0] expected;
        input [63:0] test_name; // just for display
        begin
            #10; // wait for combinational logic to settle
            if (result === expected) begin
                $display("PASS | %0s | A=%b B=%b op=%b | result=%b",
                         test_name, A, B, opcode, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %0s | A=%b B=%b op=%b | expected=%b got=%b",
                         test_name, A, B, opcode, expected, result);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("========================================");
        $display("       4-bit ALU Testbench Start        ");
        $display("========================================");

        // ---- ADD ----
        A = 4'b0011; B = 4'b0101; opcode = 3'b000; // 3 + 5 = 8
        check(5'b01000, "ADD  3+5=8 ");

        A = 4'b1111; B = 4'b0001; opcode = 3'b000; // 15 + 1 = 16 (carry)
        check(5'b10000, "ADD  15+1 carry");

        A = 4'b0000; B = 4'b0000; opcode = 3'b000; // 0 + 0 = 0 (zero flag)
        check(5'b00000, "ADD  0+0=0 ");

        // ---- SUB ----
        A = 4'b1000; B = 4'b0011; opcode = 3'b001; // 8 - 3 = 5
        check(5'b00101, "SUB  8-3=5 ");

        A = 4'b0010; B = 4'b0010; opcode = 3'b001; // 2 - 2 = 0 (zero flag)
        check(5'b00000, "SUB  2-2=0 ");

        // ---- AND ----
        A = 4'b1100; B = 4'b1010; opcode = 3'b010; // 1100 & 1010 = 1000
        check(5'b01000, "AND  1100&1010");

        A = 4'b1111; B = 4'b0000; opcode = 3'b010; // 1111 & 0000 = 0000
        check(5'b00000, "AND  1111&0000");

        // ---- OR ----
        A = 4'b1100; B = 4'b0011; opcode = 3'b011; // 1100 | 0011 = 1111
        check(5'b01111, "OR   1100|0011");

        A = 4'b0000; B = 4'b0000; opcode = 3'b011; // 0000 | 0000 = 0000
        check(5'b00000, "OR   0|0=0    ");

        // ---- XOR ----
        A = 4'b1010; B = 4'b1010; opcode = 3'b100; // same inputs = 0
        check(5'b00000, "XOR  same=0  ");

        A = 4'b1010; B = 4'b0101; opcode = 3'b100; // 1010 ^ 0101 = 1111
        check(5'b01111, "XOR  1010^0101");

        // ---- NOT ----
        A = 4'b1010; B = 4'bxxxx; opcode = 3'b101; // NOT 1010 = 0101
        check(5'b00101, "NOT  1010=0101");

        A = 4'b0000; B = 4'bxxxx; opcode = 3'b101; // NOT 0000 = 1111
        check(5'b01111, "NOT  0000=1111");

        // ---- SHL (Shift Left) ----
        A = 4'b0011; B = 4'bxxxx; opcode = 3'b110; // 0011 << 1 = 0110
        check(5'b00110, "SHL  0011->0110");

        A = 4'b1001; B = 4'bxxxx; opcode = 3'b110; // 1001 << 1 = 0010, carry=1
        check(5'b10010, "SHL  1001->carry");

        // ---- SHR (Shift Right) ----
        A = 4'b1100; B = 4'bxxxx; opcode = 3'b111; // 1100 >> 1 = 0110
        check(5'b00110, "SHR  1100->0110");

        A = 4'b0001; B = 4'bxxxx; opcode = 3'b111; // 0001 >> 1 = 0000, carry=1
        check(5'b00000, "SHR  0001->carry");

        // ---- Summary ----
        $display("========================================");
        $display("  PASSED: %0d | FAILED: %0d", pass_count, fail_count);
        $display("========================================");

        $finish;
    end

    // ---- Optional: dump waveform for GTKWave ----
    initial begin
        $dumpfile("simulation/alu_wave.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule
