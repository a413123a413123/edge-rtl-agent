[BEGIN]
module TopModule
(
  input  logic clk,
  input  logic reset,
  input  logic data,
  output logic [3:0] count,
  output logic counting,
  output logic done,
  input  logic ack
);

  // State machine
  typedef enum {IDLE, START, COUNT, DONE} state_t;
  state_t current_state, next_state;

  // Variables
  logic [3:0] delay;
  logic [3:0] count_value;
  logic [3:0] count_remaining;
  logic [3:0] count_temp;
  logic [3:0] count_temp2;
  logic [3:0] count_temp3;
  logic [3:0] count_temp4;
  logic [3:0] count_temp5;
  logic [3:0] count_temp6;
  logic [3:0] count_temp7;
  logic [3:0] count_temp8;
  logic [3:0] count_temp9;
  logic [3:0] count_temp10;
  logic [3:0] count_temp11;
  logic [3:0] count_temp12;
  logic [3:0] count_temp13;
  logic [3:0] count_temp14;
  logic [3:0] count_temp15;
  logic [3:0] count_temp16;
  logic [3:0] count_temp17;
  logic [3:0] count_temp18;
  logic [3:0] count_temp19;
  logic [3:0] count_temp20;
  logic [3:0] count_temp21;
  logic [3:0] count_temp22;
  logic [3:0] count_temp23;
  logic [3:0] count_temp24;
  logic [3:0] count_temp25;
  logic [3:0] count_temp26;
  logic [3:0] count_temp27;
  logic [3:0] count_temp28;
  logic [3:0] count_temp29;
  logic [3:0] count_temp30;
  logic [3:0] count_temp31;
  logic [3:0] count_temp32;
  logic [3:0] count_temp33;
  logic [3:0] count_temp34;
  logic [3:0] count_temp35;
  logic [3:0] count_temp36;
  logic [3:0] count_temp37;
  logic [3:0] count_temp38;
  logic [3:0] count_temp39;
  logic [3:0] count_temp40;
  logic [3:0] count_temp41;
  logic [3:0] count_temp42;
  logic [3:0] count_temp43;
  logic [3:0] count_temp44;
  logic [3:0] count_temp45;
  logic [3:0] count_temp46;
  logic [3:0] count_temp47;
  logic [3:0] count_temp48;
  logic [3:0] count_temp49;
  logic [3:0] count_temp50;
  logic [3:0] count_temp51;
  logic [3:0] count_temp52;
  logic [3:0] count_temp53;
  logic [3:0] count_temp54;
  logic [3:0] count_temp55;
  logic [3:0] count_temp56;
  logic [3:0] count_temp57;
  logic [3:0] count_temp58;
  logic [3:0] count_temp59;
  logic [3:0] count_temp60;
  logic [3:0] count_temp61;
  logic [3:0] count_temp62;
  logic [3:0] count_temp63;
  logic [3:0] count_temp64;
  logic [3:0] count_temp65;
  logic [3:0] count_temp66;
  logic [3:0] count_temp67;
  logic [3:0] count_temp68;
  logic [3:0] count_temp69;
  logic [3:0] count_temp70;
  logic [3:0] count_temp71;
  logic [3:0] count_temp72;
  logic [3:0] count_temp73;
  logic [3:0] count_temp74;
  logic [3:0] count_temp75;
  logic [3:0] count_temp76;
  logic [3:0
