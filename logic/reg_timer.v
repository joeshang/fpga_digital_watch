// Name: reg_timer
// Description: A specific data register which store time data for Timer/Set mode. 
//				At Timer mode, register is driven by a one-minute pulse signal to
//				generate digital watch time data. At Set mode, register response 
//				to the minute/set signal from external.
// Author: Joe Shang

module reg_timer(reset, clock, mode,
				 minute_set, hour_set,
	   			 second_data, minute_data, hour_data);

	input reset;
	input clock;
	input mode;
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

	wire second_data;
	wire minute_data;
	wire hour_data;

	reg one_second_pulse;
	reg [25:0] counter;

	parameter second_cnt = 52428800;

	// Generate one second pulse
	always @(posedge clock or negedge reset)
	begin
		if (!reset)
			counter <= 0;
		else
			if (counter + 1 < second_cnt)
			begin
				counter <= counter + 1;
				one_second_pulse <= 0;
			end
			else
			begin
				counter <= 0;
				one_second_pulse <= 1;
			end
	end

	assign second_carry = (second_data == 59) ? 1 : 0;
	assign minute_carry = (minute_data == 59) ? 1 : 0;

	// mode: 0 -> Set Mode, 1 -> Timer Mode. 
	// At Timer Mode: minute pulse which decided by second carry must be 
	// synchronized with second pulse, hour pulse which decided by minute carry
	// must be synchronized with minute pulse.
	assign second_pulse = mode ? one_second_pulse : 0;
	assign minute_pulse = mode ? (second_pulse & second_carry) : minute_set;
	assign hour_pulse	= mode ? (minute_pulse & minute_carry) : hour_set;	
	
	pulse_inc_cnt second(.reset(reset),
						 .clock(clock),
						 .pulse(second_pulse), 
						 .data(second_data));

	pulse_inc_cnt minute(.reset(reset),
						 .clock(clock),
						 .pulse(minute_pulse), 
						 .data(minute_data));

	pulse_inc_cnt 	hour(.reset(reset),
						 .clock(clock),
						 .pulse(hour_pulse), 
						 .data(hour_data));
	defparam hour.max_cnt = 23;

endmodule
