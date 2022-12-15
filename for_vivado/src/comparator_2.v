`include "num_data.v"

module comparator_2 (
    input wire clk,
    input wire [3:0] d1_num,
    input wire signed [`data_len - 1:0] d1,
    input wire [3:0] d2_num,
    input wire signed [`data_len - 1:0] d2,
    output reg [3:0] q_num,
    output reg signed [`data_len - 1:0] q
  );

  always @(posedge clk) begin
    if (d1 > d2) begin
      q_num <= d1_num;
      q <= d1;
    end
    else begin
      q_num <= d2_num;
      q <= d2;
    end
  end
  
endmodule