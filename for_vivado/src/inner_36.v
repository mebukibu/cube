`include "num_data.v"

module inner_36 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [36*`data_len - 1:0] d1,
    input wire [36*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  wire signed [`data_len - 1:0] temp [0:3];

  generate
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin :inner9
      inner_9 inner_9_inst (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .d1(d1[9*i*`data_len +: 9*`data_len]),
        .d2(d2[9*i*`data_len +: 9*`data_len]),
        .q(temp[i])
      );
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      q <= temp[0] + temp[1] + temp[2] + temp[3];
    end
  end
  
endmodule