`timescale 1ns/1ps
// UART 迴環測試:把 tx 直接接回 rx,送三個位元組驗證收發一致
// 通過準則:模擬輸出出現「ALL TESTS PASSED」
module tb_uart;
    reg clk = 1'b0;
    always #20 clk = ~clk;          // 40ns 週期 = 25 MHz

    reg        rst_n   = 1'b0;
    reg  [7:0] tx_data = 8'd0;
    reg        tx_valid = 1'b0;
    wire       tx, tx_busy;
    wire [7:0] rx_data;
    wire       rx_valid;
    integer    errors = 0;

    // 注意 .rx(tx):實體迴環
    uart_top dut (
        .clk(clk), .rst_n(rst_n),
        .tx_data(tx_data), .tx_valid(tx_valid),
        .tx(tx), .tx_busy(tx_busy),
        .rx(tx), .rx_data(rx_data), .rx_valid(rx_valid)
    );

    task send_and_check(input [7:0] b);
        begin
            @(negedge clk);
            tx_data  = b;
            tx_valid = 1'b1;
            @(negedge clk);
            tx_valid = 1'b0;
            wait (rx_valid);                    // 等接收端回報收滿一個位元組
            if (rx_data !== b) begin
                $display("FAIL: sent %02x, got %02x", b, rx_data);
                errors = errors + 1;
            end else
                $display("OK  : %02x", b);
            wait (!tx_busy);                    // 等傳送端回到閒置再送下一筆
            repeat (10) @(posedge clk);
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        rst_n = 1'b1;                           // 釋放重置
        send_and_check(8'hA5);
        send_and_check(8'h3C);
        send_and_check(8'hFF);
        if (errors == 0)
            $display("UART TB: ALL TESTS PASSED");
        else
            $display("UART TB: %0d ERRORS", errors);
        $finish;
    end
endmodule
