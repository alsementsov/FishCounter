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

/*
uint8_t state = 0;
void 	*virtual_base;
int 	fd;
*/


//chmod +x appl
//./appl


#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )


//#define 	N_fish_calibrate	5 //8
//#define 	N_fish_calibrate	4 //5
uint32_t 	N_fish_calibrate = 0;

#define 	N_fish_max   		10
#define 	Del_x  				12

//��������� �������� �����
uint32_t 	fish_area_max = 4500; //3689; //2000; //v33 18000;
uint32_t 	fish_len_max = 110;//350; //247; //130; //v33 407;
uint32_t 	fish_vel_max = 117; //140; //187; //v33 117;

uint32_t  fish_area_max_2 = 0;


//������� ��������� �����
uint32_t 	fish_area_mean_cnt = 0;
uint32_t 	fish_area_mean = 0; //2159; //1500; //v33 11000;
uint32_t 	fish_len_mean_cnt = 0;
uint16_t 	fish_len_mean = 0; //310; //139; //v33 353;
uint32_t 	fish_vel_mean_cnt = 0;
uint16_t 	fish_vel_mean = 46; //65; //46;
uint32_t 	fish_life_mean_cnt = 0;
uint8_t 	fish_life_mean = 22;


//������������ ��������� ����
/*float 	K_len_max = 1.05;// v00 8 ���� //1,065
float 	K_len_min = 0.94;
float 	K_area_max = 1.08;
float 	K_area_n3 = 2.1; //V00 15�����//2.01; //v00- ������ ������� s7238 //1.96;
float 	K_string_len_max = 1.06;*/

float 	K_len_max = 0;// v00 8 ���� //1,065
float 	K_len_min = 0;
float 	K_area_max = 0;
float 	K_area_n3 = 2.1; //V00 15�����//2.01; //v00- ������ ������� s7238 //1.96;
float 	K_string_len_max = 0;

uint32_t 	test = 3689;

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
volatile uint16_t	*dx_corr_addr;

uint8_t  box_cnt = 0;


//��������� ������� ����
uint8_t 	fish_string_flag = 0;
uint8_t 	fish_string_area = 0;
uint16_t 	fish_string_life = 0;
uint8_t 	fish_string_box_life = 0;
uint16_t 	fish_string_fish_vel = 0;
uint32_t	box_area_cnt = 0;

uint16_t 	fish_string_fish_x0 = 0;
uint16_t 	fish_string_fish_xn = 0;
uint16_t 	fish_string_x0 = 0;
uint16_t 	fish_string_y0 = 0;
uint16_t 	fish_string_xn = 0;
uint16_t 	fish_string_yn = 0;


uint32_t 	fish_string_time = 0;

uint8_t 	f_life = 0;
uint16_t 	f_vel = 0;
uint16_t 	f_x0 = 0;
uint16_t 	f_xn = 0;


uint16_t 	f_len = 0;
uint16_t 	t_len = 0;
uint16_t 	fish_first_cnt = 0;


//������ ����������� �����
uint16_t 	t_fish = 0;
uint16_t 	t_string = 0;
float		st_len_1 = 0;
uint16_t 	fish_string_cnt = 0;

uint16_t 	box_len = 0;


//��������� ����� �����
uint8_t 	fish_flag[N_fish_max];
uint8_t	 	fish_mark_n[N_fish_max];
uint8_t 	fish_mark_n_z[N_fish_max];
uint32_t 	fish_box_area[N_fish_max];
uint16_t	fish_x0[N_fish_max];
uint16_t 	fish_y0[N_fish_max];
uint16_t 	fish_xn[N_fish_max];
uint16_t 	fish_yn[N_fish_max];

uint32_t	fish_time[N_fish_max];
uint8_t 	fish_life[N_fish_max];
uint16_t	fish_vel[N_fish_max];
uint8_t 	fish_vel_cnt[N_fish_max];

uint32_t 	fish_area[N_fish_max];
uint16_t 	fish_len[N_fish_max];
uint8_t 	fish_len_cnt[N_fish_max];

//����������
uint16_t 	fish_cnt = 0;
uint16_t 	fish_cnt_z = 0;
uint16_t 	fish_cnt_d = 0;

uint16_t 	box_cnt_z = 0;

uint16_t	box_xn = 0;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
uint8_t		frame_cnt = 0;
uint8_t		frame_cnt_constant = 0;
uint8_t		box_string_frame_cnt = 0;
uint16_t	frame_cnt_in_string = 0;
uint16_t	fish_in_string = 0;
uint16_t 	box_right_xn = 0;
uint32_t	fish_in_string_area = 0;
uint32_t	area_on_frame_cnt = 0;
float 		a = 0;
int			b = 0;
float		c = 0;
float		d = 0;
//uint8_t		g = 0;
uint8_t		f_c_d = 0;
uint8_t		box_cnt_before = 0;
uint8_t		box_m_flag = 0;
//uint8_t		string_en = 0;
uint32_t	fish_area_min = 0;
uint16_t	fish_len_min = 0;
uint16_t	frame_cnt_cnt = 0;
uint32_t	box_area_before = 0;
uint32_t	box_area_max_now = 0;
uint32_t	box_area_max = 0;
uint32_t	fish_area_mean_cal = 0;
uint16_t	len_before = 0;
uint16_t	len_max_now = 0;
uint16_t	len_max = 0;
uint16_t	len_cnt = 0;
uint16_t	fish_len_min_1 = 0;
uint8_t		fish_cnt_in_box = 0;
uint16_t	len_field = 0;
uint16_t	area_on_frame = 0;
uint16_t	last_area = 0;
uint8_t		box_vel = 0;
uint8_t		box_before = 0;
uint8_t		first = 0;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

uint32_t	fish_area_m = 0;
uint16_t	fish_len_m = 0;
uint16_t	fish_v_m = 0;

uint8_t 	time_wait = 1;

uint8_t 	m_fish_x0 = 0;
uint8_t 	mark_n_old = 0;

uint8_t 	cross_x = 0;
uint8_t 	cross_y = 0;
uint8_t 	cross_x_2 = 0;
uint8_t 	cross_x_3 = 0;
uint8_t 	cross_box = 0;

int32_t		vel_1;
int32_t		vel_2;

uint16_t 	len = 0;

float	dx = 0;
float	dy = 0;
float	fish_div = 0;

uint16_t	vel = 0;
float		div_x = 0;

float		fish_area_dob =  0;
float		fish_len_dob =  0;
float		fish_v_dob = 0;

uint8_t 	fish_cnt_en = 0;

int16_t 	box_n_new = 0;
uint8_t 	mark_n_new = 0;
uint8_t 	fish_n_min = 0;
uint8_t 	new_fish = 0;


uint32_t		time_cnt = 0;
uint32_t		time_cnt_z = 0;


//������� ������
uint8_t  	ram_addr = 0;
uint16_t 	box[N_fish_max][4];
uint32_t 	box_area[N_fish_max];

uint8_t 	box_flag[N_fish_max];
uint8_t 	box_flag_z[N_fish_max];
uint8_t 	fish_cross[N_fish_max];
uint8_t 	fish_cross_z[N_fish_max];
uint8_t 	fish_link[N_fish_max];
uint8_t 	box_cross[N_fish_max];
uint8_t 	box_cross_z[N_fish_max];

uint16_t 	N_fish = 0;
uint16_t 	N_fish_z = 0;

uint16_t  	x0_min = 0;
uint16_t  	xn_max = 0;
uint16_t  	x_mean = 0;
uint16_t  	x_cat = 0;
uint16_t	corr = 0;

uint16_t  	box_lef_x0 = 0;
uint16_t  	box_lef_xn = 0;

uint8_t  	fish_cross_en = 0;
uint8_t  	fish_string_end = 0;

//���������� �����
uint8_t i = 0;
uint8_t m = 0;
uint8_t n = 0;
uint8_t f = 0;

