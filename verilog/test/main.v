`include "../data/state_main_data.v"

module main (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire [120 - 1:0] d,
    output reg [3:0] addr,
    output reg [3:0] step,
    output wire q
  );

  assign q = (addr == 10);

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      addr <= 0;
      step <= 0;
    end
    else if (run) begin
      if (addr < 10) begin
        addr <= addr + 1;
        step <= step + 1;
      end
    end
  end
  
endmodule