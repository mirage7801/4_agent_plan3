// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:43:39 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_xx981fl3/synth_netlist.v
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
    q);
  input clk;
  input reset;
  output [9:0]q;

  wire \<const1> ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [9:0]q;
  wire \q[0]_i_1_n_0 ;
  wire \q[1]_i_1_n_0 ;
  wire \q[2]_i_1_n_0 ;
  wire \q[3]_i_1_n_0 ;
  wire \q[4]_i_1_n_0 ;
  wire \q[5]_i_1_n_0 ;
  wire \q[6]_i_1_n_0 ;
  wire \q[7]_i_1_n_0 ;
  wire \q[8]_i_1_n_0 ;
  wire \q[9]_i_1_n_0 ;
  wire \q[9]_i_2_n_0 ;
  wire \q[9]_i_3_n_0 ;
  wire \q[9]_i_4_n_0 ;
  wire [9:0]q_OBUF;
  wire reset;
  wire reset_IBUF;

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
  LUT1 #(
    .INIT(2'h1)) 
    \q[0]_i_1 
       (.I0(q_OBUF[0]),
        .O(\q[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \q[1]_i_1 
       (.I0(q_OBUF[0]),
        .I1(q_OBUF[1]),
        .O(\q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \q[2]_i_1 
       (.I0(q_OBUF[0]),
        .I1(q_OBUF[1]),
        .I2(q_OBUF[2]),
        .O(\q[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \q[3]_i_1 
       (.I0(q_OBUF[1]),
        .I1(q_OBUF[0]),
        .I2(q_OBUF[2]),
        .I3(q_OBUF[3]),
        .O(\q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \q[4]_i_1 
       (.I0(q_OBUF[2]),
        .I1(q_OBUF[0]),
        .I2(q_OBUF[1]),
        .I3(q_OBUF[3]),
        .I4(q_OBUF[4]),
        .O(\q[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \q[5]_i_1 
       (.I0(q_OBUF[3]),
        .I1(q_OBUF[1]),
        .I2(q_OBUF[0]),
        .I3(q_OBUF[2]),
        .I4(q_OBUF[4]),
        .I5(q_OBUF[5]),
        .O(\q[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \q[6]_i_1 
       (.I0(\q[9]_i_4_n_0 ),
        .I1(q_OBUF[6]),
        .O(\q[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \q[7]_i_1 
       (.I0(\q[9]_i_4_n_0 ),
        .I1(q_OBUF[6]),
        .I2(q_OBUF[7]),
        .O(\q[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \q[8]_i_1 
       (.I0(q_OBUF[6]),
        .I1(\q[9]_i_4_n_0 ),
        .I2(q_OBUF[7]),
        .I3(q_OBUF[8]),
        .O(\q[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF08000000)) 
    \q[9]_i_1 
       (.I0(q_OBUF[1]),
        .I1(q_OBUF[0]),
        .I2(q_OBUF[3]),
        .I3(q_OBUF[2]),
        .I4(\q[9]_i_3_n_0 ),
        .I5(reset_IBUF),
        .O(\q[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \q[9]_i_2 
       (.I0(q_OBUF[7]),
        .I1(\q[9]_i_4_n_0 ),
        .I2(q_OBUF[6]),
        .I3(q_OBUF[8]),
        .I4(q_OBUF[9]),
        .O(\q[9]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2000000000000000)) 
    \q[9]_i_3 
       (.I0(q_OBUF[5]),
        .I1(q_OBUF[4]),
        .I2(q_OBUF[6]),
        .I3(q_OBUF[7]),
        .I4(q_OBUF[9]),
        .I5(q_OBUF[8]),
        .O(\q[9]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \q[9]_i_4 
       (.I0(q_OBUF[5]),
        .I1(q_OBUF[3]),
        .I2(q_OBUF[1]),
        .I3(q_OBUF[0]),
        .I4(q_OBUF[2]),
        .I5(q_OBUF[4]),
        .O(\q[9]_i_4_n_0 ));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  OBUF \q_OBUF[4]_inst 
       (.I(q_OBUF[4]),
        .O(q[4]));
  OBUF \q_OBUF[5]_inst 
       (.I(q_OBUF[5]),
        .O(q[5]));
  OBUF \q_OBUF[6]_inst 
       (.I(q_OBUF[6]),
        .O(q[6]));
  OBUF \q_OBUF[7]_inst 
       (.I(q_OBUF[7]),
        .O(q[7]));
  OBUF \q_OBUF[8]_inst 
       (.I(q_OBUF[8]),
        .O(q[8]));
  OBUF \q_OBUF[9]_inst 
       (.I(q_OBUF[9]),
        .O(q[9]));
  FDRE \q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[0]_i_1_n_0 ),
        .Q(q_OBUF[0]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[1]_i_1_n_0 ),
        .Q(q_OBUF[1]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[2]_i_1_n_0 ),
        .Q(q_OBUF[2]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[3]_i_1_n_0 ),
        .Q(q_OBUF[3]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[4]_i_1_n_0 ),
        .Q(q_OBUF[4]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[5]_i_1_n_0 ),
        .Q(q_OBUF[5]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[6]_i_1_n_0 ),
        .Q(q_OBUF[6]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[7]_i_1_n_0 ),
        .Q(q_OBUF[7]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[8]_i_1_n_0 ),
        .Q(q_OBUF[8]),
        .R(\q[9]_i_1_n_0 ));
  FDRE \q_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\q[9]_i_2_n_0 ),
        .Q(q_OBUF[9]),
        .R(\q[9]_i_1_n_0 ));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
