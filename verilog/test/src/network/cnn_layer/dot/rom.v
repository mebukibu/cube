`include "num_data.v"

module rom #(
    //parameter filename = "weight18_0.txt",
    parameter integer dwidth = 6*`data_len,
    parameter integer awidth = 13,            // 2^13 = 8192 > 5120
    parameter integer words = 7680            // 32*288*5 / 9 = 5120
  ) (
    input wire clk,
    input wire [awidth - 1:0] addr,
    output reg [dwidth - 1:0] q
  );

  (* ram_style = "block" *)
  reg [dwidth - 1:0] mem [0:words - 1];

  always @(posedge clk) begin
    q <= mem[addr];
  end

  initial begin
    $readmemb("C:/Users/masato/src/cube/verilog/test/src/network/cnn_layer/dot/weight108.txt", mem);
  end
  
endmodule