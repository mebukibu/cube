`timescale 1 ns / 1 ps
`include "../data/num_data.v"
`include "../data/state_layer_data.v"

module weight_store_tb ();

  reg clk;
  reg load;
  reg [3:0] cs;
  reg [2:0] phase;
  wire valid;
  wire [36*`data_len - 1:0] q;

  weight_store #("../data/data162/weight162_0.txt") weight0(clk, load, cs, phase, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    load=0; cs=`LIDLE; phase=0; #10
    cs=`LAYER0; #10
    load=1; #10
    #60
    load=0; #10
    load=1; phase=1; #10
    #60
    load=0; #10
    load=1; cs=`LAYER2; phase=3; #10
    #60
    #50
    $finish;
  end

endmodule