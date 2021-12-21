#include "stdint.h"
uint16_t reg[8];
uint16_t mem[256];
uint8_t idx = 0;

#define REG_0 reg[0]
#define REG_1 reg[1]
#define REG_2 reg[2]
#define REG_3 reg[3]
#define REG_4 reg[4]
#define REG_5 reg[5]
#define REG_6 reg[6]
#define REG_7 reg[7]

#define sum     0
#define pin_1	0xFFF0
#define pin_2	0xFFF2
#define pb_1	0xFFF1
#define pb_2	0xFFF3
#define s_seg	0xFFF4
#define one	    1
#define zero	0
#define two     2

int main(){

    return 0;
}

void mult()
{
    REG_6 = 0;
    while (1)
    {
        if(REG_4 == 0){
            return;
        }
        REG_6 += REG_5;
        REG_4 -= 1;
    }
}

void div()
{
    REG_6 = 0
    lessthan()
    
}

void hextodec()
{
    REG_6 = 0;
    REG_5 = 0;
    REG_4 = 0xF;
    REG_5 = REG_4 & REG_0; //REG_5 = 0000 0000 0000 xxxx
    if (REG_5 == 0){
        break;
    }
    REG_3 = REG_2 - 10;
    if(REG_3 == 0){
        REG_0 -= 10;
        REG_6++;
    }
    REG_5--;
    REG_2++;

}

void pb_1pressed(){

}

void pb_2pressed(){
    
}

void lessthan()
{
    push(REG_4);
    push(REG_5);
    while(1){
        if(REG_5 == 0){
            REG_6 = 1
            break;
        }
        if (REG_4 == 0){
            REG_6 = 0
            break;
        }
        REG_5--;
        REG_6--;
    }
    pop(REG_5);
    pop(REG_4);
    

    return
}

void push(uint8_t reg)
{
    mem[idx++] = reg;
}

void pop(uint8_t reg)
{
    reg = mem[idx--];
}