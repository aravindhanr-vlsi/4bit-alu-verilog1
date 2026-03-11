# ALU Architecture — Block Diagram & Design Notes

## Top-Level Block Diagram

```
  ┌─────────────────────────────────────────────────────┐
  │                    4-bit ALU                        │
  │                                                     │
  │   A[3:0] ──────────────────────────────────────►   │
  │                      ┌───────────┐                  │
  │   B[3:0] ───────────►│  opcode   │──► result[4:0]  │
  │                      │  decoder  │                  │
  │   opcode[2:0] ──────►│  + logic  │──► zero_flag    │
  │                      └───────────┘                  │
  │                                     ──► carry_flag  │
  │                                     ──► neg_flag    │
  └─────────────────────────────────────────────────────┘
```

## Internal Datapath

```
opcode ──► MUX select
              │
    ┌─────────▼──────────┐
    │  000: Adder        │◄── A, B
    │  001: Subtractor   │◄── A, B
    │  010: AND gate     │◄── A, B
    │  011: OR gate      │◄── A, B
    │  100: XOR gate     │◄── A, B
    │  101: NOT gate     │◄── A
    │  110: Left Shifter │◄── A
    │  111: Right Shifter│◄── A
    └────────┬───────────┘
             │
         result[4:0]
             │
      ┌──────▼──────┐
      │  Flag Logic │──► zero_flag  (result[3:0] == 0)
      │             │──► neg_flag   (result[3])
      │             │──► carry_flag (from adder/shifter)
      └─────────────┘
```

## Design Decisions

1. **5-bit result output** — The extra MSB captures carry/overflow, 
   making the ALU usable in a real CPU datapath without losing information.

2. **Combinational design** — No clock required. Pure `always @(*)` 
   ensures synthesis tools treat this as combinational logic.

3. **Separate flag outputs** — Real processors (ARM, RISC-V) expose 
   similar flags (N, Z, C, V) for conditional branching.

4. **Parameterized opcodes** — `localparam` used instead of magic numbers 
   for readability and maintainability.
