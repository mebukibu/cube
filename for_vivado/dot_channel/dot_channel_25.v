`include "num_data.v"

module dot_channel_25 #(
    parameter filename = "../data/data18/weight18_0.txt"
  ) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs,
    input wire [288*`data_len - 1:0] d,
    output reg valid,
    output wire [`data_len - 1:0] q
  );

  // ports for weight_store
  wire ws_valid;
  wire [288*`data_len - 1:0] wsout;

  // ports for inner_288

  // use in this module
  reg load_temp;
  reg init;
  reg [3:0] inner_cnt;

  weight_store_25 #(
    .filename(filename)
  ) weight_store_25_inst (
    .clk(clk),
    .cs(cs),
    .valid(ws_valid),
    .q(wsout)
  );

  inner_288 inner_288_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .d1(d),
    .d2(wsout),
    .q(q)
  );

  // if load changes 0 to 1, init = 1. not init = 0.
  always @(posedge clk) begin
    load_temp <= load;
    if (load == 1 && load_temp == 0) init <= 1;
    else init <= 0;
  end

  always @(posedge clk) begin
    if (init) begin
      valid = 0;
      inner_cnt <= 0;
    end
    else if (ws_valid && load) begin
      if (inner_cnt == 11) begin
        valid <= 1;
      end
      else begin
        inner_cnt <= inner_cnt + 1;
      end
    end
    else begin
      valid <= 0;
      inner_cnt <= 0;
    end
  end

  
endmodule