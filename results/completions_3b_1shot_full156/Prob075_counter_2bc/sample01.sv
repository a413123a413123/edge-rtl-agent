module TopModule
(
  input  logic clk,
  input  logic areset,
  input  logic train_valid,
  input  logic train_taken,
  output logic [1:0] state
);

  // Sequential logic

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01;
    end else if (train_valid && train_taken) begin
      state <= state + 2'b01;
      if (state == 2'b11) begin
        state <= 2'b11;
      end
    end else if (train_valid && !train_taken) begin
      state <= state - 2'b01;
      if (state == 2'b00) begin
        state <= 2'b00;
      end
    end
  end

endmodule
