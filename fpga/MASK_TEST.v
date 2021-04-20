module MASK_TEST(

	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	input wire en,
	output reg [10:0]mask
	);

always @(tv_x)
	begin
		
		mask = 0;
		if(en == 1)
		begin
		
			if((tv_x >= 200)&&
			(tv_x <= 400)&&
			(tv_y >= 10)&&
			(tv_y <= 150))
				mask = 1;

			if((tv_x >= 10)&&
			(tv_x <= 200)&&
			(tv_y >= 140)&&
			(tv_y <= 150))
				mask = 1;

				
				
			if((tv_x >= 10)&&
			(tv_x <= 180)&&
			(tv_y >= 120)&&
			(tv_y <= 140))
				mask = 1;	
		
			if((tv_x >= 30)&&
			(tv_x <= 180)&&
			(tv_y >= 10)&&
			(tv_y <= 100))
				mask = 1;		
				
				
				
			if((tv_x >= 530)&&
			(tv_x <= 680)&&
			(tv_y >= 40)&&
			(tv_y <= 100))
				mask = 1;		
	
			if((tv_x >= 400)&&
			(tv_x <= 600)&&
			(tv_y >= 80)&&
			(tv_y <= 90))
				mask = 1;		
			
		end //if(en == 1)
	end 
endmodule
