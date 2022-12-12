`include "../data/num_data.v"

module comparator_12 (
    input wire clk,
    input wire signed [12*`data_len - 1:0] d,
    output wire [3:0] q
  );

  // ports for comparators
  wire [3:0] q_num_first [0:5];
  wire [`data_len - 1:0] q_first [0:5];

  wire [3:0] q_num_second [0:2];
  wire [`data_len - 1:0] q_second [0:2];

  wire [3:0] q_num_third;
  wire [`data_len - 1:0] q_third;

  wire [`data_len - 1:0] q_fourth;

  generate
    genvar i;
    for (i = 0; i < 6; i = i + 1) begin
      reg [3:0] d1_num_temp = 2*i+1;
      reg [3:0] d2_num_temp = 2*i+2;
      comparator_2 comp_first (
        .clk(clk),
        .d1_num(d1_num_temp),
        .d1(d[(2*i)*`data_len +: `data_len]),
        .d2_num(d2_num_temp),
        .d2(d[(2*i+1)*`data_len +: `data_len]),
        .q_num(q_num_first[i]),
        .q(q_first[i])
      );
    end

    for (i = 0; i < 3; i = i + 1) begin
      comparator_2 comp_second (
        .clk(clk),
        .d1_num(q_num_first[2*i]),
        .d1(q_first[2*i]),
        .d2_num(q_num_first[2*i+1]),
        .d2(q_first[2*i+1]),
        .q_num(q_num_second[i]),
        .q(q_second[i])
      );
    end
  endgenerate

  comparator_2 comp_third (
    .clk(clk),
    .d1_num(q_num_second[0]),
    .d1(q_second[0]),
    .d2_num(q_num_second[1]),
    .d2(q_second[1]),
    .q_num(q_num_third),
    .q(q_third)
  );
  
  comparator_2 comp_fourth (
    .clk(clk),
    .d1_num(q_num_second[2]),
    .d1(q_second[2]),
    .d2_num(q_num_third),
    .d2(q_third),
    .q_num(q),
    .q(q_fourth)
  );
    
  

endmodule