```verilog
module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);

    // Full adder module
    module FullAdder (
        input  a,
        input  b,
        input  cin,
        output reg sum,
        output reg cout
    );
        assign sum = a ^ b ^ cin;
        assign cout = (a & b) | (b & cin) | (a & cin);
    endmodule

    // Instantiate full adders
    FullAdder fa0 (.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum[0]), .cout(sum[1]));
    FullAdder fa1 (.a(x[1]), .b(y[1]), .cin(sum[0]), .sum(sum[1]), .cout(sum[2]));
    FullAdder fa2 (.a(x[2]), .b(y[2]), .cin(sum[1]), .sum(sum[2]), .cout(sum[3]));
    FullAdder fa3 (.a(x[3]), .b(y[3]), .cin(sum[2]), .sum(sum[3]), .cout(sum[4]));

endmodule
```
