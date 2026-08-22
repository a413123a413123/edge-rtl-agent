module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [511:0] data,
  output logic [511:0] q
);

  logic [511:0] q_prev;

  // Rule 90 logic
  always_ff @(posedge clk) begin
    if (load) begin
      q_prev = data;
    end else begin
      q_prev = {q_prev[511:1], q_prev[510:0] ^ q_prev[511], q_prev[1:0]};
    end
  end

  assign q = q_prev;

endmodule
