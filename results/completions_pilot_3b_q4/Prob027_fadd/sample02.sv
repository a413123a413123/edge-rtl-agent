module TopModule
(
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic cout,
  output logic sum
);

  // Synchronous logic
  always_ff @(posedge a or posedge b or posedge cin) begin
    sum = a ^ b ^ cin;
    cout = (a & b) | (a & cin) | (b & cin);
  end

endmodule
