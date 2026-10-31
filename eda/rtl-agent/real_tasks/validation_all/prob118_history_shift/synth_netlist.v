// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:41:37 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_o8xind8l/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    areset,
    predict_valid,
    predict_taken,
    predict_history,
    train_mispredicted,
    train_taken,
    train_history);
  input clk;
  input areset;
  input predict_valid;
  input predict_taken;
  output [31:0]predict_history;
  input train_mispredicted;
  input train_taken;
  input [31:0]train_history;

  wire VCC_1;
  wire areset;
  wire areset_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [31:0]p_3_in;
  wire [31:0]predict_history;
  wire \predict_history[31]_i_1_n_0 ;
  wire [31:0]predict_history_OBUF;
  wire predict_taken;
  wire predict_taken_IBUF;
  wire predict_valid;
  wire predict_valid_IBUF;
  wire [31:0]train_history;
  wire [30:0]train_history_IBUF;
  wire train_mispredicted;
  wire train_mispredicted_IBUF;
  wire train_taken;
  wire train_taken_IBUF;

  VCC VCC
       (.P(VCC_1));
  IBUF areset_IBUF_inst
       (.I(areset),
        .O(areset_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[0]_i_1 
       (.I0(train_taken_IBUF),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_taken_IBUF),
        .O(p_3_in[0]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[10]_i_1 
       (.I0(train_history_IBUF[9]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[9]),
        .O(p_3_in[10]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[11]_i_1 
       (.I0(train_history_IBUF[10]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[10]),
        .O(p_3_in[11]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[12]_i_1 
       (.I0(train_history_IBUF[11]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[11]),
        .O(p_3_in[12]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[13]_i_1 
       (.I0(train_history_IBUF[12]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[12]),
        .O(p_3_in[13]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[14]_i_1 
       (.I0(train_history_IBUF[13]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[13]),
        .O(p_3_in[14]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[15]_i_1 
       (.I0(train_history_IBUF[14]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[14]),
        .O(p_3_in[15]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[16]_i_1 
       (.I0(train_history_IBUF[15]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[15]),
        .O(p_3_in[16]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[17]_i_1 
       (.I0(train_history_IBUF[16]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[16]),
        .O(p_3_in[17]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[18]_i_1 
       (.I0(train_history_IBUF[17]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[17]),
        .O(p_3_in[18]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[19]_i_1 
       (.I0(train_history_IBUF[18]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[18]),
        .O(p_3_in[19]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[1]_i_1 
       (.I0(train_history_IBUF[0]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[0]),
        .O(p_3_in[1]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[20]_i_1 
       (.I0(train_history_IBUF[19]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[19]),
        .O(p_3_in[20]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[21]_i_1 
       (.I0(train_history_IBUF[20]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[20]),
        .O(p_3_in[21]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[22]_i_1 
       (.I0(train_history_IBUF[21]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[21]),
        .O(p_3_in[22]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[23]_i_1 
       (.I0(train_history_IBUF[22]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[22]),
        .O(p_3_in[23]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[24]_i_1 
       (.I0(train_history_IBUF[23]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[23]),
        .O(p_3_in[24]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[25]_i_1 
       (.I0(train_history_IBUF[24]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[24]),
        .O(p_3_in[25]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[26]_i_1 
       (.I0(train_history_IBUF[25]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[25]),
        .O(p_3_in[26]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[27]_i_1 
       (.I0(train_history_IBUF[26]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[26]),
        .O(p_3_in[27]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[28]_i_1 
       (.I0(train_history_IBUF[27]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[27]),
        .O(p_3_in[28]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[29]_i_1 
       (.I0(train_history_IBUF[28]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[28]),
        .O(p_3_in[29]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[2]_i_1 
       (.I0(train_history_IBUF[1]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[1]),
        .O(p_3_in[2]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[30]_i_1 
       (.I0(train_history_IBUF[29]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[29]),
        .O(p_3_in[30]));
  LUT2 #(
    .INIT(4'hE)) 
    \predict_history[31]_i_1 
       (.I0(predict_valid_IBUF),
        .I1(train_mispredicted_IBUF),
        .O(\predict_history[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[31]_i_2 
       (.I0(train_history_IBUF[30]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[30]),
        .O(p_3_in[31]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[3]_i_1 
       (.I0(train_history_IBUF[2]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[2]),
        .O(p_3_in[3]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[4]_i_1 
       (.I0(train_history_IBUF[3]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[3]),
        .O(p_3_in[4]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[5]_i_1 
       (.I0(train_history_IBUF[4]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[4]),
        .O(p_3_in[5]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[6]_i_1 
       (.I0(train_history_IBUF[5]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[5]),
        .O(p_3_in[6]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[7]_i_1 
       (.I0(train_history_IBUF[6]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[6]),
        .O(p_3_in[7]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[8]_i_1 
       (.I0(train_history_IBUF[7]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[7]),
        .O(p_3_in[8]));
  LUT4 #(
    .INIT(16'hB888)) 
    \predict_history[9]_i_1 
       (.I0(train_history_IBUF[8]),
        .I1(train_mispredicted_IBUF),
        .I2(predict_valid_IBUF),
        .I3(predict_history_OBUF[8]),
        .O(p_3_in[9]));
  OBUF \predict_history_OBUF[0]_inst 
       (.I(predict_history_OBUF[0]),
        .O(predict_history[0]));
  OBUF \predict_history_OBUF[10]_inst 
       (.I(predict_history_OBUF[10]),
        .O(predict_history[10]));
  OBUF \predict_history_OBUF[11]_inst 
       (.I(predict_history_OBUF[11]),
        .O(predict_history[11]));
  OBUF \predict_history_OBUF[12]_inst 
       (.I(predict_history_OBUF[12]),
        .O(predict_history[12]));
  OBUF \predict_history_OBUF[13]_inst 
       (.I(predict_history_OBUF[13]),
        .O(predict_history[13]));
  OBUF \predict_history_OBUF[14]_inst 
       (.I(predict_history_OBUF[14]),
        .O(predict_history[14]));
  OBUF \predict_history_OBUF[15]_inst 
       (.I(predict_history_OBUF[15]),
        .O(predict_history[15]));
  OBUF \predict_history_OBUF[16]_inst 
       (.I(predict_history_OBUF[16]),
        .O(predict_history[16]));
  OBUF \predict_history_OBUF[17]_inst 
       (.I(predict_history_OBUF[17]),
        .O(predict_history[17]));
  OBUF \predict_history_OBUF[18]_inst 
       (.I(predict_history_OBUF[18]),
        .O(predict_history[18]));
  OBUF \predict_history_OBUF[19]_inst 
       (.I(predict_history_OBUF[19]),
        .O(predict_history[19]));
  OBUF \predict_history_OBUF[1]_inst 
       (.I(predict_history_OBUF[1]),
        .O(predict_history[1]));
  OBUF \predict_history_OBUF[20]_inst 
       (.I(predict_history_OBUF[20]),
        .O(predict_history[20]));
  OBUF \predict_history_OBUF[21]_inst 
       (.I(predict_history_OBUF[21]),
        .O(predict_history[21]));
  OBUF \predict_history_OBUF[22]_inst 
       (.I(predict_history_OBUF[22]),
        .O(predict_history[22]));
  OBUF \predict_history_OBUF[23]_inst 
       (.I(predict_history_OBUF[23]),
        .O(predict_history[23]));
  OBUF \predict_history_OBUF[24]_inst 
       (.I(predict_history_OBUF[24]),
        .O(predict_history[24]));
  OBUF \predict_history_OBUF[25]_inst 
       (.I(predict_history_OBUF[25]),
        .O(predict_history[25]));
  OBUF \predict_history_OBUF[26]_inst 
       (.I(predict_history_OBUF[26]),
        .O(predict_history[26]));
  OBUF \predict_history_OBUF[27]_inst 
       (.I(predict_history_OBUF[27]),
        .O(predict_history[27]));
  OBUF \predict_history_OBUF[28]_inst 
       (.I(predict_history_OBUF[28]),
        .O(predict_history[28]));
  OBUF \predict_history_OBUF[29]_inst 
       (.I(predict_history_OBUF[29]),
        .O(predict_history[29]));
  OBUF \predict_history_OBUF[2]_inst 
       (.I(predict_history_OBUF[2]),
        .O(predict_history[2]));
  OBUF \predict_history_OBUF[30]_inst 
       (.I(predict_history_OBUF[30]),
        .O(predict_history[30]));
  OBUF \predict_history_OBUF[31]_inst 
       (.I(predict_history_OBUF[31]),
        .O(predict_history[31]));
  OBUF \predict_history_OBUF[3]_inst 
       (.I(predict_history_OBUF[3]),
        .O(predict_history[3]));
  OBUF \predict_history_OBUF[4]_inst 
       (.I(predict_history_OBUF[4]),
        .O(predict_history[4]));
  OBUF \predict_history_OBUF[5]_inst 
       (.I(predict_history_OBUF[5]),
        .O(predict_history[5]));
  OBUF \predict_history_OBUF[6]_inst 
       (.I(predict_history_OBUF[6]),
        .O(predict_history[6]));
  OBUF \predict_history_OBUF[7]_inst 
       (.I(predict_history_OBUF[7]),
        .O(predict_history[7]));
  OBUF \predict_history_OBUF[8]_inst 
       (.I(predict_history_OBUF[8]),
        .O(predict_history[8]));
  OBUF \predict_history_OBUF[9]_inst 
       (.I(predict_history_OBUF[9]),
        .O(predict_history[9]));
  FDCE \predict_history_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[0]),
        .Q(predict_history_OBUF[0]));
  FDCE \predict_history_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[10]),
        .Q(predict_history_OBUF[10]));
  FDCE \predict_history_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[11]),
        .Q(predict_history_OBUF[11]));
  FDCE \predict_history_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[12]),
        .Q(predict_history_OBUF[12]));
  FDCE \predict_history_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[13]),
        .Q(predict_history_OBUF[13]));
  FDCE \predict_history_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[14]),
        .Q(predict_history_OBUF[14]));
  FDCE \predict_history_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[15]),
        .Q(predict_history_OBUF[15]));
  FDCE \predict_history_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[16]),
        .Q(predict_history_OBUF[16]));
  FDCE \predict_history_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[17]),
        .Q(predict_history_OBUF[17]));
  FDCE \predict_history_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[18]),
        .Q(predict_history_OBUF[18]));
  FDCE \predict_history_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[19]),
        .Q(predict_history_OBUF[19]));
  FDCE \predict_history_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[1]),
        .Q(predict_history_OBUF[1]));
  FDCE \predict_history_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[20]),
        .Q(predict_history_OBUF[20]));
  FDCE \predict_history_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[21]),
        .Q(predict_history_OBUF[21]));
  FDCE \predict_history_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[22]),
        .Q(predict_history_OBUF[22]));
  FDCE \predict_history_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[23]),
        .Q(predict_history_OBUF[23]));
  FDCE \predict_history_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[24]),
        .Q(predict_history_OBUF[24]));
  FDCE \predict_history_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[25]),
        .Q(predict_history_OBUF[25]));
  FDCE \predict_history_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[26]),
        .Q(predict_history_OBUF[26]));
  FDCE \predict_history_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[27]),
        .Q(predict_history_OBUF[27]));
  FDCE \predict_history_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[28]),
        .Q(predict_history_OBUF[28]));
  FDCE \predict_history_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[29]),
        .Q(predict_history_OBUF[29]));
  FDCE \predict_history_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[2]),
        .Q(predict_history_OBUF[2]));
  FDCE \predict_history_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[30]),
        .Q(predict_history_OBUF[30]));
  FDCE \predict_history_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[31]),
        .Q(predict_history_OBUF[31]));
  FDCE \predict_history_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[3]),
        .Q(predict_history_OBUF[3]));
  FDCE \predict_history_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[4]),
        .Q(predict_history_OBUF[4]));
  FDCE \predict_history_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[5]),
        .Q(predict_history_OBUF[5]));
  FDCE \predict_history_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[6]),
        .Q(predict_history_OBUF[6]));
  FDCE \predict_history_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[7]),
        .Q(predict_history_OBUF[7]));
  FDCE \predict_history_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[8]),
        .Q(predict_history_OBUF[8]));
  FDCE \predict_history_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\predict_history[31]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(p_3_in[9]),
        .Q(predict_history_OBUF[9]));
  IBUF predict_taken_IBUF_inst
       (.I(predict_taken),
        .O(predict_taken_IBUF));
  IBUF predict_valid_IBUF_inst
       (.I(predict_valid),
        .O(predict_valid_IBUF));
  IBUF \train_history_IBUF[0]_inst 
       (.I(train_history[0]),
        .O(train_history_IBUF[0]));
  IBUF \train_history_IBUF[10]_inst 
       (.I(train_history[10]),
        .O(train_history_IBUF[10]));
  IBUF \train_history_IBUF[11]_inst 
       (.I(train_history[11]),
        .O(train_history_IBUF[11]));
  IBUF \train_history_IBUF[12]_inst 
       (.I(train_history[12]),
        .O(train_history_IBUF[12]));
  IBUF \train_history_IBUF[13]_inst 
       (.I(train_history[13]),
        .O(train_history_IBUF[13]));
  IBUF \train_history_IBUF[14]_inst 
       (.I(train_history[14]),
        .O(train_history_IBUF[14]));
  IBUF \train_history_IBUF[15]_inst 
       (.I(train_history[15]),
        .O(train_history_IBUF[15]));
  IBUF \train_history_IBUF[16]_inst 
       (.I(train_history[16]),
        .O(train_history_IBUF[16]));
  IBUF \train_history_IBUF[17]_inst 
       (.I(train_history[17]),
        .O(train_history_IBUF[17]));
  IBUF \train_history_IBUF[18]_inst 
       (.I(train_history[18]),
        .O(train_history_IBUF[18]));
  IBUF \train_history_IBUF[19]_inst 
       (.I(train_history[19]),
        .O(train_history_IBUF[19]));
  IBUF \train_history_IBUF[1]_inst 
       (.I(train_history[1]),
        .O(train_history_IBUF[1]));
  IBUF \train_history_IBUF[20]_inst 
       (.I(train_history[20]),
        .O(train_history_IBUF[20]));
  IBUF \train_history_IBUF[21]_inst 
       (.I(train_history[21]),
        .O(train_history_IBUF[21]));
  IBUF \train_history_IBUF[22]_inst 
       (.I(train_history[22]),
        .O(train_history_IBUF[22]));
  IBUF \train_history_IBUF[23]_inst 
       (.I(train_history[23]),
        .O(train_history_IBUF[23]));
  IBUF \train_history_IBUF[24]_inst 
       (.I(train_history[24]),
        .O(train_history_IBUF[24]));
  IBUF \train_history_IBUF[25]_inst 
       (.I(train_history[25]),
        .O(train_history_IBUF[25]));
  IBUF \train_history_IBUF[26]_inst 
       (.I(train_history[26]),
        .O(train_history_IBUF[26]));
  IBUF \train_history_IBUF[27]_inst 
       (.I(train_history[27]),
        .O(train_history_IBUF[27]));
  IBUF \train_history_IBUF[28]_inst 
       (.I(train_history[28]),
        .O(train_history_IBUF[28]));
  IBUF \train_history_IBUF[29]_inst 
       (.I(train_history[29]),
        .O(train_history_IBUF[29]));
  IBUF \train_history_IBUF[2]_inst 
       (.I(train_history[2]),
        .O(train_history_IBUF[2]));
  IBUF \train_history_IBUF[30]_inst 
       (.I(train_history[30]),
        .O(train_history_IBUF[30]));
  IBUF \train_history_IBUF[3]_inst 
       (.I(train_history[3]),
        .O(train_history_IBUF[3]));
  IBUF \train_history_IBUF[4]_inst 
       (.I(train_history[4]),
        .O(train_history_IBUF[4]));
  IBUF \train_history_IBUF[5]_inst 
       (.I(train_history[5]),
        .O(train_history_IBUF[5]));
  IBUF \train_history_IBUF[6]_inst 
       (.I(train_history[6]),
        .O(train_history_IBUF[6]));
  IBUF \train_history_IBUF[7]_inst 
       (.I(train_history[7]),
        .O(train_history_IBUF[7]));
  IBUF \train_history_IBUF[8]_inst 
       (.I(train_history[8]),
        .O(train_history_IBUF[8]));
  IBUF \train_history_IBUF[9]_inst 
       (.I(train_history[9]),
        .O(train_history_IBUF[9]));
  IBUF train_mispredicted_IBUF_inst
       (.I(train_mispredicted),
        .O(train_mispredicted_IBUF));
  IBUF train_taken_IBUF_inst
       (.I(train_taken),
        .O(train_taken_IBUF));
endmodule
