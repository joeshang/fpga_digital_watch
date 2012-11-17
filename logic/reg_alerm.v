// Name: reg_alerm
// Description: A specific data register which store time data for Alerm mode.
//				It response to the minute/set signal from external.
// Author: Joe Shang

module reg_alerm(reset, clock, minute_set, hour_set, second_data, minute_data, hour_data);

	input reset;
	input clock;
	input minute_set;
	input hour_set;
	
	output [7:0] second_data;
	output [7:0] minute_data;
	output [7:0] hour_data;

	wire minute_carry;
	wire hour_carry;
	wire [7:0] second_data;

	assign second_data = 0;

	pulse_inc_cnt minute(.reset(reset),
						 .clock(clock),
						 .pulse(minute_set),
						 .data(minute_data),
						 .carry(minute_carry));

	pulse_inc_cnt hour(.reset(reset),
					   .clock(clock),
					   .pulse(hour_set),
					   .data(hour_data),
					   .carry(hour_carry));
	defparam hour.max_cnt = 23;

endmodule
