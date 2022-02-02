# Bird_Extended

Bird extended is a modified version of Bird which uses 16 bits for address width instead of 12 bits. With that, maximum addressable memory size goes to 64K. \
These document contains the changes made to regular Bird in order to make desired changes.

## Instructions

    Instructions need to change are te JMP,JZ and CALL since these instruction uses the addresses. Since the new address size is 16 and instruction is also 16 bits there are no space for opcode. As a solution we inspire from the LDI operation and we divide the code by two just like in the LDI.

## FSM


## Microcode



## Main Circuit


## Program Counter


## Assembler