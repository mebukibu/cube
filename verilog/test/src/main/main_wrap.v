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
  reg [3:0] expect_value;
  wire [3:0] addr;
  wire [3:0] step;
  wire [1:0] mainout;
  wire [3:0] data_out;

  // assign
  assign data_disp = {6'h00, data_out};
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

    expect_value = 4'd2;

  end
  
endmodule