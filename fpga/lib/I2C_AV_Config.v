module I2C_AV_Config (	//	Host Side
						iCLK,
						iRST_N,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT	);
//	Host Side
input		iCLK;
input		iRST_N;
//	I2C Side
output		I2C_SCLK;
inout		I2C_SDAT;
//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[23:0]	mI2C_DATA;
reg			mI2C_CTRL_CLK;
reg			mI2C_GO;
wire		mI2C_END;
wire		mI2C_ACK;
reg	[15:0]	LUT_DATA;
reg	[5:0]	LUT_INDEX;
reg	[3:0]	mSetup_ST;

//	Clock Setting
parameter	CLK_Freq	=	50000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	LUT Data Number
parameter	LUT_SIZE	=	51;
//	Audio Data Index
parameter	Dummy_DATA	=	0;
parameter	SET_LIN_L	=	1;
parameter	SET_LIN_R	=	2;
parameter	SET_HEAD_L	=	3;
parameter	SET_HEAD_R	=	4;
parameter	A_PATH_CTRL	=	5;
parameter	D_PATH_CTRL	=	6;
parameter	POWER_ON	=	7;
parameter	SET_FORMAT	=	8;
parameter	SAMPLE_CTRL	=	9;
parameter	SET_ACTIVE	=	10;
//	Video Data Index
parameter	SET_VIDEO	=	11;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
						.ACK(mI2C_ACK),				//	ACK
						.RESET(iRST_N)	);
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mSetup_ST)
			0:	begin
					if(LUT_INDEX<SET_VIDEO)
					mI2C_DATA	<=	{8'h34,LUT_DATA};
					else
					mI2C_DATA	<=	{8'h40,LUT_DATA};
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
					begin
						if(!mI2C_ACK)
						mSetup_ST	<=	2;
						else
						mSetup_ST	<=	0;							
						mI2C_GO		<=	0;
					end
				end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
				end
			endcase
		end
	end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////	
always
begin
	case(LUT_INDEX)
	//	Audio Config Data
	SET_LIN_L	:	LUT_DATA	<=	16'h001A;
	SET_LIN_R	:	LUT_DATA	<=	16'h021A;
	SET_HEAD_L	:	LUT_DATA	<=	16'h047B;
	SET_HEAD_R	:	LUT_DATA	<=	16'h067B;
	A_PATH_CTRL	:	LUT_DATA	<=	16'h08F8;
	D_PATH_CTRL	:	LUT_DATA	<=	16'h0A06;
	POWER_ON	:	LUT_DATA	<=	16'h0C00;
	SET_FORMAT	:	LUT_DATA	<=	16'h0E01;
	SAMPLE_CTRL	:	LUT_DATA	<=	16'h1002;
	SET_ACTIVE	:	LUT_DATA	<=	16'h1201;
	//	Video Config Data
	SET_VIDEO+1	:	LUT_DATA	   <=	16'h0000; //auto
	SET_VIDEO+2	:	LUT_DATA	   <=	16'hc301; //mux A1_in	
   SET_VIDEO+3	:	LUT_DATA	   <=	16'hc480; //mux NC 	
   SET_VIDEO+4	:	LUT_DATA	   <=	16'h0457; //BT.656-3 /HS, VS,- откл
	SET_VIDEO+5	:	LUT_DATA	   <=	16'h1741; //Shaping Filter Control avto
	SET_VIDEO+6	:	LUT_DATA	   <=	16'h5801; //pin37 - VSYNC 
	SET_VIDEO+7	:	LUT_DATA	   <=	16'h3d02; //a2-color kill NTSC,PAL <16% SECAM <15% //02-<0.5%
	SET_VIDEO+8	:	LUT_DATA	   <=	16'h37a0; //HS, VS polarity - Active low
	SET_VIDEO+9	:	LUT_DATA	   <=	16'h3e6a; //BLM optimization -no info
	SET_VIDEO+10	:	LUT_DATA	   <=	16'h3fa0; //BGB optimization -no info
	SET_VIDEO+11	:	LUT_DATA	   <=	16'h0e80; //NORMAL REGISTER SPACE /пишут 0 где 1 !!
	SET_VIDEO+12	:	LUT_DATA	   <=	16'h5581; //ADC configuration -no info
	SET_VIDEO+13	:	LUT_DATA	   <=	16'h37A0; //Polarity regiser  -second conf!
	SET_VIDEO+14	:	LUT_DATA	   <=	16'h0880; //Contrast 80, gain = 1 //00 - gaun=0*
	SET_VIDEO+15	:	LUT_DATA	   <=	16'h0a18; //Brightness 18,//00-Offset luma channel=0*
	
	SET_VIDEO+16	:	LUT_DATA	   <=	16'h2c8e; //AGC, auto*	
	SET_VIDEO+17	:	LUT_DATA	   <=	16'h2df8; //Chroma Gain- Adaptive (low bit - gain)
	SET_VIDEO+18	:	LUT_DATA	   <=	16'h2ece; //Chroma Gain- gain	
	SET_VIDEO+19	:	LUT_DATA	   <=	16'h2ff4; //Luma Gain- Medium /пишут 0 где 1 !!
	SET_VIDEO+20	:	LUT_DATA	   <=	16'h30b2; //Luma Gain- gain	
	SET_VIDEO+21	:	LUT_DATA	   <=	16'h0e00; //NORMAL REGISTER SPACE 
	
	//мои настройки	
//	SET_VIDEO+22	:	LUT_DATA	   <=	16'h2ba1; //Color kill disabled

	default:		LUT_DATA	<=	16'd0 ;
	endcase
end
////////////////////////////////////////////////////////////////////
endmodule
//
//	//	Video Config Data
//	SET_VIDEO+1	:	LUT_DATA	   <=	16'h0000; //auto
//	SET_VIDEO+2	:	LUT_DATA	   <=	16'hc301; //mux A1_in	
//   SET_VIDEO+3	:	LUT_DATA	   <=	16'hc480; //mux NC 	
//   SET_VIDEO+4	:	LUT_DATA	   <=	16'h0457; //BT.656-3 /HS, VS,- откл
//	SET_VIDEO+5	:	LUT_DATA	   <=	16'h1741; //Shaping Filter Control avto
//	SET_VIDEO+6	:	LUT_DATA	   <=	16'h5801; //pin37 - VSYNC 
//	SET_VIDEO+7	:	LUT_DATA	   <=	16'h3d02; //a2-color kill NTSC,PAL <16% SECAM <15% //02-<0.5%
//	SET_VIDEO+8	:	LUT_DATA	   <=	16'h37a0; //HS, VS polarity - Active low
//	SET_VIDEO+9	:	LUT_DATA	   <=	16'h3e6a; //BLM optimization -no info
//	SET_VIDEO+10	:	LUT_DATA	   <=	16'h3fa0; //BGB optimization -no info
//	SET_VIDEO+11	:	LUT_DATA	   <=	16'h0e80; //NORMAL REGISTER SPACE /пишут 0 где 1 !!
//	SET_VIDEO+12	:	LUT_DATA	   <=	16'h5581; //ADC configuration -no info
//	SET_VIDEO+13	:	LUT_DATA	   <=	16'h37A0; //Polarity regiser  -second conf!
//	SET_VIDEO+14	:	LUT_DATA	   <=	16'h0880; //Contrast 80, gain = 1 //00 - gaun=0*
//	SET_VIDEO+15	:	LUT_DATA	   <=	16'h0a18; //Brightness 18,//00-Offset luma channel=0*
//	
//	SET_VIDEO+16	:	LUT_DATA	   <=	16'h2c8e; //AGC, auto*	
//	SET_VIDEO+17	:	LUT_DATA	   <=	16'h2df8; //Chroma Gain- Adaptive (low bit - gain)
//	SET_VIDEO+18	:	LUT_DATA	   <=	16'h2ece; //Chroma Gain- gain	
//	SET_VIDEO+19	:	LUT_DATA	   <=	16'h2ff4; //Luma Gain- Medium /пишут 0 где 1 !!
//	SET_VIDEO+20	:	LUT_DATA	   <=	16'h30b2; //Luma Gain- gain	
//	SET_VIDEO+21	:	LUT_DATA	   <=	16'h0e00; //NORMAL REGISTER SPACE 