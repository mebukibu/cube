`include "num_data.v"
`include "state_layer_data.v"

module add_bias (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [32*12*`data_len - 1:0] d,
    output reg [32*12*`data_len - 1:0] q
  );

  // use in this module
  reg [`data_len - 1:0] bias [0:32*5 - 1]; // 1 layer uses 32 bias. 5 layers.
  reg [7:0] offset;
  integer i, j;

  always @(posedge clk) begin
    if (cs_layer == `LAYER0) offset <= 0;
    else if (cs_layer == `LAYER1) offset <= 32;
    else if (cs_layer == `LAYER2) offset <= 2*32;
    else if (cs_layer == `LAYER3) offset <= 3*32;
    else if (cs_layer == `AFFINE) offset <= 4*32;
    else offset <= 8'hXX;
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      for (i = 0; i < 32; i = i + 1) begin
        for (j = 0; j < 12; j = j + 1) begin
          q[(12*i+j)*`data_len +: `data_len] <= d[(12*i+j)*`data_len +: `data_len] + bias[i + offset];
        end
      end
    end
  end

  initial begin
    $readmemb("C:/Users/masato/src/cube/verilog/test/src/network/cnn_layer/bias18_data.txt", bias);
  end

endmodule