module TV_720x480_EN(
	input wire clk,
	input wire reset,	

	input wire tv_field,
	input wire [20:0]tv_lin,
	input wire tv_dval,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	input wire [15:0]data_in,	
	input wire mtl_on,
	output reg [20:0]addr_lin,
	output reg[15:0]data_out,	
	output reg dval,
	output reg test
	);


always @(posedge clk or posedge reset)
	if(reset) 
	begin		
		dval <= 0;
		addr_lin <= 0;
		data_out <= 0;
	end 
	else begin	
	
		test <= 0;
	
		if((tv_x == 1)&&(tv_y ==1)&&(tv_dval == 1)&&(tv_field == 0))
		begin
			test <= 1;
		
		end

//	
		if((((tv_dval)&&(tv_x >= 1)&&(tv_x <= 720)&&(tv_y >= 1)&&(tv_y <= 240)&&(tv_field == 0))&&(mtl_on == 1))||
		(((tv_dval)&&(tv_x >= 1)&&(tv_x <= 720)&&(tv_y >= 1)&&(tv_y <= 288)&&(tv_field == 0))&&(mtl_on == 0)))
		begin
		
			data_out <= data_in;
			dval <= 1;
			addr_lin <= addr_lin + 1;	
			
			if((tv_x == 1)&&(tv_y ==1))
				addr_lin <= 0;
		end
		else begin
			dval <= 0;
		end

	
	
//		if((tv_dval)&&((tv_lin >= (720*48 - 1))&&(tv_lin <= (720*(48 + 480)- 1))))
//		begin
//		
//			dval <= 1;
//			//addr_lin <= tv_lin - (720*48 - 1);	
//			
//		end
//		else begin
//			dval <= 0;
//		end
		
	end //else reset
endmodule






