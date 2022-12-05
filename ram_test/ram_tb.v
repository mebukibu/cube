module ram_tb;

  reg clk, load;
  reg [3:0] addr;
  reg [7:0] d;
  wire [7:0] q;

  ram ram0(clk,load,addr,d,q); 

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    load=0; addr=0; d=0; #100
    addr=1; #100
    addr=13; #100
    load=1; addr=8; d=0; #100
    d=8'h01; #100
    addr=4; d=1; #100
    load=0; d=3; #100
    $finish;
  end

endmodule