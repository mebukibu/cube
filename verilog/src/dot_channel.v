`include "../data/num_data.v"

module dot_channel #(
    parameter filename = "../data/data18/weight18_0.txt"
  ) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [2:0] cs,
    input wire [12*288*`data_len - 1:0] d,
    output reg valid,
    output wire [12*`data_len - 1:0] q
  );

  // ports for inner_36
  reg [288*`data_len - 1:0] data2inner;
  wire [`data_len - 1:0] innerout;

  // ports for weight_store
  wire ws_valid;
  wire [288*`data_len - 1:0] wsout;

  // use in this module
  wire [288*`data_len - 1:0] data288 [0:11];    // inner_288 repeats 12 times.
  reg [3:0] index;

  reg [3:0] inner_cnt;
  reg [`data_len - 1:0] q_temp [0:11];

  weight_store #(
    .filename(filename)
  ) weight_store_inst (
    .clk(clk),
    .cs(cs),
    .valid(ws_valid),
    .q(wsout)
  );

  inner_288 inner_288_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .d1(data2inner),
    .d2(wsout),
    .q(innerout)
  );

  generate
    genvar i;
    for (i = 0; i < 12; i = i + 1) begin
      assign data288[i] = d[288*i*`data_len +: 288*`data_len];
      assign q[i*`data_len +: `data_len] = q_temp[i];
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
    end
    else if (load) begin
      if (ws_valid) begin
        if (inner_cnt < 12) begin
          inner_cnt <= inner_cnt + 1;
        end
        else if (inner_cnt == 12) begin
          inner_cnt <= 0;
          index <= index + 1;
        end
        else if (index == 11) begin
          valid = 1;
          inner_cnt <= 0;
          index <= 11;
        end
      end
      else begin
        valid = 0;
        inner_cnt = 0;
        index = 0;
      end
    end

    data2inner <= data288[index];
    q_temp[index] <= innerout;

  end

  
endmodule