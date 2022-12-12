`include "../data/num_data.v"

module comparator_2_tb ();

  reg clk;
  reg [3:0] d1_num;
  reg signed [`data_len - 1:0] d1;
  reg [3:0] d2_num;
  reg signed [`data_len - 1:0] d2;
  wire [3:0] q_num;
  wire signed [`data_len - 1:0] q;

  comparator_2 comp0 (clk, d1_num, d1, d2_num, d2, q_num, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    d1_num=1; d2_num=12; d1=0; d2=-1; #10
    #10
    $finish;
  end

endmodule