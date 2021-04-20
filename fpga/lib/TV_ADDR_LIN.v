module TV_ADDR_LIN(
	input wire clk,
	input wire reset,	
	
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,	
	input wire [31:0]tv_count,
	input wire [15:0]data,
	input wire tv_dval,
	input wire tv_field,
	input wire [20:0]tv_count_lin,
	input wire [10:0]tv_y_lin,
	
	output reg [9:0]x,
	output reg [9:0]y,
	output reg [15:0]data_out,	
	output reg dval,
	output reg y_one,	
	output reg new_frame,
	output reg end_frame,	
	output reg end_line,	
	output reg sync_test
	);

reg [1:0] cnt = 0;
reg start_line = 0;


always @(posedge clk or posedge reset)
	if(reset) 
	begin		
		x <= 0;
		y <= 0;
		dval <= 0;
		data_out <= 0;
		sync_test <= 0;
		start_line <= 0;
		cnt <= 0;
		y_one <= 0;
		new_frame <= 0;
		end_frame <= 0;
		end_line <= 0;
	end 
	else begin
		y <= tv_y;
		dval <= 0;
		sync_test <= 0;	
		
		
		if((tv_x == 2)&&(tv_y == 10)&&(tv_field == 1))
		begin
			sync_test <= 1;
		end
				
				
				
		if(tv_y == 1)
			y_one <= 1;
		else
			y_one <= 0;
			

		if((tv_x == 1)&&(tv_y == 1)&&(tv_field == 0))
		begin
			new_frame <= 1;
			end_frame <= 0;
		end
		else
			new_frame <= 0;
			
		if((x == 723)&&((tv_y > 1)||(tv_y == 0))&&(tv_field == 0))
			end_line <= 1;
		else
			end_line <= 0;
			
			
		if((tv_x == 1)&&(tv_y == 0)&&(tv_field == 0))
			end_frame <= 1;

			
			
		if((tv_x == 0)&&(cnt != 2)&&(tv_field == 0)&&(tv_y > 0))
		begin
			cnt <= 2;
			x <= 0;			
			data_out <= 0;
			dval <= 1;
		end	
		
		if((tv_x == 1)&&(tv_dval == 1)&&(tv_field == 0))
		begin
			start_line <= 1;
			cnt <= 2;
			x <= 1;			
			data_out <= data;
			dval <= 1;
		end
		
		if(start_line)
		begin		
			cnt <= cnt + 1;			
			if(cnt == 2)
				cnt <= 1;
			
			if(cnt == 1)
			begin
				x <= x + 1;				
				if((x <= 719)&&(x > 0))
				begin
					data_out <= data;
					dval <= 1;
				end
				else if((x <= 722)&&((tv_y > 1)||(tv_y == 0)))
				begin
					data_out <= 0;
					dval <= 1;
				end
				else if((x == 720)&&(tv_y == 1))
				begin
					data_out <= 0;
					dval <= 1;
				end				
				else begin
					start_line <= 0;
					cnt <= 0;
					x <= 0;
				end				
			end			
		end //if(start_line)
		
	end //else reset
endmodule






