// Name: test_bus_sel
// Description: Test brench for bus_sel. Set sel signal 0->1->0->1 and
//				check the output data.
// Author: Joe Shang

`timescale 1ns / 1ns

module test_bus_sel;

	reg sel;
	reg [23:0] timer_data;
	reg [23:0] alerm_data;

	wire [23:0] output_data;

	bus_sel selector(.sel(sel),
				   	.timer_data(timer_data),
				   	.alerm_data(alerm_data),
				   	.output_data(output_data));
	
	initial
	begin

		$dumpfile("test_bus_sel.vcd");
		$dumpvars(0, test_bus_sel);

		$monitor($time, " [%x] [%x] -> %x", timer_data, alerm_data, output_data);

		$display("Bus selector Test\n");

		timer_data = 1;
		alerm_data = 0;
		sel = 0;

		$display($time, "Select: Alerm Register");

		#10
			sel = 1;
			$display($time, "Select: Timer/Set Register");
		#10
			sel = 0;
			$display($time, "Select: Alerm Register");
		#10
			sel = 1;
			$display($time, "Select: Timer/Set Register");
		#10
			$finish;
	end

endmodule
