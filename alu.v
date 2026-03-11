// ============================================================
// 4-bit ALU — Verilog RTL Design
// Author  : Aravindhan
// Description: Performs 8 operations on two 4-bit operands
// Operations selected by 3-bit opcode
// ============================================================

module alu (
    input  [3:0] A,       // Operand A
    input  [3:0] B,       // Operand B
    input  [2:0] opcode,  // Operation selector
    output reg [4:0] result, // 5-bit result (4-bit + carry/overflow)
    output reg zero_flag,    // 1 if result is zero
    output reg carry_flag,   // 1 if carry/borrow out
    output reg neg_flag      // 1 if result is negative (MSB set)
);

    // Opcode definitions
    localparam ADD  = 3'b000;
    localparam SUB  = 3'b001;
    localparam AND  = 3'b010;
    localparam OR   = 3'b011;
    localparam XOR  = 3'b100;
    localparam NOT  = 3'b101;  // NOT A
    localparam SHL  = 3'b110;  // Shift A left by 1
    localparam SHR  = 3'b111;  // Shift A right by 1

    always @(*) begin
        // Default flag values
        carry_flag = 1'b0;

        case (opcode)
            ADD: begin
                result     = {1'b0, A} + {1'b0, B};
                carry_flag = result[4];
            end

            SUB: begin
                result     = {1'b0, A} - {1'b0, B};
                carry_flag = (A < B) ? 1'b1 : 1'b0; // borrow
            end

            AND: result = {1'b0, (A & B)};
            OR:  result = {1'b0, (A | B)};
            XOR: result = {1'b0, (A ^ B)};
            NOT: result = {1'b0, (~A)};

            SHL: begin
                result     = {A[3], A[2:0], 1'b0}; // shift left, MSB goes to carry
                carry_flag = A[3];
            end

            SHR: begin
                result     = {1'b0, 1'b0, A[3:1]}; // shift right, LSB dropped
                carry_flag = A[0];
            end

            default: result = 5'b00000;
        endcase

        // Update flags based on result
        zero_flag = (result[3:0] == 4'b0000) ? 1'b1 : 1'b0;
        neg_flag  = result[3]; // MSB of 4-bit result
    end

endmodule
