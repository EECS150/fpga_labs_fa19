`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000
`define CLOCKS_PER_SAMPLE 2500 // 125 Mhz clock, 50 kHz audio, 2500 clocks per sample

module music_streamer_testbench();
    // Global signals
    reg clock = 0;
    reg reset = 0;

    initial clock = 0;
    always #(8/2) clock <= ~clock;

    // Music streamer inputs
    reg tempo_up = 0;
    reg tempo_down = 0;
    reg play_pause = 0;
    reg reverse = 0;

    // Music streamer outputs
    wire [23:0] tone_to_play;
    wire [2:0] leds;

    // Tone generator output
    wire sq_wave;

    tone_generator tg (
        .clk(clock),
        .rst(reset),
        .output_enable(1'b1),
        .volume(1'b1),
        .tone_switch_period(tone_to_play),
        .square_wave_out(sq_wave)
    );

    music_streamer streamer (
        .clk(clock),
        .rst(reset),
        .tempo_up(tempo_up),
        .tempo_down(temp_down),
        .play_pause(play_pause),
        .reverse(reverse),
        .leds(leds),
        .tone(tone_to_play)
    );

    initial begin
        `ifdef IVERILOG
            $dumpfile("music_streamer_testbench.fst");
            $dumpvars(0,music_streamer_testbench);
        `endif

        reset = 0;
        // Reset our modules and enable the tone_generator output
        @(posedge clock);
        reset = 1;
        @(posedge clock);
        reset = 0;

        // Warning: do not exceed delays of 2 seconds at a time
        // otherwise the delay won't work properly with our simulator
        #(20 * `MS);

        /*
        // Get FSM into PAUSED state by simulating button press
        @(posedge clock);
        play_pause = 1'b1;
        @(posedge clock);
        play_pause = 1'b0;
        #(300 * `MS);

        // Simulate tempo adjustment
        repeat (10) begin
            @(posedge clock);
            tempo_up = 1'b1;
            @(posedge clock);
            tempo_up = 1'b0;
        end
        #(1 * `SECOND);
        */
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
                @(posedge clock);
                count = count + sq_wave;
            end
            $fwrite(file, "%d\n", count);
        end
        `ifndef IVERILOG
            $vcdplusoff;
        `endif
    end

endmodule
