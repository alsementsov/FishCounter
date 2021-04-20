module MASK_2(
	input wire [7:0]Y,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
//	input wire [7:0]Y_in,
	input wire [1:0]sel,	
//	input wire [9:0]x1_in,
//	input wire [9:0]y1_in,
//	input wire [9:0]x2_in,
//	input wire [9:0]y2_in,	
	
	output reg mask,
	output wire [9:0]x_min,
	output wire [9:0]x_max,
	output reg [8:0]blob_min_x,	
	output reg [8:0]blob_min_y
	);

//reg [9:0]del_x = 110;//114 V33
//reg [9:0]del_y = 10;//14 V33

//wire [10:0]y1_add_del_y;
//wire [10:0]x1_add_del_x;
//wire signed [11:0]y2_sub_del_y;
//wire signed [11:0]x2_sub_del_x;

reg [7:0]Y_const;	
reg [9:0]x1;
reg [9:0]y1;
reg [9:0]x2;
reg [9:0]y2;

//0
reg [7:0]Y_0 = 64;	
reg [9:0]x1_0 = 55;
reg [9:0]y1_0 = 60;
reg [9:0]x2_0 = 660;
reg [9:0]y2_0 = 192;
//1
reg [7:0]Y_1 = 64;	
reg [9:0]x1_1 = 98;
reg [9:0]y1_1 = 96;
reg [9:0]x2_1 = 621;
reg [9:0]y2_1 = 196;
//2
reg [7:0]Y_2 = 64;	
reg [9:0]x1_2 = 11;
reg [9:0]y1_2 = 84;
reg [9:0]x2_2 = 709;
reg [9:0]y2_2 = 216;

//min_blob_xy
reg [8:0]blob_0_x = 21;	
reg [8:0]blob_0_y = 15;

reg [8:0]blob_1_x = 30;	
reg [8:0]blob_1_y = 30;

reg [8:0]blob_2_x = 30;	
reg [8:0]blob_2_y = 30;



//assign	y1_add_del_y = y1 + del_y;
//assign	x1_add_del_x = x1 + del_x;
//assign	y2_sub_del_y = y2 - del_y;
//assign	x2_sub_del_x = x2 - del_x;
assign	x_min = x1;
assign	x_max = x2;

always @(Y,tv_x,tv_y)
	begin
	
	   if(sel == 1)
		begin
			Y_const = Y_1;	
			x1 = x1_1;
			y1 = y1_1;
			x2 = x2_1;
			y2 = y2_1;
			blob_min_x <= blob_1_x;	
			blob_min_y <= blob_1_y;		
		end
		else if(sel == 2)
		begin
			Y_const = Y_2;	
			x1 = x1_2;
			y1 = y1_2;
			x2 = x2_2;
			y2 = y2_2;
			blob_min_x <= blob_2_x;	
			blob_min_y <= blob_2_y;			
		end
		else 
		begin
			Y_const = Y_0;	
			x1 = x1_0;
			y1 = y1_0;
			x2 = x2_0;
			y2 = y2_0;
			blob_min_x <= blob_0_x;	
			blob_min_y <= blob_0_y;
		end
		
		
		
		if 
			//(((((tv_y >= y2_sub_del_y)&&(tv_y <= y2))&&
			//((tv_x >= x1_add_del_x)&&(tv_x <= x2_sub_del_x)))||
			
			//(((tv_y >= y1)&&(tv_y <= y1_add_del_y))&&
			//((tv_x >= x1_add_del_x)&&(tv_x <= x2_sub_del_x)))||
			
			//(((tv_x >= x1)&&(tv_x <= x2))&&
			//((tv_y >= y1_add_del_y)&&(tv_y <= y2_sub_del_y))))&&
			
			//(Y < Y_const) )		
			
			(((tv_y <= y2)&&(tv_y >= y1))&&((tv_x >= x1)&&(tv_x <= x2))&&
			
			(Y < Y_const))
			
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