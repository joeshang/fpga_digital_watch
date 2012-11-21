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
	reg enable;
	reg one_second;
	reg [2:0] count;
	
	wire pulse;

	// define output result of test module
	wire [5:0] data;

	pulse_inc_cnt timer(.reset(reset),
						.clock(clock),
						.pulse(pulse), 
						.data(data)); 

	`define clock_period 2
	`define second_count 4

	initial
	begin
		// generate information for gtkwave which show signal's wave
		$dumpfile("test_pulse_inc_cnt.vcd");
		$dumpvars(0, test_pulse_inc_cnt);

		// set the value which we want to monitor
		$monitor($time," -> data:%d", data);

		// initial input signal 
		clock = 0;
		reset = 0;
		count = 0;
		enable = 0;

		// begin to run test brench
		$display("Timer Start!\n");
		
		#(`clock_period * `second_count * 4) reset = 1;
		#(`clock_period * `second_count * 4) enable = 1; // give pulse to test module -> test increasement function
		#(`clock_period * `second_count * 80) enable = 0; // close pulse -> test normal register function
		#(`clock_period * `second_count * 20) $display($time," -> data:%d", data);
		$finish;

	end

	assign pulse = enable & one_second;

	// generate a clock signal which period is 2
	always #1
		clock = ~clock;
	
	// simulate one second pulse signal
	always @(posedge clock)
	begin
		if (count + 1 < `second_count)
		begin
			count <= count + 1;	
			one_second <= 0;
		end
		else
		begin
			count <= 0;
			one_second <= 1;
		end
	end

endmodule
