`include "../data/num_data.v"

module rom #(
    parameter filename = "../data/data18/weight18_0.txt",
    parameter integer dwidth = `data_len,
    parameter integer awidth = 11,          // 2^11 = 2048 > 5*288 = 1440
    parameter integer words = 5*288
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
    $readmemb(filename, mem);
  end
  
endmodule