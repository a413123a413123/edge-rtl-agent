module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  typedef enum logic [3:0] {IDLE, S5, S6, S7, S8, S9, S10, S11, S12} state_t;

  state_t current_state, next_state;

  always @(posedge clk or posedge reset)
  begin
    if (reset)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end

  always @*
  begin
    disc = 1'b0;
    flag = 1'b0;
    err = 1'b0;

    case (current_state)
      IDLE:
        if (in == 1'b1)
          next_state = S5;
        else
          next_state = IDLE;
      S5:
        if (in == 1'b1)
          next_state = S6;
        else
          next_state = IDLE;
      S6:
        if (in == 1'b1)
          next_state = S7;
        else
          next_state = S5;
      S7:
        if (in == 1'b1)
          next_state = S8;
        else
          next_state = S6;
      S8:
        if (in == 1'b1)
          next_state = S9;
        else
          next_state = S7;
      S9:
        if (in == 1'b1)
          next_state = S10;
        else
          next_state = S8;
      S10:
        if (in == 1'b1)
          next_state = S11;
        else
          next_state = S9;
      S11:
        if (in == 1'b1)
          next_state = S12;
        else
          next_state = S10;
      S12:
        if (in == 1'b1)
          next_state = S12;
        else
          begin
            disc = 1'b1;
            flag = 1'b1;
            next_state = IDLE;
          end
    endcase
  end

endmodule
