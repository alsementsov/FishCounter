module Min_corr(
	input wire clk,
	input wire EN,
	input wire reset,
	input wire [8:0]sum_corr,	
	input wire [9:0]dx,
	
	output reg [8:0]out_min,
	output reg [9:0]step,
	output reg [8:0]out_corr
	);

reg [8:0]corr = 500;
	

always @(posedge clk)
	begin
	
		if (EN == 1)
		begin
			if (sum_corr < corr)
			begin
				corr = sum_corr;
				out_min = corr;
				step = dx;	
				out_corr = corr;
			end
			if (reset == 1)
			begin
				corr = 500;
				out_min = 0;
				step = 0;
			end
		end
	end 
endmodule