int main() {

	printf("Hello DE1_SOC!\r\n");

	//������� ������
	memset(fish_flag, 0, sizeof(fish_flag));
	memset(fish_mark_n, 0, sizeof(fish_mark_n));
	memset(fish_mark_n_z, 0, sizeof(fish_mark_n_z));
	memset(fish_box_area, 0, sizeof(fish_box_area));

	memset(fish_x0, 0, sizeof(fish_x0));
	memset(fish_y0, 0, sizeof(fish_y0));
	memset(fish_xn, 0, sizeof(fish_xn));
	memset(fish_yn, 0, sizeof(fish_yn));

	memset(fish_time, 0, sizeof(fish_time));
	memset(fish_life, 0, sizeof(fish_life));
	memset(fish_vel, 0, sizeof(fish_vel));
	memset(fish_vel_cnt, 0, sizeof(fish_vel_cnt));

	memset(fish_area, 0, sizeof(fish_area));
	memset(fish_len, 0, sizeof(fish_len));
	memset(fish_len_cnt, 0, sizeof(fish_len_cnt));

	memset(box, 0, sizeof(box));
	memset(box_area, 0, sizeof(box_area));
	memset(box_flag, 0, sizeof(fish_len_cnt));
	memset(fish_cross, 0, sizeof(fish_cross));
	memset(fish_link, 0, sizeof(fish_link));

	//�������������
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

	//���������� �����
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

met1:
	//������� ���������
	if (*(test_cnt_balls_addr) == 1) {
		fish_cnt = 0;
		fish_area_mean_cnt = 0;
		fish_area_mean = 0; //2159; //1500; //v33 11000;
		fish_len_mean_cnt = 0;
		fish_len_mean = 0; //310; //139; //v33 353;
		fish_vel_mean_cnt = 0;
		fish_vel_mean = 46; //65; //46;
		fish_life_mean_cnt = 0;
		fish_life_mean = 22;
		K_len_max = 1.03;// v00 8 ���� //1,065
		K_len_min = 0.96;
		K_area_max = 1.05;
		K_string_len_max = 1.05;
		fish_area_mean_cal = 0;
		len_cnt = 0;
		fish_len_min_1 = 87;
	}
	else {
		if(*(sw_mass_addr) == 1){
			fish_cnt = 0;
			fish_area_mean_cnt = 0;
			fish_area_mean = 0;
			fish_len_mean_cnt = 0;
			fish_len_mean =  0;
			fish_vel_mean_cnt = 0;
			fish_vel_mean = 46;
			fish_life_mean_cnt = 0;
			fish_life_mean = 22;
			K_len_max = 1.15;// v00 8 ���� //1,065
			K_len_min = 0.90;
			K_area_max = 1.17;
			K_string_len_max = 1.13;
			fish_area_mean_cal = 0;
			len_cnt = 0;
			fish_len_min_1 = 250;
		}
		if(*(sw_mass_addr) == 2){
			fish_cnt = 0;
			fish_area_mean_cnt = 0;
			fish_area_mean = 0;
			fish_len_mean_cnt = 0;
			fish_len_mean =  0;
			fish_vel_mean_cnt = 0;
			fish_vel_mean = 46;
			fish_life_mean_cnt = 0;
			fish_life_mean = 22;
			K_len_max = 1.15;// v00 8 ���� //1,065
			K_len_min = 0.94;
			K_area_max = 1.12;
			K_string_len_max = 1.06;
			fish_area_mean_cal = 0;
			len_cnt = 0;
			fish_len_min_1 = 330;
		}
		if(*(sw_mass_addr) == 3){
			fish_cnt = 0;
			fish_area_mean_cnt = 0;
			fish_area_mean = 0;
			fish_len_mean_cnt = 0;
			fish_len_mean =  0;
			fish_vel_mean_cnt = 0;
			fish_vel_mean = 46;
			fish_life_mean_cnt = 0;
			fish_life_mean = 22;
			K_len_max = 1.1;// v00 8 ���� //1,065
			K_len_min = 0.95;
			K_area_max = 1.1;
			K_string_len_max = 1.04;
			fish_area_mean_cal = 0;
			len_cnt = 0;
			fish_len_min_1 = 395;
		}
//		fish_area_mean_cnt = 0;
//		fish_area_mean = 9000; //2159; //1500; //v33 11000;
//		fish_len_mean_cnt = 0;
//		fish_len_mean = 340; //310; //139; //v33 353;
//		fish_vel_mean_cnt = 0;
//		fish_vel_mean = 46; //65; //46;
//		fish_life_mean_cnt = 0;
//		fish_life_mean = 22;
	}


	//�����������
	state = 0;

//uint16_t	x_mean1 = 0;
//uint16_t	x_mean2 = 0;
//uint16_t	a = 3;
//uint16_t	c = 2;
	*(con_yark_addr) = 80;
	*(x1_0_addr) = 40;
	*(x2_0_addr) = 640;
	*(y1_0_addr) = 60;
	*(y2_0_addr) = 192;
	*(del_x_addr) = 82;
	*(del_y_addr) = 17;
	x0_min = *(x_min_addr);
	xn_max = *(x_max_addr);
//	corr = *(dx_corr_addr);
	//*(x_cat_addr) = 650;
	x_mean = ( x0_min + (xn_max - x0_min)*0.65);
	printf("x0_min = %d\r\n", x0_min);
	printf("xn_max = %d\r\n", xn_max);
	printf("x_mean = %d\r\n", x_mean);

	printf("1 %d\r\n", 	(int)(test*2.1));
	printf("1 %d\r\n", 	(int)(test*K_area_n3));
	*(fish_area_addr) = 0;
	*(fish_len_addr) = 0;
	len_field = xn_max - x0_min;
//x_mean2 = a/c;
//x_mean2 = ceil(1.9);

//	printf("x_mean1 = %d\r\n", x_mean1);
//	printf("x_mean2 = %d\r\n", x_mean2);


	//������� ����
	while( 1 ) {
		//�����
		if(*(reset_cnt_addr) == 1) {
			goto met1;
//			fish_cnt = 0;
//			fish_area_mean_cnt = 0;
//			fish_area_mean = 9000; //2159; //1500; //v33 11000;
//			fish_len_mean_cnt = 0;
//			fish_len_mean = 340; //310; //139; //v33 353;
//			fish_vel_mean_cnt = 0;
//			fish_vel_mean = 46; //65; //46;
//			fish_life_mean_cnt = 0;
//			fish_life_mean = 22;
		}
		//����� � ���������
//		*(led) = state;

		//printf("while 1 \r\n");
		//printf("state = %d\r\n", state);

		switch (state) {

			case 0 : {
				//printf("state_0 \r\n");

				//����� ��������
				for(i=1; i < N_fish_max; i++)
				{
					box[i][x0] = 0;
					box[i][y0] = 0;
					box[i][xn] = 0;
					box[i][yn] = 0;
					box_area[i] = 0;
					box_flag_z[i] = box_flag[i];
					box_flag[i] = 0;
					fish_cross_z[i] = fish_cross[i];
					fish_cross[i] = 0;
					fish_link[i] = 0;
					box_cross_z[i] = box_cross[i];
					box_cross[i] = 0;
				}


				*(req_res) = 0;
				*(addr_out) = 0;
				//*(reset_cnt_addr) = 0;
				state = 1;
				break;
			}

			//�������� ������ �����
			case 1 : {


				//printf("state_1 \r\n");
				if (*(box_req + 3) == 1 )
				{
					//���������� ����
					*(box_req + 3) = 0;
					box_cnt = *(box_n_addr);
					//printf("box_cnt = %d\r\n", box_cnt);

					//time_cnt_z = time_cnt;
					time_cnt = time_cnt + 1;

					//time_cnt_z = *(n_frame_addr);
					N_fish_calibrate = *(n_frame_addr);

//					printf("%d\t", (time_cnt ));
					//
//					printf("%d\t", (N_fish_calibrate ));

					if (box_cnt > 0)
					{
						ram_addr = 0; //1
						*(addr_out) = ram_addr; //���������� ����� �����
						state = 2;
					}
					else {
						state = 3;
					}
				}
				break;
			}
			//������ ������� ������
			case 2 : {

				//printf("state_2 \r\n");
				//���� ������ �����
				if (*(box_addr) == ram_addr)
				{
					//����� �������� �������� ��� �� ������ ���

					box[(ram_addr+1)][x0] = *(box_x0_addr);
					box[(ram_addr+1)][y0] = *(box_y0_addr);
					box[(ram_addr+1)][xn] = *(box_xn_addr);
					box[(ram_addr+1)][yn] = *(box_yn_addr);
					box_area[(ram_addr+1)] = *(n_pix_addr);
					box_flag[(ram_addr+1)] = 1;

					if (((ram_addr + 1) < box_cnt)&&
						((ram_addr + 1) < N_fish_max))
					{
						//������ ������
						ram_addr = ram_addr + 1;
						*(addr_out) = ram_addr; //���������� ����� �����
					}
					else {
						//������� ��������� ���
						state = 4; //state = 3;
					}
				}
				break;
			}
			case 3 : {

				//printf("state_3 \r\n");
				//�������� ������ ��������
				for(i=(box_cnt + 1); i < N_fish_max; i++)
				{
					box[i][x0] = 0;
					box[i][y0] = 0;
					box[i][xn] = 0;
					box[i][yn] = 0;
					box_area[i] = 0;
					box_flag[i] = 0;
				}
				state = 4;
				break;
			}
			case 4 : {

				//printf("box= %d\t", box_cnt);
				if(box_cnt > 0)
				{

					for(i=1; i <= box_cnt; i++)
					{
						//printf("n = %d\t", i);
						//printf("box_x0 %d\t", box[i][x0]);
						//printf("box_y0 %d\t", box[i][y0]);
						//printf("box_xn %d\t", box[i][xn]);
						//printf("box_yn %d\t", box[i][yn]);
//						printf(" %d\t", box_area[i]);
						if (box_area[i] > (((box[i][xn] - box[i][x0])*(box[i][yn] - box[i][y0]))))
						{
							//printf("box_S %d\t", ((box[i][xn] - box[i][x0])*(box[i][yn] - box[i][y0])));
						}
						//printf("\r\n");

					}
				}

				state = 5;
				break;
			}

			case 5 : {
				//�������� ����� ���������
				//����������� ���� ��� ����� ������� �����
				//printf("start_0\r\n");
				corr = *(dx_corr_addr);
				printf("corr= %d\t", corr);
				box_xn = *(box_xn_addr);
				if(fish_cnt == N_fish_calibrate)
				{
					//if(fish_len_mean >=  320)
					if(fish_len_mean >=  290)
					{
						K_len_max = 1.07;
						K_area_max = 1.07;
						K_area_n3 = 3;

//						K_len_max = 1.2;
//						K_area_max = 1.2;
//						K_area_n3 = 3;
					}
					//else {
						//��������� ��� ����
						//K_len_max = 1.06;
						//K_area_max = 1.08;
						//K_area_n3 = 2.10; //v00 //1.96;
					//}
				}

				/*if((box[box_cnt][xn] >= x0_min + fish_vel_mean)&&
				 * 	(box[box_cnt][xn] <= xn_max - fish_vel_mean)){
				 * 		g++;
				 * 		box_vel_cnt = box_vel_cnt + box[box_cnt][xn];
				 * }
				 * if(box[box_cnt][xn] >= xn_max - fish_vel_mean){
				 * 		box_vel = box_vel_cnt/g;
				 * 		g = 0;
				 * }
				 */
				//����� ��� ������ ������� ������ �����
				/*if ((box_cnt == 1)&&(box_xn < xn_max)){
					box_m_flag = 0;
					f_c_d++;
					frame_cnt = f_c_d;
					//printf("xn_box= %d\t", box_xn);
					//printf("f_cnt= %d\t", frame_cnt);
				}
				else{
					//���� ������ ���������, �� ����� ������ ������� ������ ������ �����
					if ((box_cnt >= 2)&&(box_cnt <= box_cnt_before)){
						box_m_flag = 1;
						for (m = 2; m <= box_cnt; m++){
							if(box[m][xn] < box[m-1][xn]){
								box_right_xn = box[m][xn];
							}
						}
						//����� ��� ������ ������ �����
						if (box_right_xn < xn_max){
							f_c_d++;
							frame_cnt = f_c_d;
//							printf("xn_box= %d\t", box_xn);
//							printf("f_cnt= %d\t", frame_cnt);
						}
					}
					else{
						f_c_d = 0;
					}
				}
//				printf("fcd= %d\t", f_c_d);
				box_cnt_before = box_cnt;

				if (box_m_flag == 1){
					frame_cnt = frame_cnt + 1;
				}*/

				//����� ������ ������ �������
				for (m = 1; m <= box_cnt; m++)
				{
					if((box[m][x0] == x0_min)&&(box_lef_xn < box[m][xn]))
					{
						box_lef_x0 = x0_min;
						box_lef_xn = box[m][xn];
					}
				}
				//������ ������� ���
				fish_cross_en = 0;
				fish_string_end = 0;

				printf("box_1_x0= %d\t", box[1][x0]);
				printf("box_1_xn= %d\t", box[1][xn]);
				printf("box_cnt_bef_str= %d\t", box_cnt);
				//������� ������� ����
				if ((box[1][x0] == x0_min)&&(box[1][xn] == xn_max)&&(box_cnt == 1)&&(box_area[1] > 500))
				{
					printf("b_s_f_c= %d\t", box_string_frame_cnt);
					box_string_frame_cnt--;
					frame_cnt_in_string++;
					printf("frame_cnt= %d\t", frame_cnt_in_string);
					printf("fish_string_flag= %d\t", fish_string_flag);
					//printf("b_s_f_c= %d\t", box_string_frame_cnt);
					/*if (g == 0){
						box_string_frame_cnt = frame_cnt - 1;
						//printf("b_s_f_c= %d\t", box_string_frame_cnt);
						//printf("f_cnt= %d\t", frame_cnt);
						box_area_cnt = box_area[1];
					}
					if ((g > 0) && (box_string_frame_cnt == 0)){
						box_area_cnt = box_area_cnt + box_area[1];
						box_string_frame_cnt = frame_cnt - 1;
						//printf("b_c_cnt= %d\t", box_area_cnt);
					}*/
					//���� �� ������� �� �����
					if(fish_string_flag == 0)
					{
						printf("string_en ");
						fish_string_flag = 1;
						box_area_cnt = box_area[1];
						//��������� ��������� ������� � ������������ ������� �����
						f_life = 1;
						f_vel = 0;
						f_x0 = 0;
						f_xn = 0;
						//g = 1;

						for(m = 0; m < N_fish_max; m++)
						{
							if ((fish_flag[m] == 1)&&
							(fish_x0[m] <= (xn_max - fish_vel_mean))&&//??
							(fish_life[m] > f_life))
							{
								f_life = fish_life[m];
								f_vel = (uint16_t) (((float)fish_vel[m])/ ((float)fish_vel_cnt[m]));//??
								printf("fish_vel= %d\t", fish_vel[m]);
								f_x0 = fish_x0[m];
								f_xn = fish_xn[m];
							}
						} //for m = 1 : 1 : N_fish_max

						fish_string_box_life = f_life;
						fish_string_fish_vel = f_vel;
						fish_string_fish_x0 = f_x0;
						fish_string_fish_xn = f_xn;
						fish_string_life = 0;
						printf("f_vel= %d\t", f_vel);
						/*if((box_vel == 0) || (box_vel > fish_vel_mean*1.1)){
						  	 box_string_frame_cnt = (len_field / fish_vel_mean) - 1;
						  	 frame_cnt_constant = box_string_frame_cnt;
						  }
						  else{
						  	  box_string_frame_cnt = (len_field / box_vel) - 1;
						  frame_cnt_constant = box_string_frame_cnt;
						  }
						 */

						if(f_vel == 0){
							box_string_frame_cnt = (len_field / fish_vel_mean) - 1;
							frame_cnt_constant = box_string_frame_cnt;
						}
						else{
							box_string_frame_cnt = (len_field / f_vel) - 1;
							frame_cnt_constant = box_string_frame_cnt;
						}
						printf("box_string_frame_cnt= %d\t", box_string_frame_cnt);


					} //if(fish_string_flag == 0)

					if ((fish_string_flag == 1) && (box_string_frame_cnt == 0)){
						box_area_cnt = box_area_cnt + box_area[1];
						box_string_frame_cnt = frame_cnt_constant;
						//printf("b_c_cnt= %d\t", box_area_cnt);
					}

					//���������� ���������� �������
					box_flag[1] = 0;  // ���������� box
					fish_string_x0 = box[1][x0];
					fish_string_y0 = box[1][y0];
					fish_string_xn = box[1][xn];
					fish_string_yn = box[1][yn];
					fish_string_area =  (uint32_t)(box_area[1]);
					//box_area_cnt = box_area_cnt + fish_string_area;
					fish_string_box_life =fish_string_box_life + 1;
					fish_string_life = fish_string_life + 1;
					fish_string_time = time_cnt;

				} //������� ������� ����
				else
				{
					/*box_string_frame_cnt--;
					if((fish_string_flag == 1) && (box_string_frame_cnt == 0)) //���� ������� �����������
					{
						//printf("start_2\r\n");
						//�������� �������
						fish_string_flag = 0;
						box_area_cnt = box_area_cnt + box_area[1];
					*/
						box_string_frame_cnt--;
					if(fish_string_flag == 1) //���� ������� �����������
					{
					//printf("start_2\r\n");
					//�������� �������
					fish_string_flag = 0;
					if(box_string_frame_cnt == 0){
						last_area = box_area[1];
					}
					else{
						area_on_frame = box_area_cnt/frame_cnt_in_string;
						last_area = area_on_frame * box_string_frame_cnt;
					}
					box_area_cnt = box_area_cnt + last_area;

						if(fish_string_life <= time_wait) //���� ������� ���� �������� �����
						{
							fish_cross_en = 1; //����� ��������� ����� �� time_wait
							fish_string_end = 1;
						}
						else
						{//���� ������� ���� ������� �����
//							printf("b_area= %d\t", box_area[1]);
//							box_area_cnt = box_area_cnt + box_area[1];
							//printf("b_a_cnt= %d\t", box_area_cnt);
							//������� ����������� ������� �������
							if(((fish_string_fish_xn - fish_string_fish_x0) >
								(uint16_t)((float)(fish_len_max)*K_string_len_max))&&
								(fish_string_fish_x0 == x0_min))
							{
								//���� ��������� ����� � ������� ����� ������� ������ ����
								//f_len = fish_len_mean;
								fish_in_string_area = fish_area_mean;
							}
							else	{
								//f_len = xn_max - fish_string_fish_x0;
								fish_in_string_area = box_area[1];
								//f_len = xn_max - fish_string_fish_x0 - fish_string_fish_vel;
								//��� ��������� �������� ����
							}
//????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
							//t_len  = (fish_string_life + 1)*fish_string_fish_vel +
							//		(uint16_t)((float)fish_len_mean*0.05) + 4; //��� v_35_60
							// + (uint16_t)((float)fish_len_mean*0.05) + 1;
							//t_len  = (fish_string_life + 2)*fish_string_fish_vel;

/*							printf("\r\n");
							printf("f_len %d\t", f_len);
//							printf("t_len %d\t", t_len);
							printf("f_life %d\t", fish_string_box_life);
							printf("fish_x %d\t", fish_string_fish_x0);
							printf("fish_vel %d\t", fish_string_fish_vel);
							printf("fish_life %d\t", fish_string_life);
							printf("fish_len %d\t", fish_len_mean);
							printf("f_v_m %d\t", fish_vel_mean);
							printf("f_s_a %d\t", fish_string_area);
							printf("\r\n");
*/
/*							if(f_len <= t_len)
								fish_first_cnt = 1;
							else
								fish_first_cnt = 0;
*/
							//������ ���� � ������� �������
							//t_fish = (uint16_t)(((float)(f_len) / (float)(fish_string_fish_vel))); //fix!!!
							a = (float)box_area_cnt/(float)fish_in_string_area;
							b = a;
							c = a - b;
							if (c > 0.500){
								fish_in_string = b + 1;
							}
							else{
								fish_in_string = b;
							}
							if ((a > 0.200) && (a < 0.500)){
								fish_in_string = 1;
							}

/*							if(fish_string_life >= t_fish)
								t_string = fish_string_life - t_fish + 1;
							else
								t_string = 0;;

							//st_len_0 = ((float)(t_string)*(float)(fish_string_fish_vel) )/((float)(fish_len_mean)*0.93);
							st_len_1 = ((float)(t_string)*(float)(fish_vel_mean) )/((float)(fish_len_mean)*0.93);
							fish_string_cnt = (uint16_t)st_len_1; //fix!!!
*/
//							printf("fish_in_string= %d\t", fish_in_string);
							//���������� �������� ����
							fish_cnt = fish_cnt + fish_in_string - 1;//���������
//							printf("fish_cnt_aftef_string= %d\t", fish_cnt);

							//���������� ������� ��������� ��� ���������
							/*fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)(((uint16_t)fish_area_mean)*(fish_first_cnt + fish_string_cnt));
							fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)(((uint16_t)fish_life_mean)*(fish_first_cnt + fish_string_cnt));
							fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)((fish_len_mean)*(fish_first_cnt + fish_string_cnt));
							fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)((fish_vel_mean)*(fish_first_cnt + fish_string_cnt));*/

							fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)(((uint16_t)fish_area_mean)*(fish_in_string));
							fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)(((uint16_t)fish_life_mean)*(fish_in_string));
							fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)((fish_len_mean)*(fish_in_string));
							fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)((fish_vel_mean)*(fish_in_string));
//							printf("fisl_len_cnt_after_string= %d\t", fish_len_mean_cnt);

							//�������� ����� ��������
							if(box_cnt > 0)
							{
								N_fish = N_fish + box_cnt;

								for(m = 1; m <= box_cnt; m++)
								{
									if((xn_max - box[m][x0]) > fish_vel_mean*1.5) // ��������� ��������� �� ��������!
									{
										for(n = 1; n < N_fish_max; n++)
										{
											if (fish_flag[n] == 0) //���� ��������� �����
											{
												box_flag[m] = 0;
												//�������� �����
												box_len = box[m][xn] - box[m][x0];

												if((((float)box_len) > (((float)fish_len_max)*K_string_len_max))&&(box[m][xn] == xn_max))
												{
													//��� �����
													//fish_cnt = fish_cnt + 1;
													//fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)(fish_area_mean);


													fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)(fish_life_mean);
													//fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)(fish_len_mean);
													fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)(fish_vel_mean);
												}

												if(box[m][x0] > (xn_max - fish_vel_mean*4)) //���� ����� � ������ ��������
													fish_life[n] = fish_life_mean;
												else{

													if((box[m][x0] > x0_min)||((float)box[m][xn] > (float)(x0_min + xn_max)*0.5))
														fish_life[n] = fish_life_mean/2;
													else
														fish_life[n] = 1;
												}

												fish_x0[n] = box[m][x0];
												fish_y0[n] = box[m][y0];
												fish_xn[n] = box[m][xn];
												fish_yn[n] = box[m][yn];
												fish_box_area[n] =  box_area[m];
												fish_mark_n[n] = 1;
												fish_mark_n_z[n] =  1;
												fish_area[n] = fish_area_mean;
												fish_len[n]  =  fish_len_mean;
												fish_len_cnt[n] =  1;
												fish_vel[n]  =  fish_vel_mean;
												fish_vel_cnt[n] =  1;

												fish_flag[n] = 1;
												fish_time[n] = time_cnt;
												break;

											} //if (fish_flag[n] == 0) //���� ��������� �����
										} //(n = 0; n < N_fish_max; n++)
									} //if((xn_max - box[m][1]) > fish_vel_mean*1.5)
								} //for(m = 0; m < box_cnt; m++)
							} //if(box_cnt > 0) //�������� ����� ��������

						} //else if(fish_string_life <= time_wait) //���� ������� ���� ������� �����

						//�������� ������ �������
						fish_string_x0 = 0;
						fish_string_y0 = 0;
						fish_string_xn = 0;
						fish_string_yn = 0;
						fish_string_area = 0;
						fish_string_fish_vel = 0;
						fish_string_fish_x0 = 0;
						fish_string_fish_xn = 0;
						fish_string_box_life = 0;
						fish_string_life = 0;
						box_area_cnt = 0;
						box_string_frame_cnt = 0;
						frame_cnt_in_string = 0;
