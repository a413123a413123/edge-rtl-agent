module TopModule
(
  input  logic clk,
  input  logic load,
  input  logic [255:0] data,
  output logic [255:0] q
);

  // Sequential logic

  logic [15:0] q_next;

  always @(posedge clk) begin
    if (load) begin
      q_next = data;
    end else begin
      q_next = q;
      for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
          int count = 0;
          for (int di = -1; di <= 1; di++) begin
            for (int dj = -1; dj <= 1; dj++) begin
              int ni = (i + di + 16) % 16;
              int nj = (j + dj + 16) % 16;
              if (ni != i || nj != j) begin
                count += q[ni * 16 + nj];
              end
            end
          end
          if (count == 3) begin
            q_next[i * 16 + j] = 1;
          end else if (count == 2) begin
            q_next[i * 16 + j] = q[i * 16 + j];
          end else begin
            q_next[i * 16 + j] = 0;
          end
        end
      end
    end
  end

  assign q = q_next;

endmodule
