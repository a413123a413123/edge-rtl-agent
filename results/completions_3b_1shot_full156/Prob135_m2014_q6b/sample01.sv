module TopModule
(
  input  logic [2:0] y,
  input  logic w,
  output logic Y1
);

  // Next-state logic for y[1]
  always_comb begin
    case (y)
      3'b000: Y1 = w;
      3'b001: Y1 = w;
      3'b010: Y1 = w;
      3'b011: Y1 = w;
      3'b100: Y1 = w;
      3'b101: Y1 = w;
      default: Y1 = w;
    endcase
  end

endmodule