//						g = 0;

					} //else if((fish_string_flag == 1) && (box_string_frame_cnt == 0))  ���� ������� �����������
					else {

						//���� ��� � ������ ������� ���� %else if (fish_string == 1)
						//printf("start_3\r\n");
						if (fish_string_flag == 0){
							fish_cross_en = 1;
						}
					}
				} //else //if ((box(1,1) == x0_min)&&(box(1,3) == xn_max)&&(box_cnt == 1))



// 				***������ �����������***
				m_fish_x0 = 0;
				if(fish_cross_en == 1)
				{
					//printf("start_4\r\n");
					for (m = 1; m < N_fish_max; m++)
					{
						// �������� ������ � �� ������ ��� ���������
						if ((fish_flag[m] == 1)&&(fish_time[m] != time_cnt))
						{

							// ���������� � box
				// 			time
				// 			box_cnt
							for (n = 1; n <= box_cnt; n++)
							{

								//���������� ����� 2->1
								cross_x = 0;
								cross_y = 0;
								if (( box[n][x0] < fish_x0[m] )&&
								(fish_x0[m] <  box[n][xn])&&
								((fish_xn[m] - box[n][x0])  > fish_len_mean*0.8))
								{
									cross_x = 1;
								}
								if ( (box[n][yn] >=  fish_y0[m])&&(box[n][y0] <=  fish_yn[m]))
								{
									cross_y = 1;
								}
								if((cross_x && cross_y)&&
								(box[n][x0] == x0_min))
								{
									fish_link[m] = n;
								} //���������� ����� 2->1


								if(box_flag[n] == 1)
								{
									// ����������� ��������
									cross_box = 0;
									cross_x = 0;
									cross_y = 0;
									cross_x_2 = 0;
									cross_x_3 = 0;
									// �������� �� ����������� �� �
									//���� � ����� 2-�� �������, �� ����������� ��
									//�������� �����������
									vel_1 = (int32_t)( box[n][x0] -  fish_x0[m] );
									vel_2 = (int32_t)( box[n][xn] -  fish_xn[m] );
									if(((fish_xn[m] - fish_x0[m]) > fish_len_max*K_len_max)&&
									((box[n][xn] - box[n][x0]) < fish_len_max*K_len_max))
									{
										//��� ����� ������ �������������
										vel_2 = (int32_t)(fish_vel_mean);
									}
									if(fish_string_end == 1)
									{
										//�� �������� ���� � ������� 2�
										//������
										vel_1 = vel_1 / 2;
										vel_2 = vel_2 / 2;
									}

				// 					n
				//					vel_1
				// 					vel_2
									if(((box[n][x0] + Del_x) >= fish_x0[m])  &&
									(box[n][x0] <= fish_xn[m]) &&
									(box[n][xn] >= fish_xn[m]) &&
									(((vel_1 <= fish_vel_max*1.20)&&
									(vel_2 <= fish_vel_max*K_len_max))|| //��������� ����������� !!!
									(box_cnt <= 1)) )
									{
										cross_x = 1;
									}
									if((box[n][x0] >= fish_x0[m] ) &&
									(box[n][x0] <= fish_xn[m]) &&
									((box[n][xn] + Del_x) >= fish_xn[m]) &&
									(((vel_1 <= fish_vel_max*1.20)&&
									(vel_2 <= fish_vel_max*K_len_max))||
									(box_cnt <= 1)) )
									{
										cross_x = 1;
									}

									//������ ������� �� ���������
									dx =   (float)(fish_xn[m] - fish_x0[m]);
									dy =   (float)(fish_yn[m] - fish_y0[m]);
									fish_div = dy/dx;
									//���� ������� �� �
									// 	((fish_div > 3)&&(box(n,1) <= (fish_box_xn(m) + Del_x*1.6))))&&...
									if( (box[n][x0] >= fish_x0[m] ) &&
									((fish_div > 1.85)&&(box[n][x0] <= (fish_xn[m] + Del_x*0.5)))&&
									(box[n][xn] >= fish_xn[m]) &&
									(((vel_1 <= fish_vel_max*1.20)&&
									(vel_2 <= fish_vel_max*K_len_max))||
									(box_cnt <= 1)) )
									{
										cross_x = 1;
									}

									//���� ���� �� ������ ������ ���������� �����
									if((( fish_xn[m] - box[n][xn]) >= Del_x)||(( fish_x0[m] - box[n][x0]) >= Del_x))
										div_x = (float)(box[n][xn] - box[n][x0]) /(float)(fish_xn[m] - fish_x0[m]);
									{	//������ �������
										if ((box[n][x0] >= (fish_x0[m] + Del_x)) &&
										(box[n][x0] <= fish_xn[m]) &&
										(div_x >= 0.74) )
										{
											cross_x = 1;
										}
										//����� �������
						// 				if ( (div_x < 1.15) &&...
						// 				(box(n,3) >= (fish_box_xn(m) + Del_x))&&
						// 				(vel_1 <= fish_vel_max*K_fish_max) )
						// 					cross_x = 1;
						// 				end
									}


									// �������� �� �
									if((box[n][yn] >= fish_y0[m]) && (box[n][y0] <= fish_yn[m]))
									{
										cross_y = 1;
									}

									//������������� ����� 1->2
									if((fish_x0[m]  <  box[n][x0])&&
									(((fish_xn[m] < box[n][xn])&&(fish_xn[m] - box[n][x0]) > fish_len_mean*0.4)||
									((fish_xn[m] > box[n][xn])&&((box[n][x0] - fish_x0[m]) >  fish_len_mean*0))))
									{
										cross_x_2 = 1;
									}
									if ((fish_x0[m]  <  box[n][x0])&&
									(fish_xn[m] < box[n][xn])&&((fish_xn[m] + 2) > box[n][x0]))
									{
										cross_x_3 = 1;
									}

									if((cross_x || cross_x_2)&&(cross_y)&&
									(fish_x0[m] == x0_min)&&
									(box[n][x0] > x0_min))
									{
										cross_box = 1;
									}

									//����� �� ������������� x!=x0_min
									//��� v_03 340fr
									if((cross_x_3)&&(cross_y)&&
									(fish_cnt_d == 0)&&
									(box_cnt_z == 1)&&
									(box_cnt == 2)&&
									(fish_x0[m] > x0_min)&&
									(fish_mark_n[m] == 1)&&
									(fish_x0[m] < (x0_min + fish_vel_mean*0.4))&&
									(box[n][x0] < (x0_min + fish_vel_mean*2.6)))
									{
										cross_box = 1;
									}

									// v_02 270fr
									if((cross_x_3)&&(cross_y)&&
									(fish_cnt_d == 0)&&
									(box_cnt_z == 1)&&
									(box_cnt == 2)&&
									(fish_x0[m] >= x0_min)&&
									(fish_mark_n[m] <= 2)&&
									(box[n][x0] < (x0_min + fish_vel_mean*2.75)))
									{
										cross_box = 1;
									}

				// 					n
				//  				fish_cnt_d
				//  				box_cnt_z
				// 					cross_box

									if(cross_box == 1)
									{
										box_cross[n] = m;
										mark_n_old = fish_mark_n[m];
										m_fish_x0 = (uint8_t)m;
									} //������������� ����� 1->2

				// 					cross_x
				// 					cross_x_2
				// 					cross_y
				// 					step=1

									// ���� ������������ ��������� �����
									if (cross_x && cross_y)
									{
				//						if ~((fish_x0(m) == x0_min)&&(box_cnt > 1))
				//							box_flag(n) = 0;  % ���������� box
				// 							fish_cross(m) = n;
				// 							break %��� ������� ������� ����������� �������
				// 						else % � ������������ �� �� � �������?
											if(fish_cross[m] == 0)
											{
												box_flag[n] = 0;
												fish_cross[m] = n;
				// 								if(box(n,1) > x0_min)
				// 									break %��� ������� ������� ����������� �������
				// 								end
											}
											else
											{	if((box[fish_cross[m]][x0] < box[n][x0])&&(box[fish_cross[m]][x0] == x0_min))
												{
													//���� ������ ������
													box_flag[fish_cross[m]] = 1;
													box_flag[n] = 1;
													fish_cross[m] = n;
					// 								break //��� ������� ������� ����������� �������
												}
											}
				// 						end % ~((fish_box_x0(m) == x0_min)&&(box_cnt > 1))
									} //if (cross_x && cross_y)

								} //(box_flag(n) == 1)
							} //for (n = 0; n < box_cnt; n++)
						} //if ((fish_flag[m] == 1)&&(fish_time[m] ~= time))
					} //for (m = 0; m < N_fish_max; m++)
				} //if(fish_cross_en == 1)

