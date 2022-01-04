
# Polling

As lectured polling is a method to load external data into CPU. In order to do that we assign some memory addresses into memory. When CPU tries to read data from these addresses we the external data instead of the data from memory. In real world implementation of this system is easy but inefficient.

# Input Selection

In order to trigger the input mechanism, CS is needs to be one. CS is determined by the Address from the CPU. In our case if Address[4:15] is all ones and Address[2:3] is zeroes CS bit is triggered. \
In our implementation Address[1](will be referred as a[1]) is to determine the input device set. If a[1] is one than we will get input from Pin_2 or PB_2, if a[1] is zero than from Pin_1 or PB_1. This is set by a multiplexer which goes to data selection mux controlled via CS \
a[0] is determines that we will get input from Pin or Push Button. If a[1] is 1, we get data from PB, if 0 we get data from Pin.

Thus our memory addresses for peripherals are: \
Pin_1:  0xFFF0 \
PB_1:   0xFFF1 \
Pin_2:  0xFFF2 \
PB_2:   0xFFF3

# Display
In order to display data in 4-digit 7-segment display. 7_SEG_LD bit needs to be one so we can load data to 16-bit register. \
Selected address for 7-segment display is 0xFFF4. When address out from CPU matches the this address circuit loads the data output to register and it is displayed. \
Connection of the 7-segment drivers seems weird. It is a shortcut for preventing cable mess. Check (7-segment driver page link) in order to understand the schematics.

# Functions

## Less Than

Less than function determines the is reg_4 is less than reg_5 or not. If it is it makes reg_6 one. If not makes zero.


## Multiplication

Multiplication is an series of adding number x to z y times. so we get z = x*y. In our case z is reg_6 and x and y are reg_4 and reg_5 respectively. \
In this code there is a little optimization: Because of we decrease reg_5 every time our codes runs reg_5 times. If reg_4 is less than reg_5 we swap them in order to run the code with the minimum iteration.\

## Division

As we learned in elementary school division is substracting one number from another until we can't substract anymore. Result is the count of the substraction.\
The remainder is the number in dividend after all substraction. The quotient is the count of substraction.\
We implemented this approach in assembly.

As a dividend we used reg_4 and for the divider, reg_5. Quotient(result) will be wrote to reg_6.\
First we checked if the reg_4 is less than reg_5. If it is we exit from the function.
If reg_4 is equal or greater than reg_5 than we substract reg_5 from reg_4 and we increase the reg_6 by one.\
After that we go back to start and compare reg_4 and reg_5 again. This goes until reg_4 is less than reg_5. Then the number in reg_4 is the remainder.

In example: \
reg_4 = 7 \
reg_5 = 3 \
Initially we reset reg_6 by loading 0 in it. \
We comapre 7 and 3. Because 7 is greater than 3 we continiue. \
We substract 3 from 7 and increase reg_6 by one. Now reg_6 = 1 and reg_4 is 4. \
We compare 4 and 3 and do the same thing. \
Now reg_4 is 1 and reg_6 is 2. We compare 1 and 3. Because of 1 is less than 3 we end the function. \
Our result is 2 and remainder is 1.

## Hex to BCD

BCD is a method to display decimal values in this binary world. In example the number 0x3A which is 58 in decimal is represented by 0x58. With this we don't need to any hardware modification in order to represnt numbers in decimal format.

In order to converting hexadecimal numbers BCD format we simply making some divisions and multiplications.\
Because of we have four digits we start dividing the hexadecimal number by 1000. We save the result by pushing into stack.\
Now we dividing the remainder of the previous process with the 100. Luckily we don't need to change reg_4 because it already contains the remainder. We write 100 into reg_5 and make division and push the result.\
Now we do the same thing with the 10.\
Because of we don't need to divide anything with one we push the remainder of division with 10.\

Now in our stack we have decimal digits in reverse pop order. \
We pop data from stack into register_4 and add this into reg_1. There is no need to multiplication for this one because we need to multiply this with one.\
So we pop data again to reg_4 and we multiply it with the 0x10. This will write the 2nd decimal digit into 2nd 4 bits of the data. \
We do the same thing for 0x100 and 0x1000.

In example we have the number 0x4d8 which is 1234 in decimal. 
First we divide it with the 1000 which is 0x3e8. We get 1 for result and we push it into stack.\
Now we divide the remainder with 100 which is 0x64 and we push the result into stack.\
After operations we have 1 2 3 4 in stack.\

Now we pop from stack and we get 4. We add this into reg_1. \
After that we get 3 and we multiply it with 0x10 and add to reg_1.\
After completing this we get 0x1234.

