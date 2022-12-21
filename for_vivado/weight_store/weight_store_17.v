`include "num_data.v"
`include "state_layer_data.v"

module weight_store_17 #(
    parameter filename = "../data/data162/weight162_0.txt"
  ) (
    input wire clk,
    input wire load,
    input wire [3:0] cs,
    input wire [2:0] phase,
    output reg valid,
    output reg [36*`data_len - 1:0] q
  );

  // ports for rom
  reg [7:0] rom_addr;
  wire [9*`data_len - 1:0] romout;

  // use in this module
  reg init;
  wire [7:0] offset;
  reg [7:0] cs_offset;
  reg [4:0] phase_offset;
  reg [2:0] addr_cnt;
  reg [9:0] q_index;
  
  // assign
  assign offset = cs_offset + phase_offset;

  w_rom_17 #(
    .filename(filename)
  ) w_rom_17_inst (
    .clk(clk),
    .addr(rom_addr),
    .q(romout)
  );

  always @(cs) begin
    case (cs)
      `LAYER0 : cs_offset = 0*32;
      `LAYER1 : cs_offset = 1*32;
      `LAYER2 : cs_offset = 2*32;
      `LAYER3 : cs_offset = 3*32;
      `AFFINE : cs_offset = 4*32;      
      default : cs_offset = 8'hXX;
    endcase    
  end

  always @(phase) begin
    case (phase)
      3'b000 : phase_offset = 0*4;
      3'b001 : phase_offset = 1*4;
      3'b010 : phase_offset = 2*4;
      3'b011 : phase_offset = 3*4;
      3'b100 : phase_offset = 4*4;
      3'b101 : phase_offset = 5*4;
      3'b110 : phase_offset = 6*4;
      3'b111 : phase_offset = 7*4;
      default: phase_offset = 3'bXXX;
    endcase
  end

  always @(posedge clk) begin
    if (load) begin
      q[q_index +: 9*`data_len] <= romout;
      if (init) begin
        init <= 0;
        valid <= 0;
        rom_addr <= offset;
        addr_cnt <= 0;
        q_index <= 0;
      end
      else if (addr_cnt == 0) begin
        rom_addr <= rom_addr + 1;
        addr_cnt <= addr_cnt + 1;
        q_index <= 0;
      end
      else if (addr_cnt < 3) begin
        rom_addr <= rom_addr + 1;
        addr_cnt <= addr_cnt + 1;
        q_index <= q_index + 9*`data_len;
      end
      else if (addr_cnt == 3) begin
        addr_cnt <= addr_cnt + 1;
        q_index <= q_index + 9*`data_len;
      end
      else if (addr_cnt == 4) begin
        valid <= 1;
      end
    end
    else begin
      init <= 1;
      //valid <= 0;
      rom_addr <= offset;
      addr_cnt <= 0;
      q_index <= 0;
    end
  end
  
  
endmodule