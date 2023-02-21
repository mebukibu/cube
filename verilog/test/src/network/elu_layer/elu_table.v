`include "num_data.v"

module elu_table #(
    //parameter filename = "../data/data18/eLU_table.txt",
    parameter integer dwidth = 8,
    parameter integer awidth = 11,          // 2^11 = 2048 > 1597
    parameter integer words = 1597,
    parameter integer num = `data_dec - dwidth
  ) (
    input wire clk,
    input wire signed [`data_len - 1:0] d,
    output reg [`data_len - 1:0] q
  );

  // ports for elu_rom
  reg [awidth - 1:0] data2rom;
  wire [dwidth - 1:0] romout;

  // use in this module
  reg signed [`data_len - 1:0] data_delay1, data_delay2;

  elu_rom elu_rom_inst (
    .clk(clk),
    .addr(data2rom),
    .q(romout)
  );

  always @(posedge clk) begin
    // address convert 1596=11'b110_00111100 -> 6.234375
    data2rom <= d[num +: awidth] + (d[num - 1] == 1) + 1596;

    data_delay1 <= d;
    data_delay2 <= data_delay1;

    // d < -6.234375. 1596*4=6384
    if (data_delay2 < -6384) begin
      q <= {{`data_int{1'b1}}, {`data_dec{1'b0}}};  // -1 (ex. 18bit -> 11111111_0000000000)
    end
    // -6.240234375 =< d < 0
    else if (data_delay2 < 0) begin
      q <= {{`data_int{1'b1}}, romout, {num{1'b0}}};
    end
    // 0 =< d
    else begin
      q <= data_delay2;
    end
  end


endmodule