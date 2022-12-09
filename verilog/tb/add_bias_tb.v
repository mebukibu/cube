`include "../data/num_data.v"

module add_bias_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [2:0] cs;
  reg [12*32*`data_len - 1:0] d;
  wire [12*32*`data_len - 1:0] q;

  add_bias add_bias0 (clk, rst_n, load, cs, d, q);

    initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; cs=0; d={12*32{18'b00_0000_00_00_0000_0000}}; #10
    rst_n=1; #10
    cs=1; #10
    load=1; #10
    #30
    load=0; #10
    cs=5; #10
    load=1; #10
    #30
    $finish;
  end

endmodule