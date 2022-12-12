`include "../data/num_data.v"

module comp_layer (
    input wire clk,
    input wire load,
    input wire [12*`data_len - 1:0] d1,
    input wire [12*`data_len - 1:0] d2,
    output reg valid,
    output wire [3:0] q
  );

  integer i;
  reg [12*`data_len - 1:0] data2comp;

  reg [2:0] comp_cnt;

  comparator_12 comp_12_inst (
    .clk(clk),
    .d(data2comp),
    .q(q)
  );

  always @(posedge clk) begin
    for (i = 0; i < 12; i = i + 1) begin
      data2comp[i*`data_len +: `data_len] <= d1[i*`data_len +: `data_len] + d2[i*`data_len +: `data_len];
    end
  end

  always @(posedge clk) begin
    if (load) begin
      if (comp_cnt < 4) begin
        comp_cnt <= comp_cnt + 1;
      end      
      else if (comp_cnt == 4) begin
        valid <= 1;
      end
    end
    else begin
      valid <= 0;
      comp_cnt <= 0;
    end    
  end

endmodule