`include "../data/state_main_data.v"

module state_main_tb ();

  reg clk;
  reg rst_n;
  reg run;
  reg load;
  reg fin;
  wire [2:0] q;

  state_main state_main0 (clk, rst_n, run, load, fin, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; run=0; load=0; fin=0; #100
    rst_n=1; #100
    run=1; #100
    #100
    load=1; #100
    #1000
    fin=1; #100
    #100
    $finish;
  end


endmodule