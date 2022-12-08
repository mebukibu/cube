`include "../data/num_data.v"

module inner_288 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [288*`data_len - 1:0] d1,
    input wire [288*`data_len - 1:0] d2,
    output reg signed [`data_len - 1:0] q
  );

  // ports for inner_36
  reg [36*`data_len - 1:0] d1_inner;
  reg [36*`data_len - 1:0] d2_inner;
  wire [`data_len - 1:0] innerout;

  // use in this module
  wire [36*`data_len - 1:0] d1_36 [0:7];
  wire [36*`data_len - 1:0] d2_36 [0:7];
  reg signed [`data_len - 1:0] q_temp [0:7];  // inner 36 repeats 8 times. (36*8) = 288.

  reg [2:0] index;

  generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin
      assign d1_36[i] = d1[36*i*`data_len +: 36*`data_len];
      assign d2_36[i] = d2[36*i*`data_len +: 36*`data_len];
    end
  endgenerate

  inner_36 inner_36_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .d1(d1_inner),
    .d2(d2_inner),
    .q(innerout)
  );

  always @(posedge clk) begin
    if (!rst_n) begin 
      index <= 0;
    end
    else if (load) begin
      index <= index + 1;
    end

    d1_inner <= d1_36[index];
    d2_inner <= d2_36[index];
    q_temp[index] <= innerout;

  end  

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      q <=   q_temp[0] + q_temp[1] + q_temp[2] + q_temp[3]
           + q_temp[4] + q_temp[5] + q_temp[6] + q_temp[7];
    end
  end
  
endmodule