module music_streamer (
    input clk,
    input rst,
    input tempo_up,
    input tempo_down,
    input play_pause,
    input reverse,
    output [2:0] leds,
    output [23:0] tone
);
    // Instantiate the ROM here
    assign leds = 0;
    assign tone = 0;
endmodule
