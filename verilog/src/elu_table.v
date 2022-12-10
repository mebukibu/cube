module elu_table #(
    parameter filename = "../data/data18/eLU_table.txt",
    parameter integer dwidth = 8,
    parameter integer awidth = 11,          // 2^11 = 2048 > 1597
    parameter integer words = 1597
  ) (
    //input wire clk,
    input wire [awidth - 1:0] addr,
    output wire [dwidth - 1:0] q
  );

  //(* ram_style = "block" *)
  reg [dwidth - 1:0] mem [0:words - 1];

  //always @(posedge clk) begin
  assign q = mem[addr];
  //end

  initial begin
    $readmemb(filename, mem);
  end
  
endmodule