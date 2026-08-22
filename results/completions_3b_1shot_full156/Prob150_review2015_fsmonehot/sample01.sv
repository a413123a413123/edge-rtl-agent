module TopModule
(
  input  logic d,
  input  logic done_counting,
  input  logic ack,
  input  logic [9:0] state,
  output logic B3_next,
  output logic S_next,
  output logic S1_next,
  output logic Count_next,
  output logic Wait_next,
  output logic done,
  output logic counting,
  output logic shift_ena
);

  // State transition logic
  always_comb begin
    case (state)
      10'b0000000001: S_next = d ? S1_next : S_next;
      10'b0000000010: S_next = d ? S1_next : S_next;
      10'b0000000100: S_next = d ? S1_next : S_next;
      10'b0000000101: S_next = d ? S11_next : S_next;
      10'b0000001000: S_next = d ? S11_next : S_next;
      10'b0000001001: S_next = d ? S11_next : S_next;
      10'b0000001010: S_next = d ? S110_next : S_next;
      10'b0000001011: S_next = d ? B0_next : S_next;
      10'b0000010000: S_next = d ? B1_next : S_next;
      10'b0000010001: S_next = d ? B2_next : S_next;
      10'b0000010010: S_next = d ? B3_next : S_next;
      10'b0000010011: S_next = Count_next;
      10'b0000010100: S_next = Wait_next;
      default: S_next = S_next;
    endcase
  end

  // Output logic
  always_comb begin
    B3_next = (state == 10'b0000010010);
    S_next = (state == 10'b0000000001);
    S1_next = (state == 10'b0000000010);
    Count_next = (state == 10'b0000010000);
    Wait_next = (state == 10'b0000010100);
    done = (state == 10'b0000010011);
    counting = (state == 10'b0000010000);
    shift_ena = (state == 10'b0000010000);
  end

endmodule
