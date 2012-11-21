// Name: test_reg_timer
// Description: Test mode switching by this consequence: Timer -> Set(with no set signal)
//				-> Set(with set signal) ->Timer, and check the result whether valid or not.
// Author: Joe Shang

`timescale 1ns / 1ns

module test_reg_timer;

	// define input signal of test module
	reg reset;
	reg clock;
	reg mode;
	reg minute_set;
	reg hour_set;

	// define output result of test module
	wire [5:0] second_data;
	wire [5:0] minute_data;
	wire [5:0] hour_data;

	`define clock_period		2
	`define second_cnt_period	4
	`define minute_period		(60 * `second_cnt_period)
	`define hour_period			(24 * `second_cnt_period)

	reg_timer timer_data(.reset(reset), 
						 .clock(clock), 
						 .mode(mode),
						 .minute_set(minute_set),
						 .hour_set(hour_set),
						 .second_data(second_data), 
						 .minute_data(minute_data), 
						 .hour_data(hour_data));
	defparam timer_data.second_cnt = `second_cnt_period;

	initial
	begin
		// generate information for gtkwave
		$dumpfile("test_reg_timer.vcd");
		$dumpvars(0, test_reg_timer);

		$monitor($time, " time->%d:%d:%d", hour_data, minute_data, second_data);

		// initial input signal
		reset = 0;
		clock = 0;
		mode = 1;
		minute_set = 0;
		hour_set = 0;

		$display("Timer/Set Register Test\n");

		#(`clock_period * 5)
			reset = 1;
			$display($time, " Active at Timer mode");
		#(`clock_period * `minute_period * 4)
		   	mode = 0;
			$display($time, " Switch to Set mode");
		#(`clock_period * 20)
			$display($time, " time->%d:%d:%d", hour_data, minute_data, second_data);
			minute_set = 1;
			$display($time, " Set minute signal active");
		#(`clock_period * `minute_period)
			minute_set = 0;
			hour_set = 1;
			$display($time, " Set hour signal active");
		#(`clock_period * `hour_period)
			mode = 1;
			$display($time, " Back to Timer mode");
		#(`clock_period * `minute_period * 4)
			$finish;
	end

	// generate a clock signal with 2 period
	always #1
		clock <= ~clock;

endmodule
