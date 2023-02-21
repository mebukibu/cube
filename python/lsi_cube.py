import numpy as np
import random
import cube as cb

def read_file(filename):
  num = []
  with open(filename, 'r') as file_data:
    for line in file_data:
      #temp = (int(line, 2) - int(int(line[0]) << (len(line) - 1))) / (1 << 16)
      temp  = (int(line[2:18], 2) - int(int(line[2]) << (17 - 1))) / (1 << 10)
      num.append(temp)
  return num

def read_weight():
  weight = [[], [], [], [], []]
  for i in range(32):
    num = read_file('data/weight_ch_' + str(i) + '.txt')
    weight[0].append(num[0:36])
    weight[1].append(num[36:324])
    weight[2].append(num[324:612])
    weight[3].append(num[612:900])
    if i < 24:
      if i < 12:
        weight[4].append(num[900:])
      else:
        weight[4][i-12] = weight[4][i-12] + num[900:]
  return weight

def read_bias():
  bias = []
  num = read_file('data/bias_data.txt')
  bias.append(num[0:32])
  bias.append(num[32:64])
  bias.append(num[64:96])
  bias.append(num[96:128])
  bias.append(num[128:])
  return bias


def im2col(input_data):
  C, H, W = (input_data.shape)
  pad = np.pad(input_data, [(0, 0), (1, 1), (1, 1)], 'constant')
  num = []
  for y in range(H):
    for x in range(W):
      num.append(pad[:, y:y+3, x:x+3].reshape(3*3*C))
  return np.array(num)

def elu(x):
  #return np.exp((x < 0) * x) - 1 + (x > 0) * x
  return np.where(x >= 0, x, np.exp(x) - 1)

def layer(input_data, weight, bias):
  col = im2col(input_data)
  out = np.dot(col, np.array(weight).T)
  #print(min(np.array(out).flatten()))
  #out = np.dot(np.array(weight), col.T)
  out = out + np.array(bias)
  #print(min(np.array(out).flatten()))
  out = elu(out)
  print(out[11][31])
  #print(max(np.array(out).flatten()))
  out = out.T.reshape(32, 3, 4)
  return out

def predict(cube, weight, bias):
  layer0_out = layer(np.array(cube.state), weight[0], bias[0])
  layer1_out = layer(layer0_out, weight[1], bias[1])
  layer2_out = layer(layer1_out, weight[2], bias[2])
  layer3_out = layer(layer2_out, weight[3], bias[3])

  out = np.dot(layer3_out.flatten(), np.array(weight[4]).T)
  out = out + bias[4]
  return out.argmax()

def main():
  first_state = [
      [[3, 0, 1, 2], [0, 0, 0, 0], [4, 5,  6,  7]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0,  0,  0]],
      [[3, 0, 1, 2], [4, 5, 6, 7], [8, 9, 10, 11]],
      [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0,  0,  0]]
    ]
  """[
      [[7, 1, 6,  4], [0, 0, 0, 0], [0,  5, 3, 2]],
      [[0, 2, 1,  0], [0, 0, 0, 0], [1,  2, 0, 0]],
      [[3, 6, 1, 11], [7, 0, 9, 4], [5, 10, 2, 8]],
      [[0, 0, 0,  0], [0, 0, 0, 0], [0,  0, 0, 0]]
    ]"""

  weight = read_weight()
  bias = read_bias()
  #print(np.sum(weight[0][31][0:]))
  #return

  cube = cb.Cube(first_state)
  """
  cube.move(0)
  print(np.array(cube.state))
  next_step = predict(cube, weight, bias)
  print(next_step)
  cube.move(next_step)
  print(cube.check())
  """

  
  for j in range(30):
    next_step = predict(cube, weight, bias)
    print('step = ' + str(next_step + 1))
    cube.move(next_step)
    if cube.check():
      print('success')
      break
  

  """
  cnt = 0
  for i in range(1000):
    cube.reset(3)
    for j in range(30):
      next_step = predict(cube, weight, bias)
      print('step = ' + str(next_step + 1))
      cube.move(next_step)
      if cube.check():
        print('success')
        cnt = cnt + 1
        break
  print(cnt)
  """


if __name__ == '__main__':
  main()
  """ with open('data/weight_ch_0.txt', 'r') as filedata:
    for line in filedata:
      if line[0] == '1':
        continue
      print(line[:24])
      print('  ' + line[2:18])
      temp = (int(line, 2) - int(int(line[0]) << (25 - 1))) / (1 << 16)
      tmp  = (int(line[2:18], 2) - int(int(line[2]) << (17 - 1))) / (1 << 10)
      print(temp)
      print(tmp)
      break """
