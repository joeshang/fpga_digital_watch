// Name: test_bin2bcd
// Description:
// Author: Joe Shang

module test_bin2bcd;
	
	reg clock;
	reg [5:0] binary;
	
	wire [3:0] high_bcd;
	wire [3:0] low_bcd;

	integer i;

	bin2bcd test_module(.clock(clock),
						.binary(binary),
						.high_bcd(high_bcd),
						.low_bcd(low_bcd));

	initial
	begin
		
		$dumpfile("test_bin2bcd.vcd");
		$dumpvars(0, test_bin2bcd);

		$monitor($time, "  binary:%d  bcd:%d%d", binary, high_bcd, low_bcd);

		clock = 1;

		for (i=0; i<64; i=i+1)
		begin
			#2 binary = i;
		end

		#1 $finish;
	end

	always #1
		clock = ~clock;

endmodule
