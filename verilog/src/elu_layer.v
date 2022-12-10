`include "../data/num_data.v"

module elu_layer (
    input wire clk,
    input wire load,
    input wire [32*12*`data_len - 1:0] d,
    output reg valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // ports for elu_table  
  reg [12*`data_len - 1:0] data2elu;
  wire [12*`data_len - 1:0] eluout;

  // use in this module
  wire [12*`data_len - 1:0] data12 [0:31];
  reg [12*`data_len - 1:0] q_temp [0:31];
  reg [4:0] d_index;
  reg [4:0] q_index;

  generate
    genvar i;
    for (i = 0; i < 12; i = i + 1) begin :elu_table
      elu_table elu_table_inst (
        .clk(clk),
        .d(data2elu[i*`data_len +: `data_len]),
        .q(eluout[i*`data_len +: `data_len])
      );
    end
  endgenerate

  generate
    genvar j;
    for (j = 0; j < 32; j = j + 1) begin
      assign data12[j] = d[12*j*`data_len +: 12*`data_len];
      assign q[12*j*`data_len +: 12*`data_len] = q_temp[j];
    end
  endgenerate

  always @(posedge clk) begin
    if (load) begin
      if (d_index < 4) begin
        d_index <= d_index + 1;
      end
      else if (3 < d_index && d_index < 31) begin
        d_index <= d_index + 1;
        q_index <= q_index + 1;
      end
      else if (d_index == 31 && q_index != 31) begin
        q_index <= q_index + 1;
      end
      else if (d_index == 31 && q_index == 31) begin
        valid <= 1;
      end
    end
    else begin
      valid <= 0;
      d_index <= 0;
      q_index <= 0;
    end

    data2elu <= data12[d_index];
    q_temp[q_index] <= eluout;

  end

  
  
endmodule