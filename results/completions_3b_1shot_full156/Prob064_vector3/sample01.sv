module TopModule
(
  input  logic [4:0] a,
  input  logic [4:0] b,
  input  logic [4:0] c,
  input  logic [4:0] d,
  input  logic [4:0] e,
  input  logic [4:0] f,
  output logic [7:0] w,
  output logic [7:0] x,
  output logic [7:0] y,
  output logic [7:0] z
);

  // Concatenate inputs
  logic [29:0] concatenated;

  assign concatenated = {a, b, c, d, e, f, 2'b11};

  // Split concatenated into outputs
  assign w = concatenated[29:24];
  assign x = concatenated[23:18];
  assign y = concatenated[17:12];
  assign z = concatenated[11:6];

endmodule
