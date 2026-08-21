module TopModule (
    input  in1,
    input  in2,
    output out
);

    and #(.WIDTH(1)) and_inst (
        .a(in1),
        .b(in2),
        .y(out)
    );

endmodule
