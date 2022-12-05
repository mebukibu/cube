module ram (clk, load, addr, d, q);

  input clk, load;
  input [3:0] addr;
  input [7:0] d;
  output [7:0] q;
  reg [7:0] mem[0:15];

  assign q = mem[addr];

  always @(posedge clk)
    if (load)
      mem[addr] <= d;
  
  initial begin
    $readmemb("mem.txt", mem);
  end

endmodule
