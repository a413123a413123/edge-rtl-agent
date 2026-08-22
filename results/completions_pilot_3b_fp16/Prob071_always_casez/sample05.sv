module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Priority encoder logic
  assign pos = in[7:4] ? 3'b07 : 
                 in[3:2] ? 3'b06 : 
                 in[1:0] ? 3'b05 : 
                 3'b00;

endmodule
