module MASK_1ONLY(
	input wire [7:0]Y,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,	
	input wire [7:0]Y_0,
	
	output reg mask,
	output wire [9:0]x_min,
	output wire [9:0]x_max,
	output reg [8:0]blob_min_x,	
	output reg [8:0]blob_min_y
	);

reg [7:0]Y_const;	
reg [9:0]x1;
reg [9:0]y1;
reg [9:0]x2;
reg [9:0]y2;

//reg [7:0]Y_0 = 64;	
reg [9:0]x1_0 = 55;
reg [9:0]y1_0 = 60;
reg [9:0]x2_0 = 660;
reg [9:0]y2_0 = 192;

//min_blob_xy
reg [8:0]blob_0_x = 21;	
reg [8:0]blob_0_y = 15;

assign	x_min = x1;
assign	x_max = x2;

always @(Y,tv_x,tv_y)
	begin
			Y_const = Y_0;	
			x1 = x1_0;
			y1 = y1_0;
			x2 = x2_0;
			y2 = y2_0;
			blob_min_x <= blob_0_x;	
			blob_min_y <= blob_0_y;
		
		if 	
			(((tv_y <= y2)&&(tv_y >= y1))&&((tv_x >= x1)&&(tv_x <= x2))&&
			(Y < Y_const))
			mask = 1;	
		else
			mask = 0;		
	end 
endmodule