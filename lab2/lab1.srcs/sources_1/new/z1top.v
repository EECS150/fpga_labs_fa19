`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// UC Berkeley, EECS 151/251A FPGA Lab
// Lab 1, Fall 2018
// Module: z1top.v 
//------------------------------------------------------------------------------

module z1top(
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS
    );

    and(LEDS[0], BUTTONS[0], SWITCHES[0]);
    assign LEDS[5:1] = 0;

endmodule