`include "../data/num_data.v"

module elu_table_tb ();

  reg clk;
  reg [`data_len - 1:0] d;
  wire [`data_len - 1:0] q;

 elu_table elu_table0 (clk, d, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    #55
    d=18'b11111001_1100010000; #100 // -6.234375
    d=18'b00000000_0000000000; #100 // 0
    d=18'b11111111_0000000000; #100 // -1
    d=18'b00000001_0000000000; #100 // 1
    d=18'b11111000_0000000000; #100 // -8
    d=18'b11111111_1111111110; #100 // very close -0
    #500
    $finish;
  end


endmodule