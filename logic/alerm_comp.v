// Name: alerm_comp
// Description: Compare timer data with alerm data, if equal and alerm switch is enable,
//				module will output 1 lasting alerm_time. At output duration, disable
//				alerm switch, output 0.
// Author: Joe Shang

module alerm_comp(reset, clock, timer_data, alerm_data, alerm_enable, alerm_output);

	input reset;
	input clock;
	input [data_width-1:0] timer_data;
	input [data_width-1:0] alerm_data;
	input alerm_enable;
	output alerm_output;

	wire equal;
	wire equal_pulse;

	reg current_state;
	reg next_state;
	reg alerm_output;
	reg [counter_width-1:0] counter;
	reg [7:0] second;

	parameter sleep_state = 0;
	parameter alerm_state = 1;

	parameter data_width = 18;
	parameter alerm_time = 60;
	parameter second_cnt = 52428800;
	parameter counter_width = 26;

	always @(posedge clock or negedge reset)
	begin
		if (!reset)
			current_state <= sleep_state;
		else
			current_state <= next_state;
	end

	always @(current_state or alerm_enable or equal_pulse or second)
	begin
		case (current_state)
			sleep_state:
				if (alerm_enable && equal_pulse)
					next_state <= alerm_state;
				else
					next_state <= sleep_state;
			alerm_state:
				if (alerm_enable && (second < alerm_time))
					next_state <= alerm_state;
				else
					next_state <= sleep_state;
			default:
				next_state <= 1'bx;
		endcase	
	end

	always @(posedge clock or negedge reset)
	begin
		case (current_state)
			sleep_state:
			begin
				alerm_output <= 1'b0;
			end
			alerm_state:
				alerm_output <= 1'b1;
			default:
				alerm_output <= 1'bx;	
		endcase
	end

	// Calculate alerm output time in second format.
	always @(posedge clock or negedge reset)
	begin
		if (!reset)
		begin
			counter <= 0;
			second <= 0;
		end
		else
		begin
			if (counter + 1'b1 < second_cnt)
				counter <= counter + 1'b1;
			else
			begin
				counter <= 0;

				// Record alerm output time only in alerm state.
				if (current_state == alerm_state)
					second <= second + 1'b1;
				else
					second <= 0;
			end
		end
	end

	assign equal = (timer_data == alerm_data);

	// Make equal event to a equal pulse.
	pulse_maker pulse_gen(.reset(reset),
						  .clock(clock),
						  .i_pulse(equal),
						  .o_pulse(equal_pulse));

endmodule
