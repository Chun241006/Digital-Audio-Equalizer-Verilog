# DGT302 RTL Diagrams — Submission Package
Editable diagrams are provided in native `.drawio` (mxGraph XML) format. PNG previews are included for quick review.
## Files
- `03_rtl_module_hierarchy.drawio` — instance hierarchy of `audio_equalizer_top` and its child instances.
- `04_fir_internal_datapath.drawio` — 31-tap FIR: tap 0, 30-sample delay line, coefficient memory, signed 16×16 multipliers, sign-extension, 37-bit accumulation, 15, saturation, output register and valid/reset.
- `05_gain_mixer_saturation_datapath.drawio` — 3 independent Q8.8 gains, 32-bit products, 8, per-band saturation, 18-bit mixer, final 16-bit saturation.

## Implementation notes
- The FIR output register updates at a rising clock edge with `valid_in=1`; no additional 31-cycle fill latency is required for the first valid output (history is zero-initialized on reset).
- `valid_out` is a registered valid flag per FIR, combined using AND at top.
- Gain, mixer and final saturation are combinational.
- Module hierarchy arrows denote **instantiation**, not sample signal flow.
- The PNGs are overview previews; `.drawio` files are authoritative editable sources.

## Review / GitHub workflow
1. Open each `.drawio` at https://app.diagrams.net/ and inspect at 100% zoom.
2. Save any layout adjustments and export PNG from draw.io if you need exact visual parity with the editable source.
3. Copy all files to `docs/diagrams/`, commit on a branch created from up-to-date `main`, and open a PR.