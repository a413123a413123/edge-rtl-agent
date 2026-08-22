module TopModule
(
  input  logic clk,
  input  logic aresetn,
  input  logic x,
  output logic z
);

  // State definitions
  localparam IDLE = 2'b00;
  localparam WAIT_1 = 2'b01;
  localparam WAIT_2 = 2'b10;
  localparam WAIT_3 = 2'b11;

  // State register
  logic [1:0] state;

  // Next state logic
  always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (x) begin
            state <= WAIT_1;
          end
        end
        WAIT_1: begin
          if (x) begin
            state <= WAIT_2;
          end else begin
            state <= IDLE;
          end
        end
        WAIT_2: begin
          if (x) begin
            state <= WAIT_3;
          end else begin
            state <= IDLE;
          end
        end
        WAIT_3: begin
          if (x) begin
            state <= WAIT_3;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

  // Output logic
  always_comb begin
    z = (state == WAIT_3);
  end

endmodule
