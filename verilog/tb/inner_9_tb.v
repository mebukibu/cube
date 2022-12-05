`include "../data/num_data.v"

module inner_9_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg signed [9*`data_len - 1:0] d1;
  reg signed [9*`data_len - 1:0] d2;
  wire signed [`data_len - 1:0] q;

  inner_9 inner0(clk, rst_n, load, d1, d2, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d1={{4{8'd1, 10'd0}}, {5{8'd2, 10'd0}}}; d2={{4{8'd3, 10'd0}}, {5{8'd1, 10'd0}}}; #100
    rst_n=1; #100
    load=1; #100
    #300
    $finish;
  end

endmodule


//  1.5  => {6'b0000_01, 10'b10_0000_0000}
// -1.5  => {6'b1111_10, 10'b10_0000_0000}
// -1.25 => {6'b1111_10, 10'b11_0000_0000}