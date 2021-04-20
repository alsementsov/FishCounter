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

module soc_system_mm_interconnect_0_addr_router_003_default_decode
  #(
     parameter DEFAULT_CHANNEL = 5,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 18 
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


module soc_system_mm_interconnect_0_addr_router_003
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
    localparam PAD0 = log2ceil(64'h10 - 64'h0); 
    localparam PAD1 = log2ceil(64'h20 - 64'h10); 
    localparam PAD2 = log2ceil(64'h30 - 64'h20); 
    localparam PAD3 = log2ceil(64'h40 - 64'h30); 
    localparam PAD4 = log2ceil(64'h50 - 64'h40); 
    localparam PAD5 = log2ceil(64'h60 - 64'h50); 
    localparam PAD6 = log2ceil(64'h70 - 64'h60); 
    localparam PAD7 = log2ceil(64'h80 - 64'h70); 
    localparam PAD8 = log2ceil(64'h90 - 64'h80); 
    localparam PAD9 = log2ceil(64'ha0 - 64'h90); 
    localparam PAD10 = log2ceil(64'hb0 - 64'ha0); 
    localparam PAD11 = log2ceil(64'hc0 - 64'hb0); 
    localparam PAD12 = log2ceil(64'hd0 - 64'hc0); 
    localparam PAD13 = log2ceil(64'he0 - 64'hd0); 
    localparam PAD14 = log2ceil(64'hf0 - 64'he0); 
    localparam PAD15 = log2ceil(64'h100 - 64'hf0); 
    localparam PAD16 = log2ceil(64'h110 - 64'h100); 
    localparam PAD17 = log2ceil(64'h210 - 64'h200); 
    localparam PAD18 = log2ceil(64'h220 - 64'h210); 
    localparam PAD19 = log2ceil(64'h230 - 64'h220); 
    localparam PAD20 = log2ceil(64'h240 - 64'h230); 
    localparam PAD21 = log2ceil(64'h250 - 64'h240); 
    localparam PAD22 = log2ceil(64'h260 - 64'h250); 
    localparam PAD23 = log2ceil(64'h270 - 64'h260); 
    localparam PAD24 = log2ceil(64'h280 - 64'h270); 
    localparam PAD25 = log2ceil(64'h290 - 64'h280); 
    localparam PAD26 = log2ceil(64'h2a0 - 64'h290); 
    localparam PAD27 = log2ceil(64'h310 - 64'h300); 
    localparam PAD28 = log2ceil(64'h320 - 64'h310); 
    localparam PAD29 = log2ceil(64'h330 - 64'h320); 
    localparam PAD30 = log2ceil(64'h10008 - 64'h10000); 
    localparam PAD31 = log2ceil(64'h20008 - 64'h20000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h20008;
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


    soc_system_mm_interconnect_0_addr_router_003_default_decode the_default_decode(
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

    // ( 0x0 .. 0x10 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 18'h0   ) begin
            src_channel = 34'b00000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x10 .. 0x20 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 18'h10  && read_transaction  ) begin
            src_channel = 34'b00000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x20 .. 0x30 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 18'h20  && read_transaction  ) begin
            src_channel = 34'b00000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x30 .. 0x40 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 18'h30  && read_transaction  ) begin
            src_channel = 34'b00000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x40 .. 0x50 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 18'h40   ) begin
            src_channel = 34'b00000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x50 .. 0x60 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 18'h50   ) begin
            src_channel = 34'b00000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x60 .. 0x70 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 18'h60  && read_transaction  ) begin
            src_channel = 34'b00000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x70 .. 0x80 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 18'h70  && read_transaction  ) begin
            src_channel = 34'b00000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x80 .. 0x90 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 18'h80   ) begin
            src_channel = 34'b00000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x90 .. 0xa0 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 18'h90   ) begin
            src_channel = 34'b00000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0xa0 .. 0xb0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 18'ha0   ) begin
            src_channel = 34'b00000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0xb0 .. 0xc0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 18'hb0   ) begin
            src_channel = 34'b00000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0xc0 .. 0xd0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 18'hc0   ) begin
            src_channel = 34'b00000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0xd0 .. 0xe0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 18'hd0   ) begin
            src_channel = 34'b00000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0xe0 .. 0xf0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 18'he0   ) begin
            src_channel = 34'b00000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0xf0 .. 0x100 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 18'hf0   ) begin
            src_channel = 34'b00000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x100 .. 0x110 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 18'h100   ) begin
            src_channel = 34'b00000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x200 .. 0x210 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 18'h200  && read_transaction  ) begin
            src_channel = 34'b00000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x210 .. 0x220 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 18'h210  && read_transaction  ) begin
            src_channel = 34'b00000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x220 .. 0x230 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 18'h220  && read_transaction  ) begin
            src_channel = 34'b00000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x230 .. 0x240 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 18'h230   ) begin
            src_channel = 34'b00000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x240 .. 0x250 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 18'h240   ) begin
            src_channel = 34'b00000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x250 .. 0x260 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 18'h250   ) begin
            src_channel = 34'b00000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x260 .. 0x270 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 18'h260   ) begin
            src_channel = 34'b00000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x270 .. 0x280 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 18'h270   ) begin
            src_channel = 34'b00000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x280 .. 0x290 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 18'h280   ) begin
            src_channel = 34'b00001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x290 .. 0x2a0 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 18'h290   ) begin
            src_channel = 34'b00010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x300 .. 0x310 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 18'h300   ) begin
            src_channel = 34'b00100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x310 .. 0x320 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 18'h310  && read_transaction  ) begin
            src_channel = 34'b01000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x320 .. 0x330 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 18'h320   ) begin
            src_channel = 34'b10000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x10000 .. 0x10008 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 18'h10000  && read_transaction  ) begin
            src_channel = 34'b00000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x20000 .. 0x20008 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 18'h20000   ) begin
            src_channel = 34'b00000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
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


