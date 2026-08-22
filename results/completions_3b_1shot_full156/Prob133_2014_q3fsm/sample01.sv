module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic s,
  input  logic w,
  output logic z
);

  // State definitions
  localparam A = 2'b00;
  localparam B = 2'b01;

  // State register
  logic [1:0] state;

  // Next state logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (s) begin
            state <= B;
          end
        end
        B: begin
          if (w) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
      endcase
    end
  end

  // Output logic
  always @(posedge clk) begin
    if (state == B) begin
      z <= (w & w & w);
    end else begin
      z <= 1'b0;
    end
  end

endmodule
