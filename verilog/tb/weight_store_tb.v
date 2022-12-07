`include "../data/num_data.v"

module weight_store_tb ();

  reg clk;
  reg [2:0] cs;
  wire valid;
  wire [288*`data_len - 1:0] q;

  weight_store weight0(clk, cs, valid, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    cs = 0; #400
    cs = 1; #30000
    cs = 5; #30000
    $finish;
  end

endmodule