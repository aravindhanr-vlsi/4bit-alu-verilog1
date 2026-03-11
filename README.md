# 4-bit ALU — Verilog RTL Design

A fully functional 4-bit Arithmetic Logic Unit (ALU) designed in Verilog HDL,
with a complete testbench featuring automatic pass/fail checking and waveform dump.

---

## 🔧 Operations Supported

| Opcode | Operation | Description           |
|--------|-----------|------------------------|
| 000    | ADD       | A + B (with carry out) |
| 001    | SUB       | A - B (with borrow)    |
| 010    | AND       | A AND B                |
| 011    | OR        | A OR B                 |
| 100    | XOR       | A XOR B                |
| 101    | NOT       | Bitwise NOT of A       |
| 110    | SHL       | Logical shift A left   |
| 111    | SHR       | Logical shift A right  |

---

## 📁 Project Structure

```
4bit-alu-verilog/
├── src/
│   └── alu.v            # RTL design (synthesizable)
├── simulation/
│   └── alu_tb.v         # Testbench with 16 test cases
├── docs/
│   └── block_diagram.md # Architecture description
└── README.md
```

---

## 🚀 How to Simulate

### Option 1: EDA Playground (browser — no install needed)
1. Go to [https://edaplayground.com](https://edaplayground.com)
2. Paste `src/alu.v` in the **Design** panel
3. Paste `simulation/alu_tb.v` in the **Testbench** panel
4. Select **Icarus Verilog** as simulator
5. Check **Open EPWave** to view waveforms
6. Click **Run**

### Option 2: Icarus Verilog (local)
```bash
# Install
sudo apt install iverilog gtkwave   # Linux
brew install icarus-verilog         # macOS

# Compile and run
iverilog -o alu_sim src/alu.v simulation/alu_tb.v
vvp alu_sim

# View waveform
gtkwave simulation/alu_wave.vcd
```

---

## 📊 Expected Output

```
========================================
       4-bit ALU Testbench Start        
========================================
PASS | ADD  3+5=8  | A=0011 B=0101 op=000 | result=01000
PASS | ADD  15+1 carry | A=1111 B=0001 op=000 | result=10000
...
========================================
  PASSED: 16 | FAILED: 0
========================================
```

---

## 🏗️ Architecture

```
         A[3:0] ──┐
                  ├──► ALU ──► result[4:0]
         B[3:0] ──┘     │
                         ├──► zero_flag
    opcode[2:0] ────────►├──► carry_flag
                         └──► neg_flag
```

**Flags:**
- `zero_flag` — Set when result is 0x0
- `carry_flag` — Set on carry out (ADD) or borrow (SUB) or shifted-out bit (SHL/SHR)
- `neg_flag` — Set when MSB of result is 1 (negative in 2's complement)

---

## 🛠️ Tools Used

- **Language:** Verilog HDL (synthesizable RTL)
- **Simulator:** Icarus Verilog / EDA Playground
- **Waveform Viewer:** GTKWave

---

## 📚 What I Learned

- Structuring RTL code for synthesis (combinational `always @(*)` blocks)
- Writing self-checking testbenches with pass/fail automation
- Interpreting simulation waveforms using GTKWave
- Flag logic (zero, carry, negative) used in real processor datapaths

---

## 👤 Author

**Aravindhan** —  VLSI & Embedded Systems student 
📧 aravindhanrajan8@gmail.com 
🔗 [LinkedIn](https://linkedin.com/in/yourprofile](https://www.linkedin.com/in/aravindhan-rajan-0a9a36325/)
