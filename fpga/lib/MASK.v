module MASK(
	input wire [7:0]Y,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	input wire [7:0]Y_const,
	input wire [3:0]sel,	
	input wire [9:0]x1,
	input wire [9:0]y1,
	input wire [9:0]x2,
	input wire [9:0]y2,	
	
	output reg mask
	);

reg [9:0]del_x = 115;
reg [9:0]del_y = 30;

wire [10:0]y1_add_del_y;
wire [10:0]x1_add_del_x;
wire signed [11:0]y2_sub_del_y;
wire signed [11:0]x2_sub_del_x;


assign	y1_add_del_y = y1 + del_y;
assign	x1_add_del_x = x1 + del_x;
assign	y2_sub_del_y = y2 - del_y;
assign	x2_sub_del_x = x2 - del_x;

always @(Y)
	begin
		
		if (( (tv_y >= y1_add_del_y)&&(tv_y < y2_sub_del_y)||
			((tv_y < y1_add_del_y)&&
			(tv_x > x1_add_del_x)&&(tv_x < x2_sub_del_x)) ||
			((tv_y >= y2_sub_del_y)&&
			(tv_x > x1_add_del_x)&&(tv_x < x2_sub_del_x)) )&&
			(Y < Y_const) )
//		if(Y < Y_const)
			mask = 1;	
		else
			mask = 0;		
	end 
endmodule
//			if ( (my >= (y1 + square_del_y))&&(m < (y2 - square_del_y))||...
//				((m < (y1 + square_del_y))&&...
//				(n > (x1 + square_del_x))&&(n < (x2 - square_del_x))) ||...
//				((m >= (y2 - square_del_y))&&...
//				(n > (x1 + square_del_x))&&(n < (x2 - square_del_x))) )

//		if (( (tv_y >= (y1 + square_del_y))&&((tv_y + square_del_y) < y2)||
//			((tv_y < (y1 + square_del_y))&&
//			(tv_x > (x1 + square_del_x))&&((tv_x + square_del_x) < x2))||
//			(((tv_y + square_del_y) >= y2)&&
//			(tv_x > (x1 + square_del_x))&&((tv_x + square_del_x) < x2)) )&&
//			(Y < Y_const ))