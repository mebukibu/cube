`include "num_data.v"
`include "state_layer_data.v"

module add_bias (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [12*32*`data_len - 1:0] d,
    output reg valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // use in this module
  integer m, n;
  reg [7:0] offset;
  reg [4:0] index;
  wire [`data_len - 1:0] d_temp [0:11][0:31];
  reg [`data_len - 1:0] q_temp [0:11][0:31];
  reg [`data_len - 1:0] bias [0:32*5 - 1];      // 1 layer uses 32 bias. 5 layers.

  // assign
  generate
    genvar i, j;
    for (i = 0; i < 12 ; i = i + 1) begin
      for (j = 0; j < 32; j = j + 1) begin
        assign d_temp[i][j] = d[(32*i+j)*`data_len +: `data_len];
        assign q[(32*i+j)*`data_len +: `data_len] = q_temp[i][j];
      end
    end
  endgenerate

  always @(cs_layer) begin
    case (cs_layer)
      `LAYER0 : offset = 0*32;
      `LAYER1 : offset = 1*32;
      `LAYER2 : offset = 2*32;
      `LAYER3 : offset = 3*32;
      `AFFINE : offset = 4*32;
      default : offset = 8'hXX;
    endcase
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      valid <= 0;
      index <= 0;
      for (m = 0; m < 12; m = m + 1)
        for (n = 0; n < 32; n = n + 1) 
          q_temp[m][n] <= 0;
    end
    else if (load) begin
      if (index == 31) valid <= 1;
      else index <= index + 1;
      for (m = 0; m < 12; m = m + 1)
        q_temp[m][index] <= d_temp[m][index] + bias[{3'h0, index} + offset];
    end
    else begin
      valid <= 0;
      index <= 0;
    end
  end

  initial begin
    $readmemb("C:/Users/masato/src/cube/verilog/test/src/network/cnn_layer/bias18_data.txt", bias);
  end

endmodule