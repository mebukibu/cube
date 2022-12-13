`include "../data/state_cube_data.v"

module cube (
    input wire clk,
    input wire rst_n,
    input wire load,
    input wire store,
    input wire [120 - 1:0] store_data,
    input wire [3:0] d,
    output wire valid,
    output wire fin,
    output wire [120 - 1:0] q
  );

  // ports for state_cube
  wire [1:0] cs;

  // ports for current_cube
  wire [120 - 1:0] data2curr;
  wire [120 - 1:0] currout;

  // ports for change_cube
  wire [3:0] step;
  wire [120 - 1:0] chngout;

  // use in this module
  reg store_delay;

  // assign
  assign data2curr = store ? store_data : chngout;
  assign step = store_delay ? 3'b000 : d;
  assign valid = (cs == `CB_FIN) ? 1'b1 : 1'b0;
  assign q = chngout;

  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) store_delay <= 0;
    else if (store) store_delay <= 1;
    else store_delay <= 0;
  end

  // instance
  state_cube state_cube_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(load),
    .load(1'b1),
    .q(cs)
  );

  current_cube current_cube_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(store | (cs == `CHECK)),
    .d(data2curr),
    .q(currout)
  );

  change_cube change_cube_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(store_delay | (cs == `CHANGE)),
    .step(step),
    .d(currout),
    .q(chngout)
  );

  check_cube check_cube_inst (
    .clk(clk),
    .rst_n(rst_n),
    .load(cs == `CHECK),
    .d(chngout),
    .q(fin)
  );
  
endmodule