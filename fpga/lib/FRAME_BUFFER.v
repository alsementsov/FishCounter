module FRAME_BUFFER(
	input wire clk,
	input wire reset,	
	input wire sd_wait_rq,
	
	input wire [15:0]wr_data,
	input wire [19:0]wr_addr,
	input wire [6:0]wr_use,
	input wire [6:0]rd_use,
	input wire [19:0]n_pix_frame,
	input wire [19:0]test_in,
	
	output reg [24:0]sd_addr,
	output reg [1:0]sd_byte_en_n,
	output reg [15:0]sd_data,
	output reg sd_read_n,
	output reg sd_write_n,	
	output reg wr_ack,
	output reg [1:0]state_out,
	output reg [1:0]page_rd_out,
	output reg test
	);

reg [1:0]state = 0;
reg [24:0]rd_addr = 0;
reg [9:0]cnt_720 = 0;
reg fl_one = 0;
reg [1:0]page_rd = 0;
reg [1:0]page_wr = 1;
reg [3:0]timer = 0;
reg rd_start = 0;

always @(posedge clk or posedge reset)
	if(reset) 
	begin
		sd_addr <= 0;
		sd_byte_en_n <= 0;
		sd_data <= 0;
		sd_read_n <= 1;
		sd_write_n <= 1;
		rd_addr <= 0;
		cnt_720 <= 0;
		fl_one <= 0;
		page_rd <= 0;	
		page_wr <= 1;
		wr_ack <= 0;
		timer <= 0;
		rd_start <= 0;
		state <= 0;
		state_out <= 0;
	end 
	else begin	
		wr_ack <= 0;
		test <= 0;	
		page_rd_out <= page_rd;	
		
		if(rd_addr == test_in)
		begin
			test <= 1;
		end
		
		if(~sd_wait_rq)
		begin	
			case(state)		
				0: //ожидание
				begin			
					sd_write_n <= 1;
					sd_read_n <= 1;
					
					if(wr_use > 10)
					begin
						timer <= 0;
//						wr_ack <= 1;
						state <= 1;
						state_out <= 1;						
					end
					else if((rd_use <= 90)&&(rd_start))
					begin
						timer <= 0;
						state <= 2;
						state_out <= 2;				
					end				
				end //state_0
					
				1: //запись wr
				begin			
					sd_data <= wr_data;
					sd_addr[21:0] <= {page_wr, wr_addr};
					sd_write_n <= 0;
					sd_read_n <= 1;	
					wr_ack <= 1;
			
					if(wr_addr == (n_pix_frame)) 
					begin	
						page_wr <= page_wr + 1;						
						if(page_wr == 2'd2) 
						begin
							page_wr <= 2'd0;
							rd_start <= 1;
						end						
					end					
//					timer <= timer + 1;
//					if(timer == 7)
//					begin
						timer <= 0;
						state <= 0;
						state_out <= 0;
//					end
				end //state_1	
					
				2: //чтение rd
				begin				
					sd_addr[21:0] <= {page_rd, rd_addr};
					
					rd_addr <= rd_addr + 1'd1;					
					cnt_720 <= cnt_720 + 1'd1;					
					if (cnt_720 == 719)
					begin						
						cnt_720 <= 0;
						
						if(fl_one == 0)
						begin
							rd_addr <= (rd_addr - 10'd719);						
							fl_one <= 1;
						end
						else begin
							fl_one <= 0;
						end	
						
					end
				
					sd_write_n <= 1;
					sd_read_n <= 0;	
					
					if((rd_addr >= (n_pix_frame))&&(fl_one == 1))  
					begin					
						rd_addr <= 0;	
						
						if(page_wr == 0)					
							page_rd <= 2;
						else if(page_wr == 1)			
							page_rd <= 0;									
						else			
							page_rd <= 1;										
					end	
					
					timer <= timer + 1;
					if(timer == 11)
					begin
						timer <= 0;
						state <= 0;
						state_out <= 0;
					end
				end //state_2	
				
				default:
				begin			
					state <= 0;
					state_out <= 0;				
				end //default	
				
			endcase //case(state)			
		end //if(~sd_wait_rq)
		
	end //else reset
endmodule	



