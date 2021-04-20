// megafunction wizard: %Frame Buffer v13.1%
// GENERATION: DEFERRED
// synthesis translate_off

module gg (
	clock,
	reset,
	din_ready,
	din_valid,
	din_data,
	din_startofpacket,
	din_endofpacket,
	dout_ready,
	dout_valid,
	dout_data,
	dout_startofpacket,
	dout_endofpacket,
	read_master_av_address,
	read_master_av_read,
	read_master_av_waitrequest,
	read_master_av_readdatavalid,
	read_master_av_readdata,
	read_master_av_burstcount,
	write_master_av_address,
	write_master_av_write,
	write_master_av_writedata,
	write_master_av_waitrequest,
	write_master_av_burstcount,
	);
	input		clock;
	input		reset;
	output		din_ready;
	input		din_valid;
	input	[7:0]	din_data;
	input		din_startofpacket;
	input		din_endofpacket;
	input		dout_ready;
	output		dout_valid;
	output	[7:0]	dout_data;
	output		dout_startofpacket;
	output		dout_endofpacket;
	output	[31:0]	read_master_av_address;
	output		read_master_av_read;
	input		read_master_av_waitrequest;
	input		read_master_av_readdatavalid;
	input	[63:0]	read_master_av_readdata;
	output	[5:0]	read_master_av_burstcount;
	output	[31:0]	write_master_av_address;
	output		write_master_av_write;
	output	[63:0]	write_master_av_writedata;
	input		write_master_av_waitrequest;
	output	[5:0]	write_master_av_burstcount;
endmodule
// synthesis translate_on
// Retrieval info: <?xml version="1.0"?>
//<!--
//	Generated by Altera MegaWizard Launcher Utility version 1.0
//	************************************************************
//	THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//	************************************************************
//	Copyright (C) 1991-2014 Altera Corporation
//	Any megafunction design, and related net list (encrypted or decrypted),
//	support information, device programming or simulation file, and any other
//	associated documentation or information provided by Altera or a partner
//	under Altera's Megafunction Partnership Program may be used only to
//	program PLD devices (but not masked PLD devices) from Altera.  Any other
//	use of such megafunction design, net list, support information, device
//	programming or simulation file, or any other related documentation or
//	information is prohibited for any other purpose, including, but not
//	limited to modification, reverse engineering, de-compiling, or use with
//	any other silicon devices, unless such use is explicitly licensed under
//	a separate agreement with Altera or a megafunction partner.  Title to
//	the intellectual property, including patents, copyrights, trademarks,
//	trade secrets, or maskworks, embodied in any such megafunction design,
//	net list, support information, device programming or simulation file, or
//	any other related documentation or information provided by Altera or a
//	megafunction partner, remains with Altera, the megafunction partner, or
//	their respective licensors.  No other licenses, including any licenses
//	needed under any third party's intellectual property, are provided herein.
//-->
// Retrieval info: <instance entity-name="alt_vip_vfb" version="13.1" >
// Retrieval info: 	<generic name="AUTO_DEVICE_FAMILY" value="Cyclone V" />
// Retrieval info: 	<generic name="PARAMETERISATION" value="&lt;frameBufferParams&gt;&lt;VFB_NAME&gt;MyFrameBuffer&lt;/VFB_NAME&gt;&lt;VFB_MAX_WIDTH&gt;640&lt;/VFB_MAX_WIDTH&gt;&lt;VFB_MAX_HEIGHT&gt;480&lt;/VFB_MAX_HEIGHT&gt;&lt;VFB_BPS&gt;8&lt;/VFB_BPS&gt;&lt;VFB_CHANNELS_IN_SEQ&gt;3&lt;/VFB_CHANNELS_IN_SEQ&gt;&lt;VFB_CHANNELS_IN_PAR&gt;1&lt;/VFB_CHANNELS_IN_PAR&gt;&lt;VFB_WRITER_RUNTIME_CONTROL&gt;0&lt;/VFB_WRITER_RUNTIME_CONTROL&gt;&lt;VFB_DROP_FRAMES&gt;1&lt;/VFB_DROP_FRAMES&gt;&lt;VFB_READER_RUNTIME_CONTROL&gt;0&lt;/VFB_READER_RUNTIME_CONTROL&gt;&lt;VFB_REPEAT_FRAMES&gt;1&lt;/VFB_REPEAT_FRAMES&gt;&lt;VFB_FRAMEBUFFERS_ADDR&gt;00000000&lt;/VFB_FRAMEBUFFERS_ADDR&gt;&lt;VFB_MEM_PORT_WIDTH&gt;64&lt;/VFB_MEM_PORT_WIDTH&gt;&lt;VFB_MEM_MASTERS_USE_SEPARATE_CLOCK&gt;0&lt;/VFB_MEM_MASTERS_USE_SEPARATE_CLOCK&gt;&lt;VFB_RDATA_FIFO_DEPTH&gt;64&lt;/VFB_RDATA_FIFO_DEPTH&gt;&lt;VFB_RDATA_BURST_TARGET&gt;32&lt;/VFB_RDATA_BURST_TARGET&gt;&lt;VFB_WDATA_FIFO_DEPTH&gt;64&lt;/VFB_WDATA_FIFO_DEPTH&gt;&lt;VFB_WDATA_BURST_TARGET&gt;32&lt;/VFB_WDATA_BURST_TARGET&gt;&lt;VFB_MAX_NUMBER_PACKETS&gt;0&lt;/VFB_MAX_NUMBER_PACKETS&gt;&lt;VFB_MAX_SYMBOLS_IN_PACKET&gt;10&lt;/VFB_MAX_SYMBOLS_IN_PACKET&gt;&lt;VFB_INTERLACED_SUPPORT&gt;0&lt;/VFB_INTERLACED_SUPPORT&gt;&lt;VFB_CONTROLLED_DROP_REPEAT&gt;0&lt;/VFB_CONTROLLED_DROP_REPEAT&gt;&lt;VFB_BURST_ALIGNMENT&gt;0&lt;/VFB_BURST_ALIGNMENT&gt;&lt;VFB_DROP_INVALID_FIELDS&gt;0&lt;/VFB_DROP_INVALID_FIELDS&gt;&lt;/frameBufferParams&gt;" />
// Retrieval info: </instance>