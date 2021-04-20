module BLOB_ANALYSIS(
	input wire clk,
	input wire reset,	
	
	input wire new_pix,
	input wire [10:0]mask_c2,	
	input wire [10:0]in_d1,
	input wire [18:0]blob_npix,	
	input wire [9:0]blob_x0,
	input wire [9:0]blob_y0,
	input wire [9:0]blob_xn,
	input wire [9:0]blob_yn,
	input wire [9:0]tv_x,
	input wire [9:0]tv_y,
	input wire [10:0]test_in,
	
	output reg [10:0]wr_a2,
	output reg wr_a2_en,	
	output reg [18:0]ram_npix,
	output reg [9:0]ram_x0,	
	output reg [9:0]ram_y0,
	output reg [9:0]ram_xn,
	output reg [9:0]ram_yn,	
	output reg [10:0]ram_addr,
	output reg ram_wr,
	output reg [10:0]ram_labl_1,
	output reg [10:0]ram_labl_2,
	output reg [10:0]ram_labl_addr,
	output reg ram_labl_wr,
	output reg [10:0]ram_addr_save,	
	
	output reg [18:0]merg_npix,
	output reg [9:0]merg_x0,	
	output reg [9:0]merg_y0,
	output reg [9:0]merg_xn,
	output reg [9:0]merg_yn,	
	output reg [10:0]merg_addr,
	output reg merg_wr,	
	
	output reg [10:0]labl,
	output reg [2:0]state_out,
	output reg test
	);

reg [2:0]state = 0;

reg [10:0]a1 = 0;
reg [10:0]a2 = 0;
reg [10:0]b1 = 0;
reg [10:0]b2 = 0;
reg [10:0]c1 = 0;
reg [10:0]c2 = 0;
reg [10:0]d1 = 0;

reg [10:0]a1_save = 0;
reg [9:0]a1_x = 0;
reg [9:0]a1_y = 0;

reg [9:0]x0 = 0;
reg [9:0]y0 = 0;
reg [9:0]xn = 0;
reg [9:0]yn = 0;

reg [10:0]labl_nex = 2;
reg [10:0]labl_min = 0;
reg [10:0]labl_addr = 1;
reg [10:0]labl_1 = 0;
reg [10:0]labl_2 = 0;

wire [19:0] npix_add_one;
assign npix_add_one = blob_npix + 1;

always @(posedge clk or posedge reset)
	if(reset) 
	begin
		a1 <= 0;
		a2 <= 0;
		b1 <= 0;
		b2 <= 0;
		c1 <= 0;
		c2 <= 0;
		d1 <= 0;
		wr_a2 <= 0;
		wr_a2_en <= 0;
		ram_npix <= 0;
		ram_x0 <= 0;	
		ram_y0 <= 0;
		ram_xn <= 0;
		ram_yn <= 0;	
		ram_addr <= 0;
		ram_wr <= 0;
		labl <= 0;
		labl_nex <= 2;
		labl_min <= 0;
		ram_addr_save <= 0;
		ram_labl_1 <= 0;
		ram_labl_2 <= 0;
		ram_labl_addr <= 0;
		labl_addr <= 1;
		ram_labl_wr <= 0;
		merg_npix <= 0;
		merg_x0 <= 0;
		merg_y0 <= 0;
		merg_xn <= 0;
		merg_yn <= 0;	
		merg_addr <= 0;
		merg_wr <= 0;	
		state <= 0;
		state_out <= 0;		
		test <= 0;
	end 
	else begin	
		test <= 0;
		wr_a2_en <= 0;	
		ram_wr <= 0;
		merg_wr <= 0;
		ram_labl_wr <= 0;
		
