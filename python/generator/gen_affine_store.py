# affine_store generator
# please output's if (addr == -1) line comment out

cnt = 1
for i in range(64):
  print('      if (addr == ' + str(i) + ')', end='')
  if i < 20:
    print(' q <= d[' + str(cnt) + '*9*`data_len +: 9*`data_len];')
    cnt += 1
  elif i == 20:
    print(' q <= {{6*`data_len{1\'b0}}, d[' + str(cnt) + '*9*`data_len +: 3*`data_len]};')
    cnt = 0
  elif i < 31:
    print(' q <= 0;')
  elif i < 52:
    print(' q <= d[(192+' + str(cnt) + '*9)*`data_len +: 9*`data_len];')
    cnt += 1
  elif i == 52:
    print(' q <= {{6*`data_len{1\'b0}}, d[(192+' + str(cnt) + '*9)*`data_len +: 3*`data_len]};')
    cnt += 1
  elif i < 63:
    print(' q <= 0;')
  elif i == 63:
    print(' valid <= 1;')