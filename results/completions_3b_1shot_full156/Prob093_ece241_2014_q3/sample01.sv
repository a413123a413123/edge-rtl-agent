module TopModule
(
  input  logic c,
  input  logic d,
  output logic [3:0] mux_in
);

  // 2-to-1 multiplexers
  wire [1:0] mux1_out;
  wire [1:0] mux2_out;
  wire [1:0] mux3_out;
  wire [1:0] mux4_out;

  // 2-to-1 multiplexer 1
  assign mux1_out = {c, d};

  // 2-to-1 multiplexer 2
  assign mux2_out = {c, ~d};

  // 2-to-1 multiplexer 3
  assign mux3_out = {~c, d};

  // 2-to-1 multiplexer 4
  assign mux4_out = {~c, ~d};

  // 4-to-1 multiplexer
  assign mux_in = {mux4_out, mux3_out, mux2_out, mux1_out};

endmodule
