`include "num_data.v"

module inner_6 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [6*`data_len - 1:0] d1,
    input wire [6*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  reg signed [2*`data_len - 1:0] mul [0:5];
  reg [`data_len - 1:0] add1 [0:1];

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      mul[0] <= 0;
      mul[1] <= 0;
      mul[2] <= 0;

      mul[3] <= 0;
      mul[4] <= 0;
      mul[5] <= 0;
    end
    else if (load) begin
      mul[0] <= $signed(d1[1*`data_len - 1:0*`data_len]) * $signed(d2[1*`data_len - 1:0*`data_len]);
      mul[1] <= $signed(d1[2*`data_len - 1:1*`data_len]) * $signed(d2[2*`data_len - 1:1*`data_len]);
      mul[2] <= $signed(d1[3*`data_len - 1:2*`data_len]) * $signed(d2[3*`data_len - 1:2*`data_len]);
      
      mul[3] <= $signed(d1[4*`data_len - 1:3*`data_len]) * $signed(d2[4*`data_len - 1:3*`data_len]);
      mul[4] <= $signed(d1[5*`data_len - 1:4*`data_len]) * $signed(d2[5*`data_len - 1:4*`data_len]);
      mul[5] <= $signed(d1[6*`data_len - 1:5*`data_len]) * $signed(d2[6*`data_len - 1:5*`data_len]);
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      add1[0] <= 0;
      add1[1] <= 0;
    end
    else if (load) begin
      add1[0] <= mul[0][`data_len+`data_dec - 1:`data_dec] + mul[1][`data_len+`data_dec - 1:`data_dec] + mul[2][`data_len+`data_dec - 1:`data_dec];
      add1[1] <= mul[3][`data_len+`data_dec - 1:`data_dec] + mul[4][`data_len+`data_dec - 1:`data_dec] + mul[5][`data_len+`data_dec - 1:`data_dec];
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q <= 0;
    end
    else if (load) begin
      q <= add1[0] + add1[1];
    end
  end
  
endmodule