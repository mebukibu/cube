module elu_rom #(
    //parameter filename = "weight18_0.txt",
    parameter integer dwidth = 8,
    parameter integer awidth = 11,          // 2^11 = 2048 > 1597
    parameter integer words = 1597
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
    $readmemb("C:/Users/masato/src/cube/verilog/test/src/network/elu_layer/eLU_table.txt", mem);
  end
  
endmodule