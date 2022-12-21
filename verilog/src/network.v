`include "../data/num_data.v"
`include "../data/state_layer_data.v"

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
  assign load2state = (cs == `LIDLE)  & 1'b0 |
                      (cs == `BUFFER) & 1'b1 |
                      (cs == `LAYER0) & cnn_valid |
                      (cs == `LAYER1) & cnn_valid |
                      (cs == `LAYER2) & cnn_valid |
                      (cs == `LAYER3) & cnn_valid |
                      (cs == `AFFINE) & cnn_valid |
                      (cs == `ELU   ) & elu_valid |
                      (cs == `COMP  ) & comp_valid |
                      (cs == `LFIN  ) & 1'b0;

  // assign for cnn_layer
  assign load2cnn = (cs == `LAYER0) | (cs == `LAYER1) | (cs == `LAYER2) | (cs == `LAYER3) | (cs == `AFFINE);
  assign data2cnn = (cs == `LAYER0) ? bufout : eluout;

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