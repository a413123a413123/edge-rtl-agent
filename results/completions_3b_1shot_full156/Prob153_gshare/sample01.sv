module TopModule
(
  input  logic clk,
  input  logic areset,

  input  logic predict_valid,
  input  logic [6:0] predict_pc,
  output logic predict_taken,
  output logic [6:0] predict_history,

  input  logic train_valid,
  input  logic train_taken,
  input  logic train_mispredicted,
  input  logic [6:0] train_history,
  input  logic [6:0] train_pc
);

  // Global history register
  logic [6:0] global_history;

  // PHT table
  logic [11:0] pht_table[127];

  // Function to calculate the index
  function [6:0] calculate_index(input [6:0] pc, input [6:0] global_history);
    return (pc ^ global_history);
  endfunction

  // Function to update the PHT table
  function void update_pht(input [6:0] index, input logic train_valid, input logic train_taken, input logic train_mispredicted, input logic [6:0] train_history, input logic [6:0] train_pc);
    if (train_valid) begin
      if (train_mispredicted) begin
        // Recover branch history register to the state immediately after the mispredicting branch completes execution
        global_history = train_history;
      end else begin
        // Update the PHT table
        pht_table[index] = {pht_table[index][10:0], train_taken};
      end
    end
  endfunction

  // Combinational logic
  assign predict_taken = pht_table[calculate_index(predict_pc, global_history)][1];
  assign predict_history = global_history;

  // Sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
    end else begin
      if (predict_valid) begin
        // Update the global history register
        global_history = {global_history[5:0], predict_taken};
      end
      if (train_valid) begin
        // Update the PHT table
        update_pht(calculate_index(train_pc, global_history), train_valid, train_taken, train_mispredicted, train_history, train_pc);
      end
    end
  end

endmodule
