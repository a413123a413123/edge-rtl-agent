module TopModule
(
  input  logic [2:0] in,
  output logic [1:0] out
);

  // Local variables
  logic [1:0] count = 0;

  // Sequential logic
  always @(in) begin
    count = 0;
    for (int i = 0; i < 3; i++) begin
      if (in[i]) begin
        count = count + 1;
      end
    end
    out = count;
  end

endmodule
