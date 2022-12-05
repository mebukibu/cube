`include "../data/num_data.v"

module inner_new (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire signed [9*`data_len - 1:0] d1,
    input wire signed [9*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  reg signed [2*`data_len - 1:0] temp [0:9 - 1];
  reg signed [  `data_len - 1:0] sum  [0:3 - 1];

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
      temp[0] <= d1[1*`data_len - 1:0*`data_len] * d2[1*`data_len - 1:0*`data_len];
      temp[1] <= d1[2*`data_len - 1:1*`data_len] * d2[2*`data_len - 1:1*`data_len];
      temp[2] <= d1[3*`data_len - 1:2*`data_len] * d2[3*`data_len - 1:2*`data_len];
      
      temp[3] <= d1[4*`data_len - 1:3*`data_len] * d2[4*`data_len - 1:3*`data_len];
      temp[4] <= d1[5*`data_len - 1:4*`data_len] * d2[5*`data_len - 1:4*`data_len];
      temp[5] <= d1[6*`data_len - 1:5*`data_len] * d2[6*`data_len - 1:5*`data_len];
      
      temp[6] <= d1[7*`data_len - 1:6*`data_len] * d2[7*`data_len - 1:6*`data_len];
      temp[7] <= d1[8*`data_len - 1:7*`data_len] * d2[8*`data_len - 1:7*`data_len];
      temp[8] <= d1[9*`data_len - 1:8*`data_len] * d2[9*`data_len - 1:8*`data_len];
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      sum[0] <= 0;
      sum[1] <= 0;
      sum[2] <= 0;
    end
    else if (load) begin
      sum[0] <= temp[0][`data_len+`data_dec - 1:`data_dec] + temp[1][`data_len+`data_dec - 1:`data_dec] + temp[2][`data_len+`data_dec - 1:`data_dec];
      sum[1] <= temp[3][`data_len+`data_dec - 1:`data_dec] + temp[4][`data_len+`data_dec - 1:`data_dec] + temp[5][`data_len+`data_dec - 1:`data_dec];
      sum[2] <= temp[6][`data_len+`data_dec - 1:`data_dec] + temp[7][`data_len+`data_dec - 1:`data_dec] + temp[8][`data_len+`data_dec - 1:`data_dec];
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q <= 0;
    end
    else if (load) begin
      q <= sum[0] + sum[1] + sum[2];  
    end
  end


  
endmodule