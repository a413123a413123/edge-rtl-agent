module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic w,
  output logic z
);

  // State codes
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;
  localparam E = 2'b00;
  localparam F = 2'b10;

  // State registers
  reg [1:0] state;

  // State table
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      state <= A;
    else
      case (state)
        A: state <= w ? B : A;
        B: state <= w ? C : D;
        C: state <= w ? E : D;
        D: state <= w ? F : A;
        E: state <= w ? E : D;
        F: state <= w ? C : D;
      endcase
  end

  // FSM output
  always @(*)
  begin
    case (state)
      A: z = 1'b0;
      B: z = 1'b0;
      C: z = 1'b0;
      D: z = 1'b0;
      E: z = 1'b1;
      F: z = 1'b0;
    endcase
  end

endmodule
