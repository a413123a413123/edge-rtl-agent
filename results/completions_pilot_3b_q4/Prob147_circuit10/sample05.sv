module TopModule (
    input wire clk,
    input wire a,
    input wire b,
    output wire q,
    output wire state
);

    // Internal signals
    logic next_state;

    // Flip-flop to store the next state
    always_ff @(posedge clk) begin
        state <= next_state;
    end

    // Combinational logic to determine the next state
    always_comb begin
        if (a && b) begin
            next_state = 1'b1;
        end else begin
            next_state = 1'b0;
        end
    end

    // Assigning the output based on the current state
    always_comb begin
        q = state;
    end

endmodule
