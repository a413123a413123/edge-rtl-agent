module TopModule
(
  input  logic clk,
  input  logic [7:0] in,
  output logic [7:0] anyedge
);

  always_ff @(posedge clk) begin
    anyedge = 8'b0;
    for (int i = 0; i < 8; i++) begin
      if (in[i] != in[i+1]) begin
        anyedge[i] = 1'b1;
      end
    end
  end

endmodule
