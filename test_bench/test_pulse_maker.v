// Name: test_pulse_maker
// Description:
// Author: Joe Shang

`timescale 1ns / 1ns

module test_pulse_maker;

	reg clock;
	reg reset;
	reg i_pulse;
	
	wire o_pulse;

	`define clock_period 2

	pulse_maker test_module(.reset(reset),
							.clock(clock),
							.i_pulse(i_pulse),
							.o_pulse(o_pulse));

	initial
	begin
	
		$dumpfile("test_pulse_maker.vcd");
		$dumpvars(0, test_pulse_maker);

		clock = 1;
		reset = 0;
		i_pulse = 0;

		$display("Test pulse maker module\n");
		#(`clock_period * 4)

		$display($time, " Start to run");
		reset = 1;
		#(`clock_period * 4)

		$display($time, " Input event available");
		i_pulse = 1;
		#(`clock_period * 40)

		$display($time, " Input event dismiss");
		i_pulse = 0;
		#(`clock_period * 10)

		$display($time, " Input event come again");
		i_pulse = 1;
		#(`clock_period * 10)

		$finish;
	end

	always #1
		clock = ~clock;

endmodule
