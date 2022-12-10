`timescale 1 ns / 1 ps

module elu_table_tb ();

  reg clk;
  reg [11 - 1:0] addr;
  wire [8 - 1:0] q;

  rom #(
    .filename("../data/data18/eLU_table.txt"),
    .dwidth(8),
    .awidth(11),
    .words(1597)
  ) rom0 (clk, addr, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    #5
    addr=0; #10
    addr=1; #10
    addr=300; #10
    addr=1596; #10
    #10
    $finish;
  end


endmodule