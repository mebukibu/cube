`include "../data/state_layer_data.v"

module state_layer (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire load,
    output reg [3:0] q
  );

  reg [3:0] cs_last;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      q <= `LIDLE;
      cs_last <= `LIDLE;
    end
    else begin
      case(q)
        `LIDLE  : if (run)  q <= `BUFFER;
        `BUFFER : if (load) q <= `LAYER0;
        `LAYER0 : if (load) begin q <= `ELU; cs_last <= `LAYER0; end
        `LAYER1 : if (load) begin q <= `ELU; cs_last <= `LAYER1; end
        `LAYER2 : if (load) begin q <= `ELU; cs_last <= `LAYER2; end
        `LAYER3 : if (load) begin q <= `ELU; cs_last <= `LAYER3; end
        `AFFINE : if (load) q <= `COMP;
        `ELU    : begin
                    case(cs_last)
                      `LAYER0 : if (load) q <= `LAYER1;
                      `LAYER1 : if (load) q <= `LAYER2;
                      `LAYER2 : if (load) q <= `LAYER3;
                      `LAYER3 : if (load) q <= `AFFINE;
                      default : q <= 4'bXXXX;
                    endcase
                  end
        `COMP   : if (load) q <= `LFIN;
        `LFIN   : if (!run) q <= `LIDLE;
        default : q <= 4'bXXXX;
      endcase
    end
  end
  
endmodule