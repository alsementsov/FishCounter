module LABLE_MERGE(
	input wire clk,
	input wire reset,	
	
	input wire line_end,
	input wire frame_end,
	
	input wire [18:0]blob1_npix,	
	input wire [9:0]blob1_x0,
	input wire [9:0]blob1_y0,
	input wire [9:0]blob1_xn,
	input wire [9:0]blob1_yn,
	
	input wire [18:0]blob2_npix,	
	input wire [9:0]blob2_x0,
	input wire [9:0]blob2_y0,
	input wire [9:0]blob2_xn,
	input wire [9:0]blob2_yn,
		
	input wire [10:0]lable_1,
	input wire [10:0]lable_2,
	input wire [10:0]lable_wr_addr,
	input wire [10:0]labl_max,
	
	input wire [18:0]	npix_min,
	input wire [9:0]tv_y,
	input wire [9:0]tv_y_test,
	input wire [18:0]npix_npix,
	input wire [8:0]dist_x,
	input wire [8:0]L_x,
	input wire [8:0]L_y,
	
	
	output reg [18:0]ram1_npix,
	output reg [9:0]ram1_x0,	
	output reg [9:0]ram1_y0,
	output reg [9:0]ram1_xn,
	output reg [9:0]ram1_yn,	
	output reg [10:0]ram1_addr,
	output reg ram1_wr,

	output reg [18:0]ram2_npix,
	output reg [9:0]ram2_x0,	
	output reg [9:0]ram2_y0,
	output reg [9:0]ram2_xn,
	output reg [9:0]ram2_yn,	
	output reg [10:0]ram2_addr,
	output reg ram2_wr,
	
	output reg [10:0]ram_labl_addr,
	output reg ram1_sel,
	
	output reg [18:0]ram_bl_npix,
	output reg [9:0]ram_bl_x0,	
	output reg [9:0]ram_bl_y0,
	output reg [9:0]ram_bl_xn,
	output reg [9:0]ram_bl_yn,	
	output reg [7:0]ram_bl_addr,
	output reg ram_bl_wr,
	output reg [7:0]bl_cnt_out,
	output reg 	finish,
	
	output reg [3:0]state_out,
	output reg test
	);

reg [3:0]state = 0;

reg [10:0]ram_addr_save = 0;
reg [10:0]labl_addr_max = 0;
reg [10:0]labl_addr_max_z1 = 0;
reg [10:0]labl_addr_max_z2 = 0;
reg [10:0]labl_addr_save = 0;
reg [10:0]cnt = 0;
reg flag_end = 0;
reg [3:0] merge_cnt = 0;
reg [7:0]bl_cnt;
reg [10:0] labl_cnt = 0;

wire [19:0] npix_sum;
assign npix_sum = blob1_npix + blob2_npix;

reg [18:0] npix_max;
reg [9:0] cross;


wire [9:0] blob1_yn_add;
assign blob1_yn_add = blob1_yn + 1;

wire [9:0] blob2_yn_add;
assign blob2_yn_add = blob2_yn + 1;

wire [9:0] blob1_x;
assign blob1_x = blob1_xn - blob1_x0;

wire [9:0] blob2_x;
assign blob2_x = blob2_xn - blob2_x0;

reg  [18:0]sum_npix;


always @(posedge clk or posedge reset)
	if(reset) 
	begin	
		ram1_npix <= 0;
		ram1_x0 <= 0;	
		ram1_y0 <= 0;
		ram1_xn <= 0;
		ram1_yn <= 0;	
		ram1_addr <= 0;
		ram1_wr <= 0;
		
		ram2_npix <= 0;
		ram2_x0 <= 0;	
		ram2_y0 <= 0;
		ram2_xn <= 0;
		ram2_yn <= 0;	
		ram2_addr <= 0;
		ram2_wr <= 0;	
		
		ram_labl_addr <= 0;
		ram1_sel <= 0;
		
		ram_bl_npix <= 0;
		ram_bl_x0 <= 0;	
		ram_bl_y0 <= 0;
		ram_bl_xn <= 0;
		ram_bl_yn <= 0;	
		ram_bl_addr <= 0;
		ram_bl_wr <= 0;
		
		labl_addr_max <= 0;
		labl_addr_max_z1 <= 0;
		labl_addr_max_z2 <= 0;
		labl_addr_save <= 0;
		ram_labl_addr <= 0;
		merge_cnt <= 0;
		flag_end <= 0;
		bl_cnt <= 0;
		labl_cnt <= 0;
		finish <= 0;
		
		state <= 0;
		state_out <= 0;
		cnt <= 0;
		sum_npix <= 0;
		test <= 0;
		
	end 
	else begin
		finish <= 0;
		test <= 0;
		ram1_wr <= 0;
		ram2_wr <= 0;
		ram_bl_wr <= 0;
		
		if (blob1_npix > blob2_npix)
			npix_max = blob1_npix;
		else
			npix_max = blob2_npix;
			
		//запоминаем максимальную метку
		if(lable_wr_addr > labl_addr_max)
			labl_addr_max <= lable_wr_addr;
			
		//следим за таблицей слияний	
