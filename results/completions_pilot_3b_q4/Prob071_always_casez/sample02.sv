module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Logic for priority encoder
  assign pos = (in[7] ? 3'b7 : (in[6] ? 3'b6 : (in[5] ? 3'b5 : (in[4] ? 3'b4 : (in[3] ? 3'b3 : (in[2] ? 3'b2 : (in[1] ? 3'b1 : (in[0] ? 3'b0 : 3'b0))))));
endmodule
