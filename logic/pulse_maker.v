// Name: pulse_maker
// Description: This module will synchronize the input asychronized signal 
//				and generate a pulse which period is one-clock width. 
// Author: Joe Shang

module pulse_maker(reset, clock, i_pulse, o_pulse);

	input reset;
	input clock;
	input i_pulse;
	output o_pulse;

	reg o_pulse;
	reg [1:0] syn_reg;

	reg [1:0] current_state;
	reg [1:0] next_state;

	parameter sleep_state = 0;
	parameter pulse_state = 1;
	parameter finish_state = 2;

	always @(posedge clock or negedge reset)
	begin
		syn_reg[0] <= i_pulse;
		syn_reg[1] <= syn_reg[0];

		if (!reset)
			current_state <= sleep_state;
		else
			current_state <= next_state;
	end

	always @(current_state or syn_reg)
	begin
		case (current_state)
			sleep_state:	
				if (syn_reg[1])
					next_state <= pulse_state;
				else
					next_state <= sleep_state;
			pulse_state:	
				next_state <= finish_state;
			finish_state:
				if (syn_reg[1])
					next_state <= finish_state;
				else
					next_state <= sleep_state;
			default:
				next_state <= 2'bxx;
		endcase
	end

	always @(posedge clock or negedge reset)
	begin
		case (current_state)
			sleep_state:	o_pulse <= 1'b0;
			pulse_state:	o_pulse <= 1'b1;	
			finish_state:	o_pulse <= 1'b0;
			default:		o_pulse <= 1'bx;
		endcase
	end

endmodule
