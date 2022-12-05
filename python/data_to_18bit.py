
for i in range(32):
  with open('data/weight_ch_' + str(i) + '.txt', 'r') as file_data:
    cnt = 0
    with open('../verilog/data/data18/weight18_' + str(i) + '.txt', 'w') as file:
      for line in file_data:
        #print(line[2:18])
        file.write(line[0:18] + '\n')
        cnt += 1
        if cnt == 36:
          for j in range(288-36):
            file.write('000000000000000000' + '\n')
        if cnt == 1092:
          for j in range(288-192):
            file.write('000000000000000000' + '\n')          


cnt = 0
with open('data/bias_data.txt', 'r') as file_data:
  with open('../verilog/data/data18/bias18_data.txt', 'w') as file:
    for line in file_data:
      #print(line[2:18])
      file.write(line[0:18] + '\n')
      cnt += 1
      if cnt == 140:
        for j in range(32-12):
          file.write('000000000000000000' + '\n')