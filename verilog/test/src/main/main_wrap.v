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
      6912'hff173fc08ff1b3fc040343bfd44ff003fc00ff003fc14ff4800024ff013fc04ff003fc28ff013fc00ff003fc4c036cffc38ff173ff38ff003fc00ff003fd48ff003ff48ff023fce4ff0600b23ff05001e400223fc00ff003fc24ff003fc00ff003fc04ff023fc3801d97fdf8ff003fc00ff183fc28ff053fc00ff003fc00ff033fc00ff003fc38ff013fc50ff0500560ff013fc00ff1b00ebaff003fc04ff1b3fc04ff003fc00ff003fc00ff003fc00ff003fc00ff003fc00ff003fc00ff123feb4034a7fc1803e2bfc40ff703fc2c016a7fd8cff023fc2cff0400010ff003fc00ff003fc00ff003fc00ff093fc0cff003fc4cff003fc00ff003fc08ff003fc00ff003ff3c00bbffc080066ffc00ff003fc00ff003fc18ff033fc0cff023fc00006840277ff023fc04ff053fc0c037dc054f03e57fd6cff053fc04021d3fc00ff013fc04ff003fc00ff013fc00ff003fc00ff003fcf4ff013fc0cff003fc08ff003fc00ff003fc00ff003fc04ff003fc00ff2a000ff0607008c300f53fc00ff063fc0c03bbbfc00ff003fc00ff0d3fc00ff013fc00ff003fc00ff003fc00ff003fc00ff003fc00ff003fc00ff003fc000141bfc54ff093ffd4ff783fc00ff003fc08ff563fc20ff003fd00ff463fc00ff01000d6ff0c3fc00ff01005edff003fc00ff0b3fc04ff003fc00ff013fc00ff003fc00ff003fc08ff0a3fc04ff030009eff093fc10ff013fc6cff0e3fd94ff213fc58ff023fc00ff003fc00ff003fc00ff003fc000202bfc08ff14014160317bfc00ff003fca40469bfc00ff013fc78ff003fc00ff003fc00ff003fc1000d27fcc8ff003fc04ff003fc44ff003fc00ff003fc0005c8c146b011efff74ff003fc00ff21006f1ff723fc04ff4b3fc00ff013fc04ff07001aeff023fc04ff243fc98ff013fc00ff033ff20ff023fc14ff00002d6ff003fc04ff083fc00ff003fc0002c13fc48ff003fca4ff183fc00ff003fc04ff113ff38ff00005b4ff003fc00ff033fc00ff003fc68ff013fc00ff003fc00ff0a3fc00ff003fc00ff000007cffbf3fc34ff003fc0000edffc60ff033fc00ff003fc0001b37fc00ff003fc04ff093fc04ff3d0034803de4152402fc7fc04021effc00ff0b3fc140045ffc08012700947ff8b00c9fff513fc04ff073fc08ff003fc00ff013fc10ff003fc24ff003fc00ff003fe40ff003fc00ff003fc00
    };
  end
  
endmodule