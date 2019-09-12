`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000
`define SAMPLE_PERIOD 22675.7
`define IVERILOG 0

module tone_generator_testbench();
    reg clock;
    reg output_enable;
    reg volume = 0;
    reg [23:0] tone_to_play;

    wire sq_wave;

    initial clock = 0;
    always #(4) clock <= ~clock;

    tone_generator audio_controller (
        .clk(clock),
        .output_enable(output_enable),
        .tone_switch_period(tone_to_play),
        .volume(volume),
        .square_wave_out(sq_wave)
    );

    initial begin
        `ifdef IVERILOG
            $dumpfile("tone_generator_tb.vcd");
            $dumpvars(0,sq_wave);
        `endif

        tone_to_play = 24'd0;
        output_enable = 1'b0;
        #(10 * `MS);
        output_enable = 1'b1;

        tone_to_play = 24'd37500;
        #(200 * `MS);
        /*
        tone_to_play = 24'd42000;
        #(200 * `MS);

        tone_to_play = 24'd45000;
        #(200 * `MS);

        tone_to_play = 24'd47000;
        #(200 * `MS);

        tone_to_play = 24'd50000;
        #(200 * `MS);

        output_enable = 1'b0;
        #(100 * `MS);
        */
        $finish();
    end

    integer file;
    initial begin
        file = $fopen("output.txt", "w");
        forever begin
            $fwrite(file, "%h\n", sq_wave);
            #(`SAMPLE_PERIOD);
        end
    end

endmodule
