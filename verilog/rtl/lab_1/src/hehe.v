`include "params.vh"
`timescale  1ns/1ps
/* verilator lint_off BLKANDNBLK */
module hehe
#(
    parameter XLEN = 64,
    parameter VIRTUAL_ADDR_LEN = 32,
    parameter WB_DATA_LEN = 32
) 
(
    input clk,
    input reset,
    input meip,
    
    // d$ / lsu <-> Soc
    output [31:0] m2_wbd_dat_o, 
    output [31:0] m2_wbd_adr_o, 
    output [3:0] m2_wbd_sel_o,
    output [9:0] m2_wbd_bl_o,
    output m2_wbd_bry_o,
    output m2_wbd_we_o,
    output m2_wbd_cyc_o,
    output m2_wbd_stb_o,
    input [31:0] m2_wbd_dat_i,
    input m2_wbd_ack_i, 
    
    /* verilator lint_off UNUSED */
    input m2_wbd_lack_i,
    input m2_wbd_err_i,
   

    // I$ <-> Soc
    output [31:0] m3_wbd_adr_o,
    output [3:0] m3_wbd_sel_o,
    output [9:0] m3_wbd_bl_o,
    output m3_wbd_bry_o,
    output m3_wbd_we_o,
    output m3_wbd_cyc_o,
    output m3_wbd_stb_o,   
    input [31:0] m3_wbd_dat_i,
    input m3_wbd_ack_i,
    input m3_wbd_lack_i,
    input m3_wbd_err_i
);

wire [31:0] data_dout1;
wire [7:0] okk0 = 8'b0;
wire okk1 = 1;
//   sky130_fd_sc_hd__conb_1 okk1 (
//     .LO(okk1)
//   );

// cache <-> core_empty / arbitor
wire icache_req_valid;
wire icache_req_ready;
wire [31:0] icache_req_addr;
wire icache_resp_valid;
wire [31:0] insn;
wire icache_resp_ready;
wire [31:0] icache_resp_address;
wire icache_cyc_o;
wire icache_stb_o;
wire icache_we_o;
wire [31:0] icache_adr_o;
wire [9:0] icache_bl_o;
wire icache_bry_o;
wire icache_ack_i;
wire [31:0] icache_dat_i;
wire dcache_req_valid;
wire dcache_req_ready;
wire dcache_opcode;
wire [31:0] dcache_req_addr;
wire [2:0] dcache_type;
wire [63:0] dcache_st_data;
wire dcache_lsq_index;
wire dcache_resp_valid;
wire dcache_resp_ready;
wire [63:0] dcache_resp_data;
wire dcache_rob_index;
wire dcache_cyc_o;
wire dcache_stb_o;
wire dcache_we_o;
wire [31:0] dcache_adr_o;
wire [9:0] dcache_bl_o;
wire dcache_bry_o;
wire dcache_ack_i;
wire [31:0] dcache_dat_i;
wire [31:0] dcache_dat_o;
wire [3:0] dcache_sel_o;

// core_empty<->arbitor
wire others_wb_cyc;
wire others_wb_stb;
wire others_wb_we;
wire [VIRTUAL_ADDR_LEN - 1 : 0] others_wb_adr;
wire [WB_DATA_LEN-1:0] others_wb_dat_i;
wire [WB_DATA_LEN-1:0] others_wb_dat_o;
wire [WB_DATA_LEN/8-1:0] others_wb_sel;
wire  others_wb_ack;

// cache <-> sram
wire icache_tag_chip_en;    
wire icache_tag_write_en;
wire [3:0] icache_write_tag_mask;
wire [7:0] icache_tag_index;
wire [31:0] icache_tag_data_in;
wire [31:0] icache_tag_out;    
    //icache_data
wire icache_data_chip_en;    
wire icache_data_write_en;
wire [3:0] icache_write_data_mask;
wire [7:0] icache_data_index;
wire [31:0] icache_data_in;
wire [31:0] icache_data_out;
//dcache
    //dcache_tag
wire dcache_tag_chip_en;
wire dcache_tag_write_en;
wire [3:0] dcache_write_tag_mask;
wire [7:0] dcache_tag_index;
wire [31:0] dcache_tag_data_in;
wire [31:0]  dcache_tag_out;
    //dcache_data_1
wire dcache_data_chip_en_1;
wire dcache_data_write_en_1;
wire [3:0] dcache_write_data_mask_1;
wire [7:0] dcache_data_index_1;
wire [31:0] dcache_data_in_1;
wire [31:0] dcache_data_out_1;
    //dcache_data_2
wire dcache_data_chip_en_2;
wire dcache_data_write_en_2;
wire [3:0] dcache_write_data_mask_2;
wire [7:0] dcache_data_index_2;
wire [31:0] dcache_data_in_2;
wire [31:0] dcache_data_out_2;

assign m3_wbd_sel_o = 4'b0;

