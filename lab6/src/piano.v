module piano #(
    parameter CLOCK_FREQ = 125_000_000
) (
    input clk,
    input rst,

    input [2:0] buttons,
    input [1:0] switches,
    output [5:0] leds,

    output [7:0] ua_tx_din,
    output ua_tx_wr_en,
    input ua_tx_full,

    input [7:0] ua_rx_dout,
    input ua_rx_empty,
    output ua_rx_rd_en,

    output [23:0] tone,
    output volume
);
    assign tone = 'd0;
    assign volume = 'd0;
    assign ua_tx_din = 0;
    assign ua_tx_wr_en = 0;
    assign ua_rx_rd_en = 0;
endmodule
