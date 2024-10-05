## FIFO Verification Project

## Overview
This project focuses on verifying a First-In-First-Out (FIFO) buffer implemented in SystemVerilog. The objective is to develop a robust verification environment to test the functionality of the FIFO design using Universal Verification Methodology (UVM). The verification environment will ensure that the FIFO behaves as expected under various scenarios, including normal operation, corner cases, and stress conditions.

## Prerequisites
Before running this project, ensure you have the following tools installed:

SystemVerilog Compiler/Simulator: (e.g., VCS, ModelSim, Questa)

## Design Description

The FIFO (First-In-First-Out) buffer is a hardware design that stores data and retrieves it in the order it was entered. It supports:

Push: Input data is added to the FIFO.
Pop: Output data is retrieved from the FIFO.
Full/Empty Flags: Indicate when the FIFO is full or empty.
Overflow/Underflow Protection: Guards against illegal operations when the FIFO is full or empty.

## Verification Environment
The verification environment uses key components to ensure correctness:

FIFO Interface (fifo_if.sv): Connects the testbench with the FIFO DUT. It includes signals like push, pop, data_in, data_out, full, and empty.

Monitor (fifo_monitor.sv): Observes the transactions happening at the interface. The monitor captures the operations (push/pop) and logs the data for comparison.

Scoreboard (fifo_scoreboard.sv): Compares the actual data from the FIFO with expected data. It flags any mismatches between the FIFO’s behavior and the expected results.

SystemVerilog Assertions (SVA):

Assertions (in FIFO.sv file) are used to check key properties like overflow/underflow conditions, ensuring the FIFO's behavior adheres to the expected specifications.
Transaction (fifo_transaction.sv): A class-based representation of the stimulus (push/pop operations and data). This enables clean and reusable stimulus generation.

Testbench (fifo_testbench.sv): The top-level testbench that instantiates all components, connects the DUT, and drives stimulus to the design.
