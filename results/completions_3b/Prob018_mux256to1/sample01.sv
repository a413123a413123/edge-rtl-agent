module TopModule (
    input  in  [255:0] in,
    input  sel  [7:0] sel,
    output out
);

    assign out = in[sel];

endmodule
