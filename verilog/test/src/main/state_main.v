`include "state_main_data.v"

module state_main (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire load,
    input wire fin,
    output reg [2:0] q
  );

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) q <= `IDLE;
    else if (fin) q <= `FINISH;
    else begin
      case(q)
        `IDLE    : if (run)  q <= `STORE;
        `STORE   : if (load) q <= `NETWORK;
        `NETWORK : if (load) q <= `CUBE;
        `CUBE    : if (load) q <= `NETWORK;
        `FINISH  : q <= `FINISH;
        default : q <= 3'bXXX;
      endcase
    end
  end
  
endmodule