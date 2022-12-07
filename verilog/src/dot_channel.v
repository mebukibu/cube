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
  reg [36*`data_len - 1:0] weight2inner;
  reg [36*`data_len - 1:0] data2inner;
  wire [`data_len - 1:0] innerout;

  // ports for weight_store
  wire ws_valid;
  wire [288*`data_len - 1:0] wsout;

  // use in this module
  wire [36*`data_len - 1:0] data36 [0:8*12 - 1];    // 12*(8*36) = 12*288. 288 inner repeats 12 times.
  wire [36*`data_len - 1:0] weight36 [0:8 - 1];     // 36*8 = 288
  reg [6:0] d_index;
  reg [2:0] w_index;

  reg [2:0] inner_cnt;
  reg [3:0] set_cnt;
  reg [3:0] line_cnt;
  reg [`data_len - 1:0] inner_temp;
  reg [`data_len - 1:0] q_temp [0:11];

  inner_36 inner_36_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .d1(data2inner),
    .d2(weight2inner),
    .q(innerout)
  );

  weight_store #(
    .filename(filename)
  ) weight_store0 (
    .clk(clk),
    .cs(cs),
    .valid(ws_valid),
    .q(wsout)
  );

  generate
    genvar i;
    for (i = 0; i < 8*12; i = i + 1) begin
      assign data36[i] = d[36*i*`data_len +: 36*`data_len];
    end
  endgenerate

  generate
    genvar j;
    for (j = 0; j < 8; j = j + 1) begin
      assign weight36[j] = wsout[36*j*`data_len +: 36*`data_len];
    end
  endgenerate

  generate
    genvar k;
    for (k = 0; k < 12; k = k + 1) begin
      assign q[k*`data_len +: `data_len] = q_temp[k];
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      valid <= 0;
      inner_cnt <= 0;
      set_cnt <= 0;
      line_cnt <= 0;
      d_index <= 0;
      w_index <= 0;
      inner_temp <= 0;
    end
    else if (load) begin
      if (ws_valid) begin
        if (inner_cnt < 4 && set_cnt < 8 && line_cnt < 12) begin
          inner_cnt <= inner_cnt + 1;
          data2inner <= data36[d_index];
          weight2inner <= weight36[w_index];
        end
        else if (inner_cnt == 4) begin
          inner_cnt <= 0;
          set_cnt <= set_cnt + 1;
          d_index <= d_index + 1;
          w_index <= w_index + 1;
          inner_temp <= inner_temp + innerout;
        end
        else if (set_cnt == 8) begin
          inner_cnt <= 0;
          set_cnt <= 0;
          w_index <= 0;
          line_cnt <= line_cnt + 1;
          inner_temp <= 0;
          q_temp[line_cnt] <= inner_temp;
        end
        else if (line_cnt == 12) begin
          valid = 1;
          inner_cnt <= 5;
          set_cnt <= 9;
          line_cnt <= 13;
        end
      end
      else begin
        valid <= 0;
        inner_cnt <= 0;
        set_cnt <= 0;
        line_cnt <= 0;
        d_index <= 0;
        w_index <= 0;
        inner_temp <= 0;
      end
    end
  end
  
endmodule