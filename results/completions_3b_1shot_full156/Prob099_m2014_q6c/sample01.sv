module TopModule
(
  input  logic [5:0] y,
  input  logic w,
  output logic Y1,
  output logic Y3
);

  // Next-state logic
  logic [5:0] next_y;

  always_comb begin
    case (y)
      6'b000001: next_y = 6'b000010; // A -> B
      6'b000010: next_y = 6'b000001; // B -> A
      6'b000100: next_y = 6'b000100; // C -> C
      6'b001000: next_y = 6'b000100; // D -> C
      6'b100000: next_y = 6'b000100; // F -> C
      default: next_y = 6'b000001; // Reset to A
    endcase
  end

  // Output logic
  assign Y1 = y[1];
  assign Y3 = y[3];

endmodule