//		if((tv_x == 20)&&(tv_y == 30)) //32
//			test <= 1;

		if(labl_addr > test_in)
			test <= 1;
			
		case(state)		
			0: //ожидание
			begin	
				if(new_pix)
				begin
					//анализ окружения					
					//поиск минимальной метки
					//labl_min = 0;
					if((a1 > 1)&&((a1 <= b1)||(b1 < 2))&&((a1 <= c1)||(c1 < 2))&&
					((a1 <= in_d1)||(in_d1 < 2))&&((a1 <= a2)||(a2 < 2))&&((a1 <= b2)||(b2 < 2)))
						labl_min = a1;						
					else if((b1 > 1)&&((b1 <= a1)||(a1 < 2))&&((b1 <= c1)||(c1 < 2))&&
					((b1 <= in_d1)||(in_d1 < 2))&&((b1 <= a2)||(a2 < 2))&&((b1 <= b2)||(b2 < 2)))
						labl_min = b1;						
					else if((c1 > 1)&&((c1 <= a1)||(a1 < 2))&&((c1 <= b1)||(b1 < 2))&&
					((c1 <= in_d1)||(in_d1 < 2))&&((c1 <= a2)||(a2 < 2))&&((c1 <= b2)||(b2 < 2)))
						labl_min = c1;						
					else if((in_d1 > 1)&&((in_d1 <= a1)||(a1 < 2))&&((in_d1 <= b1)||(b1 < 2))&&
					((in_d1 <= c1)||(c1 < 2))&&((in_d1 <= a2)||(a2 < 2))&&((in_d1 <= b2)||(b2 < 2)))
						labl_min = in_d1;						
					else if((a2 > 1)&&((a2 <= a1)||(a1 < 2))&&((a2 <= b1)||(b1 < 2))&&
					((a2 <= c1)||(c1 < 2))&&((a2 <= in_d1)||(in_d1 < 2))&&((a2 <= b2)||(b2 < 2)))
						labl_min = a2;						
					else if((b2 > 1)&&((b2 <= a1)||(a1 < 2))&&((b2 <= b1)||(b1 < 2))&&
					((b2 <= c1)||(c1 < 2))&&((b2 <= in_d1)||(in_d1 < 2))&&((b2 <= a2)||(a2 < 2)))
						labl_min = b2;	
					else
						labl_min = 0;

				
					//обновление метки
					if(labl_min > 0)
					begin
						labl = labl_min;
					end 
					else if((in_d1 > 0)||(mask_c2 > 0))
					begin
						labl = labl_nex;
						labl_nex <= labl_nex + 1;
					end
					
					labl_1 = 0;
					labl_2 = 0;
					//слияние меток
					if((in_d1 > 1)&&(in_d1 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = in_d1;
					end
					else if((a1 > 1)&&(a1 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = a1;
					end
					else if((a2 > 1)&&(a2 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = a2;
					end	
					else if((b1 > 1)&&(b1 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = b1;
					end					
					else if((b2 > 1)&&(b2 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = b2;
					end
					else if((c1 > 1)&&(c1 != labl)&&(labl > 1))
					begin
						labl_1 = labl;
						labl_2 = c1;
					end					

					
					
					if((~(((ram_labl_1 == labl_1)&&(ram_labl_2 == labl_2))||
						((ram_labl_1 == labl_2)&&(ram_labl_2 == labl_1))))&&
						(labl_1 > 0)&&(labl_2 > 0))
					begin	
						ram_labl_1 <= labl_1;
						ram_labl_2 <= labl_2;
						ram_labl_addr <= labl_addr;
						labl_addr <= labl_addr + 1;
						ram_labl_wr <= 1;
						
						
						//если у метки еще нет координат то пишем
						if((in_d1 > 1)&&
							((ram_addr_save < labl_1)||
							(ram_addr_save < labl_2)))
						begin
							//для большей метки пишем координаты
							merg_npix <= 1;
							merg_x0 <= tv_x;							
							merg_xn <= tv_x;							
							merg_y0 <= tv_y; //- 1);//если а2 то ненужно отнимать
							merg_yn <= tv_y; //- 1);
							
							if(labl_2 > labl_1)
								merg_addr <= labl_2;
							else
								merg_addr <= labl_1;								
							merg_wr <= 1;	

						end
					end
					
					//обновление ячеек
					if(a1 > 0)
					begin
						a1 <= labl;	//можно не писать						
						a1_save <= labl;
						a1_x <= (tv_x - 2);
						a1_y <= (tv_y - 1);
						//чтение таблицы для метки a1
						if(labl != labl_nex)//если метка есть
						begin
							ram_addr <= labl;
							ram_wr <= 0;	
						end
					end
					else begin
						a1_save <= 0;
					end					
					if(a2 > 0)
						a2 <= labl;							
					if(b1 > 0)
						b1 <= labl;						
					if(b2 > 0)
						b2 <= labl;							
					if(c1 > 0)
						c1 <= labl;	
						
					if(mask_c2 > 0)
						c2 <= labl;	
					else
						c2 <= 0;	
						
					if(in_d1 > 0)
					begin
						d1 <= labl;	
					end
					else
						d1 <= 0;

//					c2 <=	mask_c2;
//					d1 <= in_d1;
					
					//переход на след. шаг
					state <= 1;
					state_out <= 1;						
				end //if(new_pix)	
			end //state_0		
		
			1://ожидание данных из памяти 
			begin	
				//запись a2
				wr_a2 <= a2;
				wr_a2_en <= 1;
				//обновление пикселей
				a1 <= b1;
				a2 <= b2;				
				b1 <= c1;
				b2 <= c2;
				c1 <= d1;				
				//переход на след. шаг	
				state <= 2;
				state_out <= 2;			
			end //state_1	
			
			2: 
			begin				
				//обновление пикселей координат
				//для активного элемента a1
				if(a1_save > 0)
				begin
					if(ram_addr_save >= a1_save)//если метка уже есть
					begin
						x0 = blob_x0;
						y0 = blob_y0;
						xn = blob_xn;
						yn = blob_yn;	
						
						if(a1_x < x0)
							x0 = a1_x;
						if(a1_x > xn)
							xn = a1_x;						
						if(a1_y < y0)
							y0 = a1_y;
						if(a1_y > yn)
							yn = a1_y;
							
						ram_npix <= npix_add_one[18:0];
						ram_x0 <= x0;	
						ram_y0 <= y0;
						ram_xn <= xn;
						ram_yn <= yn;	
						ram_addr <= a1_save;							
						ram_wr <= 1;
					end
					else begin//если новая метка
						
						ram_npix <= 1;
						ram_x0 <= a1_x;	
						ram_y0 <= a1_y;
						ram_xn <= a1_x;
						ram_yn <= a1_y;	
						ram_addr <= a1_save;	
						ram_addr_save <= a1_save;
						ram_wr <= 1;
					end
				end //if(a1_save > 0)	
				
				//переход на след. шаг	
				state <= 0;
				state_out <= 0;			
			end //state_2
			
//			3://ожидание
//			begin	
//					
//				//переход на след. шаг	
//				state <= 0;
//				state_out <= 0;			
//			end //state_3			
			
			default:
			begin			
				state <= 0;
				state_out <= 0;				
			end //default	
			
		endcase //case(state)		
	end //else reset

endmodule	



