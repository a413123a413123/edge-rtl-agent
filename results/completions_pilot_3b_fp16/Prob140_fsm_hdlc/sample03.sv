module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  logic [3:0] state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 4'b0000;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      case (state)
        4'b0000: begin
          if (in) begin
            state <= 4'b0001;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0001: begin
          if (in) begin
            state <= 4'b0010;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0010: begin
          if (in) begin
            state <= 4'b0011;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0011: begin
          if (in) begin
            state <= 4'b0100;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0100: begin
          if (in) begin
            state <= 4'b0101;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0101: begin
          if (in) begin
            state <= 4'b0110;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0110: begin
          if (in) begin
            state <= 4'b0111;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b0111: begin
          if (in) begin
            state <= 4'b1000;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1000: begin
          if (in) begin
            state <= 4'b1001;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1001: begin
          if (in) begin
            state <= 4'b1010;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1010: begin
          if (in) begin
            state <= 4'b1011;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1011: begin
          if (in) begin
            state <= 4'b1100;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1100: begin
          if (in) begin
            state <= 4'b1101;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1101: begin
          if (in) begin
            state <= 4'b1110;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1110: begin
          if (in) begin
            state <= 4'b1111;
          end else begin
            state <= 4'b0000;
          end
        end
        4'b1111: begin
          if (in) begin
            state <= 4'b0000;
            flag <= 1'b1;
          end else begin
            state <= 4'b0000;
            flag <= 1'b0;
          end
        end
      endcase
    end
  end

  always @(*) begin
    disc = (state == 4'b1000);
    err = (state == 4'b1111);
  end

endmodule
