module TopModule (
    input  in     [15:0],
    output out_hi [7:0],
    output out_lo [7:0]
);

assign out_hi = in[15:8];
assign out_lo = in[7:0];

endmodule
