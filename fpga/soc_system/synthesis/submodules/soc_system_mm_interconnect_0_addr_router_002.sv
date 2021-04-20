// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#5 $
// $Revision: #5 $
// $Date: 2013/09/30 $
// $Author: perforce $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module soc_system_mm_interconnect_0_addr_router_002_default_decode
  #(
     parameter DEFAULT_CHANNEL = 0,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 17 
   )
  (output [110 - 105 : 0] default_destination_id,
   output [34-1 : 0] default_wr_channel,
   output [34-1 : 0] default_rd_channel,
   output [34-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[110 - 105 : 0];

  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1) begin
      assign default_src_channel = '0;
    end
    else begin
      assign default_src_channel = 34'b1 << DEFAULT_CHANNEL;
    end
  end
  endgenerate

  generate begin : default_decode_rw
    if (DEFAULT_RD_CHANNEL == -1) begin
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin
      assign default_wr_channel = 34'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 34'b1 << DEFAULT_RD_CHANNEL;
    end
  end
  endgenerate

endmodule


module soc_system_mm_interconnect_0_addr_router_002
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [135-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [135-1    : 0] src_data,
    output reg [34-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 110;
    localparam PKT_DEST_ID_L = 105;
    localparam PKT_PROTECTION_H = 125;
    localparam PKT_PROTECTION_L = 123;
    localparam ST_DATA_W = 135;
    localparam ST_CHANNEL_W = 34;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h10008 - 64'h10000); 
    localparam PAD2 = log2ceil(64'h10020 - 64'h10010); 
    localparam PAD3 = log2ceil(64'h10030 - 64'h10020); 
    localparam PAD4 = log2ceil(64'h10040 - 64'h10030); 
    localparam PAD5 = log2ceil(64'h10050 - 64'h10040); 
    localparam PAD6 = log2ceil(64'h10060 - 64'h10050); 
    localparam PAD7 = log2ceil(64'h10070 - 64'h10060); 
    localparam PAD8 = log2ceil(64'h10080 - 64'h10070); 
    localparam PAD9 = log2ceil(64'h10090 - 64'h10080); 
    localparam PAD10 = log2ceil(64'h100a0 - 64'h10090); 
    localparam PAD11 = log2ceil(64'h100b0 - 64'h100a0); 
    localparam PAD12 = log2ceil(64'h100c0 - 64'h100b0); 
    localparam PAD13 = log2ceil(64'h100d0 - 64'h100c0); 
    localparam PAD14 = log2ceil(64'h100e0 - 64'h100d0); 
    localparam PAD15 = log2ceil(64'h100f0 - 64'h100e0); 
    localparam PAD16 = log2ceil(64'h10100 - 64'h100f0); 
    localparam PAD17 = log2ceil(64'h10110 - 64'h10100); 
    localparam PAD18 = log2ceil(64'h10210 - 64'h10200); 
    localparam PAD19 = log2ceil(64'h10220 - 64'h10210); 
    localparam PAD20 = log2ceil(64'h10230 - 64'h10220); 
    localparam PAD21 = log2ceil(64'h10240 - 64'h10230); 
    localparam PAD22 = log2ceil(64'h10250 - 64'h10240); 
    localparam PAD23 = log2ceil(64'h10260 - 64'h10250); 
    localparam PAD24 = log2ceil(64'h10270 - 64'h10260); 
    localparam PAD25 = log2ceil(64'h10280 - 64'h10270); 
    localparam PAD26 = log2ceil(64'h10290 - 64'h10280); 
    localparam PAD27 = log2ceil(64'h102a0 - 64'h10290); 
    localparam PAD28 = log2ceil(64'h10310 - 64'h10300); 
    localparam PAD29 = log2ceil(64'h10320 - 64'h10310); 
    localparam PAD30 = log2ceil(64'h10330 - 64'h10320); 
    localparam PAD31 = log2ceil(64'h20008 - 64'h20000); 
    localparam PAD32 = log2ceil(64'h20020 - 64'h20010); 
    localparam PAD33 = log2ceil(64'h30008 - 64'h30000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h30008;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [34-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    soc_system_mm_interconnect_0_addr_router_002_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x10000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 18'h0   ) begin
            src_channel = 34'b0000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x10000 .. 0x10008 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 18'h10000  && read_transaction  ) begin
            src_channel = 34'b0000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x10010 .. 0x10020 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 18'h10010  && read_transaction  ) begin
            src_channel = 34'b0000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x10020 .. 0x10030 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 18'h10020  && read_transaction  ) begin
            src_channel = 34'b0000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x10030 .. 0x10040 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 18'h10030  && read_transaction  ) begin
            src_channel = 34'b0000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x10040 .. 0x10050 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 18'h10040   ) begin
            src_channel = 34'b0000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x10050 .. 0x10060 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 18'h10050   ) begin
            src_channel = 34'b0000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x10060 .. 0x10070 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 18'h10060  && read_transaction  ) begin
            src_channel = 34'b0000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x10070 .. 0x10080 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 18'h10070  && read_transaction  ) begin
            src_channel = 34'b0000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x10080 .. 0x10090 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 18'h10080   ) begin
            src_channel = 34'b0000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x10090 .. 0x100a0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 18'h10090   ) begin
            src_channel = 34'b0000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x100a0 .. 0x100b0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 18'h100a0   ) begin
            src_channel = 34'b0000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x100b0 .. 0x100c0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 18'h100b0   ) begin
            src_channel = 34'b0000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x100c0 .. 0x100d0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 18'h100c0   ) begin
            src_channel = 34'b0000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x100d0 .. 0x100e0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 18'h100d0   ) begin
            src_channel = 34'b0000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x100e0 .. 0x100f0 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 18'h100e0   ) begin
            src_channel = 34'b0000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x100f0 .. 0x10100 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 18'h100f0   ) begin
            src_channel = 34'b0000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x10100 .. 0x10110 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 18'h10100   ) begin
            src_channel = 34'b0000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x10200 .. 0x10210 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 18'h10200  && read_transaction  ) begin
            src_channel = 34'b0000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x10210 .. 0x10220 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 18'h10210  && read_transaction  ) begin
            src_channel = 34'b0000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x10220 .. 0x10230 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 18'h10220  && read_transaction  ) begin
            src_channel = 34'b0000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x10230 .. 0x10240 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 18'h10230   ) begin
            src_channel = 34'b0000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x10240 .. 0x10250 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 18'h10240   ) begin
            src_channel = 34'b0000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x10250 .. 0x10260 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 18'h10250   ) begin
            src_channel = 34'b0000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x10260 .. 0x10270 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 18'h10260   ) begin
            src_channel = 34'b0000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x10270 .. 0x10280 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 18'h10270   ) begin
            src_channel = 34'b0000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x10280 .. 0x10290 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 18'h10280   ) begin
            src_channel = 34'b0000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x10290 .. 0x102a0 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 18'h10290   ) begin
            src_channel = 34'b0001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x10300 .. 0x10310 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 18'h10300   ) begin
            src_channel = 34'b0010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x10310 .. 0x10320 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 18'h10310  && read_transaction  ) begin
            src_channel = 34'b0100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x10320 .. 0x10330 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 18'h10320   ) begin
            src_channel = 34'b1000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x20000 .. 0x20008 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 18'h20000   ) begin
            src_channel = 34'b0000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x20010 .. 0x20020 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 18'h20010   ) begin
            src_channel = 34'b0000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x30000 .. 0x30008 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 18'h30000  && read_transaction  ) begin
            src_channel = 34'b0000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


