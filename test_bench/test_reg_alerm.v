// Name: test_reg_alerm
// Description: Mainly test 2 point. No minute_set & hour_set signal, reg_alrem
//				perform as normal register and when minute_set/hour_set valid,
//				it increase.
// Author: Joe Shang

`timescale 1ns / 1ns

module test_reg_alerm;

	// define input signal of test module
	reg reset;
	reg clock;
	reg minute_set;
	reg hour_set;

	// define output result of test module
	wire [7:0] second_data;
	wire [7:0] minute_data;
	wire [7:0] hour_data;

	reg_alerm alerm_data(.reset(reset),
						 .clock(clock),
						 .minute_set(minute_set),
						 .hour_set(hour_set),
						 .second_data(second_data),
						 .minute_data(minute_data),
						 .hour_data(hour_data));

	`define clock_period	2
	`define minute_period	59
	`define hour_period		23

	initial
	begin
		
		// generate information for gtkwave
		$dumpfile("test_reg_alerm.vcd");
		$dumpvars(2, test_reg_alerm);

		$monitor($time, " time->%d:%d:%d", hour_data, minute_data, second_data);

		// initial input signal
		reset = 0;
		clock = 0;
		minute_set = 0;
		hour_set = 0;

		$display($time, "Alerm Register Test\n");

		#(`clock_period * 5)
			reset = 1;
			$display($time, " Active at normal register mode");
			$display($time, " time->%d:%d:%d", hour_data, minute_data, second_data);
		#(`clock_period * 20)
			$display($time, " time->%d:%d:%d", hour_data, minute_data, second_data);
			minute_set = 1;
			$display($time, " Set minute signal active");
		#(`clock_period * `minute_period * 2 + 5)
			minute_set = 0;	
			hour_set = 1;
			$display($time, " Set hour signal active");
		#(`clock_period * `hour_period * 2 + 5)
			hour_set = 0;
			$display($time, " Disable minute set signal and hour set signal");
		#(`clock_period * 20)
			$display($time, " time->%d:%d:%d", hour_data, minute_data, second_data);
			$finish;
	end

	// generate a clock signal with 1 period
	always #1
		clock = ~clock;

endmodule
