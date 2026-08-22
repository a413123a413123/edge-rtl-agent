module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Signal declarations
  reg [1:0] state;

  // State transition logic
  always_ff @(posedge clk or posedge areset)
    if (areset) begin
      state <= 2'b00;
    end else begin
      case (state)
        2'b00: if (x) state <= 2'b01;
               else state <= 2'b00;
        2'b01: if (x) state <= 2'b01;
               else state <= 2'b10;
        2'b10: if (x) state <= 2'b10;
               else state <= 2'b11;
      endcase
    end

  // Output logic
  always_ff @(posedge clk)
    if (state == 2'b00) z <= 1'b0;
    else z <= 1'b1;

endmodule
