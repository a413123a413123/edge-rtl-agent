module TopModule
(
  input  logic in,
  input  logic [3:0] state,
  output logic [3:0] next_state,
  output logic out
);

  // State transition logic
  always_comb begin
    case (state)
      4'b0001: next_state = in ? 4'b0010 : 4'b0001;
      4'b0010: next_state = in ? 4'b0100 : 4'b0010;
      4'b0100: next_state = in ? 4'b0001 : 4'b0100;
      4'b1000: next_state = in ? 4'b0100 : 4'b0010;
    endcase
  end

  // Output logic
  always_comb begin
    out = state == 4'b1000;
  end

endmodule
