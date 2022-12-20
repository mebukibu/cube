`include "../data/num_data.v"
`include "../data/state_layer_data.v"

module dot_channel_tb ();

  reg clk;
  reg rst_n;
  reg dc_load;
  reg ws_load;
  reg [3:0] cs;
  reg [2:0] phase;
  reg [36*`data_len - 1:0] d;
  wire valid;
  wire [`data_len - 1:0] q;

  dot_channel dot_channel0 (clk, rst_n, dc_load, ws_load, cs, phase, d, valid, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; dc_load=0; ws_load=0; cs=0; phase=0; d={36{18'b0000_01_00_0000_0000}}; #10
    rst_n=1; #10
    cs=`LAYER0; ws_load=1; phase=0; #10
    dc_load=1; #10
    #100
    $finish;
  end

endmodule