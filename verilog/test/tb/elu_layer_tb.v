`include "num_data.v"

module elu_layer_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [32*12*`data_len - 1:0] d;
  wire valid;
  wire [32*12*`data_len - 1:0] q;

  elu_layer elu_layer0 (clk, rst_n, load, d, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    load=0; d={{31*12{18'b00000000_0000000000}}, {12{18'b00000001_0000000000}}}; #10
    load=1; #10
    #1000
    load=0;
    #100
    $finish;
  end
  

endmodule