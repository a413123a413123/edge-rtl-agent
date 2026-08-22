module TopModule
(
  input  logic [7:0] code,
  output logic [3:0] out,
  output logic valid
);

  // Combinational logic

  always_comb begin
    case (code)
      8'h45: out = 4'b0000; valid = 1'b1;
      8'h16: out = 4'b0001; valid = 1'b1;
      8'h1e: out = 4'b0010; valid = 1'b1;
      8'h26: out = 4'b0011; valid = 1'b1;
      8'h25: out = 4'b0100; valid = 1'b1;
      8'h2e: out = 4'b0101; valid = 1'b1;
      8'h36: out = 4'b0110; valid = 1'b1;
      8'h3d: out = 4'b0111; valid = 1'b1;
      8'h3e: out = 4'b1000; valid = 1'b1;
      8'h46: out = 4'b1001; valid = 1'b1;
      default: out = 4'b0000; valid = 1'b0;
    endcase
  end

endmodule
