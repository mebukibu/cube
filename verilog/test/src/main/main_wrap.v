`include "num_data.v"

module main_wrap (
    input wire clk,
    input wire rst_n,
    input wire run,
    output wire [3:0] cs_out,
    output wire [9:0] data_disp,
    output wire q
  );

  // ports for main
  reg [120 - 1:0] init_data;
  reg [32*12*`data_len - 1:0] expect_value;
  wire [3:0] addr;
  wire [3:0] step;
  wire mainout;
  wire [32*12*`data_len - 1:0] data_out;

  // assign
  assign data_disp = data_out[9:0];
  assign q = (expect_value == data_out);

  main main_inst (
    .clk(clk),
    .rst_n(rst_n),
    .run(run),
    .d(init_data),
    .addr(addr),
    .step(step),
    .q(mainout),
    .cs_out(cs_out),
    .data_out(data_out)
  );

  initial begin
    init_data = {
      12'd0,
      4'd11, 4'd10, 4'd9, 4'd8, 4'd7, 4'd6, 4'd5, 4'd4, 4'd2, 4'd1, 4'd0, 4'd3,
      24'd0,
      3'd7, 3'd6, 3'd5, 3'd4, 12'd0, 3'd2, 3'd1, 3'd0, 3'd3
    };

    expect_value = {
      6912'hfcd13eb31fba1bf73cfdc27f6a8fc627fb49fc3f3fb00ff56bfbaf019e3fc8aff023ff0e03e67fb91fd54c05ea01184031901334053cfac33f560fdf53f89b0065c09260155c09b8fe97bfed9ffdeffaa300a9405d40143c0ae4fae03ec10fb844010200110003cffd0c048bff91bfe6cff5dbfadbfe9a7ff29ff9300099ff897fde1009e7ff84fc843ef57fc3cbf39dfb1f80839000700fe2fdfb400d20133800adff83ffbe6ff1240160ff4a3ff92fecabff8bfebaff7bdfe86ffec60030fff8fffa7fff10fcc8bf19dff06bf446fea1bf62afd0dffe9a040b401740051c02ac0294c1231044bc0803004140478007dc069dfcc63f5aefdaf3fc56ffaa0038c0000c05b6fcc4ffb71fe9d3fabbfe587f9f2fea2ffb6dfec93fb9801ab0009ffe6ec01200011bfc9feb57bb175ef0c3d615f0af3d834f6efbe7b2fbecffb4efe47ff45ddce3b5eb6dcfdbc1a6e33439adae9c5bd4f4fa8d3eaa1f7943f1bc01583f0c8fcf8000f0ff3f4046bffd680611ffd9002b8fea6007f3ffa34039b018640ca002fb00861ff6cbfd48ff23bf9ddfe21c00f1febeff1e2fce17f185fedb00167feb8ff8a2fe7f3f391fe45bf7db00727fd80ff9cffffaff1f7fd6500dabfe4500a37ffd4ff74bfb97fe153f6bffe5bbfe17fe8c7f879fdf0ffcf600d2ffd65ffaebfbd0fee47f460fdf3ff366f9807f84fff37c0532feccbfcdc00b53fca1ff66c02340074407f7feae7f7dbfa24ffb3300923fa9fff023fb36f9e9bdca4f87bbf66203b640bf601cec0b6f018ac0431ffd30080ef8c17f5bbfdb3401c30109bef3ffb18fe5f800a87fee7fdfc3fb91ff2c7fda0ff86fed8200543f7c7ffb07f35bfe76bf6ad0088ff875f4a63dcb4f8a73eacefeb3be03afa2b3d98d015abff7cff8f7f7f1fd927e63ffa1e7eeabfc733f3f6fdb20095dff38ff961ff2cbfbd0f1b63cc2ff4f2bf02af7483f58ff9770083bfe5fbf9d8fda1ffd1d00f33fe05ffa4bfd1402ce7fe5aff2fbfc7500397fcd3ffdec01daf5e9fd2b9f61cfee07015a3fe77ff1d3f85500f9801d4ff04fff2fff5e7f051fc1040121f699fd506f796bfd86ff76bf9bffce300406fd237f8fdfdea4066c00607ff05012d007b101aa0085cfefd404bbff153fbcaff583ff9ffd36ffaa5fe9abfe26004c802750101c0176ff077ff29ff5e7fca2002f7fd5eff5800764ffc20040dffbb7fdc6
    };
  end
  
endmodule