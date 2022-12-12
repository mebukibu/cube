module network_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [32*4 - 1:0] d;
  wire valid;
  wire [3:0] q;

  network network0 (clk, rst_n, load, d, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d=128'h82a54907b1630900184e800098f; #10
    rst_n=1; #10
    load=1; #10
    #30000
    $display("%b", q);
    $finish;
  end


endmodule