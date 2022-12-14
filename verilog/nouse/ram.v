`include "../data/num_data.v"

module ram #(
    parameter integer dwidth = `data_len,
    parameter integer awidth = 12,              // 2^12 = 4096 > 12*288 = 3456
    parameter integer words = 12*288
  ) (
    input wire clk,
    input wire load,
    input wire [awidth - 1:0] addr,
    input wire [dwidth - 1:0] d,
    output reg [dwidth - 1:0] q
  );

  (* ram_style = "block" *)
  reg [dwidth - 1:0] mem [0:words - 1];

  always @(posedge clk) begin
    if (load) mem[addr] <= d;
    q <= mem[addr];
  end
  
endmodule