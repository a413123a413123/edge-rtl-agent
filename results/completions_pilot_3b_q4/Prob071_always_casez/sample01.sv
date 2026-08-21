module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Priority encoder logic
  assign pos = in[7:4] == 8'b0000 ? 3'b0 : 
              in[6:4] == 8'b0000 ? 3'b1 : 
              in[5:4] == 8'b0000 ? 3'b2 : 
              in[4:4] == 8'b0000 ? 3'b3 : 
              3'b4;

endmodule
