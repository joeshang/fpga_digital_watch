// Name: test_alerm_comp
// Description:
// Author: Joe Shang

`timescale 1ns / 1ns

module test_alerm_comp;

	reg reset;
	reg clock;
	reg [23:0] timer_data;
	reg [23:0] alerm_data;
	reg alerm_enable;
	
	wire alerm_output;

	`define clock_period 2	
	`define second_period 4

	alerm_comp test_module(.reset(reset),
						   .clock(clock),
						   .timer_data(timer_data),
						   .alerm_data(alerm_data),
						   .alerm_enable(alerm_enable),
						   .alerm_output(alerm_output));
	defparam test_module.second_cnt = `second_period;

	initial
	begin

		$dumpfile("test_alerm_comp.vcd");
		$dumpvars(2, test_alerm_comp);

		$monitor($time, " timer:%d alerm:%d enable:%d output:%d",
				timer_data, alerm_data, alerm_enable, alerm_output);

		reset = 0;
		clock = 1;
		timer_data = 0;
		alerm_data = 1;
		alerm_enable = 0;

		$display("Test Alerm Comparation Module\n");
		#(`clock_period * `second_period * 4)

		$display($time, " Start to run, alerm switch is disable.");
		reset = 1;
		#(`clock_period * `second_period * 4)
		
		$display($time, " Alerm switch is enable, but data is not equal.");
		alerm_enable = 1;
		#(`clock_period * `second_period * 4)

		$display($time, " Data is equal now, check output time.");
		timer_data = 1;
		#(`clock_period * `second_period)
		$display($time, " Data equal event only last 1 second");
		timer_data = 0;
		#(`clock_period * `second_period * 70)

		$display($time, " Delay 10 second to check no equal conditon after equal");
		#(`clock_period * `second_period * 10)

		$display($time, " Data is equal again.");
		timer_data = 1;
		#(`clock_period * `second_period * 10)

		$display($time, " Disable alerm switch when data is equal");
		alerm_enable = 0;
		#(`clock_period * `second_period)

		$display($time, " Enable alerm switch in quick when data is equal");
		alerm_enable = 1;
		#(`clock_period * `second_period)

		$display($time, " Delay 50 seconds.");
		#(`clock_period * `second_period * 50)

		$finish;

	end

	always #1
		clock <= ~clock;

endmodule