/*				if(p >= box_cnt){
					p = 1;
				}
*/
//***���������� ���������� ��� �������������� ��������***
				if(fish_cross_en == 1)
				{
					printf("cross_en ");

					for(m = 1; m < N_fish_max; m++)
					{
						//��� �������������� ��������
						if(fish_cross[m] > 0)
						{
							n = fish_cross[m];
							box_flag[n] = 0;  // ���������� box

							//���� ��� �� ������ ���� ��������� ��������
							if ( (box[n][xn] < xn_max)&&(fish_xn[m] < box[n][xn]) )
							{
								vel = (uint16_t)( box[n][xn] -  fish_xn[m] ) ;
								fish_vel[m] =  fish_vel[m] + (uint16_t)(vel);
								fish_vel_cnt[m] =  fish_vel_cnt[m] + 1;
								//���������� ������������ ��������
								if ((vel > fish_vel_max)&&
								(vel < fish_vel_max*1.6)&&
								(vel < 200))
								{
									fish_vel_max = vel;
								}
							}

							//����������
							len = (uint16_t)(box[n][xn] - box[n][x0])/1.35;

							if((fish_cnt < N_fish_calibrate)&&
//								(fish_cnt < 4)&&
							((x0_min < box[n][x0])&&(box[n][xn] < xn_max)))
							{
								/*if (box_area[n] > fish_area_max)
								{
									fish_area_max =  box_area[n];
								}
								if (len > fish_len_max)
								{
									fish_len_max =  len;
								}*/

								/*printf("box_area= %d\t", box_area[1]);
								box_area_before = box_area[1];
								len_before = len;
								printf("box_before= %d\t", box_area_before);
								printf("len_before= %d\t", len_before);
								if (box_area_before > box_area_max_now){
									box_area_max_now = box_area_before;
									printf("box_area_max_now= %d\t", box_area_max_now);
								}
								if (len_before > len_max_now){
									len_max_now = len_before;
									printf("len_max_now= %d\t", len_max_now);
								}*/

								/*if (f_c_d == 0){
									box_area_max = box_area_max_now;
									len_max = len_max_now;
									box_area_max_now = 0;
									len_max_now = 0;
									fish_area_mean_cal = fish_area_mean_cal + box_area_max;
									len_cnt = len_cnt + len_max;
									printf("cnt_area= %d\t", fish_area_mean_cal);
									printf("cnt_len= %d\t", len_cnt);
								}

								if(fish_cnt >= 1){
									frame_cnt_cnt = frame_cnt_cnt + frame_cnt;
									fish_vel_mean = frame_cnt_cnt / fish_cnt;
									fish_area_mean = fish_area_mean_cal / fish_cnt;
									fish_len_mean = len_cnt / fish_cnt;
									printf("area_mean= %d\t", fish_area_mean);
									printf("len_mean= %d\t", fish_len_mean);
								}*/

								if (box_area[n] > fish_area_mean)
								{
									fish_area_mean =  box_area[n];
								}
								if (len > fish_len_mean)
								{
									fish_len_mean =  len;
								}
							}
							/*if (f_c_d == 0){
								box_area_max = box_area_max_now;
								len_max = len_max_now;
								box_area_max_now = 0;
								len_max_now = 0;
								fish_area_mean_cal = fish_area_mean_cal + box_area_max;
								len_cnt = len_cnt + len_max;
								printf("cnt_area= %d\t", fish_area_mean_cal);
								printf("cnt_len= %d\t", len_cnt);
							}*/

							//if(fish_cnt == N_fish_calibrate){
								/*frame_cnt_cnt = frame_cnt_cnt + frame_cnt;
								fish_vel_mean = frame_cnt_cnt / fish_cnt;*/
								/*fish_area_mean = fish_area_mean_cal / fish_cnt;
								fish_len_mean = len_cnt / fish_cnt;
								printf("area_mean= %d\t", fish_area_mean);
								printf("len_mean= %d\t", fish_len_mean);
								fish_area_max = fish_area_mean * K_area_max;
								fish_len_max = fish_len_mean * K_len_max;

								fish_area_min = fish_area_mean / K_area_max;
								fish_len_min = fish_len_mean * K_len_min;
							}*/

							fish_area_max = fish_area_mean * K_area_max;
							fish_len_max = fish_len_mean * K_len_max;

							fish_area_min = fish_area_mean / K_area_max;
							fish_len_min = fish_len_mean * K_len_min;

							fish_x0[m] = box[n][x0];
							fish_y0[m] = box[n][y0];
							fish_xn[m] = box[n][xn];
							fish_yn[m] = box[n][yn];
							fish_box_area[m] =  box_area[n];
							fish_life[m] = fish_life[m] + 1;
							fish_time[m] = time_cnt;

							//���� ������� �������
							//������� ������ ��� ��������� �����
							fish_mark_n_z[m] = fish_mark_n[m];
				//			m_fish_x0
							if(fish_cnt >= N_fish_calibrate)
							{
								printf("us_1 ");
//								a = box_area[n];
//								b = fish_area_mean_cnt;
								if((( len > ((int)(fish_len_max*K_len_max) ) )||
								(box_area[n] > ((int)(fish_area_max*K_area_max) ) ))&&
								((box[n][x0] <= (x0_min + ((int)(fish_vel_max*0.15) ) ))||
								((m_fish_x0 == m)&&(m_fish_x0 > 0))))
								{
//									fish_mark_n[m] = 2;
//									c = a/b;
									printf("zashel suda ");
									a = (float)box_area[n]/(float)fish_area_mean;
									printf("a= %f\t", a);
//									printf("a= %f\t", a);
//									a = round(a);
									b = a;
									c = a - b;
//									fish_mark_n[m] = box_area[n]/fish_area_mean;
//									float round (float fish_mark_n);
//									printf("N=2 %d\t", fish_area_max);
//									printf("S %d\t", (int)(fish_area_max*K_area_max));
//									printf("L %d\t", (int)(fish_vel_max*0.15));
//									printf("f_m= %f\t", c);
									if (c > 0.500){
										fish_mark_n[m] = b + 1;
									}
									else{
										fish_mark_n[m] = b;
									}
									if((a > 0.300) && (a < 0.500)){
										fish_mark_n[m] = 1;
									}
									printf("f_m= %d\t", fish_mark_n[m]);
									if(fish_mark_n[m] > fish_cnt_in_box){
										fish_cnt_in_box = fish_mark_n[m];
									}
									printf("f_c_in_b= %d\t", fish_cnt_in_box);
								}

								//������� ������ ����� 3->2
//								if((box_area[n] > ((int)(fish_area_max*K_area_n3) ))&&
//								((box[n][x0] <= (x0_min + ((int)(fish_vel_max*0.15) )))||
//								((m_fish_x0 == m)&&(m_fish_x0 > 0))))
//								{
//									fish_mark_n[m] = 3;
//									printf("N=3 %d\t", fish_area_max);
//									printf("S %d\t", ((int)(fish_area_max*K_area_n3)));
//									printf("L %d\t", ((int)(fish_vel_max*0.15)));
//
//								}

								if( (len < ((int)(fish_len_max*1.02) ))&&
								(box_area[n] < ((int)(fish_area_max*1.3) ))&&

								(((box[n][x0] < (x0_min + ((float)fish_vel_max*0.8)))&& //���������� � ��������� ����
								(box[n][x0] < ( box_lef_xn + ((float)fish_vel_max*0.2)))&&
								(box[n][x0] > x0_min))||
								((m_fish_x0 == m)&&(m_fish_x0 > 0))) )
								{
									printf("us_2 ");
									//������� ������ ��� box(n,1)== x0_min
									fish_mark_n[m] = 1;
								}
							} //if(fish_cnt >= N_fish_calibrate)

/*
							printf("x %d\t", (box[n][xn] - box[n][x0]));
							printf("s %d\t", box_area[n]);
							printf("x0 %d\t", box[n][x0]);
							printf("box_lef_xn %d\t", box_lef_xn);
							printf("m_fish_x0 %d\t", m_fish_x0);
							printf("m %d\t", m);
							printf("\r\n");*/

							//���� �� ������������� � ������ ���������
							//����� � ������� ������� � �������
							//�� ������ ������������
							if ( ((x0_min < box[n][x0])&&(box[n][xn] < xn_max))&&
							( (len < (int)(fish_len_max*K_len_max) )&&
							(box_area[n] < (int)(fish_area_max*1.08) )&&
							(fish_cnt >= 0))&&
							(fish_mark_n[m] < 2) )//�������� �������
							{
								printf("us_3 ");
								 fish_area[m] = fish_area[m] + (uint32_t)(box_area[n]);

								 fish_len[m]  =  fish_len[m] + len;
								 fish_len_cnt[m] =  fish_len_cnt[m] + 1;

								 //���������� ������������ �������
								/*if (box_area[n] > fish_area_max)
								{
									fish_area_max =  box_area[n];
									fish_area_max_2 =  (box[n][xn] - box[n][x0])*(box[n][yn] - box[n][y0]);
									//printf("s %d\t", fish_area_max_2);
								}
								 //���������� ������������ �����
								if (len > fish_len_max)
								{	//����� ������� ����������
									//���� ���� ������ � �����
									fish_len_max =  len;
								}*/

							} //if ((x0_min < box(n,1))&&(box(n,3) < xn_max))

						} //if(fish_cross[m] > 0)
					} //for(m = 0; m < N_fish_max; m++)
				} //if(fish_cross_en == 1)


