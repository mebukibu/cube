`timescale 1 ns / 1 ps
`include "../data/num_data.v"

module weight_store_tb ();

  reg clk;
  reg [2:0] cs;
  wire valid;
  wire [288*`data_len - 1:0] q;

  weight_store #("../data/data18/weight18_0.txt") weight0(clk, cs, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    cs = 0; #40
    cs = 1; #3000
    cs = 5; #3000
    $finish;
  end

endmodule