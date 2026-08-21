module TopModule
(
  input  logic [7:0] in,
  output logic [2:0] pos
);

  // Combinational logic

  always_comb
  begin
    if (in[7]) pos = 3'b7;
    else if (in[6]) pos = 3'b6;
    else if (in[5]) pos = 3'b5;
    else if (in[4]) pos = 3'b4;
    else if (in[3]) pos = 3'b3;
    else if (in[2]) pos = 3'b2;
    else if (in[1]) pos = 3'b1;
    else pos = 3'b0;
  end

endmodule
