`include "num_data.v"
`include "state_layer_data.v"

module dot (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs_layer,
    input wire [12*288*`data_len - 1:0] d,
    output reg valid,
    output wire [32*12*`data_len - 1:0] q
  );

  // ports for rom
  reg [12:0] addr;
  wire [9*`data_len - 1:0] romout;

  // ports for inner_9
  reg [9*`data_len - 1:0] data_in [0:11];
  wire [`data_len - 1:0] innerout [0:11];

  // use in this module
  integer n;

  reg [12:0] offset;
  reg [4:0] d_index;
  wire [9*`data_len - 1:0] d_temp [0:11][0:31];

  reg [5:0] q_cnt;
  reg [4:0] q_index;
  reg [`data_len - 1:0] q_sum [0:11];
  reg [`data_len - 1:0] q_temp [0:11][0:31];

  // assign
  generate
    genvar i, j;
    for (i = 0; i < 12 ; i = i + 1) begin
      for (j = 0; j < 32; j = j + 1) begin
        assign d_temp[i][j] = d[(32*i+j)*9*`data_len +: 9*`data_len];
      end
    end
    for (i = 0; i < 32; i = i + 1) begin
      for (j = 0; j < 12; j = j + 1) begin
        assign q[(12*i+j)*`data_len +: `data_len] = q_temp[j][i];
      end
    end    
  endgenerate

  // offset
  always @(cs_layer) begin
    case (cs_layer)
      `LAYER0 : offset <= 0*1024;
      `LAYER1 : offset <= 1*1024;
      `LAYER2 : offset <= 2*1024;
      `LAYER3 : offset <= 3*1024;
      `AFFINE : offset <= 4*1024;
      default : offset <= 13'hXXXX;
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
      d_index <= d_index + 1;
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
      if (d_index == 4) begin
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
      if (q_cnt == 33) begin
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
    for (k = 0; k < 12; k = k + 1) begin :inner9
      inner_9 inner_9_inst (
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