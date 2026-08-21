module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    always @(*) begin
        out = ~in;
    end

endmodule
