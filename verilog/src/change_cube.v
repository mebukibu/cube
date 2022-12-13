module change_cube (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire [3:0] step,
    input wire [120 - 1:0] d,
    output wire [120 - 1:0] q
  );

  integer i;

  wire [2:0] now_cp [0:11];
  wire [1:0] now_cd [0:11];
  wire [3:0] now_ep [0:11];
  wire       now_ed [0:11];

  reg [2:0] next_cp [0:11];
  reg [1:0] next_cd [0:11];
  reg [3:0] next_ep [0:11];
  reg       next_ed [0:11];

  generate
    genvar j;
    for (j = 0; j < 12; j = j + 1) begin
      assign now_cp[j] = d[3*j      +: 3];
      assign now_cd[j] = d[2*j+12*3 +: 2];
      assign now_ep[j] = d[4*j+12*(3+2)   +: 4];
      assign now_ed[j] = d[1*j+12*(3+2+4) +: 1];

      assign q[3*j      +: 3] = next_cp[j];
      assign q[2*j+12*3 +: 2] = next_cd[j];
      assign q[4*j+12*(3+2)   +: 4] = next_ep[j];
      assign q[1*j+12*(3+2+4) +: 1] = next_ed[j];
    end
  endgenerate

  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i < 12; i = i + 1) begin
        next_cp[i] <= 0;
        next_cd[i] <= 0;
        next_ep[i] <= 0;
        next_ed[i] <= 0;
      end      
    end
    else if (load) begin
      case(step)
        4'b0000 : begin // stay
                    for (i = 0; i < 12; i = i + 1) begin
                      next_cp[i] <= now_cp[i];
                      next_cd[i] <= now_cd[i];
                      next_ep[i] <= now_ep[i];
                      next_ed[i] <= now_ed[i];
                    end
                  end
        4'b0001 : begin // U
                    next_cp[0] <= now_cp[3]; next_cp[1] <= now_cp[0]; next_cp[2] <= now_cp[1]; next_cp[3] <= now_cp[2];
                    next_cd[0] <= now_cd[3]; next_cd[1] <= now_cd[0]; next_cd[2] <= now_cd[1]; next_cd[3] <= now_cd[2];
                    next_ep[0] <= now_ep[3]; next_ep[1] <= now_ep[0]; next_ep[2] <= now_ep[1]; next_ep[3] <= now_ep[2];
                    next_ed[0] <= now_ed[3]; next_ed[1] <= now_ed[0]; next_ed[2] <= now_ed[1]; next_ed[3] <= now_ed[2];
                  end
        4'b0010 : begin // U'
                    next_cp[0] <= now_cp[1]; next_cp[1] <= now_cp[2]; next_cp[2] <= now_cp[3]; next_cp[3] <= now_cp[0];
                    next_cd[0] <= now_cd[1]; next_cd[1] <= now_cd[2]; next_cd[2] <= now_cd[3]; next_cd[3] <= now_cd[0];
                    next_ep[0] <= now_ep[1]; next_ep[1] <= now_ep[2]; next_ep[2] <= now_ep[3]; next_ep[3] <= now_ep[0];
                    next_ed[0] <= now_ed[1]; next_ed[1] <= now_ed[2]; next_ed[2] <= now_ed[3]; next_ed[3] <= now_ed[0];
                  end
        4'b0011 : begin // D
                    next_cp[8] <= now_cp[9]; next_cp[9] <= now_cp[10]; next_cp[10] <= now_cp[11]; next_cp[11] <= now_cp[8];
                    next_cd[8] <= now_cd[9]; next_cd[9] <= now_cd[10]; next_cd[10] <= now_cd[11]; next_cd[11] <= now_cd[8];
                    next_ep[8] <= now_ep[9]; next_ep[9] <= now_ep[10]; next_ep[10] <= now_ep[11]; next_ep[11] <= now_ep[8];
                    next_ed[8] <= now_ed[9]; next_ed[9] <= now_ed[10]; next_ed[10] <= now_ed[11]; next_ed[11] <= now_ed[8];
                  end
        4'b0100 : begin // D'
                    next_cp[8] <= now_cp[11]; next_cp[9] <= now_cp[8]; next_cp[10] <= now_cp[9]; next_cp[11] <= now_cp[10];
                    next_cd[8] <= now_cd[11]; next_cd[9] <= now_cd[8]; next_cd[10] <= now_cd[9]; next_cd[11] <= now_cd[10];
                    next_ep[8] <= now_ep[11]; next_ep[9] <= now_ep[8]; next_ep[10] <= now_ep[9]; next_ep[11] <= now_ep[10];
                    next_ed[8] <= now_ed[11]; next_ed[9] <= now_ed[8]; next_ed[10] <= now_ed[9]; next_ed[11] <= now_ed[10];
                  end
        4'b0101 : begin // F
                    next_cp[2] <= now_cp[3]; next_cp[3] <= now_cp[11]; next_cp[10] <= now_cp[2]; next_cp[11] <= now_cp[10];
                    next_cd[2]  <= {!(|now_cd[3]), now_cd[3][1]}; next_cd[3]  <= {now_cd[11][0], !(|now_cd[11])};
                    next_cd[10] <= {now_cd[2][0], !(|now_cd[2])}; next_cd[11] <= {!(|now_cd[10]), now_cd[10][1]};
                    next_ep[2] <= now_ep[7];     next_ep[6] <= now_ep[2];     next_ep[7] <= now_ep[10];     next_ep[10] <= now_ep[6];
                    next_ed[2] <= now_ed[7] + 1; next_ed[6] <= now_ed[2] + 1; next_ed[7] <= now_ed[10] + 1; next_ed[10] <= now_ed[6] + 1;
                  end
        4'b0110 : begin // F'
                    next_cp[2] <= now_cp[10]; next_cp[3] <= now_cp[2]; next_cp[10] <= now_cp[11]; next_cp[11] <= now_cp[3];
                    next_cd[2]  <= {!(|now_cd[10]), now_cd[10][1]}; next_cd[3]  <= {now_cd[2][0], !(|now_cd[2])};
                    next_cd[10] <= {now_cd[11][0], !(|now_cd[11])}; next_cd[11] <= {!(|now_cd[3]), now_cd[3][1]};
                    next_ep[2] <= now_ep[6];     next_ep[6] <= now_ep[10];     next_ep[7] <= now_ep[2];     next_ep[10] <= now_ep[7];
                    next_ed[2] <= now_ed[6] + 1; next_ed[6] <= now_ed[10] + 1; next_ed[7] <= now_ed[2] + 1; next_ed[10] <= now_ed[7] + 1;
                  end
        4'b0111 : begin // B
                    next_cp[0] <= now_cp[1]; next_cp[1] <= now_cp[9]; next_cp[8] <= now_cp[0]; next_cp[9] <= now_cp[8];
                    next_cd[0] <= {!(|now_cd[1]), now_cd[1][1]}; next_cd[1] <= {now_cd[9][0], !(|now_cd[9])};
                    next_cd[8] <= {now_cd[0][0], !(|now_cd[0])}; next_cd[9] <= {!(|now_cd[8]), now_cd[8][1]};
                    next_ep[0] <= now_ep[5];     next_ep[4] <= now_ep[0];     next_ep[5] <= now_ep[8];     next_ep[8] <= now_ep[4];
                    next_ed[0] <= now_ed[5] + 1; next_ed[4] <= now_ed[0] + 1; next_ed[5] <= now_ed[8] + 1; next_ed[8] <= now_ed[4] + 1;
                  end
        4'b1000 : begin // B'
                    next_cp[0] <= now_cp[8]; next_cp[1] <= now_cp[0]; next_cp[8] <= now_cp[9]; next_cp[9] <= now_cp[1];
                    next_cd[0] <= {!(|now_cd[8]), now_cd[8][1]}; next_cd[1] <= {now_cd[0][0], !(|now_cd[0])};
                    next_cd[8] <= {now_cd[9][0], !(|now_cd[9])}; next_cd[9] <= {!(|now_cd[1]), now_cd[1][1]};
                    next_ep[0] <= now_ep[4];     next_ep[4] <= now_ep[8];     next_ep[5] <= now_ep[0];     next_ep[8] <= now_ep[5];
                    next_ed[0] <= now_ed[4] + 1; next_ed[4] <= now_ed[8] + 1; next_ed[5] <= now_ed[0] + 1; next_ed[8] <= now_ed[5] + 1;
                  end
        4'b1001 : begin // R
                    next_cp[1] <= now_cp[2]; next_cp[2] <= now_cp[10]; next_cp[9] <= now_cp[1]; next_cp[10] <= now_cp[9];
                    next_cd[1] <= {!(|now_cd[2]), now_cd[2][1]}; next_cd[2]  <= {now_cd[10][0], !(|now_cd[10])};
                    next_cd[9] <= {now_cd[1][0], !(|now_cd[1])}; next_cd[10] <= {!(|now_cd[9]), now_cd[9][1]};
                    next_ep[1] <= now_ep[6]; next_ep[5] <= now_ep[1]; next_ep[6] <= now_ep[9]; next_ep[9] <= now_ep[5];
                    next_ed[1] <= now_ed[6]; next_ed[5] <= now_ed[1]; next_ed[6] <= now_ed[9]; next_ed[9] <= now_ed[5];
                  end
        4'b1010 : begin // R'
                    next_cp[1] <= now_cp[9]; next_cp[2] <= now_cp[1]; next_cp[9] <= now_cp[10]; next_cp[10] <= now_cp[2];
                    next_cd[1] <= {!(|now_cd[9]), now_cd[9][1]};   next_cd[2]  <= {now_cd[1][0], !(|now_cd[1])};
                    next_cd[9] <= {now_cd[10][0], !(|now_cd[10])}; next_cd[10] <= {!(|now_cd[2]), now_cd[2][1]};
                    next_ep[1] <= now_ep[5]; next_ep[5] <= now_ep[9]; next_ep[6] <= now_ep[1]; next_ep[9] <= now_ep[6];
                    next_ed[1] <= now_ed[5]; next_ed[5] <= now_ed[9]; next_ed[6] <= now_ed[1]; next_ed[9] <= now_ed[6];
                  end
        4'b1011 : begin // L
                    next_cp[0] <= now_cp[8]; next_cp[3] <= now_cp[0]; next_cp[8] <= now_cp[11]; next_cp[11] <= now_cp[3];
                    next_cd[3]  <= {!(|now_cd[0]), now_cd[0][1]}; next_cd[0]  <= {now_cd[8][0], !(|now_cd[8])};
                    next_cd[11] <= {now_cd[3][0], !(|now_cd[3])}; next_cd[8] <= {!(|now_cd[11]), now_cd[11][1]};
                    next_ep[3] <= now_ep[4]; next_ep[4] <= now_ep[11]; next_ep[7] <= now_ep[3]; next_ep[11] <= now_ep[7];
                    next_ed[3] <= now_ed[4]; next_ed[4] <= now_ed[11]; next_ed[7] <= now_ed[3]; next_ed[11] <= now_ed[7];
                  end
        4'b1100 : begin // L'
                    next_cp[0] <= now_cp[3]; next_cp[3] <= now_cp[11]; next_cp[8] <= now_cp[0]; next_cp[11] <= now_cp[8];
                    next_cd[3]  <= {!(|now_cd[11]), now_cd[11][1]}; next_cd[0] <= {now_cd[3][0], !(|now_cd[3])};
                    next_cd[11] <= {now_cd[8][0], !(|now_cd[8])};   next_cd[8] <= {!(|now_cd[0]), now_cd[0][1]};
                    next_ep[3] <= now_ep[7]; next_ep[4] <= now_ep[3]; next_ep[7] <= now_ep[11]; next_ep[11] <= now_ep[4];
                    next_ed[3] <= now_ed[7]; next_ed[4] <= now_ed[3]; next_ed[7] <= now_ed[11]; next_ed[11] <= now_ed[4];
                  end
        default : begin
                    for (i = 0; i < 12; i = i + 1) begin
                      next_cp[i] <= now_cp[i];
                      next_cd[i] <= now_cd[i];
                      next_ep[i] <= now_ep[i];
                      next_ed[i] <= now_ed[i];
                    end          
                  end
      endcase
    end
  end
  
endmodule