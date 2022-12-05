
for i in range(32):
  with open('data/weight_ch_' + str(i) + '.txt', 'r') as file_data:
    with open('data_16/weight16_' + str(i) + '.txt', 'w') as file:
      for line in file_data:
        #print(line[2:18])
        file.write(line[2:18] + '\n')
        #break

with open('data/bias_data.txt', 'r') as file_data:
  with open('data_16/bias16_data.txt', 'w') as file:
    for line in file_data:
      #print(line[2:18])
      file.write(line[2:18] + '\n')
      #break