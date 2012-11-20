fpga_digital_watch
==================
A small FPGA project which implement a digital watch. This is my first FPGA project, i do it just for practise verilog language and some basic design methods of FPGA.

There are 3 guidelines in my project:
1. Well designed.
Separating the logic part and driver part, every module should observe SRP and do simple thing. Implementing more complex module by compositon. Making every module general as far as possible.
2. Sufficiently tested.
Every module should have a related test bench. Maybe a little boring and "waste time" at first, but it will be extremly useful in the integration stage.
3. Use FSM as far as possible.
Don't be afraid that FSM is overused, because the worst thing is we could not use FSM. Practice makes perfect!

PS. Writing english is harder than writing code for me because of my poor english. :P
