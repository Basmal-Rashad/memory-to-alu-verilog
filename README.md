# Memory-to-ALU Data Processing System
Verilog HDL implementation of a complete digital data processing pipeline integrating RAM, PISO, SIPO, and ALU with functional verification using ModelSim.


## Overview

This project implements a complete digital data processing system using Verilog HDL. It demonstrates how multiple hardware modules work together in a single processing pipeline.

The system stores a 20-bit instruction in RAM, reads it back, converts the parallel data into a serial stream using a PISO (Parallel-In Serial-Out) register, reconstructs the original instruction using a SIPO (Serial-In Parallel-Out) register, and finally executes the instruction through an 8-bit ALU.

The project highlights modular design, parameterized hardware, and the integration of memory, data transmission, and processing units.

---

## Features

- Parameterized RAM design
- Parallel-to-Serial (PISO) conversion
- Serial-to-Parallel (SIPO) conversion
- 8-bit Arithmetic Logic Unit (ALU)
- Parameterized modules
- Active-low asynchronous reset

---

## Project Structure

```text
memory-to-alu-verilog/
│
├── RAM.v
├── piso.v
├── sipo.v
├── alu.v
├── top.v

```

---

# System Architecture

```text
          +-----------+
          |    RAM    |
          +-----------+
                │
      20-bit Parallel Data
                │
                ▼
          +-----------+
          |   PISO    |
          +-----------+
                │
          Serial Stream
                │
                ▼
          +-----------+
          |   SIPO    |
          +-----------+
                │
     Reconstructed Data
                │
                ▼
          +-----------+
          |    ALU    |
          +-----------+
                │
         ALU Result & Zero Flag
```

---

# Instruction Format

Each memory location stores a 20-bit instruction.

| Bits | Description |
|------|-------------|
| 19 | ALU Enable |
| 18:16 | Opcode |
| 15:8 | Operand A |
| 7:0 | Operand B |

Example:

```text
{ALU_EN, OPCODE, OPERAND_A, OPERAND_B}
```

Example instruction written by the testbench:

```text
{1'b1, 3'b000, 8'd5, 8'd3}
```

Meaning:

- ALU Enabled
- Opcode = ADD
- Operand A = 5
- Operand B = 3

Expected Result:

```text
ALU Output = 8
```

---

# Module Description

## RAM

Stores 20-bit instructions.

### Inputs

| Signal | Description |
|---------|-------------|
| clk | System clock |
| rst_n | Active-low reset |
| wr_en | Write enable |
| rd_en | Read enable |
| adrss | Memory address |
| din | Input data |

### Outputs

| Signal | Description |
|---------|-------------|
| dout | Read data |
| ram_valid | Read valid signal |

### Operation

- Clears the memory during reset.
- Stores data when `wr_en` is asserted.
- Outputs stored data when `rd_en` is asserted.
- Generates `ram_valid` after a successful read.

---

## PISO (Parallel-In Serial-Out)

Converts a 20-bit parallel word into a serial bit stream.

### Inputs

| Signal | Description |
|---------|-------------|
| parallel_in | Parallel data |
| en | Load enable |
| clk | Clock |
| rst_n | Reset |

### Outputs

| Signal | Description |
|---------|-------------|
| serial_out | Serial output |
| valid | Indicates active transmission |

### Operation

- Loads the received parallel instruction.
- Transmits one bit per clock cycle.
- Keeps `valid` asserted until all bits are transmitted.

---

## SIPO (Serial-In Parallel-Out)

Receives serial data and reconstructs the original instruction.

### Inputs

| Signal | Description |
|---------|-------------|
| serial_in | Serial data |
| shift_en | Shift enable |
| clk | Clock |
| rst_n | Reset |

### Output

| Signal | Description |
|---------|-------------|
| parallel_out | Reconstructed 20-bit instruction |

### Operation

- Shifts one bit into the register every clock cycle.
- Rebuilds the original parallel instruction.

---

## ALU

Performs arithmetic and logic operations.

### Inputs

| Signal | Description |
|---------|-------------|
| alu_en | Enable signal |
| opcode | Operation selector |
| in_a | Operand A |
| in_b | Operand B |

### Outputs

| Signal | Description |
|---------|-------------|
| alu_out | Operation result |
| a_is_zero | Indicates if Operand A equals zero |

---

## Supported Operations

| Opcode | Operation |
|---------|-----------|
| 000 | Addition |
| 001 | Subtraction |
| 010 | Bitwise AND |
| 011 | Bitwise XOR |
| 100 | Bitwise OR |
| 101 | Pass Operand A |

When `alu_en` is deasserted, the ALU output is forced to zero.

---

# Top Module

The top module integrates all system components.

```text
RAM
 ↓
PISO
 ↓
SIPO
 ↓
ALU
```

Data flows automatically from memory to the ALU through the serial communication path.

---

# Verification

The testbench verifies the complete processing pipeline.

## Test Scenario

### Step 1

Apply reset.

**Expected Result**

- RAM is cleared.
- PISO and SIPO registers are reset.
- ALU output becomes zero.

---

### Step 2

Write the following instruction into RAM.

```text
Enable = 1
Opcode = ADD
Operand A = 5
Operand B = 3
```

---

### Step 3

Read the stored instruction.

**Expected Result**

- `ram_valid` becomes HIGH.
- RAM outputs the stored instruction.

---

### Step 4

PISO starts serial transmission.

**Expected Result**

- One bit is transmitted every clock cycle.
- `valid` remains HIGH until all 20 bits are sent.

---

### Step 5

SIPO reconstructs the instruction.

**Expected Result**

- `parallel_out` matches the original instruction stored in RAM.

---

### Step 6

The reconstructed instruction reaches the ALU.

**Expected Result**

```
Operand A = 5
Operand B = 3
Opcode = ADD
```

---

### Step 7

ALU executes the operation.

**Expected Result**

```text
alu_out = 8
a_is_zero = 0
```

---

# Expected Data Flow

```text
Reset
   │
   ▼
Write Instruction to RAM
   │
   ▼
Read Instruction
   │
   ▼
Parallel Data Output
   │
   ▼
PISO Serialization
   │
   ▼
Serial Bit Stream
   │
   ▼
SIPO Reconstruction
   │
   ▼
Instruction Decoding
   │
   ▼
ALU Execution
   │
   ▼
Result Available
```

---

rification
- Hardware Integration
