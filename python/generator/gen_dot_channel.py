# verilog cannot expresses "aaa" + str(i) + "bbb".
# so, this program generates instead.

for i in range(32):
  print('dot_channel #(')
  print('  .filename("../data/data162/weight162_' + str(i) +'.txt")')
  print(') dot_channel_' + str(i) + '_inst (')
  print('  .clk(clk),')
  print('  .rst_n(rst_n),')
  print('  .dc_load(dc_start),')
  print('  .ws_load(fetch_start),')
  print('  .cs(cs),')
  print('  .phase(dc_phase),')
  print('  .d(data2dc),')
  print('  .valid(dc_valid[' + str(i) + ']),')
  print('  .q(dcout[' + str(i) + '*`data_len +: `data_len])')
  print(');')
  print('\n')