core_empty core_u (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    .clk(clk),
    .reset(reset),

    // others ports
    .others_wb_cyc_o(others_wb_cyc),
    .others_wb_stb_o(others_wb_stb),
    .others_wb_we_o(others_wb_we),
    .others_wb_adr_o(others_wb_adr),
    .others_wb_dat_o(others_wb_dat_o),
    .others_wb_sel_o(others_wb_sel),
    .others_wb_ack_i(others_wb_ack),
    .others_wb_dat_i(others_wb_dat_i),

    // Dcache interface
    .dcache_req_valid_o(dcache_req_valid),
    .dcache_opcode(dcache_opcode),
    .dcache_req_addr(dcache_req_addr),
    .dcache_type_o(dcache_type),
    .dcache_st_data_o(dcache_st_data),
    .dcache_resp_ready_o(dcache_resp_ready),
    .dcache2back_resp_valid_i(dcache_resp_valid),
    .back2dcache_lsq_index_o(dcache_lsq_index),
    .dcache2back_resp_data_i(dcache_resp_data), 
    .dcache_req_ready_i(dcache_req_ready),
    .dcache2back_rob_index_i(dcache_rob_index),

    // Icache interface
    .icache_req_valid_o(icache_req_valid),
    .icache_req_ready_i(icache_req_ready),
    .icache_req_addr(icache_req_addr),
    .icache_resp_ready_o(icache_resp_ready),
    .icache_resp_valid_i(icache_resp_valid),
    .icache_resp_address_i(icache_resp_address),
    .insn_i(insn),

    // CSR interupt controller
    .meip(meip)
);

l1icache_32 #(
  .VIRTUAL_ADDR_LEN(32),
  .WB_DATA_LEN(32)
)
l1icache_u
(
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    .clk (clk),
    .rstn (reset),
 
    //req
    .req_valid_i (icache_req_valid),
    .req_ready_o (icache_req_ready),
    .req_addr_i (icache_req_addr),

    //resp
    .resp_valid_o (icache_resp_valid),
    .ld_data_o (insn),
    .resp_ready_i(icache_resp_ready),
    .resp_addr_o(icache_resp_address),

    //sram
    .tag_chip_en (icache_tag_chip_en),
    .tag_write_en (icache_tag_write_en),
    .write_tag_mask (icache_write_tag_mask),
    .tag_index (icache_tag_index),
    .tag_data_in (icache_tag_data_in),
    .tag_out (icache_tag_out),
    .data_chip_en (icache_data_chip_en),
    .data_write_en (icache_data_write_en),
    .write_data_mask (icache_write_data_mask),
    .data_index (icache_data_index),
    .data_in (icache_data_in),
    .data_out (icache_data_out),

    .wb_cyc_o (m3_wbd_cyc_o),
    .wb_stb_o (m3_wbd_stb_o),
    .wb_we_o (m3_wbd_we_o),
    .wb_adr_o (m3_wbd_adr_o),
    .wb_bl_o(m3_wbd_bl_o),
    .wb_bry_o(m3_wbd_bry_o),
    .wb_ack_i (m3_wbd_ack_i),
    .wb_dat_i (m3_wbd_dat_i)
);

l1dcache #(
  .WB_DATA_LEN(32)
)
l1dcache_u
(
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    .clk (clk),
    .rstn (reset),
    //req
    .req_valid_i (dcache_req_valid),
    .req_ready_o (dcache_req_ready),
    .opcode (dcache_opcode),
    .req_addr_i (dcache_req_addr),
    .type_i (dcache_type),
    .st_data_i (dcache_st_data),
    .rob_index_i (dcache_lsq_index),

    //resp
    .resp_ready_i (dcache_resp_ready),
    .resp_valid_o (dcache_resp_valid),
    .ld_data_o (dcache_resp_data),
    .rob_index_o (dcache_rob_index),

    .tag_chip_en (dcache_tag_chip_en),
    .tag_write_en (dcache_tag_write_en),
    .write_tag_mask (dcache_write_tag_mask),
    .tag_index (dcache_tag_index),
    .tag_data_in (dcache_tag_data_in),
    .tag_out (dcache_tag_out), 

    .data_chip_en_1 (dcache_data_chip_en_1),
    .data_write_en_1 (dcache_data_write_en_1),
    .write_data_mask_1 (dcache_write_data_mask_1),
    .data_index_1 (dcache_data_index_1),
    .data_in_1 (dcache_data_in_1),
    .data_out_1 (dcache_data_out_1), 

    .data_chip_en_2 (dcache_data_chip_en_2),
    .data_write_en_2 (dcache_data_write_en_2),
    .write_data_mask_2 (dcache_write_data_mask_2),
    .data_index_2 (dcache_data_index_2),
    .data_in_2 (dcache_data_in_2),
    .data_out_2 (dcache_data_out_2), 

    //memory
    .wb_cyc_o (dcache_cyc_o),
    .wb_stb_o (dcache_stb_o),
    .wb_we_o (dcache_we_o),
    .wb_adr_o (dcache_adr_o),
    .wb_dat_o (dcache_dat_o),
    .wb_sel_o (dcache_sel_o),
    .wb_bl_o (dcache_bl_o),
    .wb_bry_o(dcache_bry_o),
    .wb_ack_i (dcache_ack_i),
    .wb_dat_i (dcache_dat_i)
    
);

