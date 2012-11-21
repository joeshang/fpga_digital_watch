// Name: pulse_inc_cnt
// Description: pulse_inc_cnt is a kind of counter which can increasement the
//				data when a pulse signal active. When it match its maximum, it
//				return to start value.
// Author: Joe Shang

module pulse_inc_cnt(reset, clock, pulse, data);

	input reset;
	input clock;
	input pulse;
	output [data_width-1:0] data;

	reg [data_width-1:0] data;

	parameter data_width = 6;	// the width of output data
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
				if (data + inc_step > max_cnt) 
					data <= 0;
				// no carry, register only increase 1
				else
					data <= data + inc_step;
			end
			// normal mode, just like a normal register
			else
				data <= data;
		end
	end

endmodule
