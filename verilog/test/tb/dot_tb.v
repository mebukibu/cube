`include "num_data.v"
`include "state_layer_data.v"

module dot_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [3:0] cs_layer;
  reg [12*288*`data_len - 1:0] d;
  wire valid;
  wire [32*12*`data_len - 1:0] q;

  dot dot0 (clk, rst_n, load, cs_layer, d, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; cs_layer=`LAYER0; d={{11*288{18'b00_0000_01_00_0000_0000}}, {288{18'b00_0000_01_00_0000_0000}}}; #10
    rst_n=1; #10
    load=1; #10
    #11000
    $finish;
  end

endmodule