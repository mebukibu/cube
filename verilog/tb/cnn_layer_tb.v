`include "../data/num_data.v"

module cnn_layer_tb ();

  // ports for cnn
  reg clk;
  reg rst_n;
  reg cnld;
  reg [2:0] cs_layer;
  wire valid;
  wire [32*12*`data_len - 1:0] cnnout;

  // ports for buffer
  reg bfld;
  reg [32*4 - 1:0] bufin;
  wire [32*3*4*`data_len - 1:0] bufout;

  // ports for elu
  wire eluvld;
  wire [32*12*`data_len - 1:0] q;

  cube_data_buffer buf0 (.clk(clk), .rst_n(rst_n), .load(bfld), .d(bufin), .q(bufout));
  cnn_layer cnn_layer0  (.clk(clk), .rst_n(rst_n), .load(cnld), .cs_layer(cs_layer), .d(bufout), .valid(valid), .q(cnnout));
  elu_layer elu_layer0  (.clk(clk), .load(valid), .d(cnnout), .valid(eluvld), .q(q));

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpvars;
    rst_n=0; bfld=0; cnld=0; cs_layer=0; bufin=128'h82a54907b1630900184e800098f; #10
    rst_n=1; #10
    bfld=1; #10
    cnld=1; cs_layer=1; #10
    #10000
    $display("%b", q);
    $finish;
  end

endmodule