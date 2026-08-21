module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic in,
  output logic disc,
  output logic flag,
  output logic err
);

  // Define states
  localparam IDLE = 4'b0000;
  localparam ONE = 4'b0001;
  localparam TWO = 4'b0010;
  localparam THREE = 4'b0011;
  localparam FOUR = 4'b0100;
  localparam FIVE = 4'b0101;
  localparam SIX = 4'b0110;
  localparam SEVEN = 4'b0111;
  localparam EIGHT = 4'b1000;
  localparam NINE = 4'b1001;
  localparam TEN = 4'b1010;
  localparam ELEVEN = 4'b1011;
  localparam TWELVE = 4'b1100;
  localparam THIRTEEN = 4'b1101;
  localparam FOURTEEN = 4'b1110;
  localparam FIFTEEN = 4'b1111;

  // FSM registers
  reg [15:0] state = 16'b0000000000000000;
  reg [4:0] count = 5'b00000;

  // Outputs
  wire disc_out, flag_out, err_out;

  // Output assignements
  assign disc = disc_out;
  assign flag = flag_out;
  assign err = err_out;

  // FSM state transitions
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 5'b00000;
    end else begin
      case (state)
        IDLE: begin
          if (in) begin
            state <= ONE;
          end else begin
            state <= IDLE;
          end
        end
        ONE: begin
          if (in) begin
            state <= TWO;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        TWO: begin
          if (in) begin
            state <= THREE;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        THREE: begin
          if (in) begin
            state <= FOUR;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        FOUR: begin
          if (in) begin
            state <= FIVE;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        FIVE: begin
          if (in) begin
            state <= SIX;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        SIX: begin
          if (in) begin
            state <= SEVEN;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        SEVEN: begin
          if (in) begin
            state <= EIGHT;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        EIGHT: begin
          if (in) begin
            state <= NINE;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        NINE: begin
          if (in) begin
            state <= TEN;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end
        end
        TEN: begin
          if (in) begin
            state <= ELEVEN;
            count <= count + 1'b1;
          end else begin
            state <= IDLE;
            count <= 5'b00000;
          end

