`timescale 1ns/100ps

`define SECOND 1000000000
`define MS 1000000
`define CLK_PERIOD 8
`define B_SAMPLE_COUNT_MAX 5
`define B_PULSE_COUNT_MAX 5

`define CLOCK_FREQ 125_000_000
`define BAUD_RATE 115_200

module system_testbench();
    // System clock domain I/O
    reg clk = 0;
    wire audio_pwm;
    wire [5:0] leds;
    reg [3:0] buttons;
    reg [1:0] switches;

    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;

    // Generate system clock
    always #(`CLK_PERIOD/2) clk <= ~clk;

    z1top #(.B_SAMPLE_COUNT_MAX(4), .B_PULSE_COUNT_MAX(4)) top (
      .CLK_125MHZ_FPGA(system_clock),
      .BUTTONS(buttons),
      .SWITCHES(switches),
      .LEDS(leds),
      .aud_pwm(audio_pwm),
      .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
      .FPGA_SERIAL_TX(FPGA_SERIAL_TX)
    );

    // Instantiate an off-chip UART here that uses the RX and TX lines
    // You can refer to the echo_testbench from lab 4

    initial begin
        // Enable mono audio out and audio controller output.
        switches[0] = 1'b1;
        switches[1] = 1'b1;

        // Simulate pushing the RESET button and holding it for a while
        // Verify that the reset signal into the i2s controller only pulses once
        system_reset = 1'b0;
        repeat (10) @(posedge system_clock);
        system_reset = 1'b1;
        repeat (10) @(posedge system_clock);

        // Send a few characters through the off_chip_uart

        // Watch your Piano FSM at work
        #(`MS * 20);

        // ADD SOME MORE STUFF HERE TO TEST YOUR PIANO FSM
        $finish();
    end


endmodule
