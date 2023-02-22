`include "num_data.v"

module cube_data_buffer (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [120 - 1:0] d,
    output reg [4*3*4*`data_len - 1:0] q
  );

  integer i;

  always @(posedge clk, negedge rst_n)
    if (!rst_n) q <= 0;
    else if (load) begin
      for (i = 0; i < 12; i = i + 1) begin                                // input cube data size is (4,3,4).
        q[( i    *`data_len+`data_dec) +: 3] <= d[(i*3) +: 3];            // coner position is 3bit.
        q[((i+12)*`data_len+`data_dec) +: 2] <= d[(3*12+i*2) +: 2];       // coner direction is 2bit.
        q[((i+24)*`data_len+`data_dec) +: 4] <= d[((3+2)*12+i*4) +: 4];   // edge position is 4bit.
        q[((i+36)*`data_len+`data_dec) +: 1] <= d[((3+2+4)*12+i) +: 1];   // edge direction is 1bit.
      end
    end

endmodule