module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Registers
  logic [1:0] state;

  // Combinational logic
  always_ff @(posedge clk or posedge areset)
    begin
      if (areset)
        state <= 2'b00;
      else
        state <= state + 2'b01;
    end

  // Output logic
  always_comb
    begin
      z = (state == 2'b00) ? x : ~x;
    end

endmodule
