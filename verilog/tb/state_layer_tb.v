`include "../data/state_layer_data.v"

module state_layer_tb ();

  reg clk;
  reg rst_n;
  reg run;
  reg load;
  wire [3:0] q;

  state_layer state_layer0 (clk, rst_n, run, load, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; run=0; load=0; #100
    rst_n=1; #100
    run=1; #100
    #100
    load=1; #100
    #2000
    run=0; #100
    #100
    $finish;
  end


endmodule