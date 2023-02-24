`include "num_data.v"

module elu_layer #(
    parameter integer num = 6
  ) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [32*12*`data_len - 1:0] d,
    output reg valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // ports for elu_table  
  reg [num*`data_len - 1:0] data2elu;
  wire [num*`data_len - 1:0] eluout;

  // use in this module
  integer n;
  wire [num*`data_len - 1:0] d_temp [0:32*12 / num - 1];
  reg [num*`data_len - 1:0] q_temp [0:32*12 / num - 1];
  reg [5:0] d_index;
  reg [5:0] q_index;

  generate
    genvar i;
    for (i = 0; i < num; i = i + 1) begin :elu_table
      elu_table elu_table_inst (
        .clk(clk),
        .rst_n(rst_n),
        .d(data2elu[i*`data_len +: `data_len]),
        .q(eluout[i*`data_len +: `data_len])
      );
    end
  endgenerate

  generate
    genvar j;
    for (j = 0; j < 32*12 / num; j = j + 1) begin
      assign d_temp[j] = d[num*j*`data_len +: num*`data_len];
      assign q[num*j*`data_len +: num*`data_len] = q_temp[j];
    end
  endgenerate

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      valid <= 0;
      d_index <= 0;
      q_index <= 0;
      data2elu <= 0;
      for (n = 0; n < 32*12 / num; n = n + 1) begin
        q_temp[n] <= 0;
      end
    end
    else if (load) begin
      if (d_index < 4) begin
        d_index <= d_index + 1;
      end
      else if (3 < d_index && d_index < 32*12 / num - 1) begin
        d_index <= d_index + 1;
        q_index <= q_index + 1;
      end
      else if (d_index == 32*12 / num - 1 && q_index != 32*12 / num - 1) begin
        q_index <= q_index + 1;
      end
      else if (d_index == 32*12 / num - 1 && q_index == 32*12 / num - 1) begin
        valid <= 1;
      end
      data2elu <= d_temp[d_index];
      q_temp[q_index] <= eluout;
    end
    else begin
      valid <= 0;
      d_index <= 0;
      q_index <= 0;
    end
  end

endmodule