//				***������ �� ������������ ������� �� time***

				for(m = 1; m < N_fish_max; m++)
				{
					// �������� ������ � �� ������ ��� ���������
					if ( ((fish_string_flag == 0)&&(fish_flag[m] == 1)&&(fish_time[m] != time_cnt))||
						((fish_string_flag == 1)&&(fish_flag[m] == 1)&&((fish_time[m] + (uint32_t)(time_wait)) < time_cnt)) )
					{
						printf("us_4 ");
						//�������� ������� �� �� ���� �����������
						//��������: xo-������ ��������, xn=������  �������, life > 5
						//������, ������ ����� ������ ��������
						fish_area_dob =   (float)( fish_area[m])/ (float)( fish_len_cnt[m]);
						fish_len_dob =  (float)( fish_len[m])/ (float)(fish_len_cnt[m]);
						fish_v_dob = (float)( fish_vel[m])/ (float)(fish_vel_cnt[m]);

						//�������� ������� �����
						fish_cnt_en = 1;
						if(fish_link[m] > 0)
						{
				 			//fish_link(m)
							//����� ������ �������
							for(f = 0; f < N_fish_max; f++)
							{
								if(fish_link[m] == fish_cross[f])
								{
									break;
								}
							}
							if( (fish_mark_n[f] > fish_mark_n_z[f])&&
							  ( ~((fish_xn[m] == xn_max)&&
							  ((fish_xn[m] - fish_x0[m]) < fish_area_mean*0.5))) )
							{
								fish_cnt_en = 0;
							}
						} // if(fish_link(m) > 0)
/*
						printf("fish_x0[m] = %d\r\n", fish_x0[m]);
						printf("fish_cnt_en = %d\r\n", fish_cnt_en);
						printf("fish_vel_mean = %d\r\n", fish_vel_mean);
*/
						printf("flag= %d\t", fish_string_flag);
						printf("m= %d\t", m);
						printf("m_x0= %d\t", fish_x0[m]);
						printf("x0_box= %d\t", box[m][x0]);
						printf("vel_mean= %d\t", fish_vel_mean);
						printf("box_cnt= %d\t", box_cnt);
						if  ((((fish_string_flag == 0)&&
							(fish_x0[m] > (x0_min + fish_vel_mean*0.4))&&
							(fish_cnt_en == 1)))||
							(((fish_string_flag == 1)&&(fish_x0[m] > (xn_max - fish_vel_mean)))&&
							(fish_xn[m] == xn_max)))
						{
							printf("proshla ");

							//������� ��� ����� ������
							fish_cnt = fish_cnt + (uint16_t)(fish_mark_n[m]);
							fish_cnt_in_box = 0;
							//printf("fish_cnt_after_cross= %d\t", fish_cnt);
//							if(fish_mark_n[m] > 1)
//							{
//								printf("fish_mark%d\t", fish_mark_n[m]);
								//printf("m= %d\t", m);
//							}
							//��������� ��������� �����
							if(fish_mark_n[m] == 1)
							{
								fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)(fish_area_dob);
								fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)(fish_len_dob);
								fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)(fish_v_dob);
								fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)(fish_life[m]);
								//printf("fisl_len_cnt_after_cross_1= %d\t", fish_len_mean_cnt);
							}
							else {
								//���� ����� ��������� ���������� �������
								//��������
								fish_area_mean_cnt = fish_area_mean_cnt + (uint32_t)fish_area_mean*(uint32_t)fish_mark_n[m];
								fish_len_mean_cnt = fish_len_mean_cnt + (uint32_t)fish_len_mean*(uint32_t)fish_mark_n[m];
								fish_vel_mean_cnt = fish_vel_mean_cnt + (uint32_t)fish_v_dob*(uint32_t)fish_mark_n[m];
								fish_life_mean_cnt = fish_life_mean_cnt + (uint32_t)fish_life_mean*(uint32_t)fish_mark_n[m];
								//printf("fisl_len_cnt_after_cross_2= %d\t", fish_len_mean_cnt);
							}
						} //if  (((fish_string_flag == 0)&&...

						//���������� ������
						fish_flag [m] = 0;
						N_fish = N_fish - 1;

						fish_x0[m] = 0;
						fish_y0[m] = 0;
						fish_xn[m] = 0;
						fish_yn[m] = 0;
						fish_box_area[m] =  0;
						fish_mark_n[m] =  0;
						fish_mark_n_z[m] = 0;
						fish_vel[m] = 0;
						fish_vel_cnt[m] =  0;
						fish_area[m] = 0;
						fish_len[m]  = 0;
						fish_len_cnt[m] =  0;
						fish_life[m] = 0;

					} // if ( ((fish_string_flag == 0)&&(fish_flag(m) == 1)&&(fish_time(m) != time
				} //for (m = 0; m < N_fish_max; m++)

