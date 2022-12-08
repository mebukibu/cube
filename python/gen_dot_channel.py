# verilog cannot expresses "aaa" + str(i) + "bbb".
# so, this program generates instead.

for i in range(32):
  print('dot_channel #(')
  print('  .filename("../data/data18/weight18_' + str(i) +'.txt")')
  print(') dot_channel_inst_' + str(i) + ' (')
  print('  .clk(clk),')
  print('  .rst_n(rst_n),')
  print('  .load(load),')
  print('  .cs(cs),')
  print('  .d(d),')
  print('  .valid(dc_valid[' + str(i) + ']),')
  print('  .q(q_temp[' + str(i) + '])')
  print(');')
  print('\n')