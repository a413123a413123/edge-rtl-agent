module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Register to hold the current state
  reg [511:0] current;

  // Rule 90 logic
  always_ff @(posedge clk) begin
    if (load) begin
      current <= data;
    end else begin
      current[0] <= q[511] ^ q[0] ^ q[1];
      current[511] <= q[509] ^ q[510] ^ q[511];
      for (int i = 1; i < 510; i++) begin
        current[i] <= q[i - 1] ^ q[i] ^ q[i + 1];
      end
    end
  end

  assign q = current;

endmodule
