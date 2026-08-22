module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic ena,
  input  logic [1:0] amount,
  input  logic [63:0] data,
  output logic [63:0] q
);

  logic [63:0] shifter;

  always @(posedge clk or posedge load) begin
    if (load) begin
      shifter <= data;
    end else if (ena) begin
      case (amount)
        2'b00: shifter <= {shifter[62:0], 1'b0};
        2'b01: shifter <= {shifter[55:0], shifter[63:56]};
        2'b10: shifter <= {1'b0, shifter[63:8]};
        2'b11: shifter <= {shifter[55:8], 1'b0};
      endcase
    end
  end

  assign q = shifter;

endmodule
