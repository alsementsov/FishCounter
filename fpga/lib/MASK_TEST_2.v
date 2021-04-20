module MASK_TEST_2(

	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	output reg [10:0]mask
	);

always @(tv_x)
	begin
		
		mask = 0;
		
//		
//		if((tv_x == 40)&&
//			(tv_y == 2))
//			mask = 1;			
//		if((tv_x == 40)&&
//			(tv_y == 3))
//			mask = 1;	
//		if((tv_x == 40)&&
//			(tv_y == 4))
//			mask = 1;	
//		if((tv_x == 40)&&
//			(tv_y == 5))
//			mask = 1;	
//		if((tv_x == 40)&&
//			(tv_y == 6))
//			mask = 1;	
//		if((tv_x == 40)&&
//			(tv_y == 7))
//			mask = 1;	
//		if((tv_x == 40)&&
//			(tv_y == 8))
//			mask = 1;				
	
			
	end 
endmodule
