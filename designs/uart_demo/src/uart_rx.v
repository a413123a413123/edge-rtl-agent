// UART 接收器:8N1,偵測 start bit 後改在每個 bit 的「中點」取樣
// 取樣時序:start 下緣 → 走 DIV/2 到 start 中點驗證 → 之後每隔 DIV 取樣一次
module uart_rx #(
    parameter CLK_FREQ = 25_000_000,
    parameter BAUD     = 115_200
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx,          // 串列輸入(非同步)
    output reg  [7:0] rx_data,     // 收到的位元組
    output reg        rx_valid     // 收滿一個位元組時拉高一拍
);
    localparam integer DIV = CLK_FREQ / BAUD;
    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0]  state;
    reg [15:0] baud_cnt;
    reg [2:0]  bit_idx;
    reg [7:0]  sh;

    // 兩級同步器:rx 來自晶片外部,必須先同步進 clk 時域
    reg rx_m, rx_s;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_m <= 1'b1;
            rx_s <= 1'b1;
        end else begin
            rx_m <= rx;
            rx_s <= rx_m;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            baud_cnt <= 16'd0;
            bit_idx  <= 3'd0;
            sh       <= 8'd0;
            rx_data  <= 8'd0;
            rx_valid <= 1'b0;
        end else begin
            rx_valid <= 1'b0;                    // 預設拉低,只脈衝一拍
            case (state)
                S_IDLE: begin
                    baud_cnt <= 16'd0;
                    bit_idx  <= 3'd0;
                    if (!rx_s)                   // start bit 下緣
                        state <= S_START;
                end
                S_START: begin                   // 走到 start bit 中點再確認一次
                    if (baud_cnt == DIV/2 - 1) begin
                        baud_cnt <= 16'd0;
                        state    <= (!rx_s) ? S_DATA : S_IDLE;  // 仍為低才視為有效,否則當雜訊
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                S_DATA: begin                    // 每隔整個 bit 週期取樣 → 恰落在各資料位元中點
                    if (baud_cnt == DIV - 1) begin
                        baud_cnt    <= 16'd0;
                        sh[bit_idx] <= rx_s;     // LSB 先收
                        if (bit_idx == 3'd7)
                            state <= S_STOP;
                        else
                            bit_idx <= bit_idx + 3'd1;
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                S_STOP: begin                    // 停止位元中點:資料落定、發出 valid
                    if (baud_cnt == DIV - 1) begin
                        baud_cnt <= 16'd0;
                        rx_data  <= sh;
                        rx_valid <= 1'b1;
                        state    <= S_IDLE;
                    end else
                        baud_cnt <= baud_cnt + 16'd1;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
