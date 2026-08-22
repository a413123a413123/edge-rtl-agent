module TopModule
(
  input  logic clk,
  input  logic reset,
  output logic shift_ena
);

  reg [3:0] counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 4'b0000;
      shift_ena <= 1'b0;
    end else begin
      if (counter == 4'b1111) begin
        counter <= 4'b0000;
        shift_ena <= 1'b0;
      end else begin
        counter <= counter + 1'b1;
        shift_ena <= 1'b1;
      end
    end
  end

endmodule
