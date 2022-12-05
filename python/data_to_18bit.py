
for i in range(32):
  with open('data/weight_ch_' + str(i) + '.txt', 'r') as file_data:
    with open('../verilog/data/data18/weight18_' + str(i) + '.txt', 'w') as file:
      for line in file_data:
        #print(line[2:18])
        file.write(line[0:18] + '\n')
        #break

with open('data/bias_data.txt', 'r') as file_data:
  with open('../verilog/data/data18/bias18_data.txt', 'w') as file:
    for line in file_data:
      #print(line[2:18])
      file.write(line[0:18] + '\n')
      #break