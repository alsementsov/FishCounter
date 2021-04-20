module MASS_CHOOSE(
	input wire clk,
//	input wire reset,
//	input wire enable,
	
	input wire [9:0]data,

	output reg out_choise_1,
	output reg out_choise_2,
	output reg out_choise_3
	);
	
parameter[9:0] d1 = 11'd240;
parameter[9:0] d2 = 11'd340;
parameter[9:0] d3 = 11'd400;
parameter[9:0] d4 = 11'd450;

always @ (posedge clk)
	begin
		if ((data >= d1) && (data <= d2))
				out_choise_1 = 1;
			else
				out_choise_1 = 0;
		if ((data > d2) && (data <= d3))
				out_choise_2 = 1;
			else
				out_choise_2 = 0;
		if ((data > d3) && (data <= d4))
				out_choise_3 = 1;
			else
				out_choise_3 = 0;
	end
endmodule