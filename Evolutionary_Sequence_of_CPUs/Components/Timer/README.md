# Timer
Timer is a component that allows us to measure real time. In order to do that we need to know clock speed and we need to determine an interval. This interval could be 1ms or 1s it doesnt matter in our case we used 1s. Or we can develop a timer that takes interval as an input.

We store our clock speed in hz our clock count and an another counter. For each clock we increase clock counter by one when our clock counter is equal to clock speed in hz, we increase main counter by one. For output we use the same system with the keypad. Ready bit becomes one when timer changes then becomes zero when timer data has been read.

In logisim we used a simpler but similar logic. First counter counts the clock cycles when it hits the max value it triggers the other counter. This trigger makes TIMER_INT 1 for one clock cycle and updates timer data.

For future work, verilog implementation can take interval as input. Also logisim TIMER_INT signal needs to be active until timer data has been read in order to preserve the interrupt. 