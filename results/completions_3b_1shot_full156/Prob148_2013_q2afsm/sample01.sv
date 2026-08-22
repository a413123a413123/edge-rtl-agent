module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic [2:0] r,
  output logic [2:0] g
);

  // State codes
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;

  // State registers
  reg [2:0] state;

  // State table
  always @(posedge clk or posedge resetn)
  begin
    if (resetn == 1'b0)
      state <= A;
    else
      case (state)
        A: begin
          if (r == 3'b000)
            state <= A;
          else if (r == 3'b001)
            state <= B;
          else if (r == 3'b010)
            state <= C;
          else if (r == 3'b011)
            state <= D;
        end
        B: begin
          if (r == 3'b001)
            state <= B;
          else if (r == 3'b000)
            state <= A;
        end
        C: begin
          if (r == 3'b011)
            state <= C;
          else if (r == 3'b000)
            state <= A;
        end
        D: begin
          if (r == 3'b000)
            state <= A;
        end
      endcase
  end

  // FSM outputs
  always @(*)
  begin
    case (state)
      A: g = 3'b000;
      B: g = 3'b001;
      C: g = 3'b010;
      D: g = 3'b011;
    endcase
  end

endmodule
