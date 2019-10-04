`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000
`define CLOCKS_PER_SAMPLE 2500 // 125 Mhz clock, 50 kHz audio, 2500 clocks per sample
`define B_SAMPLE_COUNT_MAX 5
`define B_PULSE_COUNT_MAX 5
`define CLOCK_PERIOD 8
`define CLOCK_FREQ 125_000_000

module z1top_testbench();
    reg clk = 0;
    always #(`CLOCK_PERIOD/2) clk <= ~clk;

    wire aud_pwm, aud_sd, speaker;
    wire [5:0] leds;
    reg [3:0] buttons = 4'h0;
    reg [1:0] switches = 2'b00;
    assign speaker = aud_pwm & aud_sd;

    z1top #(
        .CLOCK_FREQ(`CLOCK_FREQ),
        .B_SAMPLE_COUNT_MAX(`B_SAMPLE_COUNT_MAX),
        .B_PULSE_COUNT_MAX(`B_PULSE_COUNT_MAX)
    ) top (
        .CLK_125MHZ_FPGA(clk),
        .BUTTONS(buttons),
        .SWITCHES(switches),
        .LEDS(leds),
        .aud_pwm(aud_pwm),
        .aud_sd(aud_sd)
    );

    initial begin
        `ifdef IVERILOG
            $dumpfile("z1top_testbench.fst");
            $dumpvars(0,z1top_testbench);
        `endif
        buttons[0] = 1'b0;
        repeat (10) @(posedge clk);
        buttons[0] = 1'b1;
        repeat (40) @(posedge clk);
        buttons[0] = 1'b0;

        #(20 * `MS);
        $finish();
    end

    integer file;
    integer i;
    integer count;
    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        file = $fopen("output.txt", "w");
        forever begin
            count = 0;
            for (i = 0; i < `CLOCKS_PER_SAMPLE; i = i + 1) begin
                @(posedge clk);
                count = count + speaker;
            end
            $fwrite(file, "%d\n", count);
        end
        `ifndef IVERILOG
            $vcdplusoff;
        `endif
    end

endmodule
