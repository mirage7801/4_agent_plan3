// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:56:24 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_znnr0t1s/synth_netlist.v
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
    c,
    d,
    e,
    q);
  input [3:0]a;
  input [3:0]b;
  input [3:0]c;
  input [3:0]d;
  input [3:0]e;
  output [3:0]q;

  wire [3:0]a;
  wire [3:0]a_IBUF;
  wire [3:0]b;
  wire [3:0]b_IBUF;
  wire [3:0]c;
  wire [3:0]c_IBUF;
  wire [3:0]d;
  wire [3:0]d_IBUF;
  wire [3:0]e;
  wire [3:0]e_IBUF;
  wire [3:0]q;
  wire [3:0]q_OBUF;
  wire \q_OBUF[0]_inst_i_2_n_0 ;
  wire \q_OBUF[1]_inst_i_2_n_0 ;
  wire \q_OBUF[2]_inst_i_2_n_0 ;
  wire \q_OBUF[3]_inst_i_2_n_0 ;

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
  IBUF \c_IBUF[0]_inst 
       (.I(c[0]),
        .O(c_IBUF[0]));
  IBUF \c_IBUF[1]_inst 
       (.I(c[1]),
        .O(c_IBUF[1]));
  IBUF \c_IBUF[2]_inst 
       (.I(c[2]),
        .O(c_IBUF[2]));
  IBUF \c_IBUF[3]_inst 
       (.I(c[3]),
        .O(c_IBUF[3]));
  IBUF \d_IBUF[0]_inst 
       (.I(d[0]),
        .O(d_IBUF[0]));
  IBUF \d_IBUF[1]_inst 
       (.I(d[1]),
        .O(d_IBUF[1]));
  IBUF \d_IBUF[2]_inst 
       (.I(d[2]),
        .O(d_IBUF[2]));
  IBUF \d_IBUF[3]_inst 
       (.I(d[3]),
        .O(d_IBUF[3]));
  IBUF \e_IBUF[0]_inst 
       (.I(e[0]),
        .O(e_IBUF[0]));
  IBUF \e_IBUF[1]_inst 
       (.I(e[1]),
        .O(e_IBUF[1]));
  IBUF \e_IBUF[2]_inst 
       (.I(e[2]),
        .O(e_IBUF[2]));
  IBUF \e_IBUF[3]_inst 
       (.I(e[3]),
        .O(e_IBUF[3]));
  OBUF \q_OBUF[0]_inst 
       (.I(q_OBUF[0]),
        .O(q[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \q_OBUF[0]_inst_i_1 
       (.I0(\q_OBUF[0]_inst_i_2_n_0 ),
        .I1(c_IBUF[2]),
        .I2(c_IBUF[3]),
        .O(q_OBUF[0]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \q_OBUF[0]_inst_i_2 
       (.I0(e_IBUF[0]),
        .I1(b_IBUF[0]),
        .I2(d_IBUF[0]),
        .I3(c_IBUF[1]),
        .I4(c_IBUF[0]),
        .I5(a_IBUF[0]),
        .O(\q_OBUF[0]_inst_i_2_n_0 ));
  OBUF \q_OBUF[1]_inst 
       (.I(q_OBUF[1]),
        .O(q[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \q_OBUF[1]_inst_i_1 
       (.I0(\q_OBUF[1]_inst_i_2_n_0 ),
        .I1(c_IBUF[2]),
        .I2(c_IBUF[3]),
        .O(q_OBUF[1]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \q_OBUF[1]_inst_i_2 
       (.I0(e_IBUF[1]),
        .I1(b_IBUF[1]),
        .I2(d_IBUF[1]),
        .I3(c_IBUF[1]),
        .I4(c_IBUF[0]),
        .I5(a_IBUF[1]),
        .O(\q_OBUF[1]_inst_i_2_n_0 ));
  OBUF \q_OBUF[2]_inst 
       (.I(q_OBUF[2]),
        .O(q[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \q_OBUF[2]_inst_i_1 
       (.I0(\q_OBUF[2]_inst_i_2_n_0 ),
        .I1(c_IBUF[2]),
        .I2(c_IBUF[3]),
        .O(q_OBUF[2]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \q_OBUF[2]_inst_i_2 
       (.I0(e_IBUF[2]),
        .I1(b_IBUF[2]),
        .I2(d_IBUF[2]),
        .I3(c_IBUF[1]),
        .I4(c_IBUF[0]),
        .I5(a_IBUF[2]),
        .O(\q_OBUF[2]_inst_i_2_n_0 ));
  OBUF \q_OBUF[3]_inst 
       (.I(q_OBUF[3]),
        .O(q[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \q_OBUF[3]_inst_i_1 
       (.I0(\q_OBUF[3]_inst_i_2_n_0 ),
        .I1(c_IBUF[2]),
        .I2(c_IBUF[3]),
        .O(q_OBUF[3]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \q_OBUF[3]_inst_i_2 
       (.I0(e_IBUF[3]),
        .I1(b_IBUF[3]),
        .I2(d_IBUF[3]),
        .I3(c_IBUF[1]),
        .I4(c_IBUF[0]),
        .I5(a_IBUF[3]),
        .O(\q_OBUF[3]_inst_i_2_n_0 ));
endmodule
