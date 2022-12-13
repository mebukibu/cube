module check_cube (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [120 - 1:0] d,
    output reg q
  );

  reg [120 - 1:0] correct_cube;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= 0;
    else if (load) begin
      if (d == correct_cube) q <= 1;
      else q <= 0;
    end
  end

  initial begin
    correct_cube = {
      12'd0,
      4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0,
      24'd0,
      3'd7, 3'd6, 3'd5, 3'd4, 12'd0, 3'd3, 3'd2, 3'd1, 3'd0
    };
  end
  
endmodule