`include "../data/num_data.v"
`include "../data/state_calc_data.v"
`include "../data/state_layer_data.v"

module cnn_layer (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [32*3*4*`data_len - 1:0] d,
    output wire valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // ports for state_calc
  wire load2state;
  wire [2:0] cs_calc;

  // ports for zero_padding
  wire [32*5*6*`data_len - 1:0] zpadout;

  // port for im2col
  wire im2c_valid;
  wire [8:0] im2c_addr;
  wire [9*`data_len - 1:0] im2cout;

  // ports for ram
  wire [8:0] ram_addr;
  wire [9*`data_len - 1:0] ramout;

  // ports for dot
  wire dot_valid;
  //wire [12*288*`data_len - 1:0] data2dot;
  wire [8:0] dot_addr;
  wire [12*32*`data_len - 1:0] dotout;

  // assign
  assign load2state = (cs_calc == `CIDL) ? 1'b0 : 1'bZ;
  assign load2state = (cs_calc == `ZPAD) ? 1'b1 : 1'bZ;
  assign load2state = (cs_calc == `IM2C) ? im2c_valid : 1'bZ;
  assign load2state = (cs_calc == `DOTP) ? dot_valid : 1'bZ;
  assign load2state = (cs_calc == `BIAS) ? 1'b1 : 1'bZ;
  assign load2state = (cs_calc == `FINI) ? 1'b0 : 1'bZ;

  //assign data2dot = (cs_layer == `AFFINE) ? d_affine : im2cout;
  assign ram_addr = (cs_calc == `IM2C) ? im2c_addr : 9'hZZZ;
  assign ram_addr = (cs_calc == `DOTP) ? dot_addr : 9'hZZZ;
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
    .valid(im2c_valid),
    .addr(im2c_addr),
    .q(im2cout)
  );

  ram ram_inst (
    .clk(clk),
    .load(cs_calc == `IM2C),
    .addr(ram_addr),
    .d(im2cout),
    .q(ramout)
  );

  dot dot_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `DOTP),
    .cs(cs_layer),
    .d(ramout),
    .valid(dot_valid),
    .addr(dot_addr),
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