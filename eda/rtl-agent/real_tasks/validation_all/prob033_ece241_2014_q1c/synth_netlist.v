// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:36:40 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_7n1bvl4h/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (a,
    b,
    s,
    overflow);
  input [7:0]a;
  input [7:0]b;
  output [7:0]s;
  output overflow;

  wire [7:0]a;
  wire [7:0]a_IBUF;
  wire [7:0]b;
  wire [7:0]b_IBUF;
  wire overflow;
  wire overflow_OBUF;
  wire [7:0]s;
  wire [7:0]s_OBUF;
  wire \s_OBUF[4]_inst_i_2_n_0 ;
  wire \s_OBUF[6]_inst_i_2_n_0 ;
  wire \s_OBUF[7]_inst_i_2_n_0 ;

  IBUF \a_IBUF[0]_inst 
       (.I(a[0]),
        .O(a_IBUF[0]));
  IBUF \a_IBUF[1]_inst 
       (.I(a[1]),
        .O(a_IBUF[1]));
  IBUF \a_IBUF[2]_inst 
       (.I(a[2]),
        .O(a_IBUF[2]));
  IBUF \a_IBUF[3]_inst 
       (.I(a[3]),
        .O(a_IBUF[3]));
  IBUF \a_IBUF[4]_inst 
       (.I(a[4]),
        .O(a_IBUF[4]));
  IBUF \a_IBUF[5]_inst 
       (.I(a[5]),
        .O(a_IBUF[5]));
  IBUF \a_IBUF[6]_inst 
       (.I(a[6]),
        .O(a_IBUF[6]));
  IBUF \a_IBUF[7]_inst 
       (.I(a[7]),
        .O(a_IBUF[7]));
  IBUF \b_IBUF[0]_inst 
       (.I(b[0]),
        .O(b_IBUF[0]));
  IBUF \b_IBUF[1]_inst 
       (.I(b[1]),
        .O(b_IBUF[1]));
  IBUF \b_IBUF[2]_inst 
       (.I(b[2]),
        .O(b_IBUF[2]));
  IBUF \b_IBUF[3]_inst 
       (.I(b[3]),
        .O(b_IBUF[3]));
  IBUF \b_IBUF[4]_inst 
       (.I(b[4]),
        .O(b_IBUF[4]));
  IBUF \b_IBUF[5]_inst 
       (.I(b[5]),
        .O(b_IBUF[5]));
  IBUF \b_IBUF[6]_inst 
       (.I(b[6]),
        .O(b_IBUF[6]));
  IBUF \b_IBUF[7]_inst 
       (.I(b[7]),
        .O(b_IBUF[7]));
  OBUF overflow_OBUF_inst
       (.I(overflow_OBUF),
        .O(overflow));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h170000E8)) 
    overflow_OBUF_inst_i_1
       (.I0(\s_OBUF[7]_inst_i_2_n_0 ),
        .I1(a_IBUF[6]),
        .I2(b_IBUF[6]),
        .I3(a_IBUF[7]),
        .I4(b_IBUF[7]),
        .O(overflow_OBUF));
  OBUF \s_OBUF[0]_inst 
       (.I(s_OBUF[0]),
        .O(s[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \s_OBUF[0]_inst_i_1 
       (.I0(a_IBUF[0]),
        .I1(b_IBUF[0]),
        .O(s_OBUF[0]));
  OBUF \s_OBUF[1]_inst 
       (.I(s_OBUF[1]),
        .O(s[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h8778)) 
    \s_OBUF[1]_inst_i_1 
       (.I0(a_IBUF[0]),
        .I1(b_IBUF[0]),
        .I2(b_IBUF[1]),
        .I3(a_IBUF[1]),
        .O(s_OBUF[1]));
  OBUF \s_OBUF[2]_inst 
       (.I(s_OBUF[2]),
        .O(s[2]));
  LUT6 #(
    .INIT(64'hF880077F077FF880)) 
    \s_OBUF[2]_inst_i_1 
       (.I0(b_IBUF[0]),
        .I1(a_IBUF[0]),
        .I2(a_IBUF[1]),
        .I3(b_IBUF[1]),
        .I4(b_IBUF[2]),
        .I5(a_IBUF[2]),
        .O(s_OBUF[2]));
  OBUF \s_OBUF[3]_inst 
       (.I(s_OBUF[3]),
        .O(s[3]));
  LUT3 #(
    .INIT(8'h96)) 
    \s_OBUF[3]_inst_i_1 
       (.I0(\s_OBUF[4]_inst_i_2_n_0 ),
        .I1(b_IBUF[3]),
        .I2(a_IBUF[3]),
        .O(s_OBUF[3]));
  OBUF \s_OBUF[4]_inst 
       (.I(s_OBUF[4]),
        .O(s[4]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \s_OBUF[4]_inst_i_1 
       (.I0(\s_OBUF[4]_inst_i_2_n_0 ),
        .I1(a_IBUF[3]),
        .I2(b_IBUF[3]),
        .I3(b_IBUF[4]),
        .I4(a_IBUF[4]),
        .O(s_OBUF[4]));
  LUT6 #(
    .INIT(64'hEEEEE888E8888888)) 
    \s_OBUF[4]_inst_i_2 
       (.I0(b_IBUF[2]),
        .I1(a_IBUF[2]),
        .I2(b_IBUF[0]),
        .I3(a_IBUF[0]),
        .I4(a_IBUF[1]),
        .I5(b_IBUF[1]),
        .O(\s_OBUF[4]_inst_i_2_n_0 ));
  OBUF \s_OBUF[5]_inst 
       (.I(s_OBUF[5]),
        .O(s[5]));
  LUT3 #(
    .INIT(8'h96)) 
    \s_OBUF[5]_inst_i_1 
       (.I0(\s_OBUF[6]_inst_i_2_n_0 ),
        .I1(b_IBUF[5]),
        .I2(a_IBUF[5]),
        .O(s_OBUF[5]));
  OBUF \s_OBUF[6]_inst 
       (.I(s_OBUF[6]),
        .O(s[6]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \s_OBUF[6]_inst_i_1 
       (.I0(\s_OBUF[6]_inst_i_2_n_0 ),
        .I1(a_IBUF[5]),
        .I2(b_IBUF[5]),
        .I3(b_IBUF[6]),
        .I4(a_IBUF[6]),
        .O(s_OBUF[6]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hEEE8E888)) 
    \s_OBUF[6]_inst_i_2 
       (.I0(b_IBUF[4]),
        .I1(a_IBUF[4]),
        .I2(\s_OBUF[4]_inst_i_2_n_0 ),
        .I3(a_IBUF[3]),
        .I4(b_IBUF[3]),
        .O(\s_OBUF[6]_inst_i_2_n_0 ));
  OBUF \s_OBUF[7]_inst 
       (.I(s_OBUF[7]),
        .O(s[7]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \s_OBUF[7]_inst_i_1 
       (.I0(\s_OBUF[7]_inst_i_2_n_0 ),
        .I1(a_IBUF[6]),
        .I2(b_IBUF[6]),
        .I3(b_IBUF[7]),
        .I4(a_IBUF[7]),
        .O(s_OBUF[7]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \s_OBUF[7]_inst_i_2 
       (.I0(b_IBUF[5]),
        .I1(a_IBUF[5]),
        .I2(\s_OBUF[6]_inst_i_2_n_0 ),
        .O(\s_OBUF[7]_inst_i_2_n_0 ));
endmodule
