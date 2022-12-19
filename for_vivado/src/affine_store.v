`include "num_data.v"

module affine_store (
  input wire clk,
  input wire rst_n,
  input wire load,
  input wire [32*3*4*`data_len - 1:0] d,
  output reg valid,
  output reg [8:0] addr,
  output reg [9*`data_len - 1:0] q
);

  reg init;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      init <= 0;
      valid <= 0;
      addr <= 0;
      q <= 0;
    end
    else if (load) begin
      if (init) begin
        init <= 0;
        addr <= 0;
        q <= d[0*9*`data_len +: 9*`data_len];
      end
      else if (!valid) begin
        addr <= addr + 1;
        if (addr == 0) q <= d[1*9*`data_len +: 9*`data_len];
        if (addr == 1) q <= d[2*9*`data_len +: 9*`data_len];
        if (addr == 2) q <= d[3*9*`data_len +: 9*`data_len];
        if (addr == 3) q <= d[4*9*`data_len +: 9*`data_len];
        if (addr == 4) q <= d[5*9*`data_len +: 9*`data_len];
        if (addr == 5) q <= d[6*9*`data_len +: 9*`data_len];
        if (addr == 6) q <= d[7*9*`data_len +: 9*`data_len];
        if (addr == 7) q <= d[8*9*`data_len +: 9*`data_len];
        if (addr == 8) q <= d[9*9*`data_len +: 9*`data_len];
        if (addr == 9) q <= d[10*9*`data_len +: 9*`data_len];
        if (addr == 10) q <= d[11*9*`data_len +: 9*`data_len];
        if (addr == 11) q <= d[12*9*`data_len +: 9*`data_len];
        if (addr == 12) q <= d[13*9*`data_len +: 9*`data_len];
        if (addr == 13) q <= d[14*9*`data_len +: 9*`data_len];
        if (addr == 14) q <= d[15*9*`data_len +: 9*`data_len];
        if (addr == 15) q <= d[16*9*`data_len +: 9*`data_len];
        if (addr == 16) q <= d[17*9*`data_len +: 9*`data_len];
        if (addr == 17) q <= d[18*9*`data_len +: 9*`data_len];
        if (addr == 18) q <= d[19*9*`data_len +: 9*`data_len];
        if (addr == 19) q <= d[20*9*`data_len +: 9*`data_len];
        if (addr == 20) q <= {{6*`data_len{1'b0}}, d[21*9*`data_len +: 3*`data_len]};
        if (addr == 21) q <= 0;
        if (addr == 22) q <= 0;
        if (addr == 23) q <= 0;
        if (addr == 24) q <= 0;
        if (addr == 25) q <= 0;
        if (addr == 26) q <= 0;
        if (addr == 27) q <= 0;
        if (addr == 28) q <= 0;
        if (addr == 29) q <= 0;
        if (addr == 30) q <= 0;
        if (addr == 31) q <= d[(192+0*9)*`data_len +: 9*`data_len];
        if (addr == 32) q <= d[(192+1*9)*`data_len +: 9*`data_len];
        if (addr == 33) q <= d[(192+2*9)*`data_len +: 9*`data_len];
        if (addr == 34) q <= d[(192+3*9)*`data_len +: 9*`data_len];
        if (addr == 35) q <= d[(192+4*9)*`data_len +: 9*`data_len];
        if (addr == 36) q <= d[(192+5*9)*`data_len +: 9*`data_len];
        if (addr == 37) q <= d[(192+6*9)*`data_len +: 9*`data_len];
        if (addr == 38) q <= d[(192+7*9)*`data_len +: 9*`data_len];
        if (addr == 39) q <= d[(192+8*9)*`data_len +: 9*`data_len];
        if (addr == 40) q <= d[(192+9*9)*`data_len +: 9*`data_len];
        if (addr == 41) q <= d[(192+10*9)*`data_len +: 9*`data_len];
        if (addr == 42) q <= d[(192+11*9)*`data_len +: 9*`data_len];
        if (addr == 43) q <= d[(192+12*9)*`data_len +: 9*`data_len];
        if (addr == 44) q <= d[(192+13*9)*`data_len +: 9*`data_len];
        if (addr == 45) q <= d[(192+14*9)*`data_len +: 9*`data_len];
        if (addr == 46) q <= d[(192+15*9)*`data_len +: 9*`data_len];
        if (addr == 47) q <= d[(192+16*9)*`data_len +: 9*`data_len];
        if (addr == 48) q <= d[(192+17*9)*`data_len +: 9*`data_len];
        if (addr == 49) q <= d[(192+18*9)*`data_len +: 9*`data_len];
        if (addr == 50) q <= d[(192+19*9)*`data_len +: 9*`data_len];
        if (addr == 51) q <= d[(192+20*9)*`data_len +: 9*`data_len];
        if (addr == 52) q <= {{6*`data_len{1'b0}}, d[(192+21*9)*`data_len +: 3*`data_len]};
        if (addr == 53) q <= 0;
        if (addr == 54) q <= 0;
        if (addr == 55) q <= 0;
        if (addr == 56) q <= 0;
        if (addr == 57) q <= 0;
        if (addr == 58) q <= 0;
        if (addr == 59) q <= 0;
        if (addr == 60) q <= 0;
        if (addr == 61) q <= 0;
        if (addr == 62) q <= 0;
        if (addr == 63) valid <= 1;
      end
    end
    else begin
      init <= 1;
      valid <= 0;
      addr <= 0;
      q <= 0;
    end
  end
  
endmodule