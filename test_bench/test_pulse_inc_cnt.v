// Name: test_pulse_inc_reg
// Description: The TestBrench of pulse_inc_reg. Mainly test 2 aspect:
//				Normal Mode -> Whether it act as a normal register or not.
//				Increasement Mode -> Whether data and carry valid or not. 
// Author: Joe Shang

`timescale 1ns / 1ns
module test_pulse_inc_cnt;

	// define input signal of test module
	reg reset;
	reg clock;
	reg pulse;

	// define output result of test module
	wire [7:0] data;
	wire carry;

	pulse_inc_cnt timer(.reset(reset),
						.clock(clock),
						.pulse(pulse), 
						.data(data), 
						.carry(carry)); 

	`define clock_period 2

	initial
	begin
		// generate information for gtkwave which show signal's wave
		$dumpfile("test_pulse_inc_cnt.vcd");
		$dumpvars(0, test_pulse_inc_cnt);

		// set the value which we want to monitor
		$monitor($time," -> data:%d, carry:%d", data, carry);

		// initial input signal 
		clock = 0;
		reset = 0;
		pulse = 0;

		// begin to run test brench
		$display("Timer Start!\n");
		
		#(`clock_period * 5) reset = 1;
		#(`clock_period * 5) pulse = 1; // give pulse to test module -> test increasement function
		#(`clock_period * 80) pulse = 0; // close pulse -> test normal register function
		#(`clock_period * 20) $display($time," -> data:%d, carry:%d", data, carry);
		$finish;

	end

	// generate a clock signal which period is 2
	always #1
		clock = ~clock;

endmodule
