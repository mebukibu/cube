`include "../data/num_data.v"

module dot_channel_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [2:0] cs;
  reg [288*`data_len - 1:0] d;
  wire valid;
  wire [`data_len - 1:0] q;

  dot_channel dot_channel0 (clk, rst_n, load, cs, d, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; cs=0; d={288{18'b0000_01_00_0000_0000}}; #10
    rst_n=1; #10
    cs=1; #10
    load=1; #10
    #3000
    #5000
    //load=0;
    #100
    cs=2; #100
    #3000
    #5000
    $finish;
  end

endmodule