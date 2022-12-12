`include "../data/num_data.v"
`include "../data/state_calc_data.v"
`include "../data/state_layer_data.v"

module cnn_layer (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [32*3*4*`data_len - 1:0] d,
    input wire [32*3*4*`data_len - 1:0] d_affine,
    output wire valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // ports for state_calc
  wire load2state;
  wire [2:0] cs_calc;

  // ports for zero_padding
  wire [32*5*6*`data_len - 1:0] zpadout;

  // port for im2col
  wire [12*288*`data_len - 1:0] im2cout;

  // ports for dot
  wire dot_valid;
  wire [12*288*`data_len - 1:0] data2dot;
  wire [12*32*`data_len - 1:0] dotout;

  // assign
  assign load2state = (cs_calc == `DOTP) ? dot_valid : 1'b1;
  assign data2dot = (cs_layer == `AFFINE) ? d_affine : im2cout;
  assign valid = (cs_calc == `FINI);

  // instance
  state_calc state_calc_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(load),
    .load(load2state),
    .q(cs_calc)
  );

  zero_padding zero_padding_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `ZPAD),
    .d(d),
    .q(zpadout)
  );

  im2col im2col_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `IM2C),
    .d(zpadout),
    .q(im2cout)
  );

  dot dot_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `DOTP),
    .cs(cs_layer),
    .d(data2dot),
    .valid(dot_valid),
    .q(dotout)
  );

  add_bias add_bias_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `BIAS),
    .cs(cs_layer),
    .d(dotout),
    .q(q)
  );
  
endmodule