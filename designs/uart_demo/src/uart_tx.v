// UART 傳送器:8 資料位元、無同位、1 停止位元(8N1)
// 除頻值由 CLK_FREQ/BAUD 導出,預設 25 MHz / 115200 → 每 bit 217 個時脈
module uart_tx #(
    parameter CLK_FREQ = 25_000_000,
    parameter BAUD     = 115_200
)(
    input  wire       clk,
    input  wire       rst_n,      // 非同步低電位重置
    input  wire [7:0] tx_data,    // 要傳送的位元組
    input  wire       tx_valid,   // 拉高一拍觸發傳送
    output reg        tx,         // 串列輸出(閒置為高電位)
    output wire       tx_busy     // 傳送中旗標
);
    localparam integer DIV = CLK_FREQ / BAUD;
    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0]  state;
    reg [15:0] baud_cnt;   // bit 週期計數器
    reg [2:0]  bit_idx;    // 目前傳到第幾個資料位元
    reg [7:0]  sh;         // 資料鎖存

    assign tx_busy = (state != S_IDLE);
    wire baud_tick = (baud_cnt == DIV - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            tx       <= 1'b1;
            baud_cnt <= 16'd0;
            bit_idx  <= 3'd0;
            sh       <= 8'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    tx       <= 1'b1;
                    baud_cnt <= 16'd0;
                    bit_idx  <= 3'd0;
                    if (tx_valid) begin
                        sh    <= tx_data;   // 觸發當下鎖存資料
                        state <= S_START;
                    end
                end
                S_START: begin
                    tx <= 1'b0;             // start bit 拉低一個 bit 週期
                    if (baud_tick) begin
                        baud_cnt <= 16'd0;
                        state    <= S_DATA;
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                S_DATA: begin
                    tx <= sh[bit_idx];      // LSB 先送
                    if (baud_tick) begin
                        baud_cnt <= 16'd0;
                        if (bit_idx == 3'd7)
                            state <= S_STOP;
                        else
                            bit_idx <= bit_idx + 3'd1;
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                S_STOP: begin
                    tx <= 1'b1;             // stop bit 拉高一個 bit 週期
                    if (baud_tick) begin
                        baud_cnt <= 16'd0;
                        state    <= S_IDLE;
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