//				***�������� ������ �������***
				//������������� ����� 1->2
				//������� ���������� ����� �������������� box
				//������
				box_n_new = 0;
				mark_n_new = 0;
				fish_n_min = 0;
				new_fish = 0;

				//������������� ����� 1->2
				if(m_fish_x0 > 0)
				{

					for(m = 1; m <= box_cnt; m++)  // ���� ����� box_cnt = ~����� ������� box m = 1:1: box_cnt
					{
						if((box_flag[m] == 1)&&(box_cross[m] == m_fish_x0))
						{
							box_n_new = box_n_new + 1;
						}
					}
					//����������� ���������� �����
					if(fish_flag[m_fish_x0] == 1)
					{
						fish_n_min = box_n_new + 1;
					}
					else {
						fish_n_min = box_n_new;
					}
					//��������� ������� �������
					if(fish_flag[m_fish_x0] == 1)
					{
						m = m_fish_x0;
						n = fish_cross[m];
						mark_n_new = fish_mark_n[m];
					}  // if(fish_flag(m_fish_x0) == 1)

				} // if(m_fish_x0 > 0)

				//***�������� ������ �������***
				for(m = 1; m <= box_cnt; m++) //m = 1:1: box_cnt
				{
					if(box_flag[m] == 1) // ����� ����� ������ box	(box_flag(m) == 1)
					{
						if(N_fish < N_fish_max) //��������� ��� ���� �����
						{
							for(n = 1; n < N_fish_max; n++) //n = 1:1: N_fish_max
							{
								if(fish_flag[n] == 0) //������� ��������� ����� ��� ������
								{	//������� ����� ������
									if (((box[m][x0] == x0_min)&&(box[m][xn] < x_mean))||
									  ((box_cross[m] > 0)&&(m_fish_x0 > 0))||
									  ((new_fish == 1)&&(box[m][x0] < (fish_xn[m_fish_x0] + 2))))
									{

										box_flag[m] = 0;  // ���������� box
										// m - ����� ��������� box
										// n - ����� ������ ����
										// �����
										fish_x0[n] = box[m][x0];
										fish_y0[n] = box[m][y0];
										fish_xn[n] = box[m][xn];
										fish_yn[n] = box[m][yn];
										fish_box_area[n] =  box_area[m];
										fish_mark_n[n] = 1;

										//���� ������� �������
										//������� ������ ��� ��������� �����
										if((( (box[n][xn] - box[n][x0]) > (int)(fish_len_max*K_len_max) )||
										(box_area[n] > (int)(fish_area_max*K_area_max) ))&&
										(box[n][x0] <= (x0_min + (int)(fish_vel_max*0.15)))&&
										(fish_cnt >= N_fish_calibrate))
										{
											printf("zashel suda_2");
//											fish_mark_n[n] = 2;
											a = (float)box_area[n]/(float)fish_area_mean;
											printf("a= %f\t", a);
//											a = round(a);
											b = a;
											c = a - b;
											//fish_mark_n[n] = box_area[n]/fish_area_mean;
//											printf("f_m= %f\t", c);
											if (c > 0.500){
												fish_mark_n[n] = b + 1;
											}
											else{
												fish_mark_n[n] = b;
											}
											printf("f_m= %d\t", fish_mark_n[n]);
											if(fish_mark_n[n] > fish_cnt_in_box){
												fish_cnt_in_box = fish_mark_n[n];
											}
											if((a > 0.300) && (a < 0.500)){
												fish_mark_n[n] = 1;
											}
											printf("f_c_in_b= %d\t", fish_cnt_in_box);
										}
										//������� ������ ����� 3->2
//										if((box_area[n] > (int)(fish_area_max*K_area_n3) )&&
//										(box[n][x0] <= (x0_min + (int)(fish_vel_max*0.15) ))&&
//										(fish_cnt >= N_fish_calibrate))
//										{
//											fish_mark_n[n] = 3;
//										}
										//�������� ���������� �����
										if ((box_cross[m] > 0)&&(m_fish_x0 > 0))
										{
											box_n_new = box_n_new - 1;
											mark_n_new = mark_n_new + fish_mark_n[n];

											if((box_n_new == 0)&&(mark_n_new < fish_n_min))//box_n_new-����� ���� ������ ����
											{
												fish_mark_n[n] = fish_n_min - mark_n_new;
											}
										}


										fish_mark_n_z[n] =  fish_mark_n[n];
										N_fish = N_fish + 1;
										fish_flag[n] = 1;
										fish_time[n] = time_cnt;
										fish_life[n] = 1;
									}
									//�������� � ������� �� ���� �������
									break;

								} //(fish_flag(n) == 0)
							} //for m = 1:1: box_cnt
						} //(N_fish < N_fish_max)
					} //if (box_flag == 1) % ����� ����� ������	box
				} //for m = 1:1: box_cnt


