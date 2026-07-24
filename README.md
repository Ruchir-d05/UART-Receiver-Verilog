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
 ```

## FSM States 

| State           | Description                                                                    |
| --------------- | ------------------------------------------------------------------------------ |
| `STATE_IDLE`    | Waits for the UART line to go LOW, indicating a possible start bit.            |
| `STATE_START`   | Waits for half of the bit period and verifies that the start bit is still LOW. |
| `STATE_DATA`    | Samples and stores the 8 incoming data bits into the shift register.           |
| `STATE_STOP`    | Waits for the stop-bit period before declaring the byte successfully received. |
| `STATE_CLEANUP` | Clears the `rx_valid` signal and returns the receiver to the idle state.       |

## UART Recevier Interface
| Signal         | Direction | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `clk`          | Input     | System clock                                     |
| `rx`           | Input     | UART serial data input                           |
| `rx_valid`     | Output    | Indicates that a complete byte has been received |
| `rx_data[7:0]` | Output    | Received 8-bit parallel data                     |

## Parameter
| Parameter      | Default Value | Description                                                 |
| -------------- | ------------: | ----------------------------------------------------------- |
| `CLKS_PER_BIT` |         `217` | Number of clock cycles corresponding to one UART bit period |

- **Tools & Technologies:** Verilog HDL · RTL Design · FSM Design · UART Protocol · RTL Simulation · Functional Verification · Testbench Development · VCD Waveform Analysis · GTKWave · Ubuntu/Linux · Open-Source EDA Tools

## Author
Ruchir Dambhare

Electronics & Telecommunication Engineering
Interested in VLSI, RTL Design and Digital IC Design


