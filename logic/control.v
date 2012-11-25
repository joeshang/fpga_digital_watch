// Name: control
// Description: Handle all external set signal, switch digital watch's mode
//				and output related data in various mode.
// Author: Joe Shang

module control(reset, clock, set, alerm, alerm_switch, minute_set, hour_set,
			   time_data, alerm_equal, am_pm_div);

	input reset;
	input clock;
	input set;
	input alerm;
	input alerm_switch;
	input minute_set;
	input hour_set;
	output alerm_equal;
	output am_pm_div;
	output [time_width-1:0] time_data;

	reg [1:0] current_state;
	reg [1:0] next_state;

	reg output_sel;
	reg timer_mode;
	reg alerm_open;

	wire alerm_enable;
	wire alerm_minute_set;
	wire alerm_hour_set;
	wire timer_minute_set;
	wire timer_hour_set;

	wire [5:0] alerm_second;
	wire [5:0] alerm_minute;
	wire [5:0] alerm_hour;
	wire [5:0] timer_second;
	wire [5:0] timer_minute;
	wire [5:0] timer_hour;

	wire [time_width-1:0] alerm_output;
	wire [time_width-1:0] timer_output;

	parameter timer_state = 0;
	parameter set_state = 1;
	parameter alerm_state = 2;

	parameter time_width = 18;
	
	// FSM:Changing state.
	always @(posedge clock or negedge reset)
	begin
		if (!reset)
			current_state <= timer_state;
		else
			current_state <= next_state;
	end

	// FSM:Calculating next state by current state and input.
	always @(current_state or set or alerm)
	begin
		case (current_state)

		timer_state:
			if (!set && !alerm)
				next_state <= timer_state;
			else
			begin
				if (alerm)
					next_state <= alerm_state;
				if (set)
					next_state <= set_state;
			end

		set_state:
			if (set)
				next_state <= set_state;
			else
			begin
				if (alerm)
					next_state <= alerm_state;
				else
					next_state <= timer_state;
			end
		
		alerm_state:
			if (alerm)
				next_state <= alerm_state;
			else
			begin
				if (set)
					next_state <= set_state;
				else
					next_state <= timer_state;
			end	

		endcase
	end

	// FSM:Output control signal by current state.
	always @(posedge clock or negedge reset)
	begin
		if (!reset)
		begin
			output_sel <= 1'b1;
			timer_mode <= 1'b1;
			alerm_open <= 1'b1;
		end
		else
		begin
			case (current_state)
				
				timer_state:
				begin
					output_sel <= 1'b1;	// Output Timer/Set register data.
					timer_mode <= 1'b1;	// Timer/Set register perform at timer mode.
					alerm_open <= 1'b1;	// Alerm comparation open.
				end

				set_state:
				begin
					output_sel <= 1'b1;	// Output Timer/Set register data.
					timer_mode <= 1'b0;	// Timer/Set register perform at set mode. 
					alerm_open <= 1'b0;	// Alerm comparation close.
				end

				alerm_state:
				begin
					output_sel <= 1'b0;	// Output Alerm register data.
					timer_mode <= 1'b1;	// Timer/Set register perform at timer mode.
					alerm_open <= 1'b0;	// Alerm comparation close.
				end

			endcase
		end
	end

	// ---------------- Control Glue Logic ------------------
	// sel = 1, external set signal access in timer register.
	assign timer_minute_set = output_sel ? minute_set : 1'b0;
	assign timer_hour_set   = output_sel ? hour_set   : 1'b0;
	// sel = 0, external set signal access in alerm register.
	assign alerm_minute_set = output_sel ? 1'b0 : minute_set;
	assign alerm_hour_set	= output_sel ? 1'b0 : hour_set;

	// ---------------- Output Glue Logic ------------------
	// Two-in-One selector.
	// sel = 1, output timer data.
	// sel = 0, output alerm data.
	assign time_data = output_sel ? timer_output : alerm_output; 
	
	assign timer_output = {timer_hour, timer_minute, timer_second};
	assign alerm_output = {alerm_hour, alerm_minute, alerm_second};

	// Divide AM/PM.
	// AM, hour <= 12, output 0.
	// PM, hour > 12, output 1.
	assign am_pm_div = (timer_hour > 12) ? 1'b1 : 1'b0;

	// Alerm comparator.
	// alerm_open = 1, open alerm comparation.
	// alerm_open = 0, close alerm comparation.
	assign alerm_enable = alerm_open ? alerm_switch : 1'b0;

	reg_alerm alerm_data_reg(.reset(reset),
							 .clock(clock),
							 .minute_set(alerm_minute_set),
							 .hour_set(alerm_hour_set),
							 .second_data(alerm_second),
							 .minute_data(alerm_minute),
							 .hour_data(alerm_hour));

	reg_timer timer_data_reg(.reset(reset),
							 .clock(clock),
							 .mode(timer_mode),
							 .minute_set(timer_minute_set),
							 .hour_set(timer_hour_set),
							 .second_data(timer_second),
							 .minute_data(timer_minute),
							 .hour_data(timer_hour));

	alerm_comp  comp_module(.reset(reset),
		   					.clock(clock),	
							.timer_data(timer_output),
							.alerm_data(alerm_output),
							.alerm_enable(alerm_enable),
							.alerm_output(alerm_equal));

endmodule
