`include "num_data.v"

module inner_9 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [9*`data_len - 1:0] d1,
    input wire [9*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  reg signed [2*`data_len - 1:0] temp [0:9 - 1];

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      temp[0] <= 0;
      temp[1] <= 0;
      temp[2] <= 0;

      temp[3] <= 0;
      temp[4] <= 0;
      temp[5] <= 0;

      temp[6] <= 0;
      temp[7] <= 0;
      temp[8] <= 0;
    end
    else if (load) begin
      temp[0] <= $signed(d1[1*`data_len - 1:0*`data_len]) * $signed(d2[1*`data_len - 1:0*`data_len]);
      temp[1] <= $signed(d1[2*`data_len - 1:1*`data_len]) * $signed(d2[2*`data_len - 1:1*`data_len]);
      temp[2] <= $signed(d1[3*`data_len - 1:2*`data_len]) * $signed(d2[3*`data_len - 1:2*`data_len]);
      
      temp[3] <= $signed(d1[4*`data_len - 1:3*`data_len]) * $signed(d2[4*`data_len - 1:3*`data_len]);
      temp[4] <= $signed(d1[5*`data_len - 1:4*`data_len]) * $signed(d2[5*`data_len - 1:4*`data_len]);
      temp[5] <= $signed(d1[6*`data_len - 1:5*`data_len]) * $signed(d2[6*`data_len - 1:5*`data_len]);
      
      temp[6] <= $signed(d1[7*`data_len - 1:6*`data_len]) * $signed(d2[7*`data_len - 1:6*`data_len]);
      temp[7] <= $signed(d1[8*`data_len - 1:7*`data_len]) * $signed(d2[8*`data_len - 1:7*`data_len]);
      temp[8] <= $signed(d1[9*`data_len - 1:8*`data_len]) * $signed(d2[9*`data_len - 1:8*`data_len]);
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      q <=   $signed(temp[0][`data_len+`data_dec - 1:`data_dec]) + $signed(temp[1][`data_len+`data_dec - 1:`data_dec])
           + $signed(temp[2][`data_len+`data_dec - 1:`data_dec]) + $signed(temp[3][`data_len+`data_dec - 1:`data_dec])
           + $signed(temp[4][`data_len+`data_dec - 1:`data_dec]) + $signed(temp[5][`data_len+`data_dec - 1:`data_dec])
           + $signed(temp[6][`data_len+`data_dec - 1:`data_dec]) + $signed(temp[7][`data_len+`data_dec - 1:`data_dec])
           + $signed(temp[8][`data_len+`data_dec - 1:`data_dec]);
    end
  end
  
endmodule