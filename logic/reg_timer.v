// Name: reg_timer
// Description: A specific data register which store time data for Timer/Set mode. 
//				At Timer mode, register is driven by a one-minute pulse signal to
//				generate digital watch time data. At Set mode, register response 
//				to the minute/set signal from external.
// Author: Joe Shang

module reg_timer(reset, clock, state,
				 one_second, minute_set, hour_set,
	   			 second_data, minute_data, hour_data);

	input reset;
	input clock;
	input state;
	input one_second;
	input minute_set;
	input hour_set;
	output [7:0] second_data;
	output [7:0] minute_data;
	output [7:0] hour_data;

	wire second_pulse;
	wire minute_pulse;
	wire hour_pulse;

	wire second_carry;
	wire minute_carry;
	wire hour_carry;

	wire second_data;
	wire minute_data;
	wire hour_data;

	// state: 0 -> Set Mode
	//		  1 -> Timer Mode
	assign second_pulse = state ? one_second : 0;
	assign minute_pulse = state ? second_carry : minute_set;
	assign hour_pulse	= state ? minute_carry : hour_set;	
	
	pulse_inc_cnt second(.reset(reset),
						 .clock(clock),
						 .pulse(second_pulse), 
						 .data(second_data),
						 .carry(second_carry));

	pulse_inc_cnt minute(.reset(reset),
						 .clock(clock),
						 .pulse(minute_pulse), 
						 .data(minute_data),
						 .carry(minute_carry));

	pulse_inc_cnt 	hour(.reset(reset),
						 .clock(clock),
						 .pulse(hour_pulse), 
						 .data(hour_data),
						 .carry(hour_carry));
	defparam hour.max_cnt = 23;

endmodule
