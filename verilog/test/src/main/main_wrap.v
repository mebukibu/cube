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
      6912'hff083fc04ff023fc54ff143fc48ff053fce4ff043fcd4ff5f3fcfc00fe3fce8ff333fdb003467fcb4ff090036a0078400990093402bcff023fc50ff253fcb400830099b017300a2dff463ff5cfffb3fd2c0028803d100c3008e1ff013fc04ff023ff1cffa53fe8cff8000288ff773fdf0ff613fcccff2d3fe54ff783ff54ff733fdb0004a3fe8cff063fc0cff053fc24ff020076effd700f17ff1c000070100fffe0ff853fd38ff55000b8ff6a3ff0cff413ff04ff3d3fc6cff323fe800043bffd8ffc33ff64ff0b3fc20ff673fc3cff463fc5cff0e3ff04039abffb0ffe2000e902240106e03db00640ffd4002b5000d004daff093fc48ff173fd74ffa70032fffea00559ff093fd2cff3a3fcf8ff373fcfcff4a3fd70ff553fd8001c9c011aff3c0019b00307fdf0ff003fc00ff003fc00ff003fc00ff003fc04ff053fd48ff303fc3cff003fc00ff003fc00ff003fc00ff003fc00ff013fc04ff003fc180113ffc10ff093ffdcff5c0035affa600500ffa8001a7ff33006e2ff77001fc011e80b010293406c2ff603fd58ff483fc94ff1a3ff60ff563fc24ff0d3fc20ff600020eff543fcc0ff433fc34ff353fc9c00a1bfe90ffd0000b7ff803fe800109fff1c00d280091ffb23fd98ff223fc5cff2d3fe40ff363fc8cff1e3fdb000b9bfde0ffa83fd44ff613fc40ff263fc34ff003fcacff86005c0ff583fe1800d8bfdf8ff503fff0ffe5005b8ff273fc4cff003fcb000027fc98ff363fcb0ff013fc00ff003fc5803a880bbf01c100b38017d003faffcb007d7ff003fc4cff190019b00ffbfc10ff023fc00009e7feecff213fd44ff633fdf8ff8e3fc080036ffc74ffa73fc28ff313fc58006bbfc8cff003fc00ff003fc04ff3c3fc00ff013fc0001353ff08ff8e3fc74ff1b3fc00ff013fc10ff093fc3cff1e00a0dff8b3fce8ff853fda8ff003fc00ff003fc10ff003fc38ff000071bff263fca4ff123fd7400b13fde0ff8a3fd7c028c7fe0cff573fd44fff63fd64ffad000d2ff003fc00ff003fc0c0150bfe9cff653fc9000f0001aeff5c3ff20ff683fc10ff040000eff003fc00ff003fda4ff723fca4ff09002f3ff0b3fc88ff180055a001bffe6400e88069f01658074aff47003a9ff673fd68ff853ffa8ff103fd10ff403fe88004ec027e01040017fff5e3ff28ff843fdac0028bfe04ff8100749ffc3003f2ffbe3fe38
    };
  end
  
endmodule