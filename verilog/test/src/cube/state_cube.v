`include "state_cube_data.v"

module state_cube (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire load,
    output reg [1:0] q
  );

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= `CB_IDL;
    else begin
      case(q)
        `CB_IDL : if (run)  q <= `CHANGE;
        `CHANGE : if (load) q <= `CHECK;
        `CHECK  : if (load) q <= `CB_FIN;
        `CB_FIN : if (!run) q <= `CB_IDL;
        default : q <= 2'bXX;
      endcase
    end
  end
  
endmodule