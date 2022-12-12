`include "../data/num_data.v"

module comp_layer_tb ();

  reg clk;
  reg load;
  reg [12*`data_len - 1:0] d1;
  reg [12*`data_len - 1:0] d2;
  wire valid;
  wire [3:0] q;

  comp_layer comp_layer0 (clk, load, d1, d2, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    #5
    load=0; d1=0; d2={{8{18'd1}}, 18'd3, {3{18'd2}}}; #10
    #40
    d1={{9{18'd1}}, 18'd3, {2{18'd2}}}; #10
    load=1; #10
    #50
    $finish;
  end

endmodule