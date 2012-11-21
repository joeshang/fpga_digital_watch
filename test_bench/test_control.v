// Name: test_control
// Description:
// Author: Joe Shang

`timescale 1ns / 1ns

module test_control;

	reg reset;
	reg clock;
	reg set;
	reg alerm;
	reg alerm_switch;
	reg minute_set;
	reg hour_set;
	
	wire [17:0] time_data;
	wire alerm_equal;	

	`define clock_period 2
	`define second_period 4

	control test_module(.reset(reset),
					  	.clock(clock),
					  	.set(set),
					  	.alerm(alerm),
					  	.alerm_switch(alerm_switch),
					  	.minute_set(minute_set),
					  	.hour_set(hour_set),
					  	.time_data(time_data),
					  	.alerm_equal(alerm_equal));
	defparam test_module.second_cnt = `second_period;

	initial
	begin

		$dumpfile("test_control.vcd");
		$dumpvars(0, test_control);

		//$monitor("  %d:%d:%d -> %d", time_data[23:16], time_data[15:8], time_data[7:0], alerm_equal);

		reset = 0;
		clock = 1;
		set = 0;
		alerm = 0;
		alerm_switch = 1;
		minute_set = 0;
		hour_set = 0;

		$display("Test control module\n");
		#(`clock_period * 4)

		reset = 1;
		$display("Start to run, at Timer mode");
		#(`clock_period * `second_period * 60 * 5)

		set = 1;
		$display("Enter into Set mode");
		#(`clock_period * `second_period * 10)

		minute_set = 1;
		hour_set = 0;
		$display("External minute set signal valid");
		#(`clock_period * 70)

		minute_set = 0;
		hour_set = 1;
		$display("External hour set signal valid");
		#(`clock_period * 30)

		alerm = 1;
		hour_set = 0;
		$display("Want to enter Alerm mode");
		#(`clock_period * `second_period * 10)

		set = 0;
		$display("Enter into Alerm mode");
		#(`clock_period * `second_period * 10)

		minute_set = 1;
		hour_set = 0;
		$display("External minute set signal valid, make alerm one minute early than timer");
		#(`clock_period * 76)

		minute_set = 0;
		hour_set = 1;
		$display("External hour set signal valid");
		#(`clock_period * 30)

		alerm = 0;
		hour_set = 0;
		$display("Return to timer mode and wait for alerm(alerm 60s then dismiss)");
		#(`clock_period * `second_period * 60 * 3)

		alerm = 1;
		minute_set = 1;
		hour_set = 0;
		$display("Set alerm time one minute early than timer again.");
		#(`clock_period * 63)

		alerm = 0;
		$display("Return to timer mode and wait for alerm");
		#(`clock_period * `second_period * 60 * 1)

		alerm_switch = 0;
		$display("Close alerm switch");
		#(`clock_period * 60)
		
		alerm = 1;
		minute_set = 1;
		hour_set = 0;
		$display("Set alerm time one minute early than timer again.");
		#(`clock_period * 62)

		alerm = 0;
		$display("Return to timer mode and wait for alerm");
		#(`clock_period * `second_period * 60 * 1)

		alerm_switch = 1;
		$display("Close alerm switch");
		#(`clock_period * 60)

		$finish;
	end

	always #1
		clock = ~clock;

endmodule
