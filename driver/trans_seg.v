// Name: trans_seg
// Description: Translate the bcd data to seg input data format.
// Author: Joe Shang

module trans_seg(bcd_data, blank, common_anode, seg_data);

	input blank;
	input common_anode;
	input [3:0] bcd_data;
	output [6:0] seg_data;
	
	reg [6:0] seg_data;

	always @(bcd_data or blank or common_anode)
	begin
		seg_data = 7'b000_0000;
		case (bcd_data)
			0:	seg_data = 7'b111_1110;
			1:	seg_data = 7'b011_0000;
			2:	seg_data = 7'b110_1101;
			3:	seg_data = 7'b111_1001;
			4:	seg_data = 7'b011_0011;
			5:	seg_data = 7'b101_1011;
			6:	seg_data = 7'b001_1111;
			7:	seg_data = 7'b111_0000;
			8:	seg_data = 7'b111_1111;
			9:	seg_data = 7'b111_0011;
		endcase

		if (blank == 1'b1)
			seg_data = 7'b000_0000;
		if (common_anode == 1'b1)
			seg_data = ~seg_data;
	end

endmodule
