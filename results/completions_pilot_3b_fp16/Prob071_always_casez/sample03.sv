module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Assignments
  assign pos = $clog2(2**($clog2(in)+1)-1)-$clog2(in);

endmodule
