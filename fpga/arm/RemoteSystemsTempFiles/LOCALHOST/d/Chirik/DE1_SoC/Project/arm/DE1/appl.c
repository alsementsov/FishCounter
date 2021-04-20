#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
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

#define N_fish_max   		9
#define N_fish_calibrate	11

#define x0	0
#define y0	1
#define xn	2
#define yn	3
//chmod +x appl
//./appl

int main() {

	volatile uint8_t state = 0;
	void *virtual_base;
	int fd;

	volatile uint32_t *box_req;
	volatile uint32_t *req_res;
	volatile uint32_t *box_n_addr;
	volatile uint32_t *n_pix_addr;
	volatile uint32_t *led;
	volatile uint32_t *addr_out;
	volatile uint32_t *box_addr;
	volatile uint32_t *box_x0_addr;
	volatile uint32_t *box_xn_addr;
	volatile uint32_t *box_y0_addr;
	volatile uint32_t *box_yn_addr;




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
	led = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_LED_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	n_pix_addr = virtual_base +
			( ( unsigned long  )( ALT_LWFPGASLVS_OFST + N_PIX_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
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


	uint8_t  box_cnt = 10;


	//fish
	uint16_t box[16][4];
	uint32_t box_area[16];
	uint8_t  ram_addr = 0;

//	uint8_t  box[16][4] = 0;
	uint8_t i;

	//приведствие
	printf("Hello DE1_SOC!\r\n");
	//главный цикл
	while( 1 ) {


		//вывод в сигналтаб
		*(led) = state;
		//printf("state = %d\r\n", state);

		switch (state) {

			//сброс значений
			case 0 : {

				*(req_res) = 0;
				*(addr_out) = 0;

				state = 1;
				//printf("state = %d\r\n", state);
				break;
			}

			//ожидание начала кадра
			case 1 : {

				if (*(box_req + 3) == 1 )
				{
					//сбрасываем флаг
					*(box_req + 3) = 0;

					box_cnt = *(box_n_addr);
					printf("box_cnt = %d\r\n", box_cnt);

					if (box_cnt > 0)
					{
						ram_addr = 0;
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

				//ждем нужный адрес
				if (*(box_addr) == ram_addr)
				{
					box[ram_addr][x0] = *(box_x0_addr);
					box[ram_addr][y0] = *(box_y0_addr);
					box[ram_addr][xn] = *(box_xn_addr);
					box[ram_addr][yn] = *(box_yn_addr);
					box_area[ram_addr] = *(n_pix_addr);

					if ((ram_addr < (box_cnt - 1))&&
						(ram_addr <= 15))
					{
						ram_addr = ram_addr + 1;
						*(addr_out) = ram_addr; //записываем новый адрес
					}
					else {
						state = 3;
					}
				}
				break;
			}

			case 3 : {

				//обнуляем старые значения
				for(i=box_cnt;i<16;i++)
				{
					box[i][x0] = 0;
					box[i][y0] = 0;
					box[i][xn] = 0;
					box[i][yn] = 0;
					box_area[i] = 0;
				}
				state = 4;
				break;
			}

			case 4 : {

/*				//вывод на экран
				for(i=0;i<15;i++)
				{
					printf("n = %d\r\n", i);
					printf("box_x0 = %d\r\n", box[i][x0]);
					printf("box_y0 = %d\r\n", box[i][y0]);
					printf("box_xn = %d\r\n", box[i][xn]);
					printf("box_yn = %d\r\n", box[i][yn]);
					printf("box_area = %d\r\n", box_area[i]);
				}
*/				i = box[i][x0];
				printf("box_area = %d\r\n", box_area[1]);
				state = 0;
				break;
			}

			default :
				state = 0;
				break;
		}

	}



/*

	usleep( 100*1000 );

	uint16_t loop_cnt = 0;
	uint16_t n = 0;
	uint16_t m[31];

	n = *(n_pix_addr);
	printf(" %d\r\n", n);

	while( loop_cnt < 30 ) {

		// *(uint32_t *)(led_addr) = loop_cnt;
		//alt_write_word(led_addr, loop_cnt);
		//alt_write_word(led_addr, *(box_x0_addr));
		// *(led_addr) = *(box_x0_addr);

		m[loop_cnt]= *(box_x0_addr);

		//printf(" %d\r\n", n);

		loop_cnt = loop_cnt + 1;
		//usleep( 5*1000 );

	} // while


	uint8_t i;
	for(i=0;i<30;i++)
	{
		printf(" %d\r\n", m[i+1] - m[i]);
	}

*/


	// clean up our memory mapping and exit
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}

