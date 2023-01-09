`include "../data/state_main_data.v"

module main (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire [120 - 1:0] d,
    output reg [3:0] addr,
    output reg [3:0] step,
    output wire q
  );

  // ports for state_main
  wire load2state;
  wire [2:0] cs;

  // ports for cube
  wire cube_valid;
  wire cube_fin;
  wire [120 - 1:0] cubeout;

  // ports for network
  wire network_valid;
  wire [3:0] networkout;

  // use in this module
  reg [2:0] cs_temp;
  reg solve_fail;

  // assign
  assign load2state = (cs == `IDLE)    & 1'b0 |
                      (cs == `STORE)   & cube_valid |
                      (cs == `NETWORK) & network_valid |
                      (cs == `CUBE)    & cube_valid |
                      (cs == `FINISH)  & 1'b0;
  assign q = (cs == `FINISH);

  // slv_reg writer
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      cs_temp <= 0;
      addr <= 0;
    end
    else begin
      cs_temp <= cs;
      if (cs == `CUBE && cs_temp != `CUBE) begin
        addr <= addr + 1;
      end
    end
  end

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      step <= 0;
      solve_fail <= 0;
    end
    else if (cube_valid) begin
      step <= networkout;
    end
    else if (addr == 10) begin
      solve_fail <= 1;
    end
  end
  

  // instance
  state_main state_main_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(run),
    .load(load2state),
    .fin(cube_fin | solve_fail),
    .q(cs)
  );

  cube cube_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `CUBE),
    .store(cs == `STORE),
    .store_data(d),
    .d(networkout),
    .valid(cube_valid),
    .fin(cube_fin),
    .q(cubeout)
  );

  network network_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `NETWORK),
    .d(cubeout),
    .valid(network_valid),
    .q(networkout)
  );
  
endmodule