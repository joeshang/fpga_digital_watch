// Name: pulse_inc_cnt
// Description: pulse_inc_cnt is a kind of counter which can increasement the
//				data when a pulse signal active. When it match its maximum, it
//				generate a carry signal and return to start value.
// Author: Joe Shang

module pulse_inc_cnt(reset, clock, pulse, data, carry);

	input reset;
	input clock;
	input pulse;
	output carry;
	output [data_width:0] data;

	reg carry;
	reg [data_width:0] data;

	parameter data_width = 7;	// the width of output data
	parameter max_cnt = 59;		// the max counter of increasement
	parameter inc_step = 1;		// the step of increasement

	always @(posedge clock or negedge reset)
	begin
		if (!reset)
			data <= 0;
		else
		begin
			// pulse mode, register increase 1 and handle carry
			if (pulse)
			begin
				// carry must be 1 clock early than data
				if (data + inc_step == max_cnt) 
				begin
					data <= data + 1'b1;
					carry <= 1'b1;
				end
				// touch the max counter, data return to start value
				else if (data + inc_step > max_cnt) 
				begin
					data <= 0;
					carry <= 0;
				end
				// no carry, register only increase 1
				else
				begin
					data <= data + 1'b1;
					carry <= 0;
				end
			end
			// normal mode, just like a normal register
			else
			begin
				data <= data;
				carry <= 0;	
			end
		end
	end

endmodule
