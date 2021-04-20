module sdram_logic(
	input wire clk,
	input wire reset,	
	input wire start_w,
	input wire start_r,
	
	input wire wait_rq,
	
	output reg [24:0]addres,
	output reg [1:0]byte_en_n,
	output reg [15:0]data,
	output reg read_n,
	output reg write_n
	);

reg [1:0] del;
reg [24:0] cnt_addr;
reg [15:0] cnt_data;
reg read;


always @(posedge clk or posedge reset)
	if(reset) 
	begin	
	
	addres <= 25'd0;
	data <= 16'd0;
	byte_en_n <= 2'd0;
	read_n <= 1;
	write_n <= 1;
	del <= 2'd1;

	cnt_addr <= 25'd0;
	cnt_data <= 16'd0;
	read <= 0;
		
	end 
	else begin
		
//		if((wait_rq)&&(del == 2'd2))
//		begin			
//			cnt_data <= cnt_data - 16'd1;
//			cnt_addr <= cnt_addr - 25'd1;
//			del <= 2'd1;
//		end		
//		else begin	
		
				
		
//				read_n <= 1;
//				write_n <= 1;
		
				if((start_w)&&(~wait_rq)&&(~read)) 
				begin				
								
					data <= cnt_data;
					addres <= cnt_addr;
				
					cnt_data <= cnt_data + 16'd1;
					cnt_addr <= cnt_addr + 25'd1;
					
					byte_en_n <= 2'd0;
					write_n <= 0;					
					del <= 2'd2;				
				end
				
				
//				if((cnt_addr == 128)&&(start_w))
//				begin
//					read <= 1;
//					cnt_addr <= 0;
//				end
//				
//				if((read == 1)&&(cnt_addr == 128))
//				begin
//					read <= 0;
//					cnt_addr <= 0;
//				end
				
				
				

				if((start_r)&&(~wait_rq)) 
				begin				
								
//					data <= cnt_data;
					addres <= cnt_addr;
				
//					cnt_data <= cnt_data + 16'd1;
					cnt_addr <= cnt_addr + 25'd1;
					
					byte_en_n <= 2'd0;
					read_n <= 0;					
					del <= 2'd2;
						
				end			
			
			
//		end //if((wait_rq)&&(del == 2'd2))
	end

endmodule






