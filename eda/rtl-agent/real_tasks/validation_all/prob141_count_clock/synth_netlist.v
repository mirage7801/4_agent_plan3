// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:10:31 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_lp_c0lad/synth_netlist.v
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
    reset,
    ena,
    pm,
    hh,
    mm,
    ss);
  input clk;
  input reset;
  input ena;
  output pm;
  output [7:0]hh;
  output [7:0]mm;
  output [7:0]ss;

  wire \<const0> ;
  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire ena;
  wire ena_IBUF;
  wire [7:0]hh;
  wire \hh[0]_i_1_n_0 ;
  wire \hh[1]_i_1_n_0 ;
  wire \hh[2]_i_1_n_0 ;
  wire \hh[3]_i_1_n_0 ;
  wire \hh[3]_i_2_n_0 ;
  wire \hh[4]_i_1_n_0 ;
  wire \hh[5]_i_1_n_0 ;
  wire \hh[6]_i_1_n_0 ;
  wire \hh[6]_i_2_n_0 ;
  wire \hh[7]_i_1_n_0 ;
  wire \hh[7]_i_2_n_0 ;
  wire \hh[7]_i_3_n_0 ;
  wire \hh[7]_i_4_n_0 ;
  wire \hh[7]_i_5_n_0 ;
  wire \hh[7]_i_6_n_0 ;
  wire \hh[7]_i_7_n_0 ;
  wire \hh[7]_i_8_n_0 ;
  wire [7:0]hh_OBUF;
  wire [7:0]mm;
  wire [3:0]mm0;
  wire \mm[0]_i_1_n_0 ;
  wire \mm[1]_i_1_n_0 ;
  wire \mm[2]_i_1_n_0 ;
  wire \mm[3]_i_1_n_0 ;
  wire \mm[3]_i_2_n_0 ;
  wire \mm[3]_i_3_n_0 ;
  wire \mm[3]_i_4_n_0 ;
  wire \mm[7]_i_1_n_0 ;
  wire \mm[7]_i_2_n_0 ;
  wire \mm[7]_i_4_n_0 ;
  wire \mm[7]_i_5_n_0 ;
  wire \mm[7]_i_6_n_0 ;
  wire \mm[7]_i_7_n_0 ;
  wire [7:0]mm_OBUF;
  wire pm;
  wire pm_OBUF;
  wire pm_i_1_n_0;
  wire pm_i_2_n_0;
  wire pm_i_3_n_0;
  wire reset;
  wire reset_IBUF;
  wire [7:0]ss;
  wire [3:0]ss0;
  wire \ss[0]_i_1_n_0 ;
  wire \ss[1]_i_1_n_0 ;
  wire \ss[2]_i_1_n_0 ;
  wire \ss[3]_i_1_n_0 ;
  wire \ss[3]_i_2_n_0 ;
  wire \ss[7]_i_1_n_0 ;
  wire \ss[7]_i_2_n_0 ;
  wire [7:0]ss_OBUF;

  GND GND
       (.G(\<const0> ));
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
  IBUF ena_IBUF_inst
       (.I(ena),
        .O(ena_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \hh[0]_i_1 
       (.I0(hh_OBUF[0]),
        .I1(reset_IBUF),
        .O(\hh[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF66664062)) 
    \hh[1]_i_1 
       (.I0(hh_OBUF[0]),
        .I1(hh_OBUF[1]),
        .I2(\hh[7]_i_6_n_0 ),
        .I3(hh_OBUF[3]),
        .I4(\hh[7]_i_4_n_0 ),
        .I5(reset_IBUF),
        .O(\hh[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h1540154015400000)) 
    \hh[2]_i_1 
       (.I0(reset_IBUF),
        .I1(hh_OBUF[1]),
        .I2(hh_OBUF[0]),
        .I3(hh_OBUF[2]),
        .I4(\hh[7]_i_4_n_0 ),
        .I5(\hh[7]_i_3_n_0 ),
        .O(\hh[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA8AAAAAAA8AA8888)) 
    \hh[3]_i_1 
       (.I0(\hh[3]_i_2_n_0 ),
        .I1(\hh[7]_i_4_n_0 ),
        .I2(hh_OBUF[1]),
        .I3(hh_OBUF[3]),
        .I4(hh_OBUF[0]),
        .I5(\hh[7]_i_6_n_0 ),
        .O(\hh[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00006AAA)) 
    \hh[3]_i_2 
       (.I0(hh_OBUF[3]),
        .I1(hh_OBUF[2]),
        .I2(hh_OBUF[1]),
        .I3(hh_OBUF[0]),
        .I4(reset_IBUF),
        .O(\hh[3]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \hh[4]_i_1 
       (.I0(reset_IBUF),
        .I1(hh_OBUF[4]),
        .O(\hh[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h1414141414141400)) 
    \hh[5]_i_1 
       (.I0(reset_IBUF),
        .I1(hh_OBUF[4]),
        .I2(hh_OBUF[5]),
        .I3(\hh[7]_i_4_n_0 ),
        .I4(\hh[7]_i_6_n_0 ),
        .I5(hh_OBUF[0]),
        .O(\hh[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hAAA8)) 
    \hh[6]_i_1 
       (.I0(\hh[6]_i_2_n_0 ),
        .I1(\hh[7]_i_4_n_0 ),
        .I2(\hh[7]_i_6_n_0 ),
        .I3(hh_OBUF[0]),
        .O(\hh[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h006A)) 
    \hh[6]_i_2 
       (.I0(hh_OBUF[6]),
        .I1(hh_OBUF[5]),
        .I2(hh_OBUF[4]),
        .I3(reset_IBUF),
        .O(\hh[6]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFF10)) 
    \hh[7]_i_1 
       (.I0(\hh[7]_i_3_n_0 ),
        .I1(\hh[7]_i_4_n_0 ),
        .I2(ena_IBUF),
        .I3(reset_IBUF),
        .O(\hh[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hAAA8)) 
    \hh[7]_i_2 
       (.I0(\hh[7]_i_5_n_0 ),
        .I1(\hh[7]_i_4_n_0 ),
        .I2(\hh[7]_i_6_n_0 ),
        .I3(hh_OBUF[0]),
        .O(\hh[7]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hBFB0)) 
    \hh[7]_i_3 
       (.I0(hh_OBUF[1]),
        .I1(hh_OBUF[3]),
        .I2(hh_OBUF[0]),
        .I3(\hh[7]_i_6_n_0 ),
        .O(\hh[7]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \hh[7]_i_4 
       (.I0(\hh[7]_i_7_n_0 ),
        .I1(\mm[3]_i_4_n_0 ),
        .I2(\mm[7]_i_7_n_0 ),
        .I3(\hh[7]_i_8_n_0 ),
        .I4(hh_OBUF[2]),
        .O(\hh[7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00006AAA)) 
    \hh[7]_i_5 
       (.I0(hh_OBUF[7]),
        .I1(hh_OBUF[6]),
        .I2(hh_OBUF[5]),
        .I3(hh_OBUF[4]),
        .I4(reset_IBUF),
        .O(\hh[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFFFFFF)) 
    \hh[7]_i_6 
       (.I0(hh_OBUF[5]),
        .I1(hh_OBUF[6]),
        .I2(hh_OBUF[3]),
        .I3(hh_OBUF[7]),
        .I4(hh_OBUF[4]),
        .I5(hh_OBUF[1]),
        .O(\hh[7]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    \hh[7]_i_7 
       (.I0(mm_OBUF[0]),
        .I1(mm_OBUF[1]),
        .I2(mm_OBUF[3]),
        .I3(mm_OBUF[2]),
        .O(\hh[7]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hEFFF)) 
    \hh[7]_i_8 
       (.I0(mm_OBUF[7]),
        .I1(mm_OBUF[5]),
        .I2(mm_OBUF[6]),
        .I3(mm_OBUF[4]),
        .O(\hh[7]_i_8_n_0 ));
  OBUF \hh_OBUF[0]_inst 
       (.I(hh_OBUF[0]),
        .O(hh[0]));
  OBUF \hh_OBUF[1]_inst 
       (.I(hh_OBUF[1]),
        .O(hh[1]));
  OBUF \hh_OBUF[2]_inst 
       (.I(hh_OBUF[2]),
        .O(hh[2]));
  OBUF \hh_OBUF[3]_inst 
       (.I(hh_OBUF[3]),
        .O(hh[3]));
  OBUF \hh_OBUF[4]_inst 
       (.I(hh_OBUF[4]),
        .O(hh[4]));
  OBUF \hh_OBUF[5]_inst 
       (.I(hh_OBUF[5]),
        .O(hh[5]));
  OBUF \hh_OBUF[6]_inst 
       (.I(hh_OBUF[6]),
        .O(hh[6]));
  OBUF \hh_OBUF[7]_inst 
       (.I(hh_OBUF[7]),
        .O(hh[7]));
  FDRE \hh_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_1_n_0 ),
        .D(\hh[0]_i_1_n_0 ),
        .Q(hh_OBUF[0]),
        .R(\<const0> ));
  FDRE \hh_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_1_n_0 ),
        .D(\hh[1]_i_1_n_0 ),
        .Q(hh_OBUF[1]),
        .R(\<const0> ));
  FDRE \hh_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_1_n_0 ),
        .D(\hh[2]_i_1_n_0 ),
        .Q(hh_OBUF[2]),
        .R(\<const0> ));
  FDRE \hh_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_1_n_0 ),
        .D(\hh[3]_i_1_n_0 ),
        .Q(hh_OBUF[3]),
        .R(\<const0> ));
  FDRE \hh_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\hh[7]_i_1_n_0 ),
        .D(\hh[4]_i_1_n_0 ),
        .Q(hh_OBUF[4]),
        .R(\<const0> ));
  FDRE \hh_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\hh[7]_i_1_n_0 ),
        .D(\hh[5]_i_1_n_0 ),
        .Q(hh_OBUF[5]),
        .R(\<const0> ));
  FDRE \hh_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\hh[7]_i_1_n_0 ),
        .D(\hh[6]_i_1_n_0 ),
        .Q(hh_OBUF[6]),
        .R(\<const0> ));
  FDRE \hh_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\hh[7]_i_1_n_0 ),
        .D(\hh[7]_i_2_n_0 ),
        .Q(hh_OBUF[7]),
        .R(\<const0> ));
  LUT1 #(
    .INIT(2'h1)) 
    \mm[0]_i_1 
       (.I0(mm_OBUF[0]),
        .O(\mm[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \mm[1]_i_1 
       (.I0(mm_OBUF[0]),
        .I1(mm_OBUF[1]),
        .O(\mm[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \mm[2]_i_1 
       (.I0(mm_OBUF[1]),
        .I1(mm_OBUF[0]),
        .I2(mm_OBUF[2]),
        .O(\mm[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hF4)) 
    \mm[3]_i_1 
       (.I0(\mm[7]_i_5_n_0 ),
        .I1(ena_IBUF),
        .I2(reset_IBUF),
        .O(\mm[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0002000000000000)) 
    \mm[3]_i_2 
       (.I0(ena_IBUF),
        .I1(\mm[3]_i_4_n_0 ),
        .I2(ss_OBUF[7]),
        .I3(ss_OBUF[5]),
        .I4(ss_OBUF[6]),
        .I5(ss_OBUF[4]),
        .O(\mm[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \mm[3]_i_3 
       (.I0(mm_OBUF[0]),
        .I1(mm_OBUF[1]),
        .I2(mm_OBUF[2]),
        .I3(mm_OBUF[3]),
        .O(\mm[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hFFDF)) 
    \mm[3]_i_4 
       (.I0(ss_OBUF[0]),
        .I1(ss_OBUF[1]),
        .I2(ss_OBUF[3]),
        .I3(ss_OBUF[2]),
        .O(\mm[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \mm[4]_i_1 
       (.I0(mm_OBUF[4]),
        .O(mm0[0]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \mm[5]_i_1 
       (.I0(mm_OBUF[4]),
        .I1(mm_OBUF[5]),
        .O(mm0[1]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \mm[6]_i_1 
       (.I0(mm_OBUF[5]),
        .I1(mm_OBUF[4]),
        .I2(mm_OBUF[6]),
        .O(mm0[2]));
  LUT6 #(
    .INIT(64'hFFFFFFFF00010000)) 
    \mm[7]_i_1 
       (.I0(\mm[7]_i_4_n_0 ),
        .I1(mm_OBUF[5]),
        .I2(mm_OBUF[7]),
        .I3(\mm[7]_i_5_n_0 ),
        .I4(ena_IBUF),
        .I5(reset_IBUF),
        .O(\mm[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000200000)) 
    \mm[7]_i_2 
       (.I0(ena_IBUF),
        .I1(\mm[7]_i_6_n_0 ),
        .I2(mm_OBUF[0]),
        .I3(mm_OBUF[1]),
        .I4(mm_OBUF[3]),
        .I5(mm_OBUF[2]),
        .O(\mm[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \mm[7]_i_3 
       (.I0(mm_OBUF[4]),
        .I1(mm_OBUF[6]),
        .I2(mm_OBUF[5]),
        .I3(mm_OBUF[7]),
        .O(mm0[3]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \mm[7]_i_4 
       (.I0(mm_OBUF[4]),
        .I1(mm_OBUF[6]),
        .O(\mm[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFBFF)) 
    \mm[7]_i_5 
       (.I0(mm_OBUF[2]),
        .I1(mm_OBUF[3]),
        .I2(mm_OBUF[1]),
        .I3(mm_OBUF[0]),
        .I4(\mm[3]_i_4_n_0 ),
        .I5(\mm[7]_i_7_n_0 ),
        .O(\mm[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFF7)) 
    \mm[7]_i_6 
       (.I0(ss_OBUF[4]),
        .I1(ss_OBUF[6]),
        .I2(ss_OBUF[5]),
        .I3(ss_OBUF[7]),
        .I4(\mm[3]_i_4_n_0 ),
        .O(\mm[7]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hEFFF)) 
    \mm[7]_i_7 
       (.I0(ss_OBUF[7]),
        .I1(ss_OBUF[5]),
        .I2(ss_OBUF[6]),
        .I3(ss_OBUF[4]),
        .O(\mm[7]_i_7_n_0 ));
  OBUF \mm_OBUF[0]_inst 
       (.I(mm_OBUF[0]),
        .O(mm[0]));
  OBUF \mm_OBUF[1]_inst 
       (.I(mm_OBUF[1]),
        .O(mm[1]));
  OBUF \mm_OBUF[2]_inst 
       (.I(mm_OBUF[2]),
        .O(mm[2]));
  OBUF \mm_OBUF[3]_inst 
       (.I(mm_OBUF[3]),
        .O(mm[3]));
  OBUF \mm_OBUF[4]_inst 
       (.I(mm_OBUF[4]),
        .O(mm[4]));
  OBUF \mm_OBUF[5]_inst 
       (.I(mm_OBUF[5]),
        .O(mm[5]));
  OBUF \mm_OBUF[6]_inst 
       (.I(mm_OBUF[6]),
        .O(mm[6]));
  OBUF \mm_OBUF[7]_inst 
       (.I(mm_OBUF[7]),
        .O(mm[7]));
  FDRE \mm_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[3]_i_2_n_0 ),
        .D(\mm[0]_i_1_n_0 ),
        .Q(mm_OBUF[0]),
        .R(\mm[3]_i_1_n_0 ));
  FDRE \mm_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[3]_i_2_n_0 ),
        .D(\mm[1]_i_1_n_0 ),
        .Q(mm_OBUF[1]),
        .R(\mm[3]_i_1_n_0 ));
  FDRE \mm_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[3]_i_2_n_0 ),
        .D(\mm[2]_i_1_n_0 ),
        .Q(mm_OBUF[2]),
        .R(\mm[3]_i_1_n_0 ));
  FDRE \mm_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[3]_i_2_n_0 ),
        .D(\mm[3]_i_3_n_0 ),
        .Q(mm_OBUF[3]),
        .R(\mm[3]_i_1_n_0 ));
  FDRE \mm_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_2_n_0 ),
        .D(mm0[0]),
        .Q(mm_OBUF[4]),
        .R(\mm[7]_i_1_n_0 ));
  FDRE \mm_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_2_n_0 ),
        .D(mm0[1]),
        .Q(mm_OBUF[5]),
        .R(\mm[7]_i_1_n_0 ));
  FDRE \mm_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_2_n_0 ),
        .D(mm0[2]),
        .Q(mm_OBUF[6]),
        .R(\mm[7]_i_1_n_0 ));
  FDRE \mm_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\mm[7]_i_2_n_0 ),
        .D(mm0[3]),
        .Q(mm_OBUF[7]),
        .R(\mm[7]_i_1_n_0 ));
  OBUF pm_OBUF_inst
       (.I(pm_OBUF),
        .O(pm));
  LUT4 #(
    .INIT(16'h00A6)) 
    pm_i_1
       (.I0(pm_OBUF),
        .I1(pm_i_2_n_0),
        .I2(\hh[7]_i_4_n_0 ),
        .I3(reset_IBUF),
        .O(pm_i_1_n_0));
  LUT4 #(
    .INIT(16'h0008)) 
    pm_i_2
       (.I0(hh_OBUF[0]),
        .I1(ena_IBUF),
        .I2(hh_OBUF[1]),
        .I3(pm_i_3_n_0),
        .O(pm_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFFFFFFD)) 
    pm_i_3
       (.I0(hh_OBUF[4]),
        .I1(hh_OBUF[7]),
        .I2(hh_OBUF[3]),
        .I3(hh_OBUF[6]),
        .I4(hh_OBUF[5]),
        .O(pm_i_3_n_0));
  FDRE pm_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(pm_i_1_n_0),
        .Q(pm_OBUF),
        .R(\<const0> ));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  LUT1 #(
    .INIT(2'h1)) 
    \ss[0]_i_1 
       (.I0(ss_OBUF[0]),
        .O(\ss[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \ss[1]_i_1 
       (.I0(ss_OBUF[0]),
        .I1(ss_OBUF[1]),
        .O(\ss[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \ss[2]_i_1 
       (.I0(ss_OBUF[1]),
        .I1(ss_OBUF[0]),
        .I2(ss_OBUF[2]),
        .O(\ss[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF00200000)) 
    \ss[3]_i_1 
       (.I0(ss_OBUF[0]),
        .I1(ss_OBUF[1]),
        .I2(ss_OBUF[3]),
        .I3(ss_OBUF[2]),
        .I4(ena_IBUF),
        .I5(reset_IBUF),
        .O(\ss[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \ss[3]_i_2 
       (.I0(ss_OBUF[0]),
        .I1(ss_OBUF[1]),
        .I2(ss_OBUF[2]),
        .I3(ss_OBUF[3]),
        .O(\ss[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \ss[4]_i_1 
       (.I0(ss_OBUF[4]),
        .O(ss0[0]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \ss[5]_i_1 
       (.I0(ss_OBUF[4]),
        .I1(ss_OBUF[5]),
        .O(ss0[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \ss[6]_i_1 
       (.I0(ss_OBUF[5]),
        .I1(ss_OBUF[4]),
        .I2(ss_OBUF[6]),
        .O(ss0[2]));
  LUT2 #(
    .INIT(4'hE)) 
    \ss[7]_i_1 
       (.I0(\mm[3]_i_2_n_0 ),
        .I1(reset_IBUF),
        .O(\ss[7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00200000)) 
    \ss[7]_i_2 
       (.I0(ena_IBUF),
        .I1(ss_OBUF[2]),
        .I2(ss_OBUF[3]),
        .I3(ss_OBUF[1]),
        .I4(ss_OBUF[0]),
        .O(\ss[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \ss[7]_i_3 
       (.I0(ss_OBUF[4]),
        .I1(ss_OBUF[6]),
        .I2(ss_OBUF[5]),
        .I3(ss_OBUF[7]),
        .O(ss0[3]));
  OBUF \ss_OBUF[0]_inst 
       (.I(ss_OBUF[0]),
        .O(ss[0]));
  OBUF \ss_OBUF[1]_inst 
       (.I(ss_OBUF[1]),
        .O(ss[1]));
  OBUF \ss_OBUF[2]_inst 
       (.I(ss_OBUF[2]),
        .O(ss[2]));
  OBUF \ss_OBUF[3]_inst 
       (.I(ss_OBUF[3]),
        .O(ss[3]));
  OBUF \ss_OBUF[4]_inst 
       (.I(ss_OBUF[4]),
        .O(ss[4]));
  OBUF \ss_OBUF[5]_inst 
       (.I(ss_OBUF[5]),
        .O(ss[5]));
  OBUF \ss_OBUF[6]_inst 
       (.I(ss_OBUF[6]),
        .O(ss[6]));
  OBUF \ss_OBUF[7]_inst 
       (.I(ss_OBUF[7]),
        .O(ss[7]));
  FDRE \ss_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(ena_IBUF),
        .D(\ss[0]_i_1_n_0 ),
        .Q(ss_OBUF[0]),
        .R(\ss[3]_i_1_n_0 ));
  FDRE \ss_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(ena_IBUF),
        .D(\ss[1]_i_1_n_0 ),
        .Q(ss_OBUF[1]),
        .R(\ss[3]_i_1_n_0 ));
  FDRE \ss_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(ena_IBUF),
        .D(\ss[2]_i_1_n_0 ),
        .Q(ss_OBUF[2]),
        .R(\ss[3]_i_1_n_0 ));
  FDRE \ss_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(ena_IBUF),
        .D(\ss[3]_i_2_n_0 ),
        .Q(ss_OBUF[3]),
        .R(\ss[3]_i_1_n_0 ));
  FDRE \ss_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\ss[7]_i_2_n_0 ),
        .D(ss0[0]),
        .Q(ss_OBUF[4]),
        .R(\ss[7]_i_1_n_0 ));
  FDRE \ss_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\ss[7]_i_2_n_0 ),
        .D(ss0[1]),
        .Q(ss_OBUF[5]),
        .R(\ss[7]_i_1_n_0 ));
  FDRE \ss_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\ss[7]_i_2_n_0 ),
        .D(ss0[2]),
        .Q(ss_OBUF[6]),
        .R(\ss[7]_i_1_n_0 ));
  FDRE \ss_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\ss[7]_i_2_n_0 ),
        .D(ss0[3]),
        .Q(ss_OBUF[7]),
        .R(\ss[7]_i_1_n_0 ));
endmodule
