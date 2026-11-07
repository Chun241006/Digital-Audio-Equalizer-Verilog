
`timescale 1ns/1ps

module tb_gain_verification;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1;
    reg valid_in = 0;
    reg signed [15:0] sample_in = 0;

    reg signed [15:0] gain_bass_q8_8 = 256;
    reg signed [15:0] gain_mid_q8_8 = 256;
    reg signed [15:0] gain_treble_q8_8 = 256;

    wire valid_out;
    wire signed [15:0] sample_out;

    reg [15:0] inputs [0:1009];
    reg [15:0] expected [0:1009];

    integer log_fd;
    integer errors = 0;
    integer total = 0;

    audio_equalizer_top dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .sample_in(sample_in),
        .gain_bass_q8_8(gain_bass_q8_8),
        .gain_mid_q8_8(gain_mid_q8_8),
        .gain_treble_q8_8(gain_treble_q8_8),
        .valid_out(valid_out),
        .sample_out(sample_out)
    );

    task run_case;
        input integer case_id;
        input signed [15:0] gb, gm, gt;
        input [8*128-1:0] expected_file;

        integer i;
        integer errors_before;

        begin
            $readmemh(expected_file, expected);

            errors_before = errors;

            @(negedge clk);
            rst = 1;
            valid_in = 0;
            sample_in = 0;

            gain_bass_q8_8 = gb;
            gain_mid_q8_8 = gm;
            gain_treble_q8_8 = gt;

            repeat (2) begin
                @(posedge clk);
                #1;
                if (valid_out !== 1'b0 ||
                    sample_out !== 16'h0000) begin
                    errors = errors + 1;
                    $display("FAIL reset case=%0d", case_id);
                end
            end

            @(negedge clk);
            rst = 0;

            for (i = 0; i < 1010; i = i + 1) begin
                @(negedge clk);
                valid_in = 1;
                sample_in = inputs[i];

                @(posedge clk);
                #1;

                total = total + 1;

                if (valid_out !== 1'b1 ||
                    sample_out !== expected[i]) begin

                    errors = errors + 1;

                    if (errors <= 20)
                        $display(
                            "FAIL case=%0d sample=%0d expected=%h actual=%h valid=%b",
                            case_id, i, expected[i],
                            sample_out, valid_out
                        );
                end
            end

            @(negedge clk);
            valid_in = 0;
            sample_in = 0;

            @(posedge clk);
            #1;

            if (valid_out !== 1'b0) begin
                errors = errors + 1;
                $display("FAIL extra valid case=%0d", case_id);
            end

            $display(
                "CASE %0d: samples=1010 errors=%0d",
                case_id, errors - errors_before
            );

            $fdisplay(
                log_fd,
                "CASE %0d: samples=1010 errors=%0d",
                case_id, errors - errors_before
            );
        end
    endtask

    initial begin
        $readmemh("data/input_samples.mem", inputs);

        log_fd = $fopen(
            "simulation/results/gain_test_results.txt", "w"
        );

        if (!log_fd)
            $fatal(1, "Cannot create gain test log");

        // 0: Bass only
        run_case(0, 256, 0, 0,
            "data/expected_gain_bass_only.mem");

        // 1: Mid only
        run_case(1, 0, 256, 0,
            "data/expected_gain_mid_only.mem");

        // 2: Treble only
        run_case(2, 0, 0, 256,
            "data/expected_gain_treble_only.mem");

        // 3: All bands muted
        run_case(3, 0, 0, 0,
            "data/expected_gain_mute_all.mem");

        // 4: Fractional gains
        run_case(4, 128, 384, 64,
            "data/expected_gain_fractional.mem");

        // 5: Negative bass gain
        run_case(5, -256, 256, 256,
            "data/expected_gain_negative_bass.mem");

        // 6: High gains and saturation
        run_case(6, 768, 512, 384,
            "data/expected_gain_high_gains.mem");

        $display(
            "GAIN SUMMARY compared=%0d errors=%0d",
            total, errors
        );

        $fdisplay(
            log_fd,
            "GAIN SUMMARY compared=%0d errors=%0d",
            total, errors
        );

        if (errors == 0) begin
            $display("GAIN VERIFICATION PASS");
            $fdisplay(log_fd, "GAIN VERIFICATION PASS");
        end else begin
            $display("GAIN VERIFICATION FAIL");
            $fdisplay(log_fd, "GAIN VERIFICATION FAIL");
        end

        $fclose(log_fd);

        if (errors != 0)
            $fatal(1, "Gain verification failed");

        $finish;
    end

    initial begin
        #200000;
        $fatal(1, "Gain verification timeout");
    end

endmodule
