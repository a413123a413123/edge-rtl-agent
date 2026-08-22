module TopModule
(
  input  logic clk,
  input  logic resetn,
  input  logic x,
  input  logic y,
  output logic f,
  output logic g
);

  // State definitions
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  // State register
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge resetn) begin
    if (resetn == 1'b0) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (x == 1'b1 && y == 1'b1) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          if (x == 1'b1 && y == 1'b1) begin
            state <= B;
          end else if (x == 1'b0 && y == 1'b0) begin
            state <= C;
          end else begin
            state <= A;
          end
        end
        C: begin
          if (x == 1'b1 && y == 1'b1) begin
            state <= B;
          end else if (y == 1'b1) begin
            state <= D;
          end else begin
            state <= A;
          end
        end
        D: begin
          if (x == 1'b1 && y == 1'b1) begin
            state <= B;
          end else if (y == 1'b1) begin
            state <= D;
          end else begin
            state <= A;
          end
        end
      endcase
    end
  end

  // Output logic
  always @(posedge clk or posedge resetn) begin
    if (resetn == 1'b0) begin
      f <= 1'b0;
      g <= 1'b0;
    end else begin
      case (state)
        A: begin
          f <= 1'b0;
          g <= 1'b0;
        end
        B: begin
          f <= 1'b1;
          g <= 1'b0;
        end
        C: begin
          f <= 1'b0;
          g <= 1'b1;
        end
        D: begin
          f <= 1'b0;
          g <= 1'b1;
        end
      endcase
    end
  end

endmodule
