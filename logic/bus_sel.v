// Name: bus_sel
// Description: A bus selector for Timer/Set and Alerm register data output.
//				1 -> Timer/Set register data, 0 -> Alerm register data.
// Author: Joe Shang

module bus_sel(sel, timer_data, alerm_data, output_data);

	input sel;
	input [data_width:0] timer_data;
	input [data_width:0] alerm_data;
	output [data_width:0] output_data;

	reg [data_width:0] output_data;

	parameter data_width = 23;

	always @(*)
	begin
		if (sel) // sel = 1, output Timer/Set register data
			output_data = timer_data;
		else // sel = 0, output Alerm register data
			output_data = alerm_data;
	end

endmodule
