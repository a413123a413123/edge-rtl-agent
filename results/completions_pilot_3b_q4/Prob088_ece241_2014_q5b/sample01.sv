module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic x,
  output logic z
);

  // Define states
  localparam A = 2'b00;
  localparam B = 2'b01;

  // State register
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge areset)
  begin
    if (areset)
      state <= A;
    else
      case (state)
        A: if (x == 1'b0)
             state <= A;
           else
             state <= B;
        B: if (x == 1'b0)
             state <= B;
           else
             state <= B;
      endcase
  end

  // Output logic
  always @(state)
  begin
    case (state)
      A: z <= 1'b0;
      B: z <= 1'b1;
    endcase
  end

endmodule
