`include "../data/num_data.v"

module dot (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [2:0] cs,
    input wire [12*288*`data_len - 1:0] d,
    output reg valid,
    output wire [12*32*`data_len - 1:0] q
  );

  // ports for dot_channels
  reg dc_start;
  reg [288*`data_len - 1:0] data2dc;
  wire [31:0] dc_valid;
  wire [32*`data_len - 1:0] dcout;

  // use in this module
  wire [288*`data_len - 1:0] data288 [0:11];
  reg [32*`data_len - 1:0] q_temp [0:11];
  reg [3:0] index;

  generate
    genvar i, j;
    for (i = 0; i < 12; i = i + 1) begin
      assign data288[i] = d[288*i*`data_len +: 288*`data_len];
    end

    for (i = 0; i < 32; i = i + 1) begin
      for (j = 0; j < 12; j = j + 1) begin
        assign q[(12*i+j)*`data_len +: `data_len] = q_temp[j][i*`data_len +: `data_len];
      end
    end
  endgenerate

  always @(posedge clk) begin
    if (load) begin
      if (&dc_valid) begin
        dc_start <= 0;
        index <= index + 1;
        q_temp[index] <= dcout;
      end
      else if (index == 12) begin
        valid <= 1;
        dc_start <= 0;
      end
      else begin
        dc_start <= 1;
        data2dc <= data288[index];
      end
    end
    else begin
      valid <= 0;
      dc_start <= 0;
      index <= 0;
    end
  end


  // dot_channel inst
  dot_channel #(
    .filename("../data/data18/weight18_0.txt")
  ) dot_channel_inst_0 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[0]),
    .q(dcout[0*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_1.txt")
  ) dot_channel_inst_1 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[1]),
    .q(dcout[1*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_2.txt")
  ) dot_channel_inst_2 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[2]),
    .q(dcout[2*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_3.txt")
  ) dot_channel_inst_3 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[3]),
    .q(dcout[3*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_4.txt")
  ) dot_channel_inst_4 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[4]),
    .q(dcout[4*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_5.txt")
  ) dot_channel_inst_5 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[5]),
    .q(dcout[5*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_6.txt")
  ) dot_channel_inst_6 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[6]),
    .q(dcout[6*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_7.txt")
  ) dot_channel_inst_7 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[7]),
    .q(dcout[7*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_8.txt")
  ) dot_channel_inst_8 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[8]),
    .q(dcout[8*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_9.txt")
  ) dot_channel_inst_9 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[9]),
    .q(dcout[9*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_10.txt")
  ) dot_channel_inst_10 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[10]),
    .q(dcout[10*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_11.txt")
  ) dot_channel_inst_11 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[11]),
    .q(dcout[11*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_12.txt")
  ) dot_channel_inst_12 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[12]),
    .q(dcout[12*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_13.txt")
  ) dot_channel_inst_13 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[13]),
    .q(dcout[13*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_14.txt")
  ) dot_channel_inst_14 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[14]),
    .q(dcout[14*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_15.txt")
  ) dot_channel_inst_15 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[15]),
    .q(dcout[15*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_16.txt")
  ) dot_channel_inst_16 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[16]),
    .q(dcout[16*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_17.txt")
  ) dot_channel_inst_17 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[17]),
    .q(dcout[17*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_18.txt")
  ) dot_channel_inst_18 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[18]),
    .q(dcout[18*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_19.txt")
  ) dot_channel_inst_19 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[19]),
    .q(dcout[19*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_20.txt")
  ) dot_channel_inst_20 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[20]),
    .q(dcout[20*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_21.txt")
  ) dot_channel_inst_21 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[21]),
    .q(dcout[21*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_22.txt")
  ) dot_channel_inst_22 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[22]),
    .q(dcout[22*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_23.txt")
  ) dot_channel_inst_23 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[23]),
    .q(dcout[23*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_24.txt")
  ) dot_channel_inst_24 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[24]),
    .q(dcout[24*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_25.txt")
  ) dot_channel_inst_25 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[25]),
    .q(dcout[25*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_26.txt")
  ) dot_channel_inst_26 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[26]),
    .q(dcout[26*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_27.txt")
  ) dot_channel_inst_27 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[27]),
    .q(dcout[27*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_28.txt")
  ) dot_channel_inst_28 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[28]),
    .q(dcout[28*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_29.txt")
  ) dot_channel_inst_29 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[29]),
    .q(dcout[29*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_30.txt")
  ) dot_channel_inst_30 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[30]),
    .q(dcout[30*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data18/weight18_31.txt")
  ) dot_channel_inst_31 (
    .clk(clk),
    .rst_n(rst_n),
    .load(dc_start),
    .cs(cs),
    .d(data2dc),
    .valid(dc_valid[31]),
    .q(dcout[31*`data_len +: `data_len])
  );

 
endmodule