`include "../data/state_main_data.v"

module main (
    input wire clk,
    input wire rst_n,
    input wire run,
    input wire [120 - 1:0] d,
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


  // assign
  assign load2state = (cs == `IDLE)    ? 1'b0 : 1'bZ;
  assign load2state = (cs == `STORE)   ? cube_valid : 1'bZ;
  assign load2state = (cs == `NETWORK) ? network_valid : 1'bZ;
  assign load2state = (cs == `CUBE)    ? cube_valid : 1'bZ;
  assign load2state = (cs == `FINISH)  ? 1'b0 : 1'bZ;

  assign q = cube_fin;

  // instance
  state_main state_main_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(run),
    .load(load2state),
    .fin(cube_fin),
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