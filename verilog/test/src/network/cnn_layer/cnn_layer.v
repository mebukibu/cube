`include "num_data.v"
`include "state_calc_data.v"
`include "state_layer_data.v"

module cnn_layer (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [32*3*4*`data_len - 1:0] d,
    output wire valid,
    output wire [32*12*`data_len - 1:0] q,
    //debug ports
    output wire [3:0] cs_out,
    output wire [32*12*`data_len - 1:0] data_out
  );

  // ports for state_calc
  wire load2state;
  wire [2:0] cs_calc;

  // ports for zero_padding
  wire [32*5*6*`data_len - 1:0] zpadout;

  // port for im2col
  //reg im2c_valid;
  //reg [8:0] im2c_addr;
  wire [12*288*`data_len - 1:0] im2cout;

  // ports for ram
  //wire [8:0] ram_addr;
  //wire [9*`data_len - 1:0] data2ram;
  //reg [9*`data_len - 1:0] ramout;

  // ports for dot
  wire dot_valid;
  //reg [8:0] dot_addr;
  wire [32*12*`data_len - 1:0] dotout;

  // ports for add_bias
  wire [32*12*`data_len - 1:0] biasout;

  // ports for affine_store
  reg aff_valid;
  reg [8:0] aff_addr;
  reg [9*`data_len - 1:0] affout;

  // assign
  assign load2state = (cs_calc == `CIDL) & 1'b0 |
                      (cs_calc == `ZPAD) & 1'b1 |
                      (cs_calc == `IM2C) & 1'b1 | // (im2c_valid | aff_valid) |
                      (cs_calc == `DOTP) & dot_valid |
                      (cs_calc == `BIAS) & 1'b1 |
                      (cs_calc == `FINI) & 1'b0;

  // assign ram_addr = {9{(cs_layer != `AFFINE) & (cs_calc == `IM2C)}} & im2c_addr |
  //                   {9{(cs_layer == `AFFINE) & (cs_calc == `IM2C)}} & aff_addr |
  //                   {9{(cs_calc == `DOTP)}} & dot_addr;

  // assign data2ram = {9*`data_len{cs_layer == `AFFINE}} & affout |
  //                   {9*`data_len{cs_layer != `AFFINE}} & im2cout;

  assign valid = (cs_calc == `FINI);

  // assign debug ports
  assign q = biasout;
  assign cs_out = cs_layer;
  assign data_out = biasout;

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
    //.valid(im2c_valid),
    //.addr(im2c_addr),
    .q(im2cout)
  );

  // ram ram_inst (
  //   .clk(clk),
  //   .load(cs_calc == `IM2C),
  //   .addr(ram_addr),
  //   .d(data2ram),
  //   .q(ramout)
  // );

  dot dot_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `DOTP),
    .cs_layer(cs_layer),
    .d(im2cout),
    .valid(dot_valid),
    //.addr(dot_addr),
    .q(dotout)
  );

  add_bias add_bias_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs_calc == `BIAS),
    .cs_layer(cs_layer),
    .d(dotout),
    .q(biasout)
  );

  // affine_store affine_store_inst (
  //   .clk(clk),
  //   .rst_n(rst_n),
  //   .load(cs_layer == `AFFINE && cs_calc == `IM2C),
  //   .d(d),
  //   .valid(aff_valid),
  //   .addr(aff_addr),
  //   .q(affout)
  // );

  initial begin
    //im2c_valid = 0;
    //im2c_addr = 0;
    //im2cout = 0;

    //ramout = 0;

    //dot_valid = 0;
    //dot_addr = 0;
    //dotout = 0;

    aff_valid = 0;
    aff_addr = 0;
    affout = 0;
  end
  
endmodule