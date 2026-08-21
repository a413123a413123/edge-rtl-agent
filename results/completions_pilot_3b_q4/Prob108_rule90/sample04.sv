module TopModule (
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Initialize the q register with the data on the first load
  initial q = data;

  // Sequential logic to update the q register
  always @(posedge clk) begin
    if (load) begin
      q = data;
    end else begin
      q[511:2] = q[510:1]; // Shift right
      q[1] = q[510] ^ q[511]; // Apply the Rule 90 rule
      q[0] = q[1]; // Handle boundary conditions
    end
  end

endmodule
