module FISH_CALIB(
	input wire clk,
//	input wire reset,
	input wire case1,	
	input wire case2,
	input wire case3,
	
	output reg [3:0]fish_cal	
	);
	
parameter[3:0] five = 4'd5;
parameter[3:0] ten = 4'd10;
parameter[3:0] f_teen = 4'd15;

always @ (posedge clk)
	begin
		if (case1 == 1)
			fish_cal = five;
		else
			begin
			if (case2 == 1)
				fish_cal = ten;
			else
				begin
				if (case3 == 1)
					fish_cal = f_teen;
				else
					fish_cal = five;
				end
			end
	end
endmodule