// 				***���������� ��������***
				fish_cnt_d = (uint16_t)(fish_cnt - fish_cnt_z);
				fish_cnt_z = fish_cnt;
				box_cnt_z = box_cnt;
				*(fish_out_addr) = fish_cnt;

				if((fish_cnt >= 1)&&(fish_len_mean_cnt > 0)&&(fish_vel_mean_cnt > 0))
				{
					fish_life_mean = (uint8_t)( (float)(fish_life_mean_cnt) /(float)(fish_cnt) );
					//fish_area_mean = (uint32_t)((float)(fish_area_mean_cnt) /(float)(fish_cnt) );
					//fish_len_mean = (uint16_t)((float)(fish_len_mean_cnt) /(float)(fish_cnt) );
					fish_vel_mean = (uint16_t)((float)(fish_vel_mean_cnt ) /(float)(fish_cnt) );
					//printf("fisl_len_cnt_after_cross_3= %d\t", fish_len_mean_cnt);

				}

/*				if ((box_cnt > 0)&&(box_xn = xn_max)){
					frame_cnt = 0;
				}
*/
//				printf("cnt= %d\t", fish_cnt);
//				printf("N= %d\t", N_fish);
				printf("x0= %d\t", box[1][x0]);
				printf("b_area= %d\t", box_area[1]);
