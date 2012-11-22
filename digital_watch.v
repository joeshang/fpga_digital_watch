// Name: digital_watch
// Description: The top module in digital watch project. It will synchonize
//				the external asychonized input, make clock stable by using PLL
//				and glue logic with driver.
// Interface:	SW[0] is the alerm toggle switch.
//				SW[16] is the alerm setting switch.
//				SW[17] is the time setting switch.
//				KEY[0] is the minute increasing key.
//				KEY[1] is the hour increasing key.
// Author: Joe Shang

module digital_watch(CLOCK_50, SW, KEY, LEDR, LEDG,
		HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	input CLOCK_50;
	input [1:0] KEY;
	input [17:0] SW;
	output [8:8] LEDG;
	output [17:17] LEDR;
	output [6:0] HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0; 

	wire reset;
	wire clock;
	wire minute_set;
	wire hour_set;
	wire [7:0] second_bcd;
	wire [7:0] minute_bcd;
	wire [7:0] hour_bcd;
	wire [17:0] logic_output;

	// Output AM/PM display signal.
	assign LEDG[8] = (logic_output[17:12] > 12) ? 1'b1 : 1'b0;

	// Make clock stable by using PLL.

	// Synchronize the external asychonized input.
	pulse_maker syn_minute_set(.reset(reset),
							   .clock(clock),
							   .i_pulse(KEY[0]),
							   .o_pulse(minute_set));
	pulse_maker   syn_hour_set(.reset(reset),
							   .clock(clock),
							   .i_pulse(KEY[1]),
							   .o_pulse(hour_set));

	// Logic part of digital watch.
	control logic_control(.reset(reset),
						  .clock(clock),
						  .set(SW[17]),
						  .alerm(SW[16]),
						  .alerm_switch(SW[0]),
						  .minute_set(minute_set),
						  .hour_set(hour_set),
						  .time_data(logic_output),
						  .alerm_equal(LEDR[17]));
	
	// Convert logic output data to bcd format.
	bin2bcd second_bin2bcd(.clock(clock),
						   .binary(logic_output[5:0]),
						   .high_bcd(second_bcd[7:4]),
						   .low_bcd(second_bcd[3:0]));
	bin2bcd minute_bin2bcd(.clock(clock),
						   .binary(logic_output[11:6]),
						   .high_bcd(minute_bcd[7:4]),
						   .low_bcd(minute_bcd[3:0]));
	bin2bcd   hour_bin2bcd(.clock(clock),
						   .binary(logic_output[17:12]),
						   .high_bcd(hour_bcd[7:4]),
						   .low_bcd(hour_bcd[3:0]));

	// Translate bcd to seg data format and output to related seg port.
	trans_seg seg_second_high(.bcd_data(second_bcd[7:4]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX1));
	trans_seg  seg_second_low(.bcd_data(second_bcd[3:0]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX0));
	trans_seg seg_minute_high(.bcd_data(minute_bcd[7:4]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX3));
	trans_seg  seg_minute_low(.bcd_data(minute_bcd[3:0]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX2));
	trans_seg   seg_hour_high(.bcd_data(hour_bcd[7:4]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX5));
	trans_seg    seg_hour_low(.bcd_data(hour_bcd[3:0]),
							  .blank(1'b0),
							  .common_anode(1'b0),
							  .seg_data(HEX4));

endmodule
