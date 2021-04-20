module VGA_SYNC(
	input wire clk,
	input wire reset,		
	input wire [7:0]iR,
	input wire [7:0]iG,	
	input wire [7:0]iB,	
	input wire en,
		
	output reg [10:0]cnt_x,
	output reg [9:0]cnt_y,
	output reg Hsync,
	output reg Vsync,
	output reg DE,
	output reg [7:0]R,
	output reg [7:0]G,	
	output reg [7:0]B,	
	output reg data_ack,
	output reg test
	);
	
always @(posedge clk or posedge reset)

	if(reset) 
	begin	
		cnt_x <= 11'd0;
		cnt_y <= 10'd0;
		Hsync <= 0;
		Vsync <= 0;
		DE <= 0;
		R <= 0;
		G <= 0;
		B <= 0;
		data_ack <= 1;
		test <= 0;
	end 
	else if(en == 1)
	begin
	
		test <= 0;
		if((cnt_x == 1)&&(cnt_y == 0))
		begin
			test <= 1;
		end
	
		// VGA GENERATOR
		cnt_x <= cnt_x + 1'd1;
		
		if(cnt_x == 11'd1055)
		begin
			cnt_x <= 11'd0;				
			cnt_y <= cnt_y + 1'd1;
			
			if(cnt_y == 10'd627)
			begin
				cnt_y <= 10'd0;
			end				
		end
		
		if((cnt_x >= 11'd841)&&(cnt_x <= 11'd969))
			
			Hsync <= 1;
		else
			Hsync <= 0;				
			
		if((cnt_y >= 10'd602)&&(cnt_y <= 10'd606))
			
			Vsync <= 1;
		else
			Vsync <= 0;		

		if( (((cnt_x <= 11'd798)||(cnt_x == 11'd1055) )&&(cnt_y <= 10'd598)) ||
			((cnt_x <= 11'd798)&&(cnt_y <= 10'd599)) ||
			((cnt_x == 11'd1055) &&(cnt_y == 10'd627)) )
			
			DE <= 1;
		else
			DE <= 0;	
		//VGA GENERATOR END


		
		if((cnt_x <= 11'd718)&&(cnt_y <= 10'd575))
		begin			
			R <= iR;
			G <= iG;
			B <= iB;
		end
		else begin
			R <= 0;
			G <= 0;
			B <= 0;
		end

		
		if( ((cnt_x <= 11'd718)&&(cnt_y <= 10'd575)) ||
		 ((cnt_x >= 11'd1055)&&(cnt_y <= 10'd574)) ||
		 ((cnt_x >= 11'd1055)&&(cnt_y == 10'd627)) )			 
		begin	
			data_ack <= 1;
		end
		else begin
			data_ack <= 0;
		end		
			
	end
endmodule

