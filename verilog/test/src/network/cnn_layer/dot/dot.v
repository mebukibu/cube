`include "num_data.v"
`include "state_layer_data.v"

module dot #(
    parameter integer num = 6,    // inner product (num, num)
    parameter integer aw  = 13,   // rom address width. aw > log2(288*32*5 / num)
    parameter integer iw  = 6     // index width. iw > log2(288 / num)
  ) (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [12*288*`data_len - 1:0] d,
    output reg valid,
    output wire [12*32*`data_len - 1:0] q
  );

  // ports for rom
  reg [aw - 1:0] addr;
  wire [num*`data_len - 1:0] romout;

  // ports for inner_9
  reg [num*`data_len - 1:0] data_in [0:11];
  wire [`data_len - 1:0] innerout [0:11];

  // use in this module
  integer n;

  reg [aw - 1:0] offset;
  reg [iw - 1:0] d_index;
  wire [num*`data_len - 1:0] d_temp [0:11][0:288 / num - 1];

  reg [iw:0] q_cnt;
  reg [iw - 1:0] q_index;
  reg [`data_len - 1:0] q_sum [0:11];
  reg [`data_len - 1:0] q_temp [0:11][0:31];

  // assign
  generate
    genvar i, j;
    for (i = 0; i < 12 ; i = i + 1)
      for (j = 0; j < 288 / num; j = j + 1)
        assign d_temp[i][j] = d[((288 / num)*i+j)*num*`data_len +: num*`data_len];

    for (i = 0; i < 12 ; i = i + 1)
      for (j = 0; j < 32; j = j + 1)
        assign q[(32*i+j)*`data_len +: `data_len] = q_temp[i][j];
  endgenerate

  // offset
  always @(cs_layer) begin
    case (cs_layer)
      `LAYER0 : offset = 0*288*32 / num;
      `LAYER1 : offset = 1*288*32 / num;
      `LAYER2 : offset = 2*288*32 / num;
      `LAYER3 : offset = 3*288*32 / num;
      `AFFINE : offset = 4*288*32 / num;
      default : offset = {aw{1'bX}};
    endcase
  end

  // address controller
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) addr <= 0;
    else if (load) addr <= addr + 1;
    else addr <= offset;
  end

  // input data controller
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      d_index <= 0;
      for (n = 0; n < 12; n = n + 1) begin
        data_in[n] <= 0;
      end
    end
    else if (load) begin
      if (d_index == 288 / num - 1) d_index <= 0;
      else d_index <= d_index + 1;

      for (n = 0; n < 12; n = n + 1) begin
        data_in[n] <= d_temp[n][d_index];
      end
    end
    else begin
      d_index <= 0;
      for (n = 0; n < 12; n = n + 1) begin
        data_in[n] <= 0;
      end
    end
   end
  
  // output data controller
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q_cnt <= 0;
      q_index <= 0;
      valid <= 0;
      for (n = 0; n < 12; n = n + 1) begin
        q_sum[n] <= 0;
      end      
    end
    else if (load) begin
      if (d_index == 4) begin     // fetch 1 clk + inner_9 3 clk = 4 clock needed.
        q_cnt <= q_cnt + 1;
        if (q_cnt != 0) begin
          q_index <= q_index + 1;
        end
        for (n = 0; n < 12; n = n + 1) begin
          q_sum[n] <= innerout[n];
          q_temp[n][q_index] <= q_sum[n];
        end
      end
      else begin
        for (n = 0; n < 12; n = n + 1) begin
          q_sum[n] <= q_sum[n] + innerout[n];
        end
      end
      if (q_cnt == 32 + 1) begin
        valid <= 1;
      end
    end
    else begin
      q_cnt <= 0;
      q_index <= 0;
      valid <= 0;
      for (n = 0; n < 12; n = n + 1) begin
        q_sum[n] <= 0;
      end
    end
  end

  // instance
  rom rom_inst (
    .clk(clk),
    .addr(addr),
    .q(romout)
  );

  generate
    genvar k;
    for (k = 0; k < 12; k = k + 1) begin :inner
      inner_6 inner_inst (
        .clk(clk),
        .rst_n(rst_n),
        .load(1'b1),
        .d1(data_in[k]),
        .d2(romout),
        .q(innerout[k])
      );
    end
  endgenerate

endmodule