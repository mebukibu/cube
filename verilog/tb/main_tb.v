`include "../data/state_main_data.v"

module main_tb ();

  reg clk;
  reg rst_n;
  reg run;
  reg [120 - 1:0] d;
  output wire q;

  main main0 (clk, rst_n, run, d, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; run=0; d=120'h82a54907b1630900184e800098f; #10
    rst_n=1; #10
    run=1; #10
    #140000
    $finish;
  end

endmodule