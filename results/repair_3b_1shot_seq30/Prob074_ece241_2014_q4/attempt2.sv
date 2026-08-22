module TopModule
(
  input  logic clk,
  input  logic x,
  output logic z
);

  // State machine variables
  logic [1:0] state;

  // D flip-flops
  logic d1, d2, d3;

  // XOR, AND, OR gates
  logic xor_out, and_out, or_out;

  // NOR gate
  logic nor_out;

  // State transition logic
  always @(posedge clk) begin
    case (state)
      2'b00: begin
        d1 = x;
        d2 = ~d1;
        d3 = ~d1;
        state = 2'b01;
      end
      2'b01: begin
        xor_out = d1 ^ d2;
        and_out = d1 & d2;
        or_out = d1 | d2;
        state = 2'b10;
      end
      2'b10: begin
        nor_out = ~xor_out & ~and_out & ~or_out;
        state = 2'b00;
      end
    endcase
  end

  // Output assignment
  assign z = nor_out;

endmodule
