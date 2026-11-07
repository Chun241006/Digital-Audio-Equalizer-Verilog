
from golden_model import run_golden_model

# Test cases: (name, bass_gain, mid_gain, treble_gain)
CASES = [
    ("bass_only", 1.0, 0.0, 0.0),
    ("mid_only", 0.0, 1.0, 0.0),
    ("treble_only", 0.0, 0.0, 1.0),
    ("mute_all", 0.0, 0.0, 0.0),
    ("fractional", 0.5, 1.5, 0.25),
    ("negative_bass", -1.0, 1.0, 1.0),
    ("high_gains", 3.0, 2.0, 1.5),
]


def main():
    for name, bass, mid, treble in CASES:
        output_file = f"data/expected_gain_{name}.mem"

        run_golden_model(
            "data/input_samples.mem",
            output_file,
            g_b=bass,
            g_m=mid,
            g_t=treble,
        )

        print(f"[OK] {name}: {output_file}")

    print("Generated all 7 gain verification datasets.")


if __name__ == "__main__":
    main()
