module main_wrap_tb ();

  reg clk;
  reg rst_n;
  reg run;
  wire [2:0] cs_out;
  wire [9:0] data_disp;
  wire q;

  main_wrap main_wrap0 (clk, rst_n, run, cs_out, data_disp, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; run=0; #10
    rst_n=1; #10
    run=1; #10
    #100
    $finish;
  end

endmodule