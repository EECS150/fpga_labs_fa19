`timescale 1ns/100ps

`define SECOND 1000000000
`define MS 1000000
`define CLK_PERIOD 8
`define B_SAMPLE_COUNT_MAX 5
`define B_PULSE_COUNT_MAX 5

`define CLOCK_FREQ 125_000_000
`define BAUD_RATE 115_200

module system_testbench();
    reg clk = 0;
    wire audio_pwm;
    wire [5:0] leds;
    reg [2:0] buttons;
    reg [1:0] switches;
    reg reset;

    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;

    // Generate system clock
    always #(`CLK_PERIOD/2) clk <= ~clk;

    z1top #(
        .B_SAMPLE_COUNT_MAX(`B_SAMPLE_COUNT_MAX),
        .B_PULSE_COUNT_MAX(`B_PULSE_COUNT_MAX),
        .CLOCK_FREQ(`CLOCK_FREQ),
        .BAUD_RATE(`BAUD_RATE)
    ) top (
        .CLK_125MHZ_FPGA(clk),
        .BUTTONS({buttons, reset}),
        .SWITCHES(switches),
        .LEDS(leds),
        .aud_pwm(audio_pwm),
        .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
        .FPGA_SERIAL_TX(FPGA_SERIAL_TX)
    );

    // Instantiate an off-chip UART here that uses the RX and TX lines
    // You can refer to the echo_testbench from lab 4

    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("system_testbench.fst");
            $dumpvars(0,system_testbench);
        `endif
        // Simulate pushing the reset button and holding it for a while
        reset = 1'b0;
        repeat (50) @(posedge clk);
        reset = 1'b1;
        repeat (50) @(posedge clk);
        reset = 1'b0;

        // Send a few characters through the off_chip_uart

        #(`MS * 20);

        // TODO: Add some more stuff to test the piano
        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
