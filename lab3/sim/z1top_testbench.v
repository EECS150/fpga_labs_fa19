`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000
`define SAMPLE_PERIOD 22675.7

module z1top_testbench();
    reg clock;
    initial clock = 0;
    always #(4) clock <= ~clock;

    wire aud_pwm, aud_sd, speaker;
    wire [5:0] leds;
    reg [3:0] buttons = 4'h0;
    reg [1:0] switches = 2'b00;
    assign speaker = aud_pwm & aud_sd;

    z1top top (
        .CLK_125MHZ_FPGA(clock),
        .BUTTONS(buttons),
        .SWITCHES(switches),
        .LEDS(leds),
        .aud_pwm(aud_pwm),
        .aud_sd(aud_sd)
    );

    initial begin
        #(200 * `MS);
        $finish();
    end

    integer file;
    initial begin
        file = $fopen("output.txt", "w");
        forever begin
            $fwrite(file, "%h\n", speaker);
            #(`SAMPLE_PERIOD);
        end
    end

endmodule
