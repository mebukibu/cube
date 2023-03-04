import numpy as np

def read_file(filename):
  num = []
  with open(filename, 'r') as file_data:
    for line in file_data:
      #temp = (int(line, 2) - int(int(line[0]) << (len(line) - 1))) / (1 << 16)
      #temp  = (int(line[2:18], 2) - int(int(line[2]) << (17 - 1))) / (1 << 10)
      num.append(line[0:18])
  return num

def read_weight():
  weight = [[], [], [], [], []]
  for i in range(32):
    num = read_file('../data/weight_ch_' + str(i) + '.txt')
    weight[0].append(num[0:36] + ['000000000000000000' for n in range(288 - 36)])
    weight[1].append(num[36:324])
    weight[2].append(num[324:612])
    weight[3].append(num[612:900])
    if i < 24:
      weight[4].append(num[900:] + ['000000000000000000' for n in range(288 - 192)])
    else:
      weight[4].append(['000000000000000000' for n in range(288)])
  return weight

def print_weight(weight):
  with open('../../verilog/test/src/network/cnn_layer/dot/weight18.txt', 'w') as o_file:
    for i in range(len(weight)):
      for j in range(len(weight[0])):
        for k in range(len(weight[0][0])):
          o_file.write(weight[i][j][k] + '\n')
  return

def convert_weight(num):
  with open('../../verilog/test/src/network/cnn_layer/dot/weight18.txt', 'r') as i_file:
    with open('../../verilog/test/src/network/cnn_layer/dot/weight' + str(18*num) + '.txt', 'w') as o_file:
      line_cnt = 0
      o_line = ''
      for line in i_file:
        o_line = line[:18] + o_line
        if (line_cnt + 1) % num == 0:
          o_file.write(o_line + '\n')
          o_line = ''
        line_cnt += 1
  return

def main():
  weight = read_weight()
  #print(np.array(weight[4][31]))
  #print(np.shape(np.array(weight[4])))
  #print(['000000000000000000' for i in range(8)])
  
  #print(len(weight[0][0]))
  #print_weight(weight)

  convert_weight(6)

  return

if __name__ == '__main__':
  main()