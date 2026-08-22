module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic ena,
  output logic pm,
  output logic [7:0] hh,
  output logic [7:0] mm,
  output logic [7:0] ss
);

  // Define constants for BCD digits
  localparam HH_MAX = 12;
  localparam MM_MAX = 59;
  localparam SS_MAX = 59;

  // State machine for clock
  typedef enum {IDLE, COUNT_HH, COUNT_MM, COUNT_SS} ClockState;
  ClockState state = IDLE;

  // Counter variables
  logic [3:0] hh_counter = 0;
  logic [3:0] mm_counter = 0;
  logic [3:0] ss_counter = 0;

  // BCD to decimal conversion
  logic [3:0] hh_bcd = 0;
  logic [3:0] mm_bcd = 0;
  logic [3:0] ss_bcd = 0;

  // AM/PM indicator
  logic pm_flag = 0;

  // State machine process
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      hh_counter <= 0;
      mm_counter <= 0;
      ss_counter <= 0;
      hh_bcd <= 0;
      mm_bcd <= 0;
      ss_bcd <= 0;
      pm_flag <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (ena) begin
            state <= COUNT_HH;
          end
        end
        COUNT_HH: begin
          if (hh_counter == HH_MAX - 1) begin
            hh_counter <= 0;
            state <= COUNT_MM;
          end else begin
            hh_counter <= hh_counter + 1;
          end
        end
        COUNT_MM: begin
          if (mm_counter == MM_MAX - 1) begin
            mm_counter <= 0;
            state <= COUNT_SS;
          end else begin
            mm_counter <= mm_counter + 1;
          end
        end
        COUNT_SS: begin
          if (ss_counter == SS_MAX - 1) begin
            ss_counter <= 0;
            state <= COUNT_HH;
          end else begin
            ss_counter <= ss_counter + 1;
          end
        end
      endcase

      // Convert counters to BCD
      hh_bcd = hh_counter;
      mm_bcd = mm_counter;
      ss_bcd = ss_counter;

      // Determine AM/PM
      if (hh_counter >= 12) begin
        pm_flag <= 1;
      end else begin
        pm_flag <= 0;
      end
    end
  end

  // Output the results
  assign pm = pm_flag;
  assign hh = hh_bcd;
  assign mm = mm_bcd;
  assign ss = ss_bcd;

endmodule
