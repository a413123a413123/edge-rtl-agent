module TopModule (
    input  in  [7:0] in,
    output out [7:0] out
);

    always @(*) begin
        out = in;
    end

endmodule
