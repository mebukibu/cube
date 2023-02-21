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
  reg [32*`data_len - 1:0] bias;
  reg [32*`data_len - 1:0] bias_mem [0:4]; // 1 layer uses 32 bias. 5 layers.
  // reg [7:0] offset;
  integer i, j;

  // always @(posedge clk) begin
  //   if (cs_layer == `LAYER0) offset <= 0;
  //   else if (cs_layer == `LAYER1) offset <= 32;
  //   else if (cs_layer == `LAYER2) offset <= 2*32;
  //   else if (cs_layer == `LAYER3) offset <= 3*32;
  //   else if (cs_layer == `AFFINE) offset <= 4*32;
  //   else offset <= 8'hXX;
  // end

  always @(cs_layer) begin
    case (cs_layer)
      `LAYER0 : bias <= bias_mem[0]; //offset <= 0*32;
      `LAYER1 : bias <= bias_mem[1]; //offset <= 1*32;
      `LAYER2 : bias <= bias_mem[2]; //offset <= 2*32;
      `LAYER3 : bias <= bias_mem[3]; //offset <= 3*32;
      `AFFINE : bias <= bias_mem[4]; //offset <= 4*32;
      default : bias <= {32*`data_len{1'bX}}; //offset <= 8'hXX;
    endcase
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      for (i = 0; i < 32; i = i + 1) begin
        for (j = 0; j < 12; j = j + 1) begin
          q[(12*i+j)*`data_len +: `data_len] <= d[(12*i+j)*`data_len +: `data_len] + bias[i*`data_len +: `data_len];
        end
      end
    end
  end

  initial begin
    $readmemb("C:/Users/masato/src/cube/verilog/test/src/network/cnn_layer/bias576_data.txt", bias_mem);
  end

endmodule