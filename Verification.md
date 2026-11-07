# Verification — Hoang Nguyen

## Objective
Verify the supplied three-band audio equalizer RTL against integer expected outputs. Verification covers FIR state progression, fixed-point arithmetic, gain, mixing, saturation, reset, and sample-valid handling.

## Method
The file-driven testbench instantiates `audio_equalizer_top`. Inputs and gains are driven on falling clock edges. Results are sampled 1 ns after rising edges, allowing nonblocking FIR register updates and combinational gain/mixer logic to settle. Clock period is 10 ns; this is a simulation clock, not the 48 kHz audio sampling rate. Valid strobes determine sample acceptance.

The scoreboard checks `valid_out == (!rst && valid_in)` each vector cycle for the supplied implementation. Every valid sample is compared exactly with the expected signed 16-bit value. Reset cycles also require zero output. Case-inequality detects unknown outputs. Invalid cycles do not require a particular output value because gains are combinational. Per-cycle valid checking detects missing and extra transactions. File validation, nonempty sample checks and a simulation watchdog prevent false completion.

## Reference arithmetic
The generator uses signed Q1.15 coefficients and 31 sample taps. It computes exact integer FIR sums, arithmetic right shifts by 15 and clips to [-32768, 32767]. Each signed Q8.8 gain product is shifted right by 8 and clipped again. The three gained bands are summed and clipped at the final output. Python signed right shifts match the floor behavior of Verilog arithmetic right shifts, including negative products. History advances only for accepted samples and is cleared by reset.

## Test plan
The table below describes the planned verification coverage. The current saved RTL simulation exercises continuous valid samples, inserted valid gaps, and reset recovery with unity gain (Q8.8 = 256) on all three bands. Additional gain configurations and corner cases remain future verification work.

| Case | Purpose |
|---|---|
| Zero | Detect unwanted nonzero output |
| Impulse | Exercise tap order and 31-sample history |
| Individual bands | Isolate each band with other gains zero |
| Mute | Require zero mixed output |
| Fractional and negative gains | Exercise scaling and signed shifts |
| High gain and extreme samples | Exercise clipping paths |
| Random samples and gains | Broaden arithmetic combinations |
| Valid gaps | Verify history only advances on valid samples |
| Reset during traffic | Verify state clearing and output invalidation |
| Tail and idle | Exercise residual state and absence of extra outputs |

## Results and limitations

The saved ModelSim 2020.1 simulation completed successfully on November 1, 2026. The testbench compared 1,010 continuous samples, 1,010 samples with inserted valid gaps, and one additional reset-recovery sample.

- Total comparisons: 2,021
- Mismatches: 0
- Final result: OVERALL PASS

The saved results are available in `simulation/results/test_results.txt`, `simulation/results/results.csv`, and `simulation/results/console_output.txt`. Waveform screenshots are stored in `docs/images/`.

The verification uses the project's checked-in FIR coefficients and expected output data. The saved simulation confirms agreement between the tested RTL and reference outputs for the exercised scenarios. It does not establish complete functional coverage, hardware implementation, or audio quality.

The current testbench uses unity gain for all three bands. Separate tests for mute, fractional gains, negative gains, high gains, and dynamic gain changes are not yet demonstrated by the saved simulation. Frequency-response evaluation and possible improvements to band separation are documented separately in the project report.


## Evidence to submit
Attach `test_results.txt`, `results.csv`, simulator transcript and waveform screenshots. Report tested coefficient source, vector source, number of compared samples, mismatch count, and simulator version. A passing fixture run must be identified as fixture verification.
