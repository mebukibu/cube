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

  // ports for weight_store
  wire ws_valid;
  wire [288*`data_len - 1:0] wsout;

  // ports for inner_9
  reg [9*`data_len - 1:0] data2inner [0:3];
  reg [9*`data_len - 1:0] weight2inner [0:3];
  wire [`data_len - 1:0] innerout [0:3];

  // use in this module
  wire [9*`data_len - 1:0] data9_0 [0:95];    // 12*288/(9*4) = 96.
  wire [9*`data_len - 1:0] data9_1 [0:95];
  wire [9*`data_len - 1:0] data9_2 [0:95];
  wire [9*`data_len - 1:0] data9_3 [0:95];
  reg [7:0] d_index;
  
  wire [9*`data_len - 1:0] weight9_0 [0:7];     // 288/(9*4) = 8.
  wire [9*`data_len - 1:0] weight9_1 [0:7];
  wire [9*`data_len - 1:0] weight9_2 [0:7];
  wire [9*`data_len - 1:0] weight9_3 [0:7];
  reg [4:0] w_index;

  reg [`data_len - 1:0] q_temp [0:11];
  reg [3:0] q_index;

  reg [`data_len - 1:0] inner_temp;
  reg [`data_len - 1:0] inner_sum;
  reg [3:0] inner_cnt;
  

  weight_store #(
    .filename(filename)
  ) weight_store_inst (
    .clk(clk),
    .cs(cs),
    .valid(ws_valid),
    .q(wsout)
  );

  generate
    genvar i;
    for (i = 0; i < 4; i = i + 1) begin :inner9
      inner_9 inner_9_inst (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .d1(data2inner[i]),
        .d2(weight2inner[i]),
        .q(innerout[i])
      );
    end
  endgenerate

  generate
    genvar j;
    for (j = 0; j < 96; j = j + 1) begin
      assign data9_0[j] = d[(4*j  )*9*`data_len +: 9*`data_len];
      assign data9_1[j] = d[(4*j+1)*9*`data_len +: 9*`data_len];
      assign data9_2[j] = d[(4*j+2)*9*`data_len +: 9*`data_len];
      assign data9_3[j] = d[(4*j+3)*9*`data_len +: 9*`data_len];
    end
  endgenerate

  generate
    genvar k;
    for (k = 0; k < 8; k = k + 1) begin
      assign weight9_0[k] = wsout[(4*k  )*9*`data_len +: 9*`data_len];
      assign weight9_1[k] = wsout[(4*k+1)*9*`data_len +: 9*`data_len];
      assign weight9_2[k] = wsout[(4*k+2)*9*`data_len +: 9*`data_len];
      assign weight9_3[k] = wsout[(4*k+3)*9*`data_len +: 9*`data_len];
    end
  endgenerate

  generate
    genvar l;
    for (l = 0; l < 12; l = l + 1) begin
      assign q[l*`data_len +: `data_len] = q_temp[l];
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) inner_temp <= 0;
    else if (load) begin
      inner_temp <= innerout[0] + innerout[1] + innerout[2] + innerout[3];
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
    end
    else if (load) begin
      if (ws_valid) begin
        if (inner_cnt < 4) begin
          inner_cnt <= inner_cnt + 1;
          d_index <= d_index + 1;
          w_index <= w_index + 1;
        end
        else if (inner_cnt < 7) begin
          inner_cnt <= inner_cnt + 1;
          d_index <= d_index + 1;
          w_index <= w_index + 1;
          inner_sum <= inner_sum + inner_temp;
        end
        else if (inner_cnt < 12) begin
          inner_cnt <= inner_cnt + 1;
          inner_sum <= inner_sum + inner_temp;
        end
        else if (inner_cnt == 12) begin
          if (q_index == 11) begin
            valid = 1;
          end
          else begin
            inner_cnt <= 0;
            d_index <= d_index + 1;
            w_index <= 0;
            q_index <= q_index + 1;
            inner_sum <= 0;
          end
        end
        
      end
      else begin
        valid = 0;
        inner_cnt <= 0;
        d_index <= 0;
        w_index <= 0;
        q_index <= 0;
        inner_sum <= 0;
      end
    end

    data2inner[0] <= data9_0[d_index];
    data2inner[1] <= data9_1[d_index];
    data2inner[2] <= data9_2[d_index];
    data2inner[3] <= data9_3[d_index];

    weight2inner[0] <= weight9_0[w_index];
    weight2inner[1] <= weight9_1[w_index];
    weight2inner[2] <= weight9_2[w_index];
    weight2inner[3] <= weight9_3[w_index];
    
    q_temp[q_index] <= inner_sum;

  end

  
endmodule