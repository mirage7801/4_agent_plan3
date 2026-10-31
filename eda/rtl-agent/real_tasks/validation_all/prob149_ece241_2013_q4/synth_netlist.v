// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:19:29 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_8zcgu9z9/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A2 = "0" *) (* B1 = "1" *) (* B2 = "2" *) 
(* C1 = "3" *) (* C2 = "4" *) (* D1 = "5" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    reset,
    s,
    fr2,
    fr1,
    fr0,
    dfr);
  input clk;
  input reset;
  input [2:0]s;
  output fr2;
  output fr1;
  output fr0;
  output dfr;

  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire dfr;
  wire dfr_OBUF;
  wire fr0;
  wire fr0_OBUF;
  wire fr1;
  wire fr1_OBUF;
  wire fr2;
  wire fr2_OBUF;
  wire [2:0]next;
  wire reset;
  wire reset_IBUF;
  wire [2:0]s;
  wire [2:0]s_IBUF;
  wire [2:0]state;

  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF dfr_OBUF_inst
       (.I(dfr_OBUF),
        .O(dfr));
  LUT1 #(
    .INIT(2'h1)) 
    dfr_OBUF_inst_i_1
       (.I0(state[0]),
        .O(dfr_OBUF));
  OBUF fr0_OBUF_inst
       (.I(fr0_OBUF),
        .O(fr0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h7)) 
    fr0_OBUF_inst_i_1
       (.I0(state[2]),
        .I1(state[0]),
        .O(fr0_OBUF));
  OBUF fr1_OBUF_inst
       (.I(fr1_OBUF),
        .O(fr1));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h07)) 
    fr1_OBUF_inst_i_1
       (.I0(state[0]),
        .I1(state[1]),
        .I2(state[2]),
        .O(fr1_OBUF));
  OBUF fr2_OBUF_inst
       (.I(fr2_OBUF),
        .O(fr2));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h01)) 
    fr2_OBUF_inst_i_1
       (.I0(state[2]),
        .I1(state[0]),
        .I2(state[1]),
        .O(fr2_OBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF \s_IBUF[0]_inst 
       (.I(s[0]),
        .O(s_IBUF[0]));
  IBUF \s_IBUF[1]_inst 
       (.I(s[1]),
        .O(s_IBUF[1]));
  IBUF \s_IBUF[2]_inst 
       (.I(s[2]),
        .O(s_IBUF[2]));
  LUT6 #(
    .INIT(64'hDDCDDD8DDDC8D888)) 
    \state[0]_i_1 
       (.I0(state[2]),
        .I1(s_IBUF[2]),
        .I2(state[1]),
        .I3(s_IBUF[1]),
        .I4(state[0]),
        .I5(s_IBUF[0]),
        .O(next[0]));
  LUT6 #(
    .INIT(64'h1155550011007222)) 
    \state[1]_i_1 
       (.I0(state[2]),
        .I1(s_IBUF[2]),
        .I2(s_IBUF[0]),
        .I3(state[1]),
        .I4(state[0]),
        .I5(s_IBUF[1]),
        .O(next[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFCCCCC88)) 
    \state[2]_i_1 
       (.I0(s_IBUF[1]),
        .I1(state[2]),
        .I2(state[1]),
        .I3(s_IBUF[2]),
        .I4(state[0]),
        .O(next[2]));
  FDRE \state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(next[0]),
        .Q(state[0]),
        .R(reset_IBUF));
  FDRE \state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(next[1]),
        .Q(state[1]),
        .R(reset_IBUF));
  FDRE \state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(next[2]),
        .Q(state[2]),
        .R(reset_IBUF));
endmodule
