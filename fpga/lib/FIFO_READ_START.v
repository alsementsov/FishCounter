module FIFO_READ_START(
	input wire clk,
	input wire reset,		
	input wire [7:0]rd_use,
	
	output reg first_word
	
	);

//reg first_word = 0;	

	
always @(posedge clk or posedge reset)

	if(reset) 
	begin			
		
		addr <= 32'd0;
		data_mem <= 32'd0;
		
		cnt_x <= 11'd0;
		cnt_y <= 10'd0;
		Hsync <= 0;
		Vsync <= 0;
		DE <= 0;
		black_vga <= 0;
		
		fifo_r_ask <= 0;
		test_sync <= 0;
		start_vga <= 0;
		first_word <= 0;
		
	end 
	else begin
	
		if((~start_vga)&&(fifo_cnt >= 7'd200)&&(~first_word))
		begin
	
			fifo_r_ask <= 1;	
			
			if(data_in == 32'd2147483648)
			begin			
				fifo_r_ask <= 1;				
				first_word <= 1;				
			end		
			
		end
		else if ((~start_vga)&&(first_word))
		begin
			
			if(data_in == 32'd2147483647)
			begin
			
				start_vga <= 1;
				cnt_x <= 11'd2;
				cnt_y <= 10'd0;			
				addr <= 32'd2;
				DE <= 1;
				fifo_r_ask <= 1;		
			end
			else begin
				first_word <= 0;	
				fifo_r_ask <= 1;
			end
			
		end		
		else if (fifo_cnt < 7'd200)	
		begin
			fifo_r_ask <= 0;
		end		
	
//		if((cnt_x == 11'd5)&&(cnt_y == 10'd0))
		if(data_in == 32'd2147483648)
			test_sync <= 1;
		else
			test_sync <= 0;			
				
		if (start_vga)
		begin				

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

//			if((cnt_x <= 11'd799)&&(cnt_y <= 10'd599))
//				
//				DE <= 1;
//			else
//				DE <= 0;					
				
			if( (((cnt_x <= 11'd798)||(cnt_x == 11'd1055) )&&(cnt_y <= 10'd598)) ||
			
				((cnt_x <= 11'd798)&&(cnt_y <= 10'd599)) ||
			
				((cnt_x == 11'd1055) &&(cnt_y == 10'd627)) )
				
				DE <= 1;
			else
				DE <= 0;	
	
			// DATA TEST 
			if((cnt_x <= 11'd719)&&(cnt_y <= 10'd575))
			begin
				
				addr <= addr + 1'd1;
							
				if	(addr == 32'd414719)
				begin
					addr <= 32'd0;
				end				
			end
			
			if((cnt_x <= 11'd718)&&(cnt_y <= 10'd575))
			begin			
				data_mem <= data_in;	
			end
			else begin
				data_mem <= 32'd0;
			end	

			// FIFO READ
			// 11'd717 - max 719
			if( ((cnt_x <= 11'd717)&&(cnt_y <= 10'd575)) ||
			
			// 11'd724 - max 725
			 ((cnt_x >= 11'd1054)&&(cnt_y <= 10'd574)) ||
			 
			 ((cnt_x >= 11'd1054)&&(cnt_y == 10'd627)) )			 
			begin	
				fifo_r_ask <= 1;
			end
			else begin
				fifo_r_ask <= 0;
			end

		end
				
	end
endmodule

