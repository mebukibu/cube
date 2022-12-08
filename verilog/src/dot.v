`include "../data/num_data.v"

module dot (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [2:0] cs,
    input wire [12*288*`data_len - 1:0] d,
    output wire valid,
    output wire [12*32*`data_len - 1:0] q
  );

  wire [31:0] dc_valid;
  wire [12*`data_len - 1:0] q_temp [0:31];

  assign valid = & dc_valid;

  generate
    genvar i;
    for (i = 0; i < 32; i = i + 1) begin
      assign  q[12*i*`data_len +: 12*`data_len] = q_temp[i];
    end
  endgenerate

  // dot_channel inst

  dot_channel #(
    .filename("../data/data18/weight18_0.txt")
  ) dot_channel_inst_0 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[0]),
    .q(q_temp[0])
  );


  dot_channel #(
    .filename("../data/data18/weight18_1.txt")
  ) dot_channel_inst_1 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[1]),
    .q(q_temp[1])
  );


  dot_channel #(
    .filename("../data/data18/weight18_2.txt")
  ) dot_channel_inst_2 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[2]),
    .q(q_temp[2])
  );


  dot_channel #(
    .filename("../data/data18/weight18_3.txt")
  ) dot_channel_inst_3 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[3]),
    .q(q_temp[3])
  );


  dot_channel #(
    .filename("../data/data18/weight18_4.txt")
  ) dot_channel_inst_4 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[4]),
    .q(q_temp[4])
  );


  dot_channel #(
    .filename("../data/data18/weight18_5.txt")
  ) dot_channel_inst_5 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[5]),
    .q(q_temp[5])
  );


  dot_channel #(
    .filename("../data/data18/weight18_6.txt")
  ) dot_channel_inst_6 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[6]),
    .q(q_temp[6])
  );


  dot_channel #(
    .filename("../data/data18/weight18_7.txt")
  ) dot_channel_inst_7 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[7]),
    .q(q_temp[7])
  );


  dot_channel #(
    .filename("../data/data18/weight18_8.txt")
  ) dot_channel_inst_8 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[8]),
    .q(q_temp[8])
  );


  dot_channel #(
    .filename("../data/data18/weight18_9.txt")
  ) dot_channel_inst_9 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[9]),
    .q(q_temp[9])
  );


  dot_channel #(
    .filename("../data/data18/weight18_10.txt")
  ) dot_channel_inst_10 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[10]),
    .q(q_temp[10])
  );


  dot_channel #(
    .filename("../data/data18/weight18_11.txt")
  ) dot_channel_inst_11 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[11]),
    .q(q_temp[11])
  );


  dot_channel #(
    .filename("../data/data18/weight18_12.txt")
  ) dot_channel_inst_12 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[12]),
    .q(q_temp[12])
  );


  dot_channel #(
    .filename("../data/data18/weight18_13.txt")
  ) dot_channel_inst_13 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[13]),
    .q(q_temp[13])
  );


  dot_channel #(
    .filename("../data/data18/weight18_14.txt")
  ) dot_channel_inst_14 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[14]),
    .q(q_temp[14])
  );


  dot_channel #(
    .filename("../data/data18/weight18_15.txt")
  ) dot_channel_inst_15 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[15]),
    .q(q_temp[15])
  );


  dot_channel #(
    .filename("../data/data18/weight18_16.txt")
  ) dot_channel_inst_16 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[16]),
    .q(q_temp[16])
  );


  dot_channel #(
    .filename("../data/data18/weight18_17.txt")
  ) dot_channel_inst_17 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[17]),
    .q(q_temp[17])
  );


  dot_channel #(
    .filename("../data/data18/weight18_18.txt")
  ) dot_channel_inst_18 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[18]),
    .q(q_temp[18])
  );


  dot_channel #(
    .filename("../data/data18/weight18_19.txt")
  ) dot_channel_inst_19 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[19]),
    .q(q_temp[19])
  );


  dot_channel #(
    .filename("../data/data18/weight18_20.txt")
  ) dot_channel_inst_20 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[20]),
    .q(q_temp[20])
  );


  dot_channel #(
    .filename("../data/data18/weight18_21.txt")
  ) dot_channel_inst_21 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[21]),
    .q(q_temp[21])
  );


  dot_channel #(
    .filename("../data/data18/weight18_22.txt")
  ) dot_channel_inst_22 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[22]),
    .q(q_temp[22])
  );


  dot_channel #(
    .filename("../data/data18/weight18_23.txt")
  ) dot_channel_inst_23 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[23]),
    .q(q_temp[23])
  );


  dot_channel #(
    .filename("../data/data18/weight18_24.txt")
  ) dot_channel_inst_24 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[24]),
    .q(q_temp[24])
  );


  dot_channel #(
    .filename("../data/data18/weight18_25.txt")
  ) dot_channel_inst_25 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[25]),
    .q(q_temp[25])
  );


  dot_channel #(
    .filename("../data/data18/weight18_26.txt")
  ) dot_channel_inst_26 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[26]),
    .q(q_temp[26])
  );


  dot_channel #(
    .filename("../data/data18/weight18_27.txt")
  ) dot_channel_inst_27 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[27]),
    .q(q_temp[27])
  );


  dot_channel #(
    .filename("../data/data18/weight18_28.txt")
  ) dot_channel_inst_28 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[28]),
    .q(q_temp[28])
  );


  dot_channel #(
    .filename("../data/data18/weight18_29.txt")
  ) dot_channel_inst_29 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[29]),
    .q(q_temp[29])
  );


  dot_channel #(
    .filename("../data/data18/weight18_30.txt")
  ) dot_channel_inst_30 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[30]),
    .q(q_temp[30])
  );


  dot_channel #(
    .filename("../data/data18/weight18_31.txt")
  ) dot_channel_inst_31 (
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .cs(cs),
    .d(d),
    .valid(dc_valid[31]),
    .q(q_temp[31])
  );

 
endmodule