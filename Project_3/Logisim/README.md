## Input Selection
For getting input we assigned addresses with looking into last two bits if all other bits are 1.
If these:
00 we select Switch 1 \
01 Switch 2\
10 Push button\
11 Data from timer

These makes our addresses for components:
Switch 1:       0xFFC\
Swtich 2:       0xFFD\
Push Button:    0xFFE\
Timer Data:     0xFFF\
Note: If you have not loading for your stack pointer you may need to change these addresses beacuse of it will overlap.\

## Output Selection
For output, we have gone with the similar logic with the input selection. In order to prevent an overlap with the input selection Address[9] needs to be zero and this gives us chance on selecting the bit on the last bit Address[11].
Thus our address table for outputs are:\
Seven segment for timer:    0xFFA\
Seven segment for result:   0xFFB\




