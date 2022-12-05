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

string toBinary(int n)
{
	string r;
	while (n != 0) {
		r += (n % 2 == 0 ? "0" : "1");
		n /= 2;
	}
	return r;
}



int ctoi1(int* input) {
	string sstate="";
		for (int k = 0; k < 4; k++) {
			bitset<3> bs1(input[k]);
			bitset<2> bs2(input[12+k]);
			sstate = sstate + bs1.to_string()+ bs2.to_string();
			}
		bitset<20> bs3(sstate);
		int istate = std::stoi(bs3.to_string(), 0, 2);
	return istate;
}
int ctoi2(int* input) {
	string sstate = "";
	for (int k = 0; k < 4; k++) {
		bitset<3> bs1(input[8 + k]);
		bitset<2> bs2(input[20 + k]);
		sstate = sstate + bs1.to_string() + bs2.to_string();
	}
	bitset<20> bs3(sstate);
	int istate = std::stoi(bs3.to_string(), 0, 2);
	return istate;
}
int etoi1(int* input) {
	string sstate = "";
	for (int k = 0; k < 4; k++) {
		bitset<4> bs1(input[24 + k]);
		bitset<1> bs2(input[36 + k]);
		sstate = sstate + bs1.to_string() + bs2.to_string();
	}
	bitset<20> bs3(sstate);
	int istate = std::stoi(bs3.to_string(), 0, 2);
	return istate;
}
int etoi2(int* input) {
	string sstate = "";
	for (int k = 0; k < 4; k++) {
		bitset<4> bs1(input[30 + k]);
		bitset<1> bs2(input[42 + k]);
		sstate = sstate + bs1.to_string() + bs2.to_string();
	}
	bitset<20> bs3(sstate);
	int istate = std::stoi(bs3.to_string(), 0, 2);
	return istate;
}


int main(int argc, char** argv)
{
	//srand((unsigned int)time(NULL)); //rand seed set

	CUBE cube;
	//cube.reset(5);

	cube.observation;	
	print((int*)cube.observation, cube.observation_space);
	int i;

	int wdata[4];
	int rdata[34];
	wdata[0] = ctoi1((int*)cube.observation);
	wdata[1] = ctoi2((int*)cube.observation);
	wdata[2] = etoi1((int*)cube.observation);
	wdata[3] = etoi2((int*)cube.observation);
	//U
	/*wdata[0] = 393352;
	wdata[1] = 545564;
	wdata[2] = 201396490;
	wdata[3] = 417876630;*/

	for (i = 0; i < 4; i++) {
		printf("input wdata[%d] = %d\n", i, wdata[i]);
	}

	
	uint32_t address;    
	int fd;


	if ((fd = open("/dev/uio4", O_RDWR | O_SYNC)) < 0) {
		perror("open");
		return -1;
	}
	
	address = (uint32_t)mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

	

	for (i = 0;i<4; i++) 
	{
		REG(address + (51 + i) * 4) = wdata[i];
		printf("wdata[%d]=%d\n", i, REG(address + (51 + i) * 4));
		//printf("wdata[%d]=%d\n", i, wdata[i]);
	}
	usleep(72000);
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
		
		
	
	

	munmap((void*)address, 0x1000);
	close(fd);

	
	return 0;
}