bus_arbiter arbiter_u(
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    .clk(clk), 
    .reset(reset),

    .m2_others_wbd_dat_i(others_wb_dat_o),
    .m2_others_wbd_adr_i(others_wb_adr), 
    .m2_others_wbd_sel_i(others_wb_sel),
    .m2_others_wbd_we_i(others_wb_we),
    .m2_others_wbd_cyc_i(others_wb_cyc),
    .m2_others_wbd_stb_i(others_wb_stb),
    .m2_others_wbd_dat_o(others_wb_dat_i),
    .m2_others_wbd_ack_o(others_wb_ack),
        //加上突发
    .m2_dcache_wbd_dat_i(dcache_dat_o), 
    .m2_dcache_wbd_adr_i(dcache_adr_o), 
    .m2_dcache_wbd_sel_i(dcache_sel_o),
    .m2_dcache_wbd_we_i(dcache_we_o),
    .m2_dcache_wbd_cyc_i(dcache_cyc_o),
    .m2_dcache_wbd_stb_i(dcache_stb_o),
    .m2_dcache_wbd_dat_o(dcache_dat_i),
    .m2_dcache_wbd_ack_o(dcache_ack_i), 

    .m2_wbd_dat_o(m2_wbd_dat_o), 
    .m2_wbd_adr_o(m2_wbd_adr_o), 
    .m2_wbd_sel_o(m2_wbd_sel_o),
    .m2_wbd_bl_o(m2_wbd_bl_o),
    .m2_wbd_bry_o(m2_wbd_bry_o),
    .m2_wbd_we_o(m2_wbd_we_o),
    .m2_wbd_cyc_o(m2_wbd_cyc_o),
    .m2_wbd_stb_o(m2_wbd_stb_o),
    .m2_wbd_dat_i(m2_wbd_dat_i),
    .m2_wbd_ack_i(m2_wbd_ack_i)
);

sky130_sram_1kbyte_1rw1r_32x256_8  icache_tag_ram (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    						.clk0   (clk),
                            .csb0   (icache_tag_chip_en),
                            .web0   (icache_tag_write_en),
                            .wmask0 (icache_write_tag_mask),
                            .addr0  (icache_tag_index),
                            .din0   (icache_tag_data_in),
                            .dout0  (icache_tag_out),
                            .clk1 (clk),
                            .csb1 (okk1),
                            .addr1 (okk0),
                            .dout1 (data_dout1));  


sky130_sram_1kbyte_1rw1r_32x256_8  icache_data_ram (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    						.clk0   (clk),
                            .csb0   (icache_data_chip_en),
                            .web0   (icache_data_write_en),
                            .wmask0 (icache_write_data_mask),
                            .addr0  (icache_data_index),
                            .din0   (icache_data_in),
                            .dout0  (icache_data_out),
                            .clk1 (clk),
                            .csb1 (okk1),
                            .addr1 (okk0),
                            .dout1 (data_dout1));  

sky130_sram_1kbyte_1rw1r_32x256_8  dcache_tag_ram (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    						.clk0   (clk),
                            .csb0   (dcache_tag_chip_en),
                            .web0   (dcache_tag_write_en),
                            .wmask0 (dcache_write_tag_mask),
                            .addr0  (dcache_tag_index),
                            .din0   (dcache_tag_data_in),
                            .dout0  (dcache_tag_out),
                            .clk1 (clk),
                            .csb1 (okk1),
                            .addr1 (okk0),
                            .dout1 (data_dout1));  

sky130_sram_1kbyte_1rw1r_32x256_8  dcache_data_ram_1 (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    						.clk0   (clk),
                            .csb0   (dcache_data_chip_en_1),
                            .web0   (dcache_data_write_en_1),
                            .wmask0 (dcache_write_data_mask_1),
                            .addr0  (dcache_data_index_1),
                            .din0   (dcache_data_in_1),
                            .dout0  (dcache_data_out_1),
                            .clk1 (clk),
                            .csb1 (okk1),
                            .addr1 (okk0),
                            .dout1 (data_dout1));   


sky130_sram_1kbyte_1rw1r_32x256_8  dcache_data_ram_2 (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),  // User area 1 1.8V power
            .vssd1(vssd1),  // User area 1 digital ground
    `endif
    						.clk0   (clk),
                            .csb0   (dcache_data_chip_en_2),
                            .web0   (dcache_data_write_en_2),
                            .wmask0 (dcache_write_data_mask_2),
                            .addr0  (dcache_data_index_2),
                            .din0   (dcache_data_in_2),
                            .dout0  (dcache_data_out_2),
                            .clk1 (clk),
                            .csb1 (okk1),
                            .addr1 (okk0),
                            .dout1 (data_dout1));  
/* verilator lint_on BLKANDNBLK */
endmodule
