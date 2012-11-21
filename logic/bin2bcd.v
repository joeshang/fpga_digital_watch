// Name: bin2bcd
// Description: convert a 6-bit binary number to 2 BCD digits.
// Author: Joe Shang

//module bin2bcd(clock, binary, high_bcd, low_bcd);
module bin2bcd(clock, binary, high_bcd, low_bcd);

	input clock;
	input [5:0] binary;
	output [3:0] high_bcd;
	output [3:0] low_bcd;

	reg [3:0] high_bcd;
	reg [3:0] low_bcd;
	reg [7:0] bcd;
	integer i;

	function [3:0] correct;
	input [3:0] decade;
	begin
		correct = (decade >= 5) ? (decade + 3) : (decade);
	end
	endfunction

	always @(posedge clock)
	begin
		high_bcd = 4'd0;
		low_bcd = 4'd0;

		for (i=0; i<6; i=i+1)
		begin
			high_bcd = correct(high_bcd);
			low_bcd = correct(low_bcd);
			bcd = {high_bcd, low_bcd};
			bcd = bcd << 1;
			bcd[0] = binary[5-i];
			high_bcd = bcd[7:4];
			low_bcd = bcd[3:0];
		end
	end

endmodule
