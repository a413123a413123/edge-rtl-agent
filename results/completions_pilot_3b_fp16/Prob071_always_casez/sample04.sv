module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Combinational logic

  assign pos = (in == 8'b00000000) ? 3'b000 : 
               (in[7] == 1'b1) ? 3'b001 : 
               (in[6] == 1'b1) ? 3'b010 : 
               (in[5] == 1'b1) ? 3'b011 : 
               (in[4] == 1'b1) ? 3'b100 : 
               (in[3] == 1'b1) ? 3'b101 : 
               (in[2] == 1'b1) ? 3'b110 : 
               (in[1] == 1'b1) ? 3'b111 : 
               3'b000;

endmodule
