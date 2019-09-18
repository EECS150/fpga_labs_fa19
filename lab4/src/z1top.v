`timescale 1ns/1ns

`define CLOCK_FREQ 125_000_000

module z1top (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    output aud_pwm,
    output aud_sd
);
    assign LEDS[5:4] = 2'b11;
    assign aud_sd = 1; // Enable the audio output
    assign aud_pwm = 0;

    //// Button parser test circuit
    // Sample the button signal every 500us
    localparam integer B_SAMPLE_COUNT_MAX = 0.0005 * `CLOCK_FREQ;
    // The button is considered 'pressed' after 100ms of continuous pressing
    localparam integer B_PULSE_COUNT_MAX = 0.100 / 0.0005;

    wire [3:0] buttons_pressed;
    button_parser bp #(
        width = 4,
        sample_count_max = B_SAMPLE_COUNT_MAX,
        pulse_count_max = B_PULSE_COUNT_MAX
    ) (
        .clk(CLK_125MHZ_FPGA),
        .in(BUTTONS),
        .out(buttons_pressed)
    );

    reg count [3:0] = 0;
    assign LEDS[3:0] = count;
    always @(posedge CLK_125MHZ_FPGA) begin
        if (buttons_pressed[0]) begin
            count <= count + 'd1;
        end else if (buttons_pressed[1]) begin
            count <= count - 'd1;
        end else if (buttons_pressed[2]) begin
            count <= 'd0;
        end else if (buttons_pressed[3]) begin
            count <= count + 'd2;
        end
    end
endmodule
