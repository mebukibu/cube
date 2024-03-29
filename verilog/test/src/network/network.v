`include "num_data.v"
`include "state_layer_data.v"

module network (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [120 - 1:0] d,
    output wire valid,
    output wire [3:0] q,
    // debug ports
    output wire [3:0] cs_out
    //output wire [32*12*`data_len - 1:0] data_out
  );

  // ports for state_layer
  wire load2state;
  wire [3:0] cs;

  // ports for cube_data_buffer
  wire [4*3*4*`data_len - 1:0] bufout;

  //ports for cnn_layer
  wire load2cnn;
  wire [4*3*4*`data_len - 1:0] data2cnn;
  wire cnn_valid;
  wire [32*12*`data_len - 1:0] cnnout;
  //wire [`data_len - 1:0] cnn_temp [0:11][0:31];

  // ports for elu_layer
  wire elu_valid;
  wire [32*12*`data_len - 1:0] elu_in;
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
  assign data2cnn = {4*3*4*`data_len{cs == `LAYER0}} & bufout |
                    {4*3*4*`data_len{cs != `LAYER0}} & eluout[4*3*4*`data_len - 1:0];

  // assign for comp_layer
  assign comp_d1 = cnnout[0 +: 12*`data_len];
  assign comp_d2 = cnnout[(32+12)*`data_len +: 12*`data_len];

  // assign for output
  assign valid = (cs == `LFIN);

  // assign debug ports
  //assign q = 0;
  assign cs_out = cs;
  //assign data_out = cnnout;

  // transpose matrix
  generate
    genvar i, j;
    for (i = 0; i < 32; i = i + 1)
      for (j = 0; j < 12; j = j + 1)
        assign elu_in[(12*i+j)*`data_len +: `data_len] = cnnout[(32*j+i)*`data_len +: `data_len];
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
    .d({eluout[32*12*`data_len - 1 : 4*3*4*`data_len], data2cnn}),
    .valid(cnn_valid),
    .q(cnnout)
    // debug ports
    //.cs_out(cs_out),
    //.data_out(data_out)
  );

  elu_layer elu_layer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `ELU),
    .d(elu_in),
    .valid(elu_valid),
    .q(eluout)
  );

  comp_layer comp_layer_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `COMP),
    .d1(comp_d1),
    .d2(comp_d2),
    .valid(comp_valid),
    .q(q)
  );

  initial begin
    //cnn_valid = 0;
    //cnnout = 0;

    //elu_valid = 0;
    //eluout = 0;

    //comp_valid = 0;
    //comp_d1 = 0;
    //comp_d2 = 0;
  end
  
endmodule