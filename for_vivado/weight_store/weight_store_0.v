`include "num_data.v"
`include "state_layer_data.v"

module weight_store_0 #(
    parameter filename = "../data/data18/weight18_0.txt"
  ) (
    input wire clk,
    input wire [3:0] cs,
    output reg valid,
    output wire [288*`data_len - 1:0] q
  );

  reg [10:0] addr;
  wire [`data_len - 1:0] romout;

  reg init;
  reg [2:0] cs_tmp;
  reg [8:0] cnt;
  reg [8:0] index;

  reg [`data_len - 1:0] weight [0:288 - 1];

  w_rom_0 #(
    .filename(filename)
  ) w_rom_0_inst (
    .clk(clk),
    .addr(addr),
    .q(romout)
  );  

  // if cs change, init = 1. not init = 0.
  always @(posedge clk) begin
    cs_tmp <= cs;
    if (cs != cs_tmp) init <= 1;
    else init <= 0;    
  end

  always @(posedge clk) begin
    if (init) begin
      valid <= 0;
      index <= 0;
      cnt <= 0;
      if      (cs == `LAYER0) addr <= 0;
      else if (cs == `LAYER1) addr <= 288;
      else if (cs == `LAYER2) addr <= 2*288;
      else if (cs == `LAYER3) addr <= 3*288;
      else if (cs == `AFFINE) addr <= 4*288;
      else addr <= 11'hXXX;
    end
    else if (cnt == 0) begin
      cnt <= cnt + 1;
      addr <= addr + 1;      
    end
    else if (cnt < 288 + 1) begin
      index <= index + 1;
      cnt <= cnt + 1;
      addr <= addr + 1;
    end
    else if (cnt == 288 + 1) begin
      valid <= 1;
      cnt <= cnt + 1;
    end
    weight[index] <= romout;
  end

  generate
    genvar i;
    for (i = 0; i < 288; i = i + 1) begin
      assign q[i*`data_len +: `data_len] = weight[i];
    end
  endgenerate
  
endmodule