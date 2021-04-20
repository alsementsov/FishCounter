// megafunction wizard: %LPM_CONSTANT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_CONSTANT 

// ============================================================
// File Name: n_pix_frame_3.v
// Megafunction Name(s):
// 			LPM_CONSTANT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.1.0 Build 162 10/23/2013 SJ Full Version
// ************************************************************


//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module n_pix_frame_3 (
	result);

	output	[19:0]  result;

	wire [19:0] sub_wire0;
	wire [19:0] result = sub_wire0[19:0];

	lpm_constant	LPM_CONSTANT_component (
				.result (sub_wire0));
	defparam
		LPM_CONSTANT_component.lpm_cvalue = 172079,
		LPM_CONSTANT_component.lpm_hint = "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=pN3",
		LPM_CONSTANT_component.lpm_type = "LPM_CONSTANT",
		LPM_CONSTANT_component.lpm_width = 20;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "1"
// Retrieval info: PRIVATE: JTAG_ID STRING "pN3"
// Retrieval info: PRIVATE: Radix NUMERIC "10"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: Value NUMERIC "172079"
// Retrieval info: PRIVATE: nBit NUMERIC "20"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "172079"
// Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=pN3"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "20"
// Retrieval info: USED_PORT: result 0 0 20 0 OUTPUT NODEFVAL "result[19..0]"
// Retrieval info: CONNECT: result 0 0 20 0 @result 0 0 20 0
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3.bsf TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL n_pix_frame_3_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
