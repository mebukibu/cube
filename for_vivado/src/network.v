`include "num_data.v"
`include "state_layer_data.v"

module network (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [120 - 1:0] d,
    output wire valid,
    output wire [3:0] q 
  );

  // ports for state_layer
  wire load2state;
  wire [3:0] cs;

  // ports for cube_data_buffer
  wire [32*3*4*`data_len - 1:0] bufout;

  //ports for cnn_layer
  wire load2cnn;
  wire [32*3*4*`data_len - 1:0] data2cnn;
  wire [12*288*`data_len - 1:0] affine2cnn;
  wire cnn_valid;
  wire [32*12*`data_len - 1:0] cnnout;

  // ports for elu_layer
  wire elu_valid;
  wire [32*12*`data_len - 1:0] eluout;

  // port for comp_layer
  wire comp_valid;
  wire [12*`data_len - 1:0] comp_d1;
  wire [12*`data_len - 1:0] comp_d2;


  // assign for state_layer
  assign load2state = (cs == `LIDLE)  ? 1'b0 : 1'bZ;
  assign load2state = (cs == `BUFFER) ? 1'b1 : 1'bZ;
  assign load2state = (cs == `LAYER0) ? cnn_valid : 1'bZ;
  assign load2state = (cs == `LAYER1) ? cnn_valid : 1'bZ;
  assign load2state = (cs == `LAYER2) ? cnn_valid : 1'bZ;
  assign load2state = (cs == `LAYER3) ? cnn_valid : 1'bZ;
  assign load2state = (cs == `AFFINE) ? cnn_valid : 1'bZ;
  assign load2state = (cs == `ELU   ) ? elu_valid : 1'bZ;
  assign load2state = (cs == `COMP  ) ? comp_valid : 1'bZ;
  assign load2state = (cs == `LFIN  ) ? 1'b0 : 1'bZ;

  // assign for cnn_layer
  assign load2cnn = (cs == `LAYER0) | (cs == `LAYER1) | (cs == `LAYER2) | (cs == `LAYER3) | (cs == `AFFINE);
  assign data2cnn = (cs == `LAYER0) ? bufout : eluout;
  assign affine2cnn = {
    {10*288*`data_len{1'b0}},
    {96*`data_len{1'b0}}, eluout[32*6*`data_len +: 192*`data_len],
    {96*`data_len{1'b0}}, eluout[0 +: 32*6*`data_len]};

  // assign for output
  assign valid = (cs == `LFIN);

  generate
    genvar i;
    for (i = 0; i < 12; i = i + 1) begin
      assign comp_d1[i*`data_len +: `data_len] = cnnout[12*i*`data_len +: `data_len];
      assign comp_d2[i*`data_len +: `data_len] = cnnout[(12*(i+12)+1)*`data_len +: `data_len];
    end
  endgenerate

  // instance
  state_layer state_layer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(load),
    .load(load2state),
    .q(cs)
  );

  cube_data_buffer cube_data_buffer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `BUFFER),
    .d(d),
    .q(bufout)
  );

  cnn_layer cnn_layer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load2cnn),
    .cs_layer(cs),
    .d(data2cnn),
    .d_affine(affine2cnn),
    .valid(cnn_valid),
    .q(cnnout)
  );

  elu_layer elu_layer_inst (
    .clk(clk),
    .load(cs == `ELU),
    .d(cnnout),
    .valid(elu_valid),
    .q(eluout)
  );

  comp_layer comp_layer_inst (
    .clk(clk),
    .load(cs == `COMP),
    .d1(comp_d1),
    .d2(comp_d2),
    .valid(comp_valid),
    .q(q)
  );
  
endmodule