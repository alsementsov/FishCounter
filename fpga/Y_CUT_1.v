module Y_CUT_1(
	input wire [9:0]yy,
	input wire [9:0]y_cut,
	input wire [9:0]cut_constant,
	
	output reg mask_eq
	);

wire	[9:0]y_cut_end;

assign y_cut_end = y_cut + cut_constant;
	
always @(yy, y_cut)
	begin
		if((yy >= y_cut)&&(yy <= y_cut_end))
			mask_eq = 1;
		else
			mask_eq = 0;	
	end 
endmodule