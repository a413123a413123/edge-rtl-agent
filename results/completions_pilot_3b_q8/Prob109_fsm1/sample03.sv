module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic in,
  output logic out
);

  // States
  localparam A = 0, B = 1;

  // State register
  logic state;

  // Next state logic
  always_comb
  begin
    case (state)
      A:
        if (in) state = B;
        else state = A;
      B:
        if (in) state = B;
        else state = A;
    endcase
  end

  // Output logic
  always_ff @(posedge clk, posedge areset)
  begin
    if (areset) state = B;
    out = (state == B);
  end

endmodule
