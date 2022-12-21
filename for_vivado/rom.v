`include "num_data.v"

module rom #(
    parameter filename = "../data/data162/weight162_0.txt",
    parameter integer dwidth = 9*`data_len,
    parameter integer awidth = 8,          // 2^8 = 256 > 5*32 = 160
    parameter integer words = 5*32
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
    //$readmemb(filename, mem);
  end
  
endmodule