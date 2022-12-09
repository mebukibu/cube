`include "../data/num_data.v"

module ram_tb ();

  parameter integer dwidth = 288*`data_len;
  parameter integer awidth = 4;

  reg clk;
  reg load;
  reg [awidth - 1:0] addr;
  reg [dwidth - 1:0] d;
  wire [dwidth - 1:0] q;

  ram #(.dwidth(dwidth), .awidth(awidth)) ram0 (clk, load, addr, d, q);
  
  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    load=0; addr=0; d=1; #100
    load=1; #200
    addr=11; d=2; #100
    load=0; d=3; #100
    #100
    $finish;
  end

endmodule