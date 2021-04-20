#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <sys/mman.h>
#include "C:/altera/13.1/embedded/ip/altera/hps/altera_hps/hwlib/include/hwlib.h"
#include "C:/altera/13.1/embedded/ip/altera/hps/altera_hps/hwlib/include/socal/socal.h"
#include "C:/altera/13.1/embedded/ip/altera/hps/altera_hps/hwlib/include/socal/hps.h"
#include "C:/altera/13.1/embedded/ip/altera/hps/altera_hps/hwlib/include/socal/alt_gpio.h"

#include <inttypes.h>
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

uint32_t 	N_fish_calibrate = 0;

//#define 	N_fish_max   		10
//#define 	Del_x  				12

//X_line, Y_line
uint32_t Area_mean = 6500;
uint32_t Area_remain = 0;
uint32_t Area_max = 0;
uint32_t Area_mean_mass[15];
uint32_t Area_bef_y = 0;
//uint32_t Area_cnt = 0;
uint32_t Area_cnt_2 = 0;
uint16_t X_line = 720;
uint16_t Y_line = 220;
uint16_t X_Draw = 720;
uint16_t Y_Draw = 220;
//uint16_t Y_Draw_old = 0;
bool yn_cut = 0;
bool y0_cut = 0;
uint16_t yn_cut_box_1 = 0;
uint16_t y0_cut_box_1 = 0;
uint16_t yn_cut_box = 0;
uint16_t y0_cut_box = 500;
uint8_t m_remain = 0;
uint16_t x0_cut_end = 0;
uint8_t m_cut_devide = 0;
//uint16_t len_to_draw_1 = 0;
//uint16_t len_to_draw = 500;

//uint16_t X_Draw_old = 1;
/*************************************BOOL*********************************************/
bool met_en = 0;

uint16_t Fish_Counter = 0;

bool first_Y_en = 0;
bool Y_enable = 0;

bool flag_cross = 0;
bool flag_big = 0;
bool empty_line = 1;

bool first = 1;
uint8_t N = 0;
uint16_t Xn_leftBlob = 0;
uint16_t X_line_old = 0;
uint16_t X_draw_old = 0;

uint16_t Xmin = 0;
uint16_t Xmax= 0;
uint16_t x_mean = 0;
uint8_t step_x = 0;

uint32_t ar_cut_n = 0;
uint32_t ar_cut_m = 0;

uint32_t ar_cut = 0;


//Переменные для цепочки:

uint8_t box_string_frame_cnt = 0;
float frame_cnt_constant = 0;
//uint8_t frame_cnt_constant_first = 0;
float frame_cnt_last = 0;
uint16_t frame_cnt_in_string = 0;
uint32_t area_between = 0;
uint32_t last_area_cnt = 0;
uint32_t box_area_cnt = 0;
uint32_t last_add_area = 0;
uint16_t len_field = 0;
bool fish_string_flag = 0;
bool error_else_string = 0;
bool flag_gap = 0;
uint8_t sub = 0;
float frame_cnt_var = 0;
uint16_t corr = 0;
uint16_t corr_old = 80;
uint16_t corr_bef = 0;
//uint8_t last_string_vel = 0;



//Переменные для калибровки:
uint16_t xn_old = 0;
//uint8_t vel_mean_calibrate = 0;
uint8_t vel_max_calibrate = 0;
//uint8_t vel_min_calibrate = 0;
uint8_t frame_cnt = 0;
//uint8_t f_v_en = 1;
uint16_t step_cal_cnt = 0;
uint8_t step_cal = 0;
uint16_t vel_count_calibrate = 0;
bool Flag_calibrate = 0;
bool Calibrate_end = 0;
bool flag_same_object = 0;
uint16_t len = 0;
uint16_t fish_len_mean = 0;
uint16_t fish_len_min = 0;
uint16_t fish_len_max = 0;
//uint32_t fish_area_mean = 0;
uint32_t fish_area_min = 0;
uint32_t fish_area_max = 0;
float K_fish_len_min = 0.93;
float K_fish_len_max = 1.05;
float K_fish_area_min = 0.95;
float K_fish_area_max = 1.1;



//Переменные для скорости:

//uint16_t Fish_Counter_vel = 0;
uint16_t box_xn_before[10];
uint16_t box_xn_old = 0;
uint16_t box_frame_cnt[10];
uint16_t box_frame_cnt_2 = 0;
uint8_t fish_vel_calibrate = 0;
uint16_t fish_vel_mass[15];
uint8_t step[10];
//uint8_t step_2 = 0;
uint16_t step_cnt[10];
//uint16_t step_cnt_2 = 0;
uint16_t corr_cnt = 0;
uint8_t corr_mean = 0;
uint16_t corr_mean_cnt = 0;
//uint8_t fish_vel = 0;
//uint8_t fish_vel_2 = 0;
//uint32_t fish_vel_cnt = 0;
//uint16_t fish_vel_cnt_2 = 0;
//uint8_t fish_vel_mean = 0;
//uint8_t fish_vel_mean_2 = 0;
uint8_t flag_vel_cnt_en[10];
bool flag_vel_cnt_en_2 = 0;
//uint8_t step_line = 0;
uint16_t new_matrix[10][4];
//uint8_t flag_rebuild = 0;
uint8_t delta_x = 0;
uint8_t delta_x_old = 0;
//uint8_t first_delta_x = 1;
//uint8_t vel = 0;




//Правая граница:

uint8_t left_box_frame_cnt = 0;
uint8_t vel_left_box = 0;
bool flag_vel_en = 0;
bool flag_vel_left = 0;
uint16_t boxes_new[10][4];
uint32_t Area_new[10];
uint16_t boxes_old[10][4];




//Вынужденное разделение:

uint8_t m_cut = 0;
bool flag_mustcut = 0;

uint8_t f_cnt = 0;
//uint32_t ar_cut_m = 0;
//uint32_t ar_cut_n = 0;




//Перестроение матриц:

uint16_t box_a[1][4];
uint16_t box_b[1][4];
uint32_t Ar = 0;
uint32_t Ar_1 = 0;

uint32_t area_on_frame = 0;
uint32_t last_area = 0;
uint32_t fish_in_string = 0;
bool string_add_en = 0;




#define 	x0		0
#define 	y0		1
#define 	xn		2
#define 	yn		3


volatile	uint8_t state = 0;
void 	*virtual_base;
int 	fd;

