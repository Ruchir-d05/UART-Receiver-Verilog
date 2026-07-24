# UART Receiver – Verilog RTL Design

A Verilog HDL implementation of a UART (Universal Asynchronous Receiver/Transmitter) Receiver with configurable clock-per-bit timing. The design receives serial UART data, converts it into an 8-bit parallel data byte, and generates a valid signal when a complete byte has been received.

The RTL design was developed and simulated using an Ubuntu-based open-source EDA environment.

---

## Project Overview

This project implements a **UART Receiver (RX)** using Verilog HDL.

The receiver monitors the `rx` serial input line, detects the UART start bit, samples and receives 8 data bits, processes the stop bit, and outputs the received byte through an 8-bit parallel data bus.

A Verilog testbench is used to transmit the test byte `8'hAA` serially and verify that the UART receiver correctly reconstructs the received data.

---

## Key Features

- Verilog HDL-based UART Receiver
- 8-bit serial-to-parallel data conversion
- Configurable `CLKS_PER_BIT` parameter
- Start-bit detection and validation
- 8-bit data reception
- Stop-bit processing
- `rx_valid` signal generation after successful reception
- FSM-based RTL architecture
- Verilog testbench for functional verification
- VCD waveform generation for simulation analysis
- Tested using the UART data byte `8'hAA`

---

## Block Diagram

```text
                 +-----------------------+
                 |      UART Receiver    |
                 |                       |
 UART Serial --->| rx                rx_data |---> 8-bit Parallel Data
 Input           |                       |
                 |                  rx_valid |---> Data Valid Signal
                 |                       |
 Clock --------->| clk                   |
                 +-----------------------+
RTL Architecture

The UART Receiver is implemented using a Finite State Machine (FSM) consisting of five states:

              +-------------+
              | STATE_IDLE  |
              +------+------+
                     |
                 rx = 0
                     |
                     v
             +---------------+
             | STATE_START   |
             +-------+-------+
                     |
             Valid Start Bit
                     |
                     v
             +---------------+
             |  STATE_DATA   |
             +-------+-------+
                     |
                8 Bits Received
                     |
                     v
             +---------------+
             |  STATE_STOP   |
             +-------+-------+
                     |
               Stop Bit Period
                     |
                     v
             +------------------+
             | STATE_CLEANUP    |
             +--------+---------+
                      |
                      v
                STATE_IDLE
FSM States
State	Description
STATE_IDLE	Waits for the UART line to go LOW, indicating a possible start bit.
STATE_START	Waits for half of the bit period and verifies that the start bit is still LOW.
STATE_DATA	Samples and stores the 8 incoming data bits into the shift register.
STATE_STOP	Waits for the stop-bit period before declaring the byte successfully received.
STATE_CLEANUP	Clears the rx_valid signal and returns the receiver to the idle state.
UART Receiver Interface
Signal	Direction	Description
clk	Input	System clock
rx	Input	UART serial data input
rx_valid	Output	Indicates that a complete byte has been received
rx_data[7:0]	Output	Received 8-bit parallel data
Parameter
Parameter	Default Value	Description
CLKS_PER_BIT	217	Number of clock cycles corresponding to one UART bit period
Data Reception Process

The UART Receiver follows this sequence:

The receiver remains in STATE_IDLE while the rx line is HIGH.
When rx becomes LOW, the receiver detects a possible start bit.
The receiver enters STATE_START and waits for approximately half a bit period.
The start bit is validated by checking that rx is still LOW.
The receiver enters STATE_DATA.
Each of the 8 data bits is sampled and stored in rx_shift_reg.
After receiving all 8 bits, the receiver enters STATE_STOP.
The receiver waits for the stop-bit period.
rx_valid is asserted for one clock cycle to indicate successful byte reception.
The receiver enters STATE_CLEANUP and then returns to STATE_IDLE.
RTL Design

The main RTL design is located in:

UART_RX.v

The module is instantiated as:

UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),
    .rx(rx),
    .rx_valid(),
    .rx_data(rx_data)
);

The default value of:

CLKS_PER_BIT = 217

is used in the design and testbench.

Testbench

The UART Receiver is verified using:

uart_tb.v

The testbench generates:

System clock
UART serial input
UART start bit
8-bit data transmission
UART stop bit

The testbench sends the following byte:

8'hAA

The byte is transmitted serially, beginning with the UART start bit followed by the 8 data bits and the stop bit.

The testbench then checks whether the received parallel data matches the transmitted byte.

The verification condition is:

if (rx_data == 8'hAA)
    $display("Test Passed - Correct Byte Received");
else
    $display("Test Failed - Incorrect Byte Received");
Testbench Timing Parameters

The testbench uses the following parameters:

parameter CLOCK_PERIOD_NS = 40;
parameter CLKS_PER_BIT = 217;
parameter BIT_PERIOD = 8600;

The system clock period is:

40 ns

The UART bit period used by the testbench is:

8600 ns

The testbench transmits the data byte:

0xAA
Simulation

The testbench generates a VCD waveform file using:

$dumpfile("dump.vcd");
$dumpvars();

The generated waveform can be viewed using GTKWave for signal-level analysis and debugging.

Important signals to observe include:

clk
rx
rx_data
rx_valid

The waveform can be used to verify the UART reception sequence and observe the transition between FSM states during data reception.

Expected Verification Result

For the transmitted byte:

8'hAA

the expected received data is:

rx_data = 8'hAA

The testbench displays:

Test Passed - Correct Byte Received

when the received data matches the transmitted byte.

Project Files
UART-Receiver-Verilog/
│
├── UART_RX.v       # UART Receiver RTL design
├── uart_tb.v       # Verilog testbench
└── README.md       # Project documentation
Tools & Technologies
Verilog HDL
RTL Design
Finite State Machine (FSM)
UART Protocol
RTL Simulation
Functional Verification
Testbench Development
VCD Waveform Analysis
GTKWave
Ubuntu/Linux
Open-Source EDA Tools
Skills Demonstrated
RTL Design using Verilog HDL
Digital Logic Design
FSM-based Design
UART Serial Communication
Serial-to-Parallel Data Conversion
Clock and Bit Timing Control
Testbench Development
Functional Verification
RTL Simulation
Waveform Debugging and Analysis
Open-Source EDA Tool Usage
Linux/Ubuntu-based Hardware Design Environment
Future Improvements

Possible future enhancements to the project include:

Add configurable UART baud rate support
Add parity-bit support
Support different data widths
Add configurable stop-bit support
Implement a complete UART Transmitter (TX)
Develop a combined UART TX/RX module
Add loopback testing
Perform RTL synthesis and analyze synthesis reports
Perform timing analysis
Implement the design on an FPGA
Author

Ruchir Dambhare

Electronics & Telecommunication Engineering
Interested in VLSI, RTL Design, Digital IC Design, and Embedded Systems

License

This project is available for educational and learning purposes.
