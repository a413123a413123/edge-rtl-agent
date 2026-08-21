module TopModule
(
  input  logic [31:0] in,
  output logic [31:0] out
);

  // Combinational logic

  assign out = {in[31:24], in[23:16], in[15:8], in[7:0]};

endmodule
