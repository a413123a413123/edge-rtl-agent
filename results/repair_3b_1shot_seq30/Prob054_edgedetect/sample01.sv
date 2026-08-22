module TopModule
(
  input  logic clk,
  input  logic [7:0] in,
  output logic [7:0] pedge
);

  // Register to store the previous input value
  logic [7:0] prev_in;

  // Combinational logic
  always_ff @(posedge clk) begin
    prev_in <= in;
    pedge <= (in ^ prev_in) & (in[7:0] != prev_in[7:0]);
  end

endmodule
