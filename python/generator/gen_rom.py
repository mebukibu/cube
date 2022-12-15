# generate rom module's initial valie & assign 

DATA_ROOT = '../../verilog/data/data18/'
SRC_DIR = '../../for_vivado/'

def gen_mem(mem, text, tab):
  addr = 0
  n_tab = ''
  for i in range(tab):
    n_tab += '  '
  with open(DATA_ROOT + text, 'r') as file_data:
    for line in file_data:
      print(n_tab + mem + '[' + str(addr) + '] = 18\'b' + line[:-1] + ';')
      addr += 1
  return

def write_mem(file, mem, text, tab):
  addr = 0
  n_tab = ''
  for i in range(tab):
    n_tab += '  '
  with open(DATA_ROOT + text, 'r') as file_data:
    for line in file_data:
      file.write(n_tab + mem + '[' + str(addr) + '] = 18\'b' + line[:-1] + ';' + '\n')
      addr += 1
  return

def gen_rom(o_name, i_name):
  with open(SRC_DIR + 'rom/' + o_name + '.v', 'w') as o_file:
    with open(SRC_DIR  + 'rom.v', 'r') as i_file:
      for line in i_file:
        if (line == 'module rom #(\n'):
          o_file.write('module ' + o_name + ' #(\n')
        else:
          o_file.write(line)
        if (line == '    //$readmemb(filename, mem);\n'):
          write_mem(o_file, 'mem', i_name + '.txt', 2)
  return

def gen_w_rom():
  for i in range(32):
    gen_rom('w_rom_' + str(i), 'weight18_' + str(i))
  return

def gen_ws():
  for i in range(32):
    o_name = 'weight_store_' + str(i)
    with open(SRC_DIR + 'weight_store/' + o_name + '.v', 'w') as o_file:
      with open(SRC_DIR + 'weight_store.v', 'r') as i_file:
        for line in i_file:
          if (line == 'module weight_store #(\n'):
            o_file.write('module weight_store_' + str(i) + ' #(\n')
          elif (line == '  rom #(\n'):
            o_file.write('  w_rom_' + str(i) + ' #(\n')
          elif (line == '  ) rom_inst (\n'):
            o_file.write('  ) w_rom_' + str(i) + '_inst (\n')
          else:
            o_file.write(line)
  return

def gen_dc():
  for i in range(32):
    o_name = 'dot_channel_' + str(i)
    with open(SRC_DIR + 'dot_channel/' + o_name + '.v', 'w') as o_file:
      with open(SRC_DIR + 'dot_channel.v', 'r') as i_file:
        for line in i_file:
          if (line == 'module dot_channel #(\n'):
            o_file.write('module dot_channel_' + str(i) + ' #(\n')
          elif (line == '  weight_store #(\n'):
            o_file.write('  weight_store_' + str(i) + ' #(\n')
          elif (line == '  ) weight_store_inst (\n'):
            o_file.write('  ) weight_store_' + str(i) + '_inst (\n')
          else:
            o_file.write(line)
  return

if __name__ == '__main__':
  #gen_mem('bias', 'bias18_data.txt', 2)
  gen_rom('elu_rom', 'eLU_table')
  gen_w_rom()
  gen_ws()
  gen_dc()
  