# im2col generator
# please output's if (addr == -1) line comment out

addr = -1
for i in range(3):
  for j in range(4):
    for k in range(32):
      print('      if (addr == ' + str(addr) + ')', end='')
      print(' q <= {', end='')
      print('d[' + str(12+6*i+j+30*k) + '*`data_len +: 3*`data_len], ', end='')
      print('d[' + str(6+6*i+j+30*k) + '*`data_len +: 3*`data_len], ', end='')
      print('d[' + str(0+6*i+j+30*k) + '*`data_len +: 3*`data_len]};')
      addr += 1

print('      if (addr == ' + str(addr) + ')', end='')
print(' valid <= 1;')