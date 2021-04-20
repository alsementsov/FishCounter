module XY_CUT(
	input wire [9:0]xx,
	input wire [9:0]yy,
	input wire [9:0]x_cat,
	input wire [9:0]y_cut,
	input wire [9:0]cut_constant,
	
	output reg mask_eq
	);

wire	[9:0]x_cat_end;
wire	[9:0]y_cut_end;

assign x_cat_end = x_cat + cut_constant;
assign y_cut_end = y_cut + 1;
	
always @(xx, yy, x_cat, y_cut)
	begin
		if(((xx >= x_cat)&&(xx <= x_cat_end))||((xx>=x_cat)&&(xx<=680)&&(yy >= y_cut)&&(yy <= y_cut_end)))
			mask_eq = 1;
		else
			mask_eq = 0;	
	end 
endmodule