volatile uint32_t 	*fish_out_addr;
volatile uint32_t 	*box_req;
volatile uint32_t 	*req_res;
volatile uint32_t 	*box_n_addr;
volatile uint32_t 	*n_pix_addr;
volatile uint32_t	*led;
volatile uint32_t 	*addr_out;
volatile uint32_t 	*box_addr;
volatile uint32_t 	*box_x0_addr;
volatile uint32_t 	*box_xn_addr;
volatile uint32_t 	*box_y0_addr;
volatile uint32_t 	*box_yn_addr;
volatile uint32_t 	*x_min_addr;
volatile uint32_t 	*x_max_addr;
volatile uint32_t 	*n_frame_addr;
volatile uint32_t 	*fish_area_addr;
volatile uint32_t 	*fish_len_addr;
volatile uint32_t 	*reset_cnt_addr;
volatile uint32_t 	*sw_mass_addr;
volatile uint32_t 	*test_cnt_balls_addr;
volatile uint8_t	*con_yark_addr;
volatile uint16_t	*x1_0_addr;
volatile uint16_t	*x2_0_addr;
volatile uint16_t	*y1_0_addr;
volatile uint16_t	*y2_0_addr;
volatile uint16_t	*del_x_addr;
volatile uint16_t	*del_y_addr;
volatile uint16_t	*x_cat_addr;
volatile uint16_t 	*y_cut_addr;
volatile uint16_t	*dx_corr_addr;

uint8_t  Count = 0; //box_cnt

uint32_t	time_cnt = 0;

uint16_t fish_len = 0;
uint16_t fish_height = 0;


//входные данные
uint8_t  	ram_addr = 0;
//uint16_t 	boxes_new[10][4];
//uint32_t 	Area_new[10];

uint8_t 	box_flag[10];
uint8_t 	box_flag_z[10];
uint8_t 	fish_cross[10];
uint8_t 	fish_cross_z[10];
uint8_t 	fish_link[10];
uint8_t 	box_cross[10];
uint8_t 	box_cross_z[10];



//переменные цикла
uint8_t k = 0;
uint8_t i = 0;
uint8_t m = 0;
uint8_t n = 0;
uint8_t f = 0;

float a = 0;
int b = 0;
int b_yen = 0;
float c = 0;
int d = 0;

int main() {

	printf("Hello DE1_SOC!\r\n");

	met1:
	if (met_en == 1){
		printf("met1 \r\n");
		N_fish_calibrate = *(n_frame_addr);

		Fish_Counter = 0;

		Area_mean = 6500;
		Area_cnt_2 = 0;
		X_line = 720;
		Y_line = 220;
		X_Draw = 720;
		Y_Draw = 220;
		fish_len_mean = 0;

		delta_x = 0;
		delta_x_old = 0;
		xn_old = 0;
		box_xn_old = 0;
		Calibrate_end = 0;
	    //fish_area_mean = 0;
		//fish_vel_cnt_2 = 0;
		corr_mean_cnt = 0;

//		Fish_Counter_vel = 0;
		box_xn_old = 0;
		fish_vel_calibrate = 0;
		state = 0;

		m_remain = 0;
		yn_cut = 0;
		y0_cut = 0;
		ar_cut = 0;
		first_Y_en = 0;
	}

	//очищаем память
	memset(fish_vel_mass, 0, sizeof(fish_vel_mass));
	memset(Area_mean_mass, 0, sizeof(Area_mean_mass));
	memset(box_xn_before, 0, sizeof(box_xn_before));
	memset(box_frame_cnt, 0, sizeof(box_frame_cnt));
	memset(step, 0, sizeof(step));
	memset(step_cnt, 0, sizeof(step_cnt));
	memset(flag_vel_cnt_en, 0, sizeof(flag_vel_cnt_en));
	memset(new_matrix, 0, sizeof(new_matrix));
	memset(boxes_new, 0, sizeof(boxes_new));
	memset(Area_new, 0, sizeof(Area_new));
	memset(box_a, 0, sizeof(box_a));
	memset(box_b, 0, sizeof(box_b));
	memset(boxes_new, 0, sizeof(boxes_new));
	memset(boxes_old, 0, sizeof(boxes_old));
	memset(Area_new, 0, sizeof(Area_new));

	//инициализация
	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}
	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );
	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	//запоминаем адрес
	box_req = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_REQ_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	req_res = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + REQ_RES_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
