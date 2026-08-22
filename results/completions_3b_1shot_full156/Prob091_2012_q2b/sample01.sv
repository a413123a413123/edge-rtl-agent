module TopModule
(
  input  logic [5:0] y,
  input  logic w,
  output logic Y1,
  output logic Y3
);

  // State assignment
  always_comb begin
    case (y)
      6'b000001: Y1 = y[1];
      6'b000010: Y1 = y[1];
      6'b000100: Y1 = y[1];
      6'b001000: Y1 = y[1];
      6'b010000: Y1 = y[1];
      6'b100000: Y1 = y[1];
      default: Y1 = 1'b0;
    endcase
  end

  // State assignment
  always_comb begin
    case (y)
      6'b000001: Y3 = y[3];
      6'b000010: Y3 = y[3];
      6'b000100: Y3 = y[3];
      6'b001000: Y3 = y[3];
      6'b010000: Y3 = y[3];
      6'b100000: Y3 = y[3];
      default: Y3 = 1'b0;
    endcase
  end

endmodule
