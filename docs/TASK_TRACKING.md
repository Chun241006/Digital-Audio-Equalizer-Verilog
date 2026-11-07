
# DGT302 - PROJECT TASK TRACKING

Project: Digital Audio Equalizer Using Verilog HDL

Team Size: 4 members

Project Duration: Week 5 - Week 7

## 1. Team Responsibilities

| Role | Responsibility |
|---|---|
| Leader | Management, specification, architecture, report |
| Member 1 | DSP filter design and Python Golden Model |
| Member 2 | Verilog RTL implementation |
| Member 3 | Testbench and verification |

## 2. Week 5 Tasks (09/10 - 11/10)

| Member | Task | Status |
|---|---|---|
| Leader | Initialize GitHub repository | DONE |
| Leader | Create project folder structure | DONE |
| Leader | Write project specification | DONE |
| Leader | Create architecture diagram | DONE |
| Leader | Create task tracking document | IN PROGRESS |
| Leader | Create report outline | TODO |
| Member 1 | Finalize DSP design parameters | TODO |
| Member 1 | Generate FIR coefficients | TODO |
| Member 1 | Implement Python Golden Model | TODO |
| Member 1 | Generate expected output samples | TODO |
| Member 2 | Implement FIR RTL | TODO |
| Member 2 | Implement gain and mixer | TODO |
| Member 2 | Integrate top-level module | TODO |
| Member 2 | Run initial RTL simulation | TODO |
| Member 3 | Write verification test plan | TODO |
| Member 3 | Develop Verilog Testbench | TODO |
| Member 3 | Compare RTL with Golden Model | TODO |
| Member 3 | Save initial verification logs | TODO |

## 3. Week 6 Tasks (12/10 - 18/10)

| Member | Task | Status |
|---|---|---|
| Leader | Monitor team progress | TODO |
| Leader | Integrate final report | TODO |
| Leader | Prepare final report file | TODO |
| Member 1 | Finalize Golden Model | TODO |
| Member 1 | Generate frequency response plots | TODO |
| Member 1 | Write DSP and Golden Model report sections | TODO |
| Member 2 | Debug and complete RTL design | TODO |
| Member 2 | Complete system integration | TODO |
| Member 2 | Write RTL implementation report section | TODO |
| Member 3 | Execute all verification test cases | TODO |
| Member 3 | Generate comparison results | TODO |
| Member 3 | Write verification report section | TODO |

## 4. Week 7 - Submission
- Final project review
- Report submission
- Verify final report and submission files
- Final GitHub repository check

## 5. Status Definitions

TODO: Not started

IN PROGRESS: Currently working

DONE: Completed and reviewed

BLOCKED: Cannot proceed due to a dependency or error

## 6. Required Deliverables

- RTL Verilog source code
- Python Golden Model
- FIR coefficients
- Verilog Testbench
- Golden Model comparison results
- Simulation waveforms
- Project report
- GitHub repository

## 7. Integration Dependencies

Member 1 must provide coefficients and
fixed-point arithmetic rules to Member 2.

Member 1 must provide expected outputs
to Member 3.

Member 2 must provide RTL interfaces
and simulation timing to Member 3.

Member 3 must report verification failures
to Members 1 and 2.

Leader reviews progress and resolves
integration issues.



## 8. Final Project Status - 07/11/2026

The weekly tables above represent the original project plan. The following table summarizes the current repository deliverables.

| Deliverable | Status | Evidence |
|---|---|---|
| System specification | DONE | docs/PROJECT_SPECIFICATION.md |
| System architecture | DONE | docs/ARCHITECTURE.drawio |
| FIR coefficient generation | DONE | dsp/coeff_gen.py |
| Python Golden Model | DONE | dsp/golden_model.py |
| Verilog RTL implementation | DONE | rtl/ |
| Original RTL verification | PASS | 2021 comparisons, 0 errors |
| Gain verification | PASS | 7070 comparisons, 0 errors |
| Verification diagrams | DONE | docs/diagrams/ and diagrams/ |
| Project report draft | DONE | docs/REPORT_DRAFT.md |
| Final report review | DONE | Final DOCX report reviewed and corrected |
| Diagram PNG files | DONE | docs/diagram/, docs/diagrams/, diagrams/ |
| Final report DOCX | DONE | docs/DGT302_Final_Report.docx |
| Final report PDF | DONE | docs/DGT302_Final_Report.pdf |
| Physical FPGA implementation | NOT IN SCOPE | RTL simulation project |

The two recorded ModelSim verification runs contain 9091 comparisons with zero mismatches.

The project has not been verified on physical FPGA hardware. Dynamic gain changes and exhaustive boundary-value combinations remain future verification work.
