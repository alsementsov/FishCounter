// Generated by SDI 13.1 [Altera, IP Toolbench 1.3.0 Build 162]
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
// ************************************************************
// Copyright (C) 1991-2014 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.

module sdi (
	rst_tx,
	tx_pclk,
	tx_serial_refclk,
	txdata,
	tx_trs,
	tx_ln,
	enable_ln,
	enable_crc,
	sdi_reconfig_togxb,
	sdi_tx,
	tx_status,
	gxb_tx_clkout,
	sdi_reconfig_fromgxb);

	input		rst_tx;
	input		tx_pclk;
	input		tx_serial_refclk;
	input	[19:0]	txdata;
	input	[0:0]	tx_trs;
	input	[21:0]	tx_ln;
	input	[0:0]	enable_ln;
	input	[0:0]	enable_crc;
	input	[139:0]	sdi_reconfig_togxb;
	output	[0:0]	sdi_tx;
	output	[0:0]	tx_status;
	output	[0:0]	gxb_tx_clkout;
	output	[91:0]	sdi_reconfig_fromgxb;
endmodule
