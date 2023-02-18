module current_cube (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [120 - 1:0] d,
    output reg [120 - 1:0] q
  );

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) q <= d;
  end
  
endmodule