`include "num_data.v"

module main_wrap (
    input wire clk,
    input wire rst_n,
    input wire run,
    output wire [3:0] cs_out,
    output wire [9:0] data_disp,
    output wire q
  );

  // ports for main
  reg [120 - 1:0] init_data;
  reg [32*12*`data_len - 1:0] expect_value;
  wire [3:0] addr;
  wire [3:0] step;
  wire mainout;
  wire [32*12*`data_len - 1:0] data_out;

  // assign
  assign data_disp = data_out[9:0];
  assign q = (expect_value == data_out);

  main main_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(run),
    .d(init_data),
    .addr(addr),
    .step(step),
    .q(mainout),
    .cs_out(cs_out),
    .data_out(data_out)
  );

  initial begin
    init_data = {
      12'd0,
      4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd2, 4'd1, 4'd0, 4'd3,
      24'd0,
      3'd7, 3'd6, 3'd5, 3'd4, 12'd0, 3'd2, 3'd1, 3'd0, 3'd3
    };

    expect_value = {
      6912'hfc7ebe9e7fb4f3f5f2fd6fff55efc0fff9fffbecbf9b6ff043fa6500fe3fa0afe623fc8e03467f911fcb4c036a0078400990093402bcfae07f5d5fe127f91000830099b017300a2dfeb4fff4efffc3fb180028803d100c3008e1fa5f7ea0dfb03bfeffff907fe39ff5000288ff3d7fd1bff097f98afe463fdd8ff3efff48ff353fc90004a3fe33fc517ee8cfc09ff2d2faecc076effd440f17fdc8800070100fffe2ff59ffb3efee8400b8ff203feeafea0bfee3fe90ff715fe5cffe1e0043bffdaffbabff5bfcdb7f1e8ff197f491feb47f675fd20bfee5039abffb1ffe1000e902240106e03db00640ffd0802b5000d004dafcaeff551fd97ffbf9ff92c032fffe980559fcadbfb14fe85ffa5efe773fa6dfec1bfbe8fee7ffc1301c9c011afe8d8019b00307fd1aeb62fb1a2ef177d642f0ba7d861f6fafe7dffbf83fb7bfe533f48adca375db5dcbd7c0a5e2f3f99d9e9857d3f3fa4cfe9a0f753ff0bb0113fefb7fcb3fffdffefb0035aff9240500ff94c01a7fe61c06e2ff3b801fc011e80b010293406c2ff04ffba9febbff83efdba3ff52fee8bf289fd0b3f22cff04c020efee2bf949fea8ff438fe6f7f88200a1bfe3dffcc000b7ff4ebfe220109fff0200d280091ffa3ffc54fdfbff65afe427fdb2fe733f814fdd7bfc9100b9bfd00ff957fb6bff07ff4eefe177f3f4f9a3ff8ddff5b405c0fef03fd6a00d8bfd2ffed73fff5ffe4805b8fe1ebf59cf9953f8f400027f860fe727f8f7f9dbfdc6df86dff62b03a880bbf01c100b38017d003faffc5407d7f8b77f593fda94019b00ffbef17fb0efe5d0009e7febffdf23fb69ff0f3fd2bff69bed0d0036ff752ff933f2e6fe597f638006bbf800f480bdc1ef881bea38fe8e3dfa4fa05bd8f701353fee6ff69ff75bfdbe7e6effa4a7ef5bfc9f3f4a6fdde00a0dff64ffa11ff58bfc80f16e3cb0ff4aabef0af7003f46ff92f0071bfe17bf8b8fd59ffbfd00b13fcfdff62bfc0c028c7fd52feedbfb6dfff77fbcbff9cc00d2f5e07d293f6137ede10150bfe51ff13bf82f00f0001aefefb7ff09ff19bef3efbcb8000ef6553d3f3f751ffc73ff31ff8acfc9e402f3fcdeff7ebfda5c055a001bffdf300e88069f01658074afeb8c03a9ff177fbd3ff5a7ffa8fd393faaefe9cffe2f004ec027e01040017fff00bff0eff57bfc870028bfd43ff5140749ffbb403f2ffb4bfdab
    };
  end
  
endmodule