`include "num_data.v"

module zero_padding (
  input wire clk,
  input wire rst_n,
  input wire load,
  input wire [32*3*4*`data_len - 1:0] d,
  output reg [32*5*6*`data_len - 1:0] q
  );

  integer i;

  always @(posedge clk, negedge rst_n)
    if (!rst_n) q <= 0;
    else if (load) begin
      for (i = 0; i < 32; i = i + 1) begin    // input data size is (32,3,4).
        q[((i*30+7 )*`data_len) +: 4*`data_len] <= d[((i*12  )*`data_len) +: 4*`data_len];
        q[((i*30+13)*`data_len) +: 4*`data_len] <= d[((i*12+4)*`data_len) +: 4*`data_len];
        q[((i*30+19)*`data_len) +: 4*`data_len] <= d[((i*12+8)*`data_len) +: 4*`data_len];
      end
    end
  
endmodule