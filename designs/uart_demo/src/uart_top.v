// UART 頂層:獨立的 TX 與 RX 通道,參數統一由頂層下發
module uart_top #(
    parameter CLK_FREQ = 25_000_000,
    parameter BAUD     = 115_200
)(
    input  wire       clk,
    input  wire       rst_n,
    // 傳送側
    input  wire [7:0] tx_data,
    input  wire       tx_valid,
    output wire       tx,
    output wire       tx_busy,
    // 接收側
    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_valid
);
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD(BAUD)
    ) u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD(BAUD)
    ) u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );
endmodule