//				printf("b_a_cnt= %d\t", box_area_cnt);
//				printf ("b= %d\t", box_area[n]);
//				printf("fish_len_max= %d\t", fish_len_max);
//				printf("fish_area_max= %d\t", fish_area_max);
//				printf("fam= %d\t", fish_area_max);
//				printf("flm= %d\t", fish_len_max);
//				printf("f_v_m= %d\t", fish_vel_mean);
//				printf("area_mean= %d\t", fish_area_mean);
//				printf("len_mean= %d\t", fish_len_mean);
//				printf("vel= %d\t", fish_vel_mean);

				*(fish_area_addr) = fish_area_mean;
				*(fish_len_addr) = fish_len_mean;

/*

				for(i=1; i <= box_cnt; i++)
					{
						//printf("n = %d\t", i);
						//printf("box_x0 = %d\t", box[i][x0]);
						//printf("box_y0 = %d\r\n", box[i][y0]);
						//printf("box_xn = %d\t", box[i][xn]);
						//printf("box_yn = %d\r\n", box[i][yn]);
						printf("S %d\t", box_area[i]);
						//printf("box_flag = %d\r\n", box_flag[i]);
					}
*/
/*				for(m = 1; m <= box_cnt; m++){
					if (box[m][x0] > x0_min){
						box_vel = box[m][x0] - box_before;
						if (first == 1){
							*(x_cat_addr) = box[m][x0];
							first = 0;
						}
						else{
							*(x_cat_addr) = x_cat + box_vel;
						}
						box_before = box[m][x0];
					}
				}*/
				printf("\r\n");



				state = 0;
				break;
			}

			default :
				state = 0;
				break;
		}

	}

	// clean up our memory mapping and exit
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
