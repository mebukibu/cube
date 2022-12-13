module check_cube_tb ();

  reg clk;
  reg rst_n;
  reg load;
  reg [120 - 1:0] d;
  wire q;

  check_cube check_cube0 (clk, rst_n, load, d, q);

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; load=0; d=0; #10
    rst_n=1; #10
    load=1; #10
    d=2; #10
    d={
      12'd0,
      4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0,
      24'd0,
      3'd7, 3'd6, 3'd5, 3'd4, 12'd0, 3'd3, 3'd2, 3'd1, 3'd0
    }; #10
    #50
    $finish;
  end

endmodule