`include "state_calc_data.v"

module state_calc (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire load,
    output reg [2:0] q
  );

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= `CIDL;
    else begin
      case(q)
        `CIDL : if (run)  q <= `ZPAD;
        `ZPAD : if (load) q <= `IM2C;
        `IM2C : if (load) q <= `DOTP;
        `DOTP : if (load) q <= `BIAS;
        `BIAS : if (load) q <= `FINI;
        `FINI : if (!run) q <= `CIDL;
        default: q <= 3'bXXX;
      endcase
    end
  end
  
endmodule