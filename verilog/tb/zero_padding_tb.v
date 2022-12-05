`include "../data/num_data.v"

module zero_padding_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [32*3*4*`data_len - 1:0] d;
  wire [32*5*6*`data_len - 1:0] q;

  zero_padding zero_padding0(clk, rst_n, load, d, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d={16{16'hffff}}; #100
    rst_n=1; #100
    load=1; #100
    #100
    $finish;
  end


endmodule