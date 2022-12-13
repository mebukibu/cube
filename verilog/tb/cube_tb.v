`include "../data/state_cube_data.v"

module cube_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg store;
  reg [120 - 1:0] store_data;
  reg [3:0] d;
  wire valid;
  wire fin;
  wire [120 - 1:0] q;

  cube cube0 (clk, rst_n, load, store, store_data, d, valid, fin, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; store=0; d=0;
    store_data=120'h82a54907b1630900184e800098f; #10
    rst_n=1; #10
    store=1; #10
    store=0; #10
    d=4; #10
    load=1; #10
    #50
    load=0; #10
    d=10; #10
    load=1; #10
    #50
    load=0; #10
    d=12; #10
    load=1; #10
    #50
    load=0; #10
    d=12; #10
    load=1; #10
    #50
    load=0; #10
    d=2; #10
    load=1; #10
    #100
    $finish;
  end

endmodule