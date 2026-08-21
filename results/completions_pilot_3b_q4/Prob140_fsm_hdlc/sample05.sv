module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // States
  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam IN_FRAME = 2'b10;
  localparam ERROR = 2'b11;

  // Internal variables
  logic [1:0] count;
  logic [7:0] sequence;

  // Sequential logic
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 2'b00;
      sequence <= 8'b00000000;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      if (in) begin
        count <= count + 1;
      end else begin
        count <= 2'b00;
      end

      // Update sequence
      sequence = {sequence[7:1], in};

      // State transitions
      case (count)
        2'b00: begin
          if (sequence == 8'b1111110) begin
            count <= 2'b10; // IN_FRAME
            sequence <= 8'b00000000; // Reset sequence
          end
        end
        2'b10: begin
          if (sequence == 8'b1111110) begin
            count <= 2'b11; // ERROR
            sequence <= 8'b00000000; // Reset sequence
          end else if (sequence == 8'b00000000) begin
            count <= 2'b00; // IDLE
            sequence <= 8'b00000000; // Reset sequence
          end
        end
      endcase

      // Outputs
      disc <= count == 2'b10;
      flag <= count == 2'b11;
      err <= count == 2'b11;
    end
  end

endmodule
