// megafunction wizard: %LPM_COMPARE%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_COMPARE 

// ============================================================
// File Name: COMP_USE.v
// Megafunction Name(s):
// 			LPM_COMPARE
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
module COMP_USE (
	dataa,
	ageb);

	input	[6:0]  dataa;
	output	  ageb;

	wire  sub_wire0;
	wire [6:0] sub_wire1 = 7'h50;
	wire  ageb = sub_wire0;

	lpm_compare	LPM_COMPARE_component (
				.dataa (dataa),
				.datab (sub_wire1),
				.ageb (sub_wire0),
				.aclr (1'b0),
				.aeb (),
				.agb (),
				.alb (),
				.aleb (),
				.aneb (),
				.clken (1'b1),
				.clock (1'b0));
	defparam
		LPM_COMPARE_component.lpm_hint = "ONE_INPUT_IS_CONSTANT=YES",
		LPM_COMPARE_component.lpm_representation = "UNSIGNED",
		LPM_COMPARE_component.lpm_type = "LPM_COMPARE",
		LPM_COMPARE_component.lpm_width = 7;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: AeqB NUMERIC "0"
// Retrieval info: PRIVATE: AgeB NUMERIC "1"
// Retrieval info: PRIVATE: AgtB NUMERIC "0"
// Retrieval info: PRIVATE: AleB NUMERIC "0"
// Retrieval info: PRIVATE: AltB NUMERIC "0"
// Retrieval info: PRIVATE: AneB NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: LPM_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: Latency NUMERIC "0"
// Retrieval info: PRIVATE: PortBValue NUMERIC "80"
// Retrieval info: PRIVATE: Radix NUMERIC "10"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: SignedCompare NUMERIC "0"
// Retrieval info: PRIVATE: aclr NUMERIC "0"
// Retrieval info: PRIVATE: clken NUMERIC "0"
// Retrieval info: PRIVATE: isPortBConstant NUMERIC "1"
// Retrieval info: PRIVATE: nBit NUMERIC "7"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_HINT STRING "ONE_INPUT_IS_CONSTANT=YES"
// Retrieval info: CONSTANT: LPM_REPRESENTATION STRING "UNSIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_COMPARE"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "7"
// Retrieval info: USED_PORT: ageb 0 0 0 0 OUTPUT NODEFVAL "ageb"
// Retrieval info: USED_PORT: dataa 0 0 7 0 INPUT NODEFVAL "dataa[6..0]"
// Retrieval info: CONNECT: @dataa 0 0 7 0 dataa 0 0 7 0
// Retrieval info: CONNECT: @datab 0 0 7 0 80 0 0 7 0
// Retrieval info: CONNECT: ageb 0 0 0 0 @ageb 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL COMP_USE_bb.v TRUE
// Retrieval info: LIB_FILE: lpm