`include "../data/num_data.v"

module im2col (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [32*5*6*`data_len - 1:0] d,
    output reg [12*288*`data_len - 1:0] q
  );

  integer i, j, k;

  always @(posedge clk, negedge rst_n)
    if (!rst_n) q <= 0;
    else if (load) begin
      for (i = 0; i < 32; i = i+1) begin    // input data size is (32,5,6).
        for (j = 0; j < 3; j = j+1) begin
          for (k = 0; k < 4; k = k+1) begin
            q[((0+288*k+288*4*j+9*i)*`data_len) +: 3*`data_len] <= d[(( 0+k+6*j+30*i)*`data_len) +: 3*`data_len];
            q[((3+288*k+288*4*j+9*i)*`data_len) +: 3*`data_len] <= d[(( 6+k+6*j+30*i)*`data_len) +: 3*`data_len];
            q[((6+288*k+288*4*j+9*i)*`data_len) +: 3*`data_len] <= d[((12+k+6*j+30*i)*`data_len) +: 3*`data_len];
          end
        end
      end
    end
  
endmodule