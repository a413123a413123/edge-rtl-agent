module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic load,
  input  logic ena,
  input  logic [3:0] data,
  output logic [3:0] q
);

  // Sequential logic
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      q <= 4'b0;
    end else if (load) begin
      q <= data;
    end else if (ena) begin
      q <= {q[2:0], q[3]};
    end
  end

endmodule
