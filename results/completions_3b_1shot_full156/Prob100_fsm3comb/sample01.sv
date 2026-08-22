module TopModule
(
  input  logic in,
  input  logic [1:0] state,
  output logic [1:0] next_state,
  output logic out
);

  // State transition logic
  always_comb begin
    case (state)
      2'b00: begin
        next_state = in ? 2'b10 : 2'b00;
        out = 0;
      end
      2'b01: begin
        next_state = in ? 2'b10 : 2'b01;
        out = 0;
      end
      2'b10: begin
        next_state = in ? 2'b00 : 2'b11;
        out = 0;
      end
      2'b11: begin
        next_state = in ? 2'b10 : 2'b01;
        out = 1;
      end
    endcase
  end

endmodule
