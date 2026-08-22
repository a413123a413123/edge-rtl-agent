module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic data,
  output logic start_shifting
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam SEARCH = 2'b01;
  localparam FOUND = 2'b10;

  // State register
  logic [1:0] state;

  // Register to store the last 4 bits of the input stream
  logic [3:0] last_four_bits;

  // Next state logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      last_four_bits <= 4'b0000;
      start_shifting <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (data) begin
            state <= SEARCH;
            last_four_bits <= 4'b0000;
          end
        end
        SEARCH: begin
          last_four_bits = {last_four_bits[3:1], data};
          if (last_four_bits == 4'b1101) begin
            state <= FOUND;
            start_shifting <= 1'b1;
          end else if (data) begin
            state <= SEARCH;
          end
        end
        FOUND: begin
          // Stay in FOUND state forever
        end
      endcase
    end
  end

endmodule
