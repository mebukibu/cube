`include "num_data.v"

module inner_3 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3*`data_len - 1:0] d1,
    input wire [3*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  reg signed [2*`data_len - 1:0] mul [0:2];

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      mul[0] <= 0;
      mul[1] <= 0;
      mul[2] <= 0;
    end
    else if (load) begin
      mul[0] <= $signed(d1[1*`data_len - 1:0*`data_len]) * $signed(d2[1*`data_len - 1:0*`data_len]);
      mul[1] <= $signed(d1[2*`data_len - 1:1*`data_len]) * $signed(d2[2*`data_len - 1:1*`data_len]);
      mul[2] <= $signed(d1[3*`data_len - 1:2*`data_len]) * $signed(d2[3*`data_len - 1:2*`data_len]);
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q <= 0;
    end
    else if (load) begin
      q <= mul[0][`data_len+`data_dec - 1:`data_dec] + mul[1][`data_len+`data_dec - 1:`data_dec] + mul[2][`data_len+`data_dec - 1:`data_dec];
    end
  end
  
endmodule