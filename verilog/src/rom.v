`include "../data/num_data.v"

module rom #(
    parameter filename = "../data/data18/weight18_0.txt",
    parameter integer width = 11,     // 2^11 = 2048 > 5*288 = 1440
    parameter integer depth = 5*288
  ) (
    input wire clk,
    input wire [width - 1:0] addr,
    output reg [`data_len - 1:0] q
  );

  reg [`data_len - 1:0] mem [0:depth - 1];

  always @(posedge clk) begin
    q <= mem[addr];
  end

  initial begin
    $readmemb(filename, mem);
  end
  
endmodule