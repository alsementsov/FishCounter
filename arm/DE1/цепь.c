case 5 : {

				if(fish_cnt == N_fish_calibrate)
				{
					//if(fish_len_mean >=  320)
					if(fish_len_mean >=  290)
					{
						K_len_max = 1.07;
						K_area_max = 1.07;
						K_area_n3 = 3;
					}
				}
				//поиск самого левого объекта
				for (m = 1; m <= box_cnt; m++)
				{
					if((box[m][x0] == x0_min)&&(box_lef_xn < box[m][xn]))
					{
						box_lef_x0 = x0_min;
						box_lef_xn = box[m][xn];
					}
				}
				//анализ цепочки рыб
				fish_cross_en = 0;
				fish_string_end = 0;

				//условие цепочки рыбы
				if ((box[1][x0] == x0_min)&&(box[1][xn] == xn_max)&&(box_cnt == 1))
				{
					
					//printf("start_1\r\n");
					//была ли цепочка до этого
					if(fish_string_flag == 0)
					{
						fish_string_flag = 1;
						//сохраняем параметры объекта о максимальном времени жизни
						f_life = 1;
						f_vel = 0;
						f_x0 = 0;
						f_xn = 0;

						while(box[1][x0] < xn_max)
						{
							if ((fish_flag[m] == 1)&&
							(fish_x0[m] <= (xn_max - fish_vel_mean))
							{
								fish_string_area_cnt = fish_string_area_cnt + fish_string_area;
								f_life++

								f_vel = (uint16_t) (((float)fish_vel[m])/ ((float)fish_vel_cnt[m]));//??

								f_x0 = fish_x0[m];
								f_xn = fish_xn[m];
							}
						} //for m = 1 : 1 : N_fish_max
						
						fish_string_box_life = f_life;
						fish_string_fish_vel = f_vel;
						fish_string_fish_x0 = f_x0;
						fish_string_fish_xn = f_xn;
						fish_string_life = 0;

					} //if(fish_string_flag == 0)

					//обновление параметров объекта
					box_flag[1] = 0;  // сбрасываем box
					fish_string_x0 = box[1][x0];
					fish_string_y0 = box[1][y0];
					fish_string_xn = box[1][xn];
					fish_string_yn = box[1][yn];
					fish_string_area =  (uint32_t)(box_area[1]);
					fish_string_box_life =fish_string_box_life + 1;
					fish_string_life = fish_string_life + 1;
					fish_string_time = time_cnt;


				} //условие цепочки рыбы
				else
				{
					if(fish_string_flag == 1) //если цепочка закончилась
					{
						//printf("start_2\r\n");
						//удаление объекта
						fish_string_flag = 0;

						if(fish_string_life <= time_wait) //если цепочка была короткое время
						{
							fish_cross_en = 1; //можно увеличить время на time_wait
							fish_string_end = 1;
						}
						else
						{//если цепочка была длинное время

							//условие прохождения первого объекта
							if(((fish_string_fish_xn - fish_string_fish_x0) >
								(uint16_t)((float)(fish_len_max)*K_string_len_max))&&
								(fish_string_fish_x0 == x0_min))
							{
								//если несколько рыбок в цепочке берем средний размер рыбы
								f_len = fish_len_mean;
							}
							else	{
								f_len = xn_max - fish_string_fish_x0;
								//f_len = xn_max - fish_string_fish_x0 - fish_string_fish_vel;
								//тут вычитание скорости рыбы
							}
//????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
							t_len  = (fish_string_life + 1)*fish_string_fish_vel +
									(uint16_t)((float)fish_len_mean*0.05) + 4; //для v_35_60
							// + (uint16_t)((float)fish_len_mean*0.05) + 1;
							//t_len  = (fish_string_life + 2)*fish_string_fish_vel;

							printf("\r\n");
							printf("f_len %d\t", f_len);
							printf("t_len %d\t", t_len);
							printf("fish_x %d\t", fish_string_fish_x0);
							printf("fish_vel %d\t", fish_string_fish_vel);
							printf("fish_life %d\t", fish_string_life);
							printf("fish_len %d\t", fish_len_mean);
							printf("f_v_m %d\t", fish_vel_mean);
							printf("\r\n");

							if(f_len <= t_len)
								fish_first_cnt = 1;
							else
								fish_first_cnt = 0;

							//расчет рыбы в длинной цепочке
							t_fish = (uint16_t)(((float)(f_len) / (float)(fish_string_fish_vel))); //fix!!!

							if(fish_string_life >= t_fish)
								t_string = fish_string_life - t_fish + 1;
							else
								t_string = 0;;

							//st_len_0 = ((float)(t_string)*(float)(fish_string_fish_vel) )/((float)(fish_len_mean)*0.93);
							st_len_1 = ((float)(t_string)*(float)(fish_vel_mean) )/((float)(fish_len_mean)*0.93);
							fish_string_cnt = (uint16_t)st_len_1; //fix!!!

							//увеличение счетчика рыбы
							fish_cnt = fish_cnt + fish_first_cnt + fish_string_cnt;

							//записываем средние параметры для счетчиков
							fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)(((uint16_t)fish_area_mean)*(fish_first_cnt + fish_string_cnt));
							fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)(((uint16_t)fish_life_mean)*(fish_first_cnt + fish_string_cnt));
							fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)((fish_len_mean)*(fish_first_cnt + fish_string_cnt));
							fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)((fish_vel_mean)*(fish_first_cnt + fish_string_cnt));