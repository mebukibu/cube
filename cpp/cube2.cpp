#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <stdint.h> 
#include <string>
#include "cube1.hpp"
#include <bitset>
#include <unistd.h>




#define REG(address) *(volatile uint32_t*)(address)

void print(int* input, int input_shape[3]) {
	// cout << input_shape[0];
	for (int i = 0; i < input_shape[0]; i++) {
		for (int j = 0; j < input_shape[1]; j++) {
			for (int k = 0; k < input_shape[2]; k++) {
				cout << input[i * input_shape[1] * input_shape[2] + j * input_shape[2] + k];
				cout << ' ';
			}
			cout << '\n';
		}
		cout << '\n';
	}
	cout << '\n';
}

string cube_data2binary(int* input) {
	string cp = "", cd = "", ep = "", ed = "";
	for (int i = 0; i < 12; i++) {
		bitset<3> bs_cp(input[i]);
		bitset<2> bs_cd(input[i+12]);
		bitset<4> bs_ep(input[i+24]);
		bitset<1> bs_ed(input[i+36]);
		cp = bs_cp.to_string() + cp;
		cd = bs_cd.to_string() + cd;
		ep = bs_ep.to_string() + ep;
		ed = bs_ed.to_string() + ed;
	}
	//printf("length = %d\n", (int)(ed + ep + cd + cp).length());
	return ed + ep + cd + cp;
}

void split_string2int(unsigned int* store, string input) {
	store[0] = std::stoul(input.substr(120-32, 32), 0, 2);
	store[1] = std::stoul(input.substr(120-32*2, 32), 0, 2);
	store[2] = std::stoul(input.substr(120-32*3, 32), 0, 2);
	store[3] = std::stoul(input.substr(0, 120-32*3), 0, 2);
}


int main(int argc, char** argv)
{
	//srand((unsigned int)time(NULL)); //rand seed set

	CUBE cube;
	//cube.reset(5);

	cube.observation;	
	print((int*)cube.observation, cube.observation_space);
	int i;

	unsigned int wdata[4];
	int rdata[34];

	string cube_binary;
	cube_binary = cube_data2binary((int*)cube.observation);
	//printf("%s\n", c.c_str());
	split_string2int(wdata, cube_binary);

	for (i = 0; i < 4; i++) {
		printf("input wdata[%d] = %#x\n", i, wdata[i]);
	}
	
	uint32_t address;    
	int fd;


	/* if ((fd = open("/dev/uio4", O_RDWR | O_SYNC)) < 0) {
		perror("open");
		return -1;
	}
	
	address = (uint32_t)mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

	

	for (i = 0;i<4; i++) 
	{
		REG(address + (0 + i) * 4) = wdata[i];
		printf("wdata[%d]=%#x\n", i, REG(address + (0 + i) * 4));
		//printf("wdata[%d]=%d\n", i, wdata[i]);
	} */
	/* usleep(72000);
		for (i = 0; i < 55; i++)
		{

			rdata[i] = REG(address+i*4);

		}
		for (i = 0; i < 51; i++) {

			printf("step[%d]=%d\n", i, rdata[i]);
		}
		for (i = 0; i < 4; i++) {

			printf("in[%d]=%d\n", i+51, rdata[51+i]);
		}
		 */
		
	
	

	munmap((void*)address, 0x1000);
	close(fd);

	
	return 0;
}
