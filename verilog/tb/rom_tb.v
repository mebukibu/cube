`timescale 1 ns / 1 ps
`include "../data/num_data.v"

module rom_tb ();

  reg clk;
  reg [11 - 1:0] addr;
  wire [`data_len - 1:0] q;

  rom #("../data/data18/weight18_0.txt") rom0 (clk, addr, q);
  //rom #(filename=$sformatf("../data/data18/weight18_%0d.txt", 0)) rom0 (clk, addr, q);

  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    $dumpvars;
    // temp = 0;
    // $display("a");
    // $sformat(temp, "%s%d", "ab", 1);
    // $display("%s", $sformatf("%d", 1));
    #51
    addr = 0; #100
    addr = 1; #100
    addr = 1439; #100
    #100
    $finish;
  end

endmodule