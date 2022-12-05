#ifndef __CUBE_H_INCLUDED__
#define __CUBE_H_INCLUDED__


#include <iostream>
#include <random>
std::random_device rnd;
using namespace std;

class CUBE{
    public:
        int action_space = 12;
        int cp[12], cd[12], ep[12], ed[12];
        int s_cp[12] = {0, 1, 2, 3, 0, 0, 0, 0, 4, 5, 6, 7};
        int s_cd[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        int s_ep[12] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
        int s_ed[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        int observation_space[3]={4, 3, 4};
        int moves[12][4][12] = {
                    {  {3, 0, 1, 2,   0, 0, 0, 0,   4, 5, 6, 7}, {0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0}, {3, 0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {1, 2, 3, 0,   0, 0, 0, 0,   4, 5, 6, 7}, {0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0}, {1, 2, 3, 0, 4, 5, 6, 7, 8, 9, 10, 11}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {0, 1, 2, 3,   0, 0, 0, 0,   5, 6, 7, 4}, {0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0}, {0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 8}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {0, 1, 2, 3,   0, 0, 0, 0,   7, 4, 5, 6}, {0, 0, 0, 0,  0, 0, 0, 0,   0, 0, 0, 0}, {0, 1, 2, 3, 4, 5, 6, 7, 11, 8, 9, 10}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {0, 1, 3, 7,   0, 0, 0, 0,   4, 5, 2, 6}, {0, 0, 2, 1,  0, 0, 0, 0,   0, 0, 1, 2}, {0, 1, 7, 3, 4, 5, 2, 10, 8, 9, 6, 11}, {0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0},  },
                    {  {0, 1, 6, 2,   0, 0, 0, 0,   4, 5, 7, 3}, {0, 0, 2, 1,  0, 0, 0, 0,   0, 0, 1, 2}, {0, 1, 6, 3, 4, 5, 10, 2, 8, 9, 7, 11}, {0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0},  },
                    {  {1, 5, 2, 3,   0, 0, 0, 0,   0, 4, 6, 7}, {2, 1, 0, 0,  0, 0, 0, 0,   1, 2, 0, 0}, {5, 1, 2, 3, 0, 8, 6, 7, 4, 9, 10, 11}, {1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0},  },
                    {  {4, 0, 2, 3,   0, 0, 0, 0,   5, 1, 6, 7}, {2, 1, 0, 0,  0, 0, 0, 0,   1, 2, 0, 0}, {4, 1, 2, 3, 8, 0, 6, 7, 5, 9, 10, 11}, {1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0},  },
                    {  {0, 2, 6, 3,   0, 0, 0, 0,   4, 1, 5, 7}, {0, 2, 1, 0,  0, 0, 0, 0,   0, 1, 2, 0}, {0, 6, 2, 3, 4, 1, 9, 7, 8, 5, 10, 11}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {0, 5, 1, 3,   0, 0, 0, 0,   4, 6, 2, 7}, {0, 2, 1, 0,  0, 0, 0, 0,   0, 1, 2, 0}, {0, 5, 2, 3, 4, 9, 1, 7, 8, 6, 10, 11}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {4, 1, 2, 0,   0, 0, 0, 0,   7, 5, 6, 3}, {1, 0, 0, 2,  0, 0, 0, 0,   2, 0, 0, 1}, {0, 1, 2, 4, 11, 5, 6, 3, 8, 9, 10, 7}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                    {  {3, 1, 2, 7,   0, 0, 0, 0,   0, 5, 6, 4}, {1, 0, 0, 2,  0, 0, 0, 0,   2, 0, 0, 1}, {0, 1, 2, 7, 3, 5, 6, 11, 8, 9, 10, 4}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},  },
                };

        int observation[4][3][4] = {
                { {7, 1, 6, 4}, {0, 0, 0, 0}, {0, 5, 3, 2} },
                { {0, 2, 1, 0}, {0, 0, 0, 0}, {1, 2, 0, 0} },
                { {3, 6, 1, 11}, {7, 0, 9, 4}, {5, 10, 2, 8} },
                { {0, 0, 0, 0,}, {0, 0, 0, 0}, {0, 0, 0, 0} },
            };
        int reward, terminal;
        
        CUBE();
        
        void reset(int rotations);
        void step(int input); // input is a move's number (1-12)
        void move(int input);
        int check_solved();
        void state_to_observation();
        void observation_to_state();
};

CUBE::CUBE(){
    for(int i=0; i<12; i++){
        this->cp[i] = s_cp[i];
        this->cd[i] = s_cd[i];
        this->ep[i] = s_ep[i];
        this->ed[i] = s_ed[i];
    }
    //state_to_observation();
    observation_to_state();
}

void CUBE::reset(int rotations=20){
    for(int i=0; i<12; i++){
        this->cp[i] = s_cp[i];
        this->cd[i] = s_cd[i];
        this->ep[i] = s_ep[i];
        this->ed[i] = s_ed[i];
    }
    for(int i=0; i<rotations; i++){
        int rng = rand() % 12;
        printf("rng=%d\n", rng);
        step(rng);
    }
    state_to_observation();
}

void CUBE::step(int input){
    move(input);
    check_solved();
}

void CUBE::move(int input){

    int n_cp[12]={0}, n_cd[12]={0}, n_ep[12], n_ed[12];
    int cp8[8], cd8[8], n_cp8[8], n_cd8[8];
    int move8[2][8];
    

    for(int i=0; i<8; i++){
        if(i < 4){
            cp8[i] = cp[i];
            cd8[i] = cd[i];
            move8[0][i] = moves[input][0][i];
            move8[1][i] = moves[input][1][i];
        }else{
            cp8[i] = cp[i+4];
            cd8[i] = cd[i+4];
            move8[0][i] = moves[input][0][i+4];
            move8[1][i] = moves[input][1][i+4];
        }
    }
    
  
    for(int i=0; i<8; i++){
        n_cp8[i] = cp8[move8[0][i]];
        n_cd8[i] = ( cd8[move8[0][i]] + move8[1][i] ) % 3;
    }


    for(int i=0; i<8; i++){
        if(i < 4){
            n_cp[i] = n_cp8[i];
            n_cd[i] = n_cd8[i];
        }else{
            n_cp[i+4] = n_cp8[i];
            n_cd[i+4] = n_cd8[i];
        }
    }

    for(int i=0; i<12; i++){
        n_ep[i] = ep[moves[input][2][i]];
        n_ed[i] = ( ed[moves[input][2][i]] + moves[input][3][i] ) % 2;
    }

    for(int i=0; i<12; i++){
        cp[i] = n_cp[i];
        cd[i] = n_cd[i];
        ep[i] = n_ep[i];
        ed[i] = n_ed[i];
    }
   
    state_to_observation();
}


int CUBE::check_solved(){
    for(int i=0; i<12; i++){
        if(cp[i] == s_cp[i] && cd[i] == s_cd[i] && ep[i] == s_ep[i] && ed[i] == s_ed[i])
            continue;
        else{
            reward = 0;
            terminal = false;
            return 0;
        }
    }
    reward = 1;
    terminal = true;
    return 0;
}

void CUBE::state_to_observation(){
    for(int i=0; i<4; i++){
        observation[0][0][i] = cp[i];
        observation[0][1][i] = cp[i+4];
        observation[0][2][i] = cp[i+8];
        observation[1][0][i] = cd[i];
        observation[1][1][i] = cd[i+4];
        observation[1][2][i] = cd[i+8];
        observation[2][0][i] = ep[i];
        observation[2][1][i] = ep[i+4];
        observation[2][2][i] = ep[i+8];
        observation[3][0][i] = ed[i];
        observation[3][1][i] = ed[i+4];
        observation[3][2][i] = ed[i+8];
    }
}

void CUBE::observation_to_state(){
    for(int i=0; i<4; i++){
        cp[i]   = observation[0][0][i];
        cp[i+4] = observation[0][1][i];
        cp[i+8] = observation[0][2][i];
        cd[i]   = observation[1][0][i];
        cd[i+4] = observation[1][1][i];
        cd[i+8] = observation[1][2][i];
        ep[i]   = observation[2][0][i];
        ep[i+4] = observation[2][1][i];
        ep[i+8] = observation[2][2][i];
        ed[i]   = observation[3][0][i];
        ed[i+4] = observation[3][1][i];
        ed[i+8] = observation[3][2][i];
    }
}

#endif