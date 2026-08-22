[BEGIN]
module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic [2:0] s,
  output logic fr2,
  output logic fr1,
  output logic fr0,
  output logic dfr
);

  // State machine states
  localparam IDLE = 3'b000;
  localparam LOW = 3'b001;
  localparam HIGH = 3'b010;
  localparam BETWEEN_S1_S2 = 3'b011;
  localparam BETWEEN_S2_S0 = 3'b100;
  localparam BETWEEN_S0_S2 = 3'b101;
  localparam BETWEEN_S2_S1 = 3'b110;
  localparam BETWEEN_S1_S0 = 3'b111;

  // State register
  logic [2:0] state;

  // Next state logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (s == 3'b111) begin
            state <= LOW;
          end else begin
            state <= IDLE;
          end
        end
        LOW: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else begin
            state <= LOW;
          end
        end
        HIGH: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else begin
            state <= HIGH;
          end
        end
        BETWEEN_S1_S2: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else if (s == 3'b001) begin
            state <= BETWEEN_S1_S0;
          end else begin
            state <= BETWEEN_S1_S2;
          end
        end
        BETWEEN_S2_S0: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else if (s == 3'b001) begin
            state <= BETWEEN_S2_S1;
          end else begin
            state <= BETWEEN_S2_S0;
          end
        end
        BETWEEN_S0_S2: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else if (s == 3'b001) begin
            state <= BETWEEN_S0_S1;
          end else begin
            state <= BETWEEN_S0_S2;
          end
        end
        BETWEEN_S2_S1: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else if (s == 3'b001) begin
            state <= BETWEEN_S2_S0;
          end else begin
            state <= BETWEEN_S2_S1;
          end
        end
        BETWEEN_S1_S0: begin
          if (s == 3'b000) begin
            state <= IDLE;
          end else if (s == 3'b001) begin
            state <= BETWEEN_S1_S2;
          end else begin
            state <= BETWEEN_S1_S0;
          end
        end
      endcase
    end
  end

  // Output logic
  always @(state) begin
    case (state)
      IDLE: begin
        fr0 = 1'b0;
        fr1 = 1'b0;
        fr2 = 1'b0;
        dfr = 1'b0;
      end
      LOW: begin
        fr0 = 1'b1;
        fr1 = 1'b0;
        fr2 = 1'b0;
        dfr = 1'b0;
      end
      HIGH: begin
        fr0 = 1'b0;
        fr1 = 1'b0;
        fr2 = 1'b0;
        dfr = 1'b0;
      end
      BETWEEN_S1_S2: begin
        fr0 = 1'b1;
        fr1 = 1'b0;
        fr2 = 1'b0;
        dfr = 1'b0;
      end
      BETWEEN_S2_S0: begin
        fr0 = 1'b0;
        fr1 = 1'b1;
        fr2 = 1'b0;
        dfr = 1'b0;
      end
      BETWEEN_S0_S2: begin
        fr0 = 1'b0;
        fr1 = 1'b0;
        fr2 = 1'b1;
        dfr
