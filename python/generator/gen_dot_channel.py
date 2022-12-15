# verilog cannot expresses "aaa" + str(i) + "bbb".
# so, this program generates instead.

for i in range(32):
  print('dot_channel_' + str(i) + ' #(')
  print('  .filename("../data/data18/weight18_' + str(i) +'.txt")')
  print(') dot_channel_' + str(i) + '_inst (')
  print('  .clk(clk),')
  print('  .rst_n(rst_n),')
  print('  .load(dc_start),')
  print('  .cs(cs),')
  print('  .d(data2dc),')
  print('  .valid(dc_valid[' + str(i) + ']),')
  print('  .q(dcout[' + str(i) + '*`data_len +: `data_len])')
  print(');')
  print('\n')