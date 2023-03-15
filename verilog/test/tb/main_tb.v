`include "num_data.v"
`include "state_main_data.v"

module main_tb ();

  reg clk;
  reg rst_n;
  reg run;
  reg [120 - 1:0] d;
  wire [3:0] addr;
  wire [3:0] step;
  wire [1:0] q;

  wire [3:0] cs_out;
  wire [3:0] data_out;

  main main0 (clk, rst_n, run, d, addr, step, q, cs_out, data_out);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; run=0; //d=120'h82a54907b1630900184e800098f; #10
    d = {
      12'd0,
      4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd2, 4'd1, 4'd0, 4'd3,
      24'd0,
      3'd7, 3'd6, 3'd5, 3'd4, 12'd0, 3'd2, 3'd1, 3'd0, 3'd3
    }; #10
    rst_n=1; #10
    run=1; #10
    #90000
    //$display("%b", data_out);
    $finish;
  end

endmodule