//		if(line_end)
//		begin
//			labl_addr_max_z <= labl_addr_max;					
//		end	
	
//	
//		//отладка
//		//if((tv_y == tv_y_test)&&(line_end))
//		if(frame_end)
//		begin
//			test <= 1;
//		end	

		
		case(state)		
			0: //ожидание
			begin	
				ram1_sel <= 0;			
				
				//обновление в конце строки
				if((line_end == 1)&&
					(labl_addr_save < labl_addr_max_z2)) 
				begin
					//обновление меток после строки
					ram1_sel <= 1;
					ram_labl_addr <= labl_addr_save + 1;
					cnt <= labl_addr_save + 1;
					state <= 1;
					state_out <= 1;
				end
				else 
				if(line_end == 1)
				begin
					labl_addr_max_z2 <= labl_addr_max_z1;
					labl_addr_max_z1 <= labl_addr_max;
					
					//labl_addr_save <= labl_addr_max_z2; // добавели
				end	
				
						
				
				//обновление в конце кадра
				if(frame_end == 1)
				begin
					//если есть слияния
					if(labl_addr_max > 0)
					begin
						//обновление меток в конце кадра
						flag_end <= 1;
						merge_cnt <= 5;//сколько раз проходить таблицу
						ram1_sel <= 1;
						ram_labl_addr <= 1;
						cnt <= 1;					
						state <= 1;
						state_out <= 1;
					end
					else begin
						//переход на след. шаг	
						state <= 5;
						state_out <= 5;
					end				
				end
				
			end //state_0		
			
			1://ожидание метки
			begin					
				//переход на след. шаг	

				state <= 2;
				state_out <= 2;			
			end //state_1
			
			2://чтение координат метки
			begin	
			

				ram1_addr <= lable_1;
				ram2_addr <= lable_2;
				//переход на след. шаг	
				state <= 3;
				state_out <= 3;			
			end //state_2	
			
			3://ожидание координат метки
			begin				
				//переход на след. шаг	
				state <= 4;
				state_out <= 4;			
			end //state_3
			
			4://обновление координат метки
			begin	
						
				if(((blob1_yn_add < tv_y)&&(blob2_yn_add < tv_y))||(flag_end == 1))
				//if(flag_end == 1)
				begin
					
	
					
					ram1_npix <= blob1_npix;
					ram2_npix <= blob2_npix;					
					
					
//					//test
//					if(npix_npix < npix_sum) 
//						test <= 1;			
					
									
					if(blob1_x0 < blob2_x0)
					begin					
						ram1_x0 <= blob1_x0;
						ram2_x0 <= blob1_x0;
					end
					else begin
						ram1_x0 <= blob2_x0;
						ram2_x0 <= blob2_x0;
					end

					if(blob1_xn > blob2_xn)
					begin
						ram1_xn <= blob1_xn;
						ram2_xn <= blob1_xn;
					end
					else begin
						ram1_xn <= blob2_xn;
						ram2_xn <= blob2_xn;
					end	
					
					if(blob1_y0 < blob2_y0)
					begin
						ram1_y0 <= blob1_y0;
						ram2_y0 <= blob1_y0;
					end
					else begin
						ram1_y0 <= blob2_y0;
						ram2_y0 <= blob2_y0;
					end	
					
					if(blob1_yn > blob2_yn)
					begin
						ram1_yn <= blob1_yn;
						ram2_yn <= blob1_yn;
					end
					else begin
						ram1_yn <= blob2_yn;
						ram2_yn <= blob2_yn;
					end				
					ram1_wr <= 1;
					ram2_wr <= 1;
					
				end
				
				//следующие слияние
				ram_labl_addr <= cnt + 1;
				cnt <= cnt + 1;
				
				//выход
				if((cnt == labl_addr_max_z2)&&(flag_end == 0)||
					(cnt == labl_addr_max)&&(flag_end == 1))
				begin
					if(merge_cnt == 0)
					begin
						if(flag_end == 0)
						begin
							//переход на след. шаг	
							state <= 0;
							state_out <= 0;
							//перезапоминаем адрес следующего обновления
							labl_addr_save <= labl_addr_max_z2;
							labl_addr_max_z2 <= labl_addr_max_z1;
							labl_addr_max_z1 <= labl_addr_max;
						end
						else begin
							//переход на удаление дублир. меток
							state <= 5;
							state_out <= 5;					
						end						
					end
					else begin					
						//переход на след. шаг
						merge_cnt = merge_cnt - 1;
						ram_labl_addr <= 1;
						cnt <= 1;
						state <= 1;
						state_out <= 1;
					end
				end
				else begin		
					//переход на след. шаг	
					state <= 1;
					state_out <= 1;					
				end
				
			end //state_4

			5://ожидание
			begin	
				//если есть метки, переход на удаление дублирующих
				if(labl_max > 1)
				begin
					ram1_sel <= 1;
					ram2_addr <= 2;
					labl_cnt <= 2;	
					sum_npix	<= 0;
					state <= 6;
					state_out <= 6;	
					test <= 1;
				end
				else begin
					state <= 9;
					state_out <= 9;				
				end
			end //state_5
			
			6://ожидание координат метки + доп. ожидан если адр. стираем
			begin	
			
				if((ram1_wr == 1)&&(ram1_addr == ram2_addr))
				begin
					state <= 6;
					state_out <= 6;				
				end
				else begin
					state <= 7;
					state_out <= 7;
				end
				
			end //state_6
			
			
			7://сохранение координат метки
			begin				
				if((blob2_x0 != 0)&&
					(blob2_y0 != 0)&&
					(blob2_xn != 0)&&
					(blob2_yn != 0)&&
					((blob2_xn - blob2_x0) >= L_x)&&
					((blob2_yn - blob2_y0) >= L_y))					
				begin
					//вывод координат
					//ram_bl_npix <= blob2_npix; пока не пишем, суммируем					
					sum_npix <= blob2_npix;
					ram_bl_npix <= blob2_npix;
					
					ram_bl_x0 <= blob2_x0;	
					ram_bl_y0 <= blob2_y0;
					ram_bl_xn <= blob2_xn;
					ram_bl_yn <= blob2_yn;
					//запись box
					ram_bl_addr <= bl_cnt;
					bl_cnt <= bl_cnt + 1;
					ram_bl_wr <= 1;
					
					cnt <= labl_cnt + 1;
					//поиск дублирующих координат
					state <= 8;
					state_out <= 8;
				end
				else if(labl_cnt < labl_max)
				begin
					//меток дублир нет
					ram2_addr <= labl_cnt + 1;
					labl_cnt <= labl_cnt + 1;					
					state <= 6;
					state_out <= 6;
				end		
				
				//завершение анализа
				if(labl_cnt >= labl_max)
				begin
					//выход
					state <= 9;
					state_out <= 9;				
				end
			end //state_7		
			
			8://пробегаем все координаты
			begin				
				cnt <= cnt + 1;				
				//анализ координат
				if((cnt >= (labl_cnt + 3))&&
					(cnt <= (labl_max + 2)))
				begin
				
					if((ram_bl_x0 == blob2_x0)&&	
						(ram_bl_y0 == blob2_y0)&&
						(ram_bl_xn == blob2_xn)&&
						(ram_bl_yn == blob2_yn))
					begin
						//удаление дублирующих координат
						sum_npix[18:0] <= sum_npix[17:0] + blob2_npix[17:0]; //суммируем пиксели
						ram_bl_npix <= sum_npix[17:0] + blob2_npix[17:0];
						ram_bl_wr <= 1;
						
						ram1_x0 <= 0;
						ram1_y0 <= 0;
						ram1_xn <= 0;
						ram1_yn <= 0;
						ram1_npix <= 0;
						
						ram1_addr <= (cnt - 2);
						ram1_wr <= 1;
					end					
				end
				
				//чтение данных
				if(cnt <= labl_max)
					ram2_addr <= cnt;				
				
				//выход на след. шаг
				if(cnt == (labl_max + 2))
				begin
					ram2_addr <= labl_cnt + 1;
					labl_cnt <= labl_cnt + 1;	
					state <= 6;
					state_out <= 6;				
				end
			end //state_8				

			9:// завершение удаления дублир. меток
			begin	
				flag_end <= 0;
				ram1_sel <= 0;
				bl_cnt_out <= bl_cnt;
				finish <= 1;
				
				state <= 0;
				state_out <= 0;	
			end //state_9	
			
			default:
			begin			
				state <= 0;
				state_out <= 0;				
			end //default	
			
		endcase //case(state)	
		
		
	end //else reset
endmodule	




