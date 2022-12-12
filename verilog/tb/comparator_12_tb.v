`include "../data/num_data.v"

module comparator_12_tb ();

  reg clk;
  reg signed [12*`data_len - 1:0] d;
  wire [3:0] q;
  
  comparator_12 comp0 (clk, d, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    d={18'd11, 18'd10, 18'd9, 18'd8, 18'd7, 18'd6, 
       18'd5,  18'd4,  18'd3, 18'd2, 18'd1, 18'd0}; #10
    #100
    $finish;
  end

endmodule