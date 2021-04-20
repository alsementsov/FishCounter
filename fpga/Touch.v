module Touch (	
						T_iCLK,
						T_iRSTN,
						T_iTRIG,
						T_oREADY,
						T_oREG_X1,
						T_oREG_Y1,
						T_oREG_X2,
						T_oREG_Y2,
						T_oREG_TOUCH_COUNT,
						T_oREG_GESTURE,
						//	I2C Side
						T_I2C_SCLK,
						T_I2C_SDAT	);
//	Host Side
input			T_iCLK;
input			T_iRSTN;
input			T_iTRIG;
//	I2C Side
output			T_I2C_SCLK;
output			T_oREADY;
output			[9:0]T_oREG_X1;
output			[8:0]T_oREG_Y1;
output			[9:0]T_oREG_X2;
output			[8:0]T_oREG_Y2;
output			[1:0]T_oREG_TOUCH_COUNT;
output			[7:0]T_oREG_GESTURE;
inout			T_I2C_SDAT;




////////////////////////////////////////////////////////////////////
i2c_touch_config 	u0	(	.iCLK(T_iCLK),		//	Controller Work Clock
						.iRSTN(T_iRSTN),
						.iTRIG(T_iTRIG),
						.oREADY(T_oREADY),
						.oREG_X1(T_oREG_X1),
						.oREG_Y1(T_oREG_Y1),
						.oREG_X2(T_oREG_X2),
						.oREG_Y2(T_oREG_Y2),
						.oREG_TOUCH_COUNT(T_oREG_TOUCH_COUNT),
						.oREG_GESTURE(T_oREG_GESTURE),
						.I2C_SCLK(T_I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(T_I2C_SDAT));
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
endmodule