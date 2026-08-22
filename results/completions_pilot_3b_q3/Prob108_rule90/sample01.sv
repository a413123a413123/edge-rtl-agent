

[BEGIN
TopModule(
  input clk,

  output q [51:0]
  input data [51:0]
  load data [51:0]

  state q = load data

  state q = state q | (state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1)

  next state q = state q | (state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next load data = load data | (load data[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next load data = load data | (next load data[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next load data = load data | (next load data[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next load data = load data | (next load data[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next load data = load data | (next load data[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1

  next state q = next state q | (next state q[51:0] | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 0) | 1) | 
