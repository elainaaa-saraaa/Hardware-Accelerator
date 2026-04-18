# Trinity-Core: Programmable 16-bit MAC Accelerator

This project is a high-density, programmable Multiply-Accumulate (MAC) hardware engine. Unlike fixed-function logic, Trinity-Core utilizes a custom 4-bit Instruction Set Architecture (ISA) and a dedicated 8-slot register file to execute complex mathematical sequences with deterministic timing.

## How does it work?
Trinity-Core is built using a Harvard Architecture. In simple terms, this means the brain of the chip has two separate "highways" for its work: one for the Instructions (the program) and one for the Data (the numbers).
By keeping these pathways separate, the chip doesn't get "clogged up." It can look at the next command while it's still finishing the math on the current one, making it much more efficient than basic designs.

## Main Components
- Instruction Memory (The Map): A small, dedicated storage area that holds the list of commands the chip needs to follow.
- Control Unit (The Brain): It reads the map, figures out what math needs to be done, and tells the- other parts of the chip when to move.
- Datapath & ALU (The Calculator): This is where the heavy lifting happens. It handles addition, subtraction, and multiplication with a 16-bit Accumulator, a special register that keeps a running total without losing accuracy.
- Register File (The Workbench): 8 high-speed "slots" (R0-R7) for current numbers. For this implementation, the core is pre-configured to load 10 and 5 as primary sample inputs upon reset to demonstrate mathematical accuracy.

## Modules Structure
- tt_um_accelerator.v
- regfile.v
- datapath.v
- defines.v
- tb_accelerator.v

## Functional Verification (Waveforms)
The design has been fully verified through behavioral simulation to ensure mathematical accuracy and timing stability. Below are the execution waveforms captured during the testbench run.
<img width="1874" height="547" alt="image" src="https://github.com/user-attachments/assets/7e1462e6-b3a5-46cf-8575-ab6c2670d876" />

To provide a clear "Golden Reference" for verification, the internal program is hard-coded to process the values 10 (R1) and 5 (R2). Upon pulsing the reset pin, the accelerator executes the following sequence:
-ADD: 10+5=15
-SUB: 10-5=5
-MUL: 10 x 5=50
-MAC: Adds the product (50) to the 16-bit Accumulator.
-STACC: Streams the final accumulation result to the output pins.

_Note: Each instruction is held for 128 clock cycles (timed strobe) to ensure high-margin signal stability and to allow for real-time visual monitoring._

## Author:
_Elaina Sara Sabu_


_Designed as a standalone Silicon IP core focused on efficient arithmetic offloading and Harvard Architecture implementation._
