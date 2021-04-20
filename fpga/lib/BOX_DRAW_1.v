module BOX_DRAW_1(
	input wire clk,
	input  reset,	
	
	input wire new_pix,	
	input wire [39:0]xy,
	input wire [7:0]bl_addr,
	input wire bl_en,
	input wire [9:0]x,
	input wire [9:0]y,
	input wire [7:0]bl_cnt,
	
	output reg pix_draw
	);
parameter size = 20; 

reg [39:0] box [size:0];
reg [39:0] box_xy;
reg [9:0] x0;
reg [9:0] y0;
reg [9:0] xn;
reg [9:0] yn;	
integer n;
	
always @(posedge clk or posedge reset)
	if(reset) 
	begin
		pix_draw = 0;
//		for (n = size; n>0; n = n-1)
//		begin
//			box[n] <= 0;
//		end
	end 
	else begin
		//запись значений
		
		if((bl_en == 1)&&(bl_addr <= size))
		begin
			box[bl_addr] <= xy;
		end
		
		//анализ
		if(new_pix == 1)
		begin
		
			pix_draw = 0;
			for (n = size; n >= 0; n = n-1)
			begin
				box_xy = box[n];
				
				x0 = box_xy[9:0];
				y0 = box_xy[19:10];
				xn = box_xy[29:20];
				yn = box_xy[39:30];
				
				if(((x0 > 0)||(xn > 0)||(y0 > 0)||(yn > 0))&&
					(n < bl_cnt))
				begin
					if((((x == x0)||(x == xn))&&
						((y >= y0)&&(y <= yn)))|| 
						(((y == y0)||(y == yn))&&
						((x >= x0)&&(x <= xn))))
						
						pix_draw = 1;
				end
					
			end //for
		end
		
	end //else reset
endmodule	


//		if(bl_en == 1)
//		begin
//			box[bl_addr] <= xy;
//		end
//		//анализ
//		if(new_pix == 1)
//		begin
//			
//			pix_draw = 0;
//			for (n = size; n >= 0; n = n-1)
//			begin
//				box_xy = box[n];
//				//if (((x >= box_1[39:30])&&(x_dff <= box_1[19:10])&&
//				//(y_dff >= box_1[29:20])&&(y <= box_1[9:0])) && 
//				//(~((x_dff > box_1[39:30])&&(x < box_1[19:10])&&
//				//(y > box_1[29:20])&&(y_dff < box_1[9:0])))) 	
//				if((x >= box_xy[9:0])&&(x <= box_xy[29:20])&&
//					(y >= box_xy[19:10])&&(y <= box_xy[39:30])) 
//
//					pix_draw = 1;
//					
////				else 
////					pix_draw = 0;
//			end
//		end