/*	led = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_LED_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
*/	n_pix_addr = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + N_PIX_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	fish_out_addr = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + N_FISH_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	addr_out = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + ADDR_OUT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_ADDR_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_n_addr = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_N_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_x0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_X0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_xn_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_XN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_y0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_Y0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	box_yn_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + BOX_YN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	x_min_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + X_MIN_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	x_max_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + X_MAX_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	n_frame_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + N_FRAME_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	fish_area_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TEST_32T_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	fish_len_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TEST_16T_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	reset_cnt_addr = virtual_base +
					( ( unsigned long  )( ALT_LWFPGASLVS_OFST + RESET_CNT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	sw_mass_addr = virtual_base +
					( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SW_MASS_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	test_cnt_balls_addr = virtual_base +
					( ( unsigned long  )( ALT_LWFPGASLVS_OFST + TEST_CNT_BALLS_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	con_yark_addr = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + CON_YARK_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	x1_0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + X1_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	x2_0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + X2_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	y1_0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + Y1_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	y2_0_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + Y2_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	del_x_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DEL_X_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	del_y_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DEL_Y_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	x_cat_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + X_CAT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	dx_corr_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DX_CORR_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	y_cut_addr = virtual_base +
				( ( unsigned long  )( ALT_LWFPGASLVS_OFST + Y_CUT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	//приветствие
	state = 0;

	met_en = 1;
	*(con_yark_addr) = 90;
	*(x1_0_addr) = 48;
	*(x2_0_addr) = 633;
	*(y1_0_addr) = 58;
	*(y2_0_addr) = 197;
	*(del_x_addr) = 0;//82
	*(del_y_addr) = 17;
	Xmin = *(x_min_addr);
	Xmax = *(x_max_addr);
	//*(x_cat_addr) = 720;
	x_mean = ( Xmin + (Xmax - Xmin)*0.65);

	*(fish_area_addr) = 0;
	*(fish_len_addr) = 0;
	len_field = Xmax - Xmin;

	while (1){
		if(*(reset_cnt_addr) == 1) {
			goto met1;
		}


		switch (state) {

			case 0 : {
//			printf("state_0 \r\n");
			//сброс значений
				for(i=1; i < 10; i++){
					boxes_old[i][x0] = boxes_new[i][x0];
					boxes_old[i][xn] = boxes_new[i][xn];
					boxes_old[i][y0] = boxes_new[i][y0];
					boxes_old[i][yn] = boxes_new[i][yn];
					boxes_new[i][x0] = 0;
					boxes_new[i][y0] = 0;
					boxes_new[i][xn] = 0;
					boxes_new[i][yn] = 0;
					Area_new[i] = 0;
//					box_flag_z[i] = box_flag[i];
//					box_flag[i] = 0;
//					fish_cross_z[i] = fish_cross[i];
//					fish_cross[i] = 0;
//					fish_link[i] = 0;
//					box_cross_z[i] = box_cross[i];
//					box_cross[i] = 0;
				}


				*(req_res) = 0;
				*(addr_out) = 0;
				//*(reset_cnt_addr) = 0;
				state = 1;
				break;
			}

			//ожидание начала кадра
			case 1 : {
//			printf("state_1 \r\n");
				if (*(box_req + 3) == 1 ){
					//сбрасываем флаг
					*(box_req + 3) = 0;
					Count = *(box_n_addr);
					//printf("box_cnt = //d\r\n", box_cnt);
					//time_cnt_z = time_cnt;
					time_cnt = time_cnt + 1;
					first = 1;

					//time_cnt_z = *(n_frame_addr);
					N_fish_calibrate = *(n_frame_addr);
//					printf("//d\t", (time_cnt ));
//
//					printf("//d\t", (N_fish_calibrate ));

					if (Count > 0)
					{
						ram_addr = 0; //1
						*(addr_out) = ram_addr; //записываем новый адрес
						state = 2;
					}
					else {
						state = 3;
					}
				}
				break;
			}

			//читаем входные данные
			case 2 : {

//				printf("state_2 \r\n");
				//ждем нужный адрес
				if (*(box_addr) == ram_addr)
				{
					//можно добавить проверку нет ли схожих уже

					boxes_new[(ram_addr+1)][x0] = *(box_x0_addr);
					boxes_new[(ram_addr+1)][y0] = *(box_y0_addr);
					boxes_new[(ram_addr+1)][xn] = *(box_xn_addr);
					boxes_new[(ram_addr+1)][yn] = *(box_yn_addr);
					Area_new[(ram_addr+1)] = *(n_pix_addr);
//					box_flag[(ram_addr+1)] = 1;

					if (((ram_addr + 1) < Count)&&
						((ram_addr + 1) < 10))
					{
						//читаем данные
						ram_addr = ram_addr + 1;
						*(addr_out) = ram_addr; //записываем новый адрес
					}
					else {
						//переход следующий шаг
						state = 4; //state = 3;
					}
				}
				break;
			}
			case 3 : {

				printf("state_3 \r\n");
				//обнуляем старые значения
				for(i=(Count + 1); i < 10; i++)
				{
					boxes_old[i][x0] = boxes_new[i][x0];
					boxes_old[i][xn] = boxes_new[i][xn];
					boxes_old[i][y0] = boxes_new[i][y0];
					boxes_old[i][yn] = boxes_new[i][yn];
					boxes_new[i][x0] = 0;
					boxes_new[i][y0] = 0;
					boxes_new[i][xn] = 0;
					boxes_new[i][yn] = 0;
					Area_new[i] = 0;
//					box_flag[i] = 0;
				}
				state = 4;
				break;
			}

			case 4 : {
				printf("state_4 \r\n");
				//основная часть программы
				//выполняется один раз после прихода кадра

				//		Count = *(box_n_addr);
				//		N_fish_calibrate = *(n_frame_addr);
				X_draw_old = X_Draw;
				corr = *(dx_corr_addr);
				if ((corr == 124)||(corr == 22)){
					corr = corr_old;
				}
				X_line_old = X_line;


//				boxes_new = boxes_new; //записать матрицу координат в новую
//				Area_new = Area_new; //записать матрицу площадей в новую
				for (m = 1; m <= Count; m++){
					for (n = 1; n <= Count; n++){
						for (i = 0; i <= 3; i++){
							box_a[1][i] = boxes_new[m][i]; //записать
							box_b[1][i] = boxes_new[n][i];  //строки
						}
						Ar = Area_new[m];	    //матриц
						Ar_1 = Area_new[n];	   //в переменные
						if ((boxes_new[n][xn] > boxes_new[m][xn])&&(n>m)){ //если бокс оказался дальше предыдущего (по правым границам боксов)
							for (i = 0; i <= 3; i++){
								boxes_new[m][i] = box_b[1][i];	//то поменять
								boxes_new[n][i] = box_a[1][i];	 //строки
							}
							Area_new[m] = Ar_1;	 //матриц
							Area_new[n] = Ar;	    //между собой
						}//if ((boxes_new[n][xn] > boxes_new[m][xn])&&(n>m))
					}//for (n = 1; m <= Count; m++)
				}//for (m = 1; m <= Count; m++)

				//Калибровка
				if(N_fish_calibrate > Fish_Counter){ //если для калибровки требуется больше, чем насчитано
					printf("1 \r\n");
					Flag_calibrate = 1;//устанавливается флаг калибровки
					if(((boxes_new[1][x0]) > Xmin)&&(boxes_new[1][xn] < Xmax)){//если есть в поле объект, не касающийся границ

/*/////////////////////////////////////////////////////////////////
						step_cal = boxes_new[1][xn] - xn_old; //шаг за кадр
						step_cal_cnt = step_cal_cnt + step_cal; // общее расстояние
						frame_cnt = frame_cnt + 1; //число кадров
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

						flag_same_object = 1;//слежение за этим объектом
						len = boxes_new[1][xn] - boxes_new[1][x0];//вычисляется длина
						if(len > fish_len_mean){//если длина получилась больше средней
							fish_len_mean = len;//то она становится средней
							*(fish_len_addr) = fish_len_mean/1.43;
						}
						if(Area_new[1] > Area_mean){ //если площадь получилась больше средней
							Area_mean = Area_new[1];//то она становится средней
							if(Area_max < Area_mean){
								Area_max = Area_mean;
							}
						}
					}//if((boxes_new[1][x0]) > Xmin)&&(boxes_new[1][xn]) < Xmax))
					fish_len_min = fish_len_mean *  K_fish_len_min;  		// минимальная длина
					fish_len_max = fish_len_mean *  K_fish_len_max;			// максимальная длина
					if((boxes_new[1][xn] == Xmax)&&(flag_same_object == 1)){//если объект дошел до правой границы
						//Area_cnt = Area_cnt + Area_mean;
						Fish_Counter++;//увеличение счетчика
						Area_mean_mass[Fish_Counter] = Area_mean;
						Area_mean = 0;
						flag_same_object = 0;//прекращение слежения за объектом

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						vel = step_cal_cnt/frame_cnt; //скорость только что прошедшего бокса
			            vel_count_calibrate = vel_count_calibrate + vel;
						vel_mean_calibrate = vel_count_calibrate/Fish_Counter; //средняя скорость
						if (vel_max_calibrate < vel){ //максимальная скорость
							vel_max_calibrate = vel;
						}
						if ((vel_min_calibrate > vel) || (vel_min_calibrate == 0)){ //минимальная скорость
							vel_min_calibrate = vel;
						}
						frame_cnt = 0;
						step_cal_cnt = 0;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
//						Fish_Counter_vel = Fish_Counter_vel + 1;
						/*if(N_fish_calibrate == Fish_Counter){//если прошло уже достаточно рыб
							Flag_calibrate = 0;//прекратить калибровку
						}*/
					}//((boxes_new[1][xn] == Xmax)&&(flag_same_object))
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//				xn_old = boxes_new[1][xn]; //записывается старое значение xn
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				}//if(N_fish_calibrate > Fish_Counter)
				else{
					for (m = 1; m<=Count; m++){
						printf("x0 = %d\t", boxes_new[m][x0]);
						printf("xn = %d\t", boxes_new[m][xn]);
					}
//					printf("xm = %d\t", Xmax);
					if ((N_fish_calibrate == Fish_Counter)&&(Count == 0)&&(Calibrate_end == 0)){
						Flag_calibrate = 0;
//						Area_mean = Area_cnt/Fish_Counter;
						for(m = 1; m <= N_fish_calibrate; m++){
							if (Area_mean_mass[m] < Area_max * 0.75){
								Area_mean_mass[m] = Area_max * 0.75;
							}
							if (fish_vel_mass[m] < vel_max_calibrate * 0.8){
								fish_vel_mass[m] = vel_max_calibrate * 0.8;
							}
							corr_mean_cnt = corr_mean_cnt + fish_vel_mass[m];
							Area_cnt_2 = Area_cnt_2 + Area_mean_mass[m];
							Area_mean_mass[m] = 0;
							fish_vel_mass[m] = 0;
						}
						Area_mean = Area_cnt_2/Fish_Counter;
						printf("c_m_c %d\n", corr_mean_cnt);
						fish_vel_calibrate = corr_mean_cnt/Fish_Counter;
						d = Area_mean/2.2;
						fish_area_min = Area_mean * K_fish_area_min;	    // минимальная площадь
						fish_area_max = Area_mean * K_fish_area_max;	    // максимальная площадь
						Calibrate_end = 1;
						//Area_cnt = 0;
						Area_cnt_2 = 0;
						corr_mean_cnt = 0;
					}
				}
				if (Count == 0) { //если нет блобов в кадре (пустой)
					X_line = 720;
					X_Draw = 720;
					X_draw_old = 720;
					Y_enable = 0;
				}
				if ((Flag_calibrate == 1)&&(Count == 1)){
					//Расчет скорости
					if((boxes_new[1][xn]>(Xmin+40))&&(boxes_new[1][xn]<Xmax)&&(boxes_new[1][xn]>box_xn_old)){//если бокс в анализируемой области и не пошел назад и это не отрезанный кусок
						printf("333 \r\n");
						flag_vel_cnt_en_2 = 0;
						box_frame_cnt_2 = box_frame_cnt_2 + 1;//считается, сколько кадров потребовалось для прохождения поля
						printf("b_f_c_2 %d\n", box_frame_cnt_2);
//						step_2 = boxes_new[1][xn] - box_xn_old;//считается, сколько бокс прошел с прошлого кадра до текущего
//						step_cnt_2 = step_cnt_2 + step_2;//общее расстояние, что прошел бокс
						if(corr > 160){
							corr_cnt = corr_cnt + (corr/2);
						}
						else{
							corr_cnt = corr_cnt + corr;
						}
					}//if((boxes_new[m][xn]>Xmin)....
					else{
						printf("5555 \r\n");
						if((boxes_new[1][xn] == Xmax)&&(flag_vel_cnt_en_2 == 0)&&(boxes_new[1][x0] != Xmin)){//если бокс дошел до границы и это новый бокс и это не отрезанный кусок
							printf("333_01 \r\n");
							flag_vel_cnt_en_2 = 1;
							corr_mean = corr_cnt/(box_frame_cnt_2);
							fish_vel_mass[Fish_Counter] = corr_mean;
							if (vel_max_calibrate < corr_mean){ //максимальная скорость
								vel_max_calibrate = corr_mean;
							}
							/*if ((vel_min_calibrate > corr_mean) || (vel_min_calibrate == 0)){ //минимальная скорость
								vel_min_calibrate = corr_mean;
							}*/
							//printf("c_cnt %d\n", corr_cnt);
							printf("c_mean %d\n", corr_mean);
							//printf("b_f_c_2 %d\n", box_frame_cnt_2);
							//corr_mean_cnt = corr_mean_cnt + corr_mean;

/*							if (box_frame_cnt_2 == 0){
								fish_vel_2 = 0;
							}
							else{
								fish_vel_2 = step_cnt_2/box_frame_cnt_2;//считается, средняя скорость каждого бокса
							}
*/
//							fish_vel_cnt_2 = fish_vel_cnt_2 + fish_vel_2;
							if (Fish_Counter == 0){
								fish_vel_calibrate = 0;
							}
							/*else{
//								fish_vel_calibrate = fish_vel_cnt_2/Fish_Counter;//средняя скорость по всем когда-либо проходившим боксам
								fish_vel_calibrate = corr_mean_cnt/Fish_Counter;
							}*/
							printf("b_f_cnt=  %d\n", box_frame_cnt_2);
							corr_cnt = 0;
							box_frame_cnt_2 = 0;
//							step_cnt_2 = 0;
						}//if((boxes_new[m][xn] == Xmax)....
					}//else

					box_xn_old = boxes_new[1][xn];
				}//if ((Flag_calibrate == 1)&&(Count == 1))
			//	elseif(~Flag_calibrate)//если блобы есть и это не калибровка
				else{
					printf("2 \r\n");

					if (flag_mustcut == 1){
						for (m = 1; m <= Count; m++){
							if ((boxes_new[m][x0] == X_draw_old + 3)&&(yn_cut == 1)){
								yn_cut_box_1 = boxes_new[m][yn];
								if(yn_cut_box_1 > yn_cut_box){
									yn_cut_box = boxes_new[m][yn];
									m_cut_devide = m;
								}
							}
							if ((boxes_new[m][x0] == X_draw_old + 3)&&(y0_cut == 1)){
								y0_cut_box_1 = boxes_new[m][y0];
								if(y0_cut_box_1 < y0_cut_box){
									y0_cut_box = boxes_new[m][y0];
									m_cut_devide = m;
								}
							}
							/*if (((boxes_new[m][x0] == X_draw_old + 3)&&(yn_cut == 1)
									&&(boxes_new[m][yn] > Y_Draw))||((boxes_new[m][x0] == X_draw_old + 3)
									&&(y0_cut == 1)&&(boxes_new[m][y0] < Y_Draw))){
								ar_cut = Area_new[m];
								//flag_cross = 0;
								flag_mustcut = 0;
								yn_cut = 0;
								y0_cut = 0;
							}*/
							/*for (n = 1; n <= Count; n++){
//////////////////////////////////////////////////////////////////////////////////////////////
								if (((flag_mustcut == 1) && (boxes_new[m][x0]) == X_Draw + 3) && (boxes_new[n][xn] == X_Draw - 1)
								&& (m != m_cut) && (n != m_cut)){ // ПРОВЕРИТЬ!!!!!!!!!!!!!!!!!!!!!!!
//////////////////////////////////////////////////////////////////////////////////////////////
									ar_cut_m = Area_new[m];
									ar_cut_n = Area_new[n];
									Fish_Counter = Fish_Counter + (Area_new[m] + Area_new[n])/Area_mean;
									flag_mustcut = 0;
								}//if.....
							}//(n = 1; n <= Count; n++)*/
						}//(m = 1; m <= Count; m++)
						ar_cut = Area_new[m_cut_devide];
						flag_mustcut = 0;
						yn_cut = 0;
						y0_cut = 0;
						yn_cut_box = 0;
						yn_cut_box_1 = 0;
						y0_cut_box = 500;
						y0_cut_box_1 = 0;
					}//(flag_mustcut == 1)


			///Поиск Xline
			//		flag_mustcut=false;
					for (m = 1; m <= Count; m++){
						if((boxes_new[m][x0] == Xmin)&&(boxes_new[m][xn] == X_draw_old - 1)){
							flag_big = 1;
						}
						if((boxes_new[m][x0] == (X_draw_old + 3))||(boxes_new[m][xn] == (X_draw_old - 1))){
							empty_line = 0;
						}
						if ((boxes_new[m][x0]>Xmin+5)&&(Flag_calibrate == 0)){
								//&&(boxes_new[m][x0] < X_draw_old)){ // если левая граница оторвалась от левого края и это не калибровка
							// если x0 не пересекает невышедший Блоб
							flag_cross = 0;
							for (n = 1; n <= Count; n++){
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   поменял X_Draw на (X_Draw - 1)	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
								if ((boxes_new[m][x0]>boxes_new[n][x0])&&(boxes_new[m][x0]<boxes_new[n][xn])&&
								(boxes_new[m][x0] < X_draw_old) && (boxes_new[n][x0] < X_draw_old)){
								//(boxes_new[m][xn] < X_Draw - 1) && (boxes_new[n][xn] < X_Draw - 1)){
									flag_cross = 1;
									if  ((boxes_new[m][xn]>=(Xmax-20)) && (m<n) && (fish_string_flag == 0)&&(Y_enable == 0)){
										flag_mustcut = 1;
										m_cut = m; //запомнить бокс, за которым пришлось ставить X_line
										if (boxes_new[m][x0]<X_line){
											//X_line = boxes_new[m][x0];
											first_Y_en = 1;
											if(Y_enable == 1){
												for(f = 1; f<=Count; f++){
													if((boxes_new[f][x0] < boxes_new[m][x0])&&(boxes_new[f][x0] > Xmin+5)
															&&(boxes_new[f][xn] == X_draw_old - 1)){
														X_line = boxes_new[f][x0];
														Area_bef_y = Area_new[f] + ar_cut + 200;
													}
												}
												ar_cut = 0;
											}
											else{
												Y_enable = 1;
												X_line = boxes_new[m][x0];
												Area_bef_y = Area_new[m];
											}
											a = (float)Area_bef_y/(float)Area_mean;
											b_yen = a;
											c = a - b_yen;
											if(c > 0.400){
												printf("up_3 \r\n");
												Fish_Counter = Fish_Counter + b_yen + 1;
											}
											else{
												printf("up_4 \r\n");
												Fish_Counter = Fish_Counter + b_yen;
											}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
											if (boxes_new[m_cut][y0] < boxes_new[m_cut+1][y0]){
												Y_line = boxes_new[m_cut][yn];
												yn_cut = 1;
											}
											else{
												Y_line = boxes_new[m_cut][y0];
												y0_cut = 1;
											}//else
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
										}//if (boxes_new[m][x0]<X_line)
									}//if  ((boxes_new[m][xn]>=(Xmax-20)) && (m<n))
								}//if (((boxes_new[m][x0]>boxes_new[n][x]).....
							}//for (n = 1; n <= Count; n++)

							//					if boxes_new[m][xn] > X_line
							//						count_boxes = count_boxes + 1;
							//					}
							//printf("f_c =  %d\n", flag_cross);
							if (flag_cross == 0){ // ЕСЛИ ПРОСТОЙ БЛОБ
								// Первый раз такое в текущем кадре?
								if (first == 1){
									X_line = boxes_new[m][x0]; // инициализация
									//printf("fir \r\n");
									first = 0;
									if(Y_enable == 1){
										printf("1111 \r\n");

										for (k = 1; k<=Count; k++){
											if(boxes_new[k][xn] == X_draw_old - 1){
												if(Area_new[k] > Area_remain){
													Area_remain = Area_new[k];
													m_remain = k;
												}

											}
										}
									}
								}
								if  ((boxes_new[m][x0] <= X_line)&&(first == 0)){// если следующий блоб левее
									X_line = boxes_new[m][x0];
								}
							}//if (flag_cross == 0)
							else{
								if((boxes_new[m][xn] == X_draw_old - 1)&&(Y_enable == 1)
										&&(boxes_new[m][x0] > x0_cut_end)&&(m_remain == 0)){
									x0_cut_end = boxes_new[m][x0];
									X_line = boxes_new[m][x0];
									if(X_line == Xmin){
										X_line = X_line_old;
									}
									/*len_to_draw_1 = X_draw_old - boxes_new[m][x0];
									if(len_to_draw_1 < len_to_draw){
									len_to_draw = len_to_draw_1;
									X_line = boxes_new[m][x0];
								}*/
								}
							}
				//			}
						}//if (boxes_new[m][x0]>(Xmin+5)&&(Flag_calibrate == 0))
					}//for (m = 1: m <= Count; m++)
					x0_cut_end = 0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					//Расчет скорости для правой границы самого левого бокса
					if((boxes_new[Count][xn] < Xmax)&&(boxes_new[Count][x0]!=(X_line))&&(Count > 0)){ //если правая граница самого левого бокса не дошла до края, а левая не X_line
//						printf("3_1 \r\n");
//						printf("l_b_f_c = %d\t", left_box_frame_cnt);
						flag_vel_en = 1;
						left_box_frame_cnt = left_box_frame_cnt + 1; //то считаются кадры, за сколько бокс пройдет от края до края
						if (left_box_frame_cnt == 0){
							vel_left_box = 0;
						}
						else{
							vel_left_box = (boxes_new[Count][xn] - Xmin)/left_box_frame_cnt; //сразу рассчитывается скорость
						}
						//first_delta_x = true;
					}//if((boxes_new[Count][xn] < Xmax).....
					else{
						if (flag_vel_en == 1){
							printf("3_2 \r\n");
							flag_vel_en = 0;
							flag_vel_left = 1;	//если бокс дошел до границы, или X_line перешел на левую границу бокса, то перестать считать скорость
							left_box_frame_cnt = 0; //и обнулить кадры
//							printf("f_v_c =  %d\n", fish_vel_calibrate);
							printf("v_l_b =  %d\n", vel_left_box);
							if(vel_left_box < fish_vel_calibrate*0.7){ //если скорость получилась слишком маленькая
								vel_left_box = fish_vel_calibrate*0.7; //то принять скорость за калибровочную
							}//if((vel_left_box < fish_vel_calibrate*0.8)....
							if(vel_left_box >fish_vel_calibrate*1.4){ //или слишком большая
								vel_left_box = fish_vel_calibrate*1.4; //то принять скорость за калибровочную
							}//if((vel_left_box < fish_vel_calibrate*0.8)....
						}//if (flag_vel_en = 1)
					}//else


					//// Вычисление X_Draw
					// добавление предсказания (пикселей за кадр)
					//if (first_delta_x && (N_fish_calibrate == Fish_Counter))
					if (flag_vel_left == 1){
//						printf("4 \r\n");
						if (vel_left_box < (fish_vel_calibrate * 1.5)){
							if (vel_left_box > (fish_vel_calibrate * 0.6)){
								delta_x = vel_left_box; //шаг принять за скорость бокса в начальный момент
							}
							else{
								delta_x = fish_vel_calibrate * 0.5;
							}
						}
						else{
							delta_x = fish_vel_calibrate;
						}
			//			first_delta_x = false;
						flag_vel_left = 0; //флаг начального момента
					}
//					X_draw_old = X_Draw;
					printf("v_l_b=  %d\n", vel_left_box);
					delta_x_old = delta_x; //запомнить старое значение шага
					if(X_line > X_line_old ){ //если X_line сдвинулся
						printf("x_l_m  \r\n");
						step_x = X_line - X_line_old - 3; //то рассчитать новый шаг(-3,т.к. X_line а 3 пикселя дальше)
						if ((step_x < (fish_vel_calibrate * 1.7))||(step_x > 250)){ //если шаг не слишком большой
							if ((step_x > (fish_vel_calibrate * 0.5))&&(step_x < 250)){// и не слишком маленький
								delta_x = step_x; //то принимается этот
							}
							else{
								delta_x = fish_vel_calibrate * 0.5; //если слишком маленькая, то принимается половина калибровочной скорости
							}
						}//if (step_x < vel_mean_calibrate * 1.4)
						else{
							delta_x = fish_vel_calibrate; //если слишком большая, то принимается калибровочная
						}
					}//if(X_line > X_line_old)
					else{
						if ((X_line > Xmin)&&(X_line < Xmax)&&(X_line_old == X_line)){ //если X_line остался в поле на том же месте
							delta_x = delta_x_old; //если нет, то оставить старый шаг
							//delta_x = delta_x_old; //то оставить старый шаг
							if((flag_cross == 1)||(flag_big == 1)||(empty_line == 1)){
								X_line = X_line + delta_x; //сместить X_line
							}
						}
						else{
							delta_x = delta_x_old; //если нет, то оставить старый шаг
						}
					}//else(if(X_line > X_line_old))


					X_Draw = X_line + delta_x;
					if (first_Y_en == 1){
						Y_Draw = Y_line;
						//Y_Draw_old = Y_Draw;
						first_Y_en = 0;
					}
					else{
						Y_Draw = 220;
					}

					//// Цепочка
					for (m = 1; m <= Count; m++){
						if((boxes_new[m][x0] == Xmin)&&(boxes_new[m][xn] == Xmax)){//если появилась цепочка
			        		sub = sub + 1; //кадры до новой фиксации площади
			        		if((corr < fish_vel_calibrate * 0.5)||(corr < fish_vel_calibrate * 1.5)){
			        			corr = corr_bef;
			        		}
			        		frame_cnt_constant = (float)len_field/(float)corr; //сколько кадров потребовалось для прохождения от края до края поля
/*			        		b = a;
			        		c = a - b;
			        		printf("c_fcnt = %f\n", c);
			        		if (c > 0.500){
			        			frame_cnt_constant = b + 1;
			        		}
			        		else{
			        			frame_cnt_constant = b;
			        		}*/
			        		printf("f_c_c = %f\n", frame_cnt_constant);
			        		frame_cnt_var = frame_cnt_constant - sub; //сколько кадров осталось до новой фиксации площади
//			        		last_string_vel = corr; //запись последней скорости (делается для того, что при разрыве цепочки, корреляция выдает неадекватную скорость)
			 //       		box_string_frame_cnt = box_string_frame_cnt - 1;//уменьшается число кадров  для цепочки(кадры, за сколько бокс прошел от границы до границы)
			        		frame_cnt_in_string = frame_cnt_in_string + 1;//увеличивается число кадров цепочки(сколько кадров всего была цепочка)
			        		if(fish_string_flag == 0){//если в первый раз
//			        			fish_string_flag = 1;//флаг цепочки в 1
			        			for (n = 1; n <= Count; n++){
			        				box_area_cnt = box_area_cnt + Area_new[n];//записывается текущая площадь боксов в кадре
			        				if((boxes_new[n][x0] == Xmin)&&(boxes_new[n][xn] == Xmax)){
			        					fish_string_flag = 1;
			        					if(Y_enable == 1){
			        						box_area_cnt = box_area_cnt + ar_cut;
			        						ar_cut = 0;
			        						Y_enable = 0;
			        					}
			        					break;
			        				}
			        			}
			        			//frame_cnt_constant_first = frame_cnt_constant; //сколько кадров потребовалось для прохождения поля при появлении цепочки
			        			printf("f_ar = %d\n", box_area_cnt);
			//       			box_string_frame_cnt = uint8(round(len_field/uint16(vel_left_box))) - 1;%5.08.15
			            		//box_string_frame_cnt = uint8(round(len_field/uint16(fish_vel_mean))) - 1;%вычисляется, за сколько правая граница бокса прошла от края до края
			//       			frame_cnt_constant = box_string_frame_cnt%записывается, чтобы потом можно было обновить
			        		}//if(fish_string_flag == 0)
			        		if((fish_string_flag == 1)&&((frame_cnt_var <= 0.499)||(frame_cnt_var > 200))){//если цепочка продолжается и предыдущая часть уже ушла
			        			last_add_area = 0;
			        			for (n = 1; n <= Count; n++){
			        				box_area_cnt = box_area_cnt + Area_new[n];//добавляется текущая площадь в кадре
			        				last_add_area = last_add_area + Area_new[n];
			        			}
			//             	  	box_string_frame_cnt = frame_cnt_constant;%обновляются кадры для цепочки
			        			sub = 0;
			        		}//if((fish_string_flag == 1)&&(frame_cnt_var <= 0))
						}//if((boxes_new[m][x0]==Xmin)&&(boxes_new[m][xn]==(Xmax))){
			        	else{//если цепочка закончилась
			//       		box_string_frame_cnt = box_string_frame_cnt - 1;%уменьшение в последний раз
//			        		frame_cnt_var = len_field/last_string_vel - sub;//(sub + 1));
			        		if((fish_string_flag == 1)&&(error_else_string == 0)){
			        			for (n = 1; n <= Count; n++){//проверяется ошибочность выполнения ветки else
			        				if((boxes_new[n][x0] == Xmin)&&(boxes_new[n][xn] == Xmax)){
			        					error_else_string = 1;//если цепочка все-таки есть, то ветка ошибочна
			        					break;
			        				}
			        			}
			        			if(error_else_string == 0){//если цепочка на самом деле закончилась
			        				for(n = 1; n <= Count - 1; n++){
			        					if((boxes_new[n][x0] > boxes_new[n+1][xn])&&//если
			        							(boxes_new[n][x0] == X_line)&&//X_line слишком далеко
			        							(X_line > Xmin + corr*1.1)){//и далее есть блобы
			        						flag_gap = 1;//значит произошел разрыв
			        					}
			        				}
			        				//поменял last_string_vel на corr
			        				if((corr < fish_vel_calibrate * 0.5)||(corr < fish_vel_calibrate * 1.5)){//проверяется корректность скорости
			        					corr = corr_bef;
			        				}
			        				frame_cnt_last = (float)len_field/(float)corr; //сколько кадров потребовалось для прохождения от края до края поля
/*					        		b = a;
				        			c = a - b;
				        			printf("c_fcnt_2 = %f\n", c);
				        			if (c > 0.500){
				        				frame_cnt_last = b + 1;
				        			}
				        			else{
				        				frame_cnt_last = b;
				        			}*/
			        				frame_cnt_var = frame_cnt_last - sub;//(sub + 1);
			        				fish_string_flag = 0; //обнуление флага
			        				if((frame_cnt_var <= 0.499)||(frame_cnt_var > 190)){ //если кадров прошло как раз до новой фиксации
//			        					last_area = Area_new[1]; //то последняя площадь и есть площадь в кадре
			        					area_between = 0;
			        				}
			        				else{
			        					//////////////////////////////изменил frame_cnt_in_string на (frame_cnt_in_string - 1)
//			        					area_on_frame = box_area_cnt/((frame_cnt_in_string - 1) + frame_cnt_constant_first);//иначе - расчет площади за кадр
			        					for (n = 1; n <= Count; n++){
			        						if ((boxes_new[n][x0] >= X_line)||((boxes_new[n][xn]==Xmax)&&(boxes_new[n][x0]>Xmin))){
			        							last_area_cnt = last_area_cnt + Area_new[n];
			        						}
			        					}
			        					if (flag_gap == 0){//если цепочка кончилась без разрыва
			        						//area_on_frame = Area_new[1]/frame_cnt_last;
			        						area_on_frame = last_area_cnt/frame_cnt_last;//расчет площади за кадр
			        					}
			        					else{//если цепочка закончилась разрывом
			        						area_on_frame = last_add_area/frame_cnt_constant;//то расчет площади за кадр в прошлой фиксации
			        						//box_area_cnt = box_area_cnt + last_area_cnt - last_add_area;//отмена прибавки последней площади и добавление текущей
			        						box_area_cnt = box_area_cnt + area_on_frame - last_add_area;
			        						sub++;
			        					}
			        					//area_between = (frame_cnt_var + 1) * area_on_frame;
			        					area_between = sub * area_on_frame;
//			        					last_area = area_on_frame*(frame_cnt_constant - frame_cnt_var); //и расчет площади в боксе в последнем кадре
			        				}
			        				//box_area_cnt = box_area_cnt + Area_new[1] - area_between; //добавление этой площади к общей
			        				box_area_cnt = box_area_cnt + area_between;

			        				printf("f_g = %d\n", flag_gap);
			        				printf("f_c_var = %f\n", frame_cnt_var);
			        				printf("l_a_cnt = %d\n", last_area_cnt);
			        				printf("b_a_cnt = %d\n", box_area_cnt);
//			        				fish_in_string = round(box_area_cnt/fish_area_mean);//расчет рыб в цепочке
			        				a = (float)box_area_cnt/(float)Area_mean;
			        				b = a;
			        				c = a - b;
			        				printf("c = %f\n", c);
			        				printf("b = %d\n", b);
			        				if (c > 0.400){
			        					fish_in_string = b + 1;
			        				}
			        				else{
			        					fish_in_string = b;
			        				}

			        				//Fish_Counter = Fish_Counter + fish_in_string;//добавление к счетчику
			        				Fish_Counter = Fish_Counter + 2;
			        				string_add_en = 1;
			        				printf("sub = %d\n", sub);
			        				printf("ar_bet = %d\n", area_between);
			        				sub = 0;
			        				flag_gap = 0;
/*			        				printf("b_a_c = %d\n", box_area_cnt);
			        				printf("a_o_f = %d\n", area_on_frame);
			        				printf("f_c_l = %f\n", frame_cnt_last);
			        				printf("f_c_v = %f\n", frame_cnt_var);
			        				printf("f_c_s = %d\n", frame_cnt_in_string);
			        				//printf("f_c_c_f = %d\n", frame_cnt_constant_first);
			        				printf("f_in_s = %d\n", fish_in_string);
*/
			        				frame_cnt_var = 0;
			        				box_area_cnt = 0;
			        				last_area_cnt = 0;
			        				frame_cnt_in_string = 0;
			        			}//if(error_esle_string == 1)
			        		}//if(fish_string_flag == 1)
			        	}//если цепочка закончилась
					}//for (m = 1; m <= Count; m++)
					corr_bef = corr;

					//// Подсчет
					if((fish_string_flag == 0)&&(Flag_calibrate == 0)&&(flag_mustcut == 0)){
//						printf("6 \r\n");
						for (m = 1; m <= Count; m++){
							if ((boxes_new[m][x0]>=X_line)&&(boxes_new[m][x0]<X_draw_old)){
//								d = Area_mean/2.4;
//								printf("C = %d\t", Count);
//								printf("m = %d\t", m);
//								printf("b_n_x0 = %d\t", boxes_new[m][x0]);
//								printf("b_n_xn = %d\t", boxes_new[m][xn]);
								fish_len = boxes_new[m][xn] - boxes_new[m][x0];
								fish_height = boxes_new[m][yn] - boxes_new[m][y0];
//								printf("f_l = %d\n", fish_len);
//								printf("f_h = %d\n", fish_height);
//								printf("A_n = %d\n", Area_new[m]);
//								printf("f_m = %d\n", flag_mustcut);
//								printf("MREM = %d\n", m_remain);
//								printf("M = %d\n", m);
								if((Y_enable == 1)&&(m == m_remain)){
//									printf("AR_1 = %d\n", Area_new[m]);
									Area_new[m] = Area_new[m] + ar_cut + 500;
//									printf("AR_CUT = %d\n", Area_new[m]);
									Y_enable = 0;
									ar_cut = 0;
									Area_remain = 0;
									m_remain = 0;
								}
								if((Y_enable == 1)&&(m_remain == 0)){
									Area_new[m] = Area_new[m] + ar_cut + 500;
									Y_enable = 0;
									ar_cut = 0;
									Area_remain = 0;
									m_remain = 0;
								}
								printf("a_n = %d\n", Area_new[m]);
								printf("f_l = %d\n", fish_len);
								printf("f_h = %d\n", fish_height);
								if ((Area_new[m] < d)&&(flag_mustcut == 0)&&(((fish_len > 190)&&(fish_height > 45))||
										((fish_len > 85)&&(fish_height > 120)))){
									printf("up_2 \r\n");
									Fish_Counter++;
								}

								/*if((Area_new[m] < d)&&(boxes_new[m][x0] != X_Draw_old + 3)&&(boxes_new[m][xn] != X_Draw_old - 1)){
									Fish_Counter = Fish_Counter + 1;
								}*/
//								printf("ar_or = %d\t", Area_new[m]);
//								printf("ar = %d\t", d);
								if (Area_new[m] >(d)){
									if (!((boxes_new[m][x0] >= X_line_old)&&(boxes_new[m][x0] <= X_draw_old))){// можно подпарвить на примыкает к x_draw_old
//										N = round(Area_new[m]/Area_mean);
										printf("up \r\n");
										a = (float)Area_new[m]/(float)Area_mean;
										printf("a = %f\n", a);
										b = a;
										printf("b = %d\n", b);
										c = a - b;
										printf("c = %f\n", c);
										if (c > 0.370){
											N = b + 1;
										}
										else{
											if((boxes_new[m][xn] == Xmax)&&(c > 0.200)){
												N = b + 1;
											}
											else{
												N = b;
											}
										}

										if(string_add_en == 0){
//											printf("up \r\n");
											printf("N = %d\n", N);
											Fish_Counter = Fish_Counter + N + f_cnt - b_yen;
//											Fish_Counter_vel = Fish_Counter_vel + N;
											f_cnt = 0;
											fish_in_string = 0;
											N = 0;
											b_yen = 0;
//											first = 1;
										}//if(string_add_en == 0)
									}//if (!((boxes_new[m][x0]>=X_line_old)&&(boxes_new[m][x0]<=X_draw_old)))
								}//if (Area_new[m] >(Area_mean/1.8))
							}//if ((boxes_new[m][x0]>=X_line)&&(boxes_new[m][x0]<X_draw_old))
						}//for (m = 1; m <= Count; m++)
					}//if((fish_string_flag == 0)&&(Flag_calibrate == 0))
					string_add_en = 0;
				}//else(Count==0)
				if((corr < 190)&&(corr != 124)&&(corr != 22)){
					corr_old = corr;
				}
				error_else_string = 0;
				flag_big = 0;
				empty_line = 1;
				*(fish_out_addr) = Fish_Counter;
				*(fish_area_addr) = Area_mean;
//				*(fish_len_addr) = fish_len_mean/1.43;
				*(x_cat_addr) = X_Draw;
				*(y_cut_addr) = Y_Draw;
//				Y_Draw = 220;

				printf("A_m = %d\t", Area_mean);
//				printf("Flag_calibrate = %d\t", Flag_calibrate);
				printf("X_l = %d\n", X_line);
				printf("X_l_o = %d\n", X_line_old);
				printf("X_d = %d\n", X_Draw);
				printf("X_d_o = %d\n", X_draw_old);
				printf("d_x = %d\n", delta_x);
				printf("s_x = %d\n", step_x);
				printf("d_x_o = %d\t", delta_x_old);
				printf("f_v_c =  %d\n", fish_vel_calibrate);
				printf("corr = %d\n", corr);
				printf("f_s_f = %d\t", fish_string_flag);
				printf("C = %d\n", Count);
//				printf("corr_m = %d\n", corr_mean);
//				printf("Area_cnt = %d\n", Area_cnt);
				for (m = 1; m <= Count; m++){
					printf("Area = %d\n", Area_new[m]);
				}
				printf("Y_en = %d\n", Y_enable);

//				printf("ar_cut = %d\n", ar_cut);
//				printf("fl_c = %d\n", flag_cross);
//				printf("fi = %d\n", first);
//				printf("fl_mc = %d\n", flag_mustcut);
//				printf("Y_en = %d\n", Y_enable);

				/*for (m = 1; m <= Count; m++){
					printf("b_x0 = %d\t", boxes_new[m][x0]);
					printf("b_xn = %d\t", boxes_new[m][xn]);
				}*/

				state = 0;
				break;
			}//state 4
			default:
				state = 0;
				break;
		}//switch
	}//while (1)
	return(0);

}//main
