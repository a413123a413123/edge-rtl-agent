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
        2'b00: shifter <= {shifter[63], shifter[63:1]};
        2'b01: shifter <= {shifter[63-8:0], 8'b0};
        2'b10: shifter <= shifter >> 1;
        2'b11: shifter <= {8'b0, shifter[63:8]};
      endcase
    end
  end

  assign q = shifter;

endmodule
