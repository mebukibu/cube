`include "../data/num_data.v"
`include "../data/state_layer_data.v"

module dot_tb ();

  reg clk;
  reg rst_n;

  // ports for im2col
  reg im_load;
  reg [32*5*6*`data_len - 1:0] d;
  wire im_valid;
  wire [8:0] im_addr;
  wire [9*`data_len - 1:0] imout;

  // ports for ram
  reg ram_load;
  wire [8:0] ram_addr;
  wire [9*`data_len - 1:0] ramout;
  
  // ports for dot
  reg dot_load;
  reg [3:0] cs;
  wire dot_valid;
  wire [8:0] dot_addr;
  wire [12*32*`data_len - 1:0] q;

  im2col im2col0 (clk, rst_n, im_load, d, im_valid, im_addr, imout);
  ram ram0 (clk, ram_load, ram_addr, imout, ramout);
  dot dot0 (clk, rst_n, dot_load, cs, ramout, dot_valid, dot_addr, q);

  initial clk = 0;
  always #5 clk = ~clk;

  assign ram_addr = im_load ? im_addr : 9'hZZZ;
  assign ram_addr = dot_load ? dot_addr : 9'hZZZ;

  initial begin
    $dumpvars;
    rst_n=0; im_load=0; ram_load=0; dot_load=0; cs=`LIDLE; d={32*5*6{18'b00_0000_01_00_0000_0000}}; #10
    rst_n=1; #10
    cs=`LAYER1; #10
    im_load=1; ram_load=1;#10
    #4000
    im_load=0; ram_load=0; dot_load=1; #10
    #11000
    $finish;
  end

endmodule  