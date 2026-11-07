
# PROJECT SPECIFICATION

## 1. Project Information

Project Title:
Design and Verification of a 3-Band Digital
Audio Equalizer Using Verilog HDL

Course: Digital Signal Processing (DGT302)

Project Type: RTL Design and Verification

Development Tools:
- Visual Studio Code
- Git and GitHub
- Python (NumPy, SciPy)
- Verilog HDL
- ModelSim or compatible Verilog simulator

## 2. Project Overview

This project implements a 3-band digital
audio equalizer using Verilog HDL.

The system separates incoming audio samples
into three frequency bands:

- Bass
- Mid
- Treble

Each band is processed by a digital FIR filter.

The filtered signals are independently scaled
using gain controls and combined to produce
the final audio output.

A Python Golden Model will be developed to
generate reference outputs.

A Verilog Testbench will compare RTL outputs
with the Golden Model.

## 3. System Architecture

Input Audio Samples (16-bit signed)
              |
              +----> Bass FIR Filter ----> Bass Gain ----+
              |                                         |
              +----> Mid FIR Filter -----> Mid Gain -----+----> Mixer
              |                                         |        |
              +----> Treble FIR Filter --> Treble Gain --+        |
                                                                 v
                                                            Saturation
                                                                 |
                                                                 v
                                                        Output Audio Samples
                                                           (16-bit signed)

## 4. Functional Requirements

FR01:
The system shall accept signed 16-bit input samples.

FR02:
The system shall process samples using three FIR filters.

FR03:
The system shall support independent Bass, Mid,
and Treble gain controls.

FR04:
The system shall combine the three processed
signals into one output signal.

FR05:
The output shall be saturated to the signed
16-bit range (-32768 to +32767).

FR06:
The system shall provide valid input and
valid output control signals.

FR07:
The system shall support synchronous sample processing
and reset functionality.

FR08:
The system shall be implemented using Verilog HDL.

FR09:
The RTL shall be verified using a testbench
and a Python Golden Model.

## 5. DSP Design Parameters

The equalizer uses a 48 kHz sampling rate and
processes signed 16-bit audio samples.

The system has three FIR filters:

- Bass: Low-pass filter, 200 Hz cutoff
- Mid: Band-pass filter, 250–3800 Hz
- Treble: High-pass filter, 4000 Hz cutoff

Each filter has 31 taps and uses a Hamming window.

The FIR coefficients are stored as signed 16-bit
Q1.15 values. The RTL uses a 37-bit accumulator,
followed by a right shift of 15 bits and
16-bit saturation.

Each frequency band has a separate Q8.8 gain.
A gain value of 256 represents unity gain.

The three outputs are added using an 18-bit
mixer. The final result is saturated to
the signed 16-bit range.

These cutoff values are design parameters.
The actual frequency responses depend on
the 31-tap FIR coefficients.


## 6. RTL Interface

The top-level module is `audio_equalizer_top`.

### Input Signals

| Signal | Width | Description |
|---|---|---|
| clk | 1 bit | System clock |
| rst | 1 bit | Synchronous active-high reset |
| valid_in | 1 bit | Input sample valid signal |
| sample_in | 16 bits | Signed audio sample |
| gain_bass_q8_8 | 16 bits | Signed Bass gain (Q8.8) |
| gain_mid_q8_8 | 16 bits | Signed Mid gain (Q8.8) |
| gain_treble_q8_8 | 16 bits | Signed Treble gain (Q8.8) |

### Output Signals

| Signal | Width | Description |
|---|---|---|
| sample_out | 16 bits | Signed processed audio sample |
| valid_out | 1 bit | Output sample valid signal |

### Timing and Reset

The FIR filters operate on the rising edge of `clk`.

When `rst = 1`, the FIR history, output registers,
and valid flags are cleared at the next rising edge.

When `valid_in = 1`, a new input sample is accepted.
The FIR outputs and `valid_out` are updated at that
rising edge.

When `valid_in = 0`, the sample history is held and
`valid_out` becomes 0.

Gain control, mixing, and final saturation are
combinational. The output is considered valid only
when `valid_out = 1`.

## 7. Golden Model

The Golden Model is implemented in Python in
`dsp/golden_model.py`.

It uses the same FIR coefficients as the RTL,
stored in `dsp/coefficients/`.

The processing steps are:

1. Read signed 16-bit input samples from
   `data/input_samples.mem`.
2. Load the 31 Q1.15 coefficients for each filter.
3. Calculate the FIR output for Bass, Mid, and Treble.
4. Shift each FIR accumulator right by 15 bits
   and apply 16-bit saturation.
5. Apply the three Q8.8 gains.
6. Add the three band outputs.
7. Apply final 16-bit saturation.
8. Save the results to `data/expected_output.mem`.

The model uses integer arithmetic to match
the RTL fixed-point operations.

The current reference data contains 1010 samples.
The default gain is 1.0 for all three bands.

The model processes consecutive accepted samples.
Reset and valid-gap timing are checked separately
by the Verilog Testbench.

The expected output file is used to compare
the RTL results with the Python reference.



## 8. Testbench and Verification

The Verilog Testbench is implemented in
`tb/tb_audio_equalizer.v`.

It checks the RTL outputs against the Python
Golden Model using the same input samples
and FIR coefficients.

The Testbench performs the following steps:

1. Generate clock and reset signals.
2. Read input samples from `data/input_samples.mem`.
3. Read reference outputs from
   `data/expected_output.mem`.
4. Apply samples and gain values to the RTL.
5. Check `valid_out` and compare output samples
   with the expected values.
6. Count mismatches and report PASS or FAIL.
7. Save the comparison results and simulation logs.

The current tests use unity gain (256 in Q8.8)
for all three frequency bands.

The outputs are compared as signed 16-bit
fixed-point values.

## 9. Verification Results

The project was tested using ModelSim
Intel FPGA Edition 2020.1.

| Test | Compared Samples | Mismatches | Result |
|---|---:|---:|---|
| Continuous input | 1010 | 0 | PASS |
| Input with valid gaps | 1010 | 0 | PASS |
| Reset recovery | 1 | 0 | PASS |
| Total | 2021 | 0 | PASS |

The continuous-input test checks the output
for every accepted audio sample.

The valid-gap test inserts idle clock cycles
between selected samples and checks that
the FIR history is preserved.

The reset test checks that the stored FIR
history and output registers are cleared.

All 2021 compared samples matched the
Golden Model reference data.

The current verification is limited to
unity-gain operation. Additional gain values,
clipping cases, and more boundary conditions
can be tested in future work.

The saved simulation results are located in
`simulation/results/`.


## 10. Project Scope

Included:
- FIR-based audio equalizer
- Three frequency bands
- Independent gain control
- Verilog RTL design
- Python Golden Model
- Verilog Testbench
- Automated RTL/Golden Model comparison
- Simulation results and report

Excluded:
- Physical FPGA implementation
- Microphone and speaker integration
- Real-time analog audio hardware
- Graphical user interface
- Adaptive filtering

## 11. Team Responsibilities

Leader:
- System specification
- Architecture documentation
- Project management
- Report integration

Member 1:
- DSP filter design
- Coefficient generation
- Python Golden Model
- DSP documentation

Member 2:
- Verilog RTL implementation
- Module integration
- RTL simulation and debugging
- RTL documentation

Member 3:
- Testbench implementation
- Verification test cases
- Golden Model comparison
- Verification results documentation

## 12. Project Schedule

Week 5:
- Finalize specification and interfaces
- Develop Golden Model
- Implement basic RTL
- Develop initial Testbench

Week 6:
- Complete integration
- Run verification tests
- Debug mismatches
- Complete report

Week 7:
- Final project review
- Submit source code, simulation results, and report

## 13. Acceptance Criteria

The project is considered complete when:

1. RTL compiles successfully.
2. Golden Model produces expected outputs.
3. Testbench runs the required test cases.
4. RTL matches the fixed-point Golden Model.
5. All failures are resolved or documented.
6. Simulation evidence is saved.
7. The project report is completed.
