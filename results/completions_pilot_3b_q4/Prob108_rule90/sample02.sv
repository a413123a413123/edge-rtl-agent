module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  // Sequential logic
  reg [511:0] q_next;

  always_ff @(posedge clk) begin
    if (load) begin
      q_next = data;
    end else begin
      q_next = {
        q[510:0], q[511] ^ q[0] ^ q[1]
      };
    end
  end

  assign q = q_next;

endmodule
