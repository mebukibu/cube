# data convert

def convert_18():
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

def convert_162():
  for i in range(32):
    with open('../verilog/data/data18/weight18_' + str(i) + '.txt', 'r') as i_file:
      with open('../verilog/data/data162/weight162_' + str(i) + '.txt', 'w') as o_file:
        line_cnt = 0
        o_line = ''
        for line in i_file:
          o_line = line[:18] + o_line
          if (line_cnt + 1) % 9 == 0:
            o_file.write(o_line + '\n')
            o_line = ''
          line_cnt += 1

def convert_bias():
  for i in range(32):
    with open('../verilog/data/data18/bias18_data.txt', 'r') as i_file:
      with open('../verilog/test/src/network/cnn_layer/bias576_data.txt', 'w') as o_file:
        line_cnt = 0
        o_line = ''
        for line in i_file:
          o_line = line[:18] + o_line
          if (line_cnt + 1) % 32 == 0:
            o_file.write(o_line + '\n')
            o_line = ''
          line_cnt += 1


if __name__ == '__main__':
  #convert_162()
  convert_bias()