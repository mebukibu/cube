`include "../data/num_data.v"

module im2col_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [32*5*6*`data_len - 1:0] d;
  wire valid;
  wire [8:0] addr;
  wire [9*`data_len - 1:0] q;

  wire [9*`data_len - 1:0] ramout;
  
  im2col im2col0 (clk, rst_n, load, d, valid, addr, q);
  ram ram0 (clk, load, addr, q, ramout);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d={13{`data_len'h3ffff}}; #10
    rst_n=1; #10
    load=1; #10
    #4000
    $finish;
  end
  
endmodule