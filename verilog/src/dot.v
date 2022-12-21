`include "../data/num_data.v"

module dot (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] cs,
    input wire [9*`data_len - 1:0] d,
    output reg valid,
    output reg [8:0] addr,
    output wire [12*32*`data_len - 1:0] q
  );

  // ports for dot_channels
  reg dc_start;
  reg [2:0] dc_phase;
  reg [36*`data_len - 1:0] data2dc;
  wire [31:0] dc_valid;
  wire [32*`data_len - 1:0] dcout;

  // use in this module
  integer n;
  
  reg [32*`data_len - 1:0] q_temp [0:11];
  reg [3:0] q_index;

  reg load_temp;
  reg init;
  
  reg fetch_start;
  reg fetch_end;
  reg [2:0] fetch_cnt;
  reg [9:0] data_index;

  generate
    genvar i, j;
    for (i = 0; i < 32; i = i + 1) begin
      for (j = 0; j < 12; j = j + 1) begin
        assign q[(12*i+j)*`data_len +: `data_len] = q_temp[j][i*`data_len +: `data_len];
      end
    end
  endgenerate

  // if load changes 0 to 1, init = 1. not init = 0.
  always @(posedge clk) begin
    load_temp <= load;
    if (load == 1 && load_temp == 0) init <= 1;
    else init <= 0;
  end

  // fetch 36*`data_len data from ram
  always @(posedge clk) begin
    if (load & !valid) begin
      if (fetch_start) begin
        if (fetch_cnt == 0) begin
          fetch_cnt <= fetch_cnt + 1;
          addr <= addr + 1;
        end
        else if (fetch_cnt < 3) begin
          fetch_cnt <= fetch_cnt + 1;
          addr <= addr + 1;
          data_index <= data_index + 9*`data_len;
        end
        else if (fetch_cnt == 3) begin
          fetch_cnt <= fetch_cnt + 1;
          data_index <= data_index + 9*`data_len;
        end 
        else if (fetch_cnt == 4) begin
          fetch_end <= 1;
        end
      end
      else if (&dc_valid) begin
        addr <= addr + 1;
      end
      else begin
        fetch_end <= 0;
        fetch_cnt <= 0;
        data_index <= 0;
      end
    end
    else begin
      fetch_end <= 0;
      fetch_cnt <= 0;
      addr <= 0;
      data_index <= 0;
      dc_phase <= 0;
    end
    data2dc[data_index +: 9*`data_len] <= d;
  end

  // dot_channel controller
  always @(posedge clk) begin
    if (load & !valid) begin
      if (init) begin
        fetch_start <= 1;
      end
      else if (&dc_valid) begin
        dc_start <= 0;
        fetch_start <= 1;
      end
      else if (fetch_end) begin
        dc_start <= 1;
        fetch_start <= 0;
      end
    end
    else begin
      dc_start <= 0;
      fetch_start <= 0;
    end
  end

  // store dcout to q_temp
  always @(posedge clk) begin
    if (load) begin
      if (&dc_valid & dc_start) begin
        dc_phase <= dc_phase + 1;
        if (dc_phase == 0) begin
          for (n = 0; n < 32 ; n = n + 1) begin
            q_temp[q_index][n*`data_len +: `data_len] <= dcout[n*`data_len +: `data_len];
          end          
        end
        else if (dc_phase < 7) begin
          for (n = 0; n < 32 ; n = n + 1) begin
            q_temp[q_index][n*`data_len +: `data_len] <= q_temp[q_index][n*`data_len +: `data_len] + dcout[n*`data_len +: `data_len];
          end
        end
        else if (dc_phase == 7) begin
          q_index <= q_index + 1;
          for (n = 0; n < 32 ; n = n + 1) begin
            q_temp[q_index][n*`data_len +: `data_len] <= q_temp[q_index][n*`data_len +: `data_len] + dcout[n*`data_len +: `data_len];
          end
        end
      end
      else if (q_index == 12) begin
        valid <= 1;
      end
    end
    else begin
      valid <= 0;
      dc_phase <= 0;
      q_index <= 0;
    end
  end

  // dot_channel inst
  /* dot_channel #(
    .filename("../data/data162/weight162_0.txt")
  ) dot_channel_0_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[0]),
    .q(dcout[0*`data_len +: `data_len])
  ); */

  dot_channel #(
    .filename("../data/data162/weight162_0.txt")
  ) dot_channel_0_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[0]),
    .q(dcout[0*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_1.txt")
  ) dot_channel_1_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[1]),
    .q(dcout[1*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_2.txt")
  ) dot_channel_2_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[2]),
    .q(dcout[2*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_3.txt")
  ) dot_channel_3_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[3]),
    .q(dcout[3*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_4.txt")
  ) dot_channel_4_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[4]),
    .q(dcout[4*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_5.txt")
  ) dot_channel_5_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[5]),
    .q(dcout[5*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_6.txt")
  ) dot_channel_6_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[6]),
    .q(dcout[6*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_7.txt")
  ) dot_channel_7_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[7]),
    .q(dcout[7*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_8.txt")
  ) dot_channel_8_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[8]),
    .q(dcout[8*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_9.txt")
  ) dot_channel_9_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[9]),
    .q(dcout[9*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_10.txt")
  ) dot_channel_10_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[10]),
    .q(dcout[10*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_11.txt")
  ) dot_channel_11_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[11]),
    .q(dcout[11*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_12.txt")
  ) dot_channel_12_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[12]),
    .q(dcout[12*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_13.txt")
  ) dot_channel_13_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[13]),
    .q(dcout[13*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_14.txt")
  ) dot_channel_14_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[14]),
    .q(dcout[14*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_15.txt")
  ) dot_channel_15_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[15]),
    .q(dcout[15*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_16.txt")
  ) dot_channel_16_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[16]),
    .q(dcout[16*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_17.txt")
  ) dot_channel_17_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[17]),
    .q(dcout[17*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_18.txt")
  ) dot_channel_18_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[18]),
    .q(dcout[18*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_19.txt")
  ) dot_channel_19_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[19]),
    .q(dcout[19*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_20.txt")
  ) dot_channel_20_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[20]),
    .q(dcout[20*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_21.txt")
  ) dot_channel_21_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[21]),
    .q(dcout[21*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_22.txt")
  ) dot_channel_22_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[22]),
    .q(dcout[22*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_23.txt")
  ) dot_channel_23_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[23]),
    .q(dcout[23*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_24.txt")
  ) dot_channel_24_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[24]),
    .q(dcout[24*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_25.txt")
  ) dot_channel_25_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[25]),
    .q(dcout[25*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_26.txt")
  ) dot_channel_26_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[26]),
    .q(dcout[26*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_27.txt")
  ) dot_channel_27_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[27]),
    .q(dcout[27*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_28.txt")
  ) dot_channel_28_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[28]),
    .q(dcout[28*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_29.txt")
  ) dot_channel_29_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[29]),
    .q(dcout[29*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_30.txt")
  ) dot_channel_30_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[30]),
    .q(dcout[30*`data_len +: `data_len])
  );


  dot_channel #(
    .filename("../data/data162/weight162_31.txt")
  ) dot_channel_31_inst (
    .clk(clk),
    .rst_n(rst_n),
    .dc_load(dc_start),
    .ws_load(fetch_start),
    .cs(cs),
    .phase(dc_phase),
    .d(data2dc),
    .valid(dc_valid[31]),
    .q(dcout[31*`data_len +: `data_len])
  );

endmodule