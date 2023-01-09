`include "num_data.v"

module dot_channel_31 #(
    parameter filename = "../data/data162/weight162_0.txt"
  ) (
    input wire clk,
    input wire rst_n,
    input wire dc_load,
    input wire ws_load,
    input wire [3:0] cs,
    input wire [2:0] phase,
    input wire [36*`data_len - 1:0] d,
    output reg valid,
    output wire [`data_len - 1:0] q
  );

  // ports for weight_store
  wire ws_valid;
  wire [36*`data_len - 1:0] wsout;

  // use in this module
  reg [3:0] inner_cnt;

  weight_store_31 #(
    .filename(filename)
  ) weight_store_31_inst (
    .clk(clk),
    .load(ws_load),
    .cs(cs),
    .phase(phase),
    .valid(ws_valid),
    .q(wsout)
  );

  inner_36 inner_36_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_load),
    .d1(d),
    .d2(wsout),
    .q(q)
  );

  always @(posedge clk) begin
    if (ws_valid && dc_load) begin
      if (inner_cnt == 5) begin
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