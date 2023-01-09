`include "../data/num_data.v"

module inner_36 (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [36*`data_len - 1:0] d1,
    input wire [36*`data_len - 1:0] d2,
    output reg [`data_len - 1:0] q
  );

  wire [`data_len - 1:0] innerout [0:3];
  reg [`data_len - 1:0] add [0:1];

  generate
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin :inner9
      inner_9 inner_9_inst (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .d1(d1[9*i*`data_len +: 9*`data_len]),
        .d2(d2[9*i*`data_len +: 9*`data_len]),
        .q(innerout[i])
      );
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      add[0] <= 0;
      add[1] <= 0;
    end
    else if (load) begin
      add[0] <= innerout[0] + innerout[1];
      add[1] <= innerout[2] + innerout[3];
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q <= 0;
    end
    else if (load) begin
      q <= add[0] + add[1];
    end
  end
  
endmodule