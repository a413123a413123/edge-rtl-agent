module TopModule (
    input  in  [2:0],
    output out [1:0]
);

    assign out = in[2] + in[1] + in[0];

endmodule
