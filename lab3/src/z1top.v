`timescale 1ns / 1ps

module z1top (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    output aud_pwm,
    output aud_sd
);
    // TODO(you): Your code here. Remove the following lines once you add your implementation.
    assign LEDS[5:0] = 6'b111111;
    assign aud_sd = 0;
endmodule
