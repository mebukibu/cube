module current_cube_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [119:0] d;
  wire [119:0] q;

  current_cube cube0(clk, rst_n, load, d, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d=0; #100
    rst_n=1; #100
    load=1; d=123; #100
    load=0; d=456; #100
    load=1; #100
    rst_n=0; #100
    $finish;
  end
  
endmodule