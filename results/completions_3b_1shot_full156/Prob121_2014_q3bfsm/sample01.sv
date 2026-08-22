module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic x,
  output logic z
);

  // State variables
  logic [2:0] y;

  // State assignment table
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      y <= 3'b000;
    end else begin
      case (y)
        3'b000: begin
          if (x) begin
            y <= 3'b001;
          end else begin
            y <= 3'b000;
          end
        end
        3'b001: begin
          if (x) begin
            y <= 3'b100;
          end else begin
            y <= 3'b001;
          end
        end
        3'b010: begin
          if (x) begin
            y <= 3'b001;
          end else begin
            y <= 3'b010;
          end
        end
        3'b011: begin
          if (x) begin
            y <= 3'b010;
          end else begin
            y <= 3'b001;
          end
        end
        3'b100: begin
          if (x) begin
            y <= 3'b100;
          end else begin
            y <= 3'b011;
          end
        end
      endcase
    end
  end

  // Output assignment
  assign z = y[2];

endmodule
