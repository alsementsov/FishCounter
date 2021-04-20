module X_CAT_1(
	input wire [9:0]xx,
	input wire [9:0]x_cat,
	input wire [9:0]cat_constant,
	
	output reg mask_eq
	);

wire	[9:0]x_cat_end;

assign x_cat_end = x_cat + cat_constant;
	
always @(xx, x_cat)
	begin
		if((xx >= x_cat)&&(xx <= x_cat_end))
			mask_eq = 1;
		else
			mask_eq = 0;	
	end 
endmodule