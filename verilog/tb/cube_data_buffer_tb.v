`include "../data/num_data.v"

module cube_data_buffer_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [32*4 - 1:0] d;
  wire [32*3*4*`data_len - 1:0] q;

  cube_data_buffer cube_data_buffer0(clk, rst_n, load, d, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d=128'h82a54907b1630900184e800098f; #100
    rst_n=1; #100
    load=1; #100
    $finish;
  end

endmodule

// input wdata[0] = 0xe800098f
// input wdata[1] = 0x30900184
// input wdata[2] = 0x54907b16
// input wdata[3] = 0x82a