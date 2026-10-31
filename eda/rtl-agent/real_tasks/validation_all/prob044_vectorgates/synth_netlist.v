// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:55:52 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_oi_z0qv0/synth_netlist.v
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
    out_or_bitwise,
    out_or_logical,
    out_not);
  input [2:0]a;
  input [2:0]b;
  output [2:0]out_or_bitwise;
  output out_or_logical;
  output [5:0]out_not;

  wire [2:0]a;
  wire [2:0]a_IBUF;
  wire [2:0]b;
  wire [2:0]b_IBUF;
  wire [5:0]out_not;
  wire [5:0]out_not_OBUF;
  wire [2:0]out_or_bitwise;
  wire [2:0]out_or_bitwise_OBUF;
  wire out_or_logical;
  wire out_or_logical_OBUF;

  IBUF \a_IBUF[0]_inst 
       (.I(a[0]),
        .O(a_IBUF[0]));
  IBUF \a_IBUF[1]_inst 
       (.I(a[1]),
        .O(a_IBUF[1]));
  IBUF \a_IBUF[2]_inst 
       (.I(a[2]),
        .O(a_IBUF[2]));
  IBUF \b_IBUF[0]_inst 
       (.I(b[0]),
        .O(b_IBUF[0]));
  IBUF \b_IBUF[1]_inst 
       (.I(b[1]),
        .O(b_IBUF[1]));
  IBUF \b_IBUF[2]_inst 
       (.I(b[2]),
        .O(b_IBUF[2]));
  OBUF \out_not_OBUF[0]_inst 
       (.I(out_not_OBUF[0]),
        .O(out_not[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[0]_inst_i_1 
       (.I0(a_IBUF[0]),
        .O(out_not_OBUF[0]));
  OBUF \out_not_OBUF[1]_inst 
       (.I(out_not_OBUF[1]),
        .O(out_not[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[1]_inst_i_1 
       (.I0(a_IBUF[1]),
        .O(out_not_OBUF[1]));
  OBUF \out_not_OBUF[2]_inst 
       (.I(out_not_OBUF[2]),
        .O(out_not[2]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[2]_inst_i_1 
       (.I0(a_IBUF[2]),
        .O(out_not_OBUF[2]));
  OBUF \out_not_OBUF[3]_inst 
       (.I(out_not_OBUF[3]),
        .O(out_not[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[3]_inst_i_1 
       (.I0(b_IBUF[0]),
        .O(out_not_OBUF[3]));
  OBUF \out_not_OBUF[4]_inst 
       (.I(out_not_OBUF[4]),
        .O(out_not[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[4]_inst_i_1 
       (.I0(b_IBUF[1]),
        .O(out_not_OBUF[4]));
  OBUF \out_not_OBUF[5]_inst 
       (.I(out_not_OBUF[5]),
        .O(out_not[5]));
  LUT1 #(
    .INIT(2'h1)) 
    \out_not_OBUF[5]_inst_i_1 
       (.I0(b_IBUF[2]),
        .O(out_not_OBUF[5]));
  OBUF \out_or_bitwise_OBUF[0]_inst 
       (.I(out_or_bitwise_OBUF[0]),
        .O(out_or_bitwise[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_or_bitwise_OBUF[0]_inst_i_1 
       (.I0(a_IBUF[0]),
        .I1(b_IBUF[0]),
        .O(out_or_bitwise_OBUF[0]));
  OBUF \out_or_bitwise_OBUF[1]_inst 
       (.I(out_or_bitwise_OBUF[1]),
        .O(out_or_bitwise[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_or_bitwise_OBUF[1]_inst_i_1 
       (.I0(a_IBUF[1]),
        .I1(b_IBUF[1]),
        .O(out_or_bitwise_OBUF[1]));
  OBUF \out_or_bitwise_OBUF[2]_inst 
       (.I(out_or_bitwise_OBUF[2]),
        .O(out_or_bitwise[2]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_or_bitwise_OBUF[2]_inst_i_1 
       (.I0(a_IBUF[2]),
        .I1(b_IBUF[2]),
        .O(out_or_bitwise_OBUF[2]));
  OBUF out_or_logical_OBUF_inst
       (.I(out_or_logical_OBUF),
        .O(out_or_logical));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    out_or_logical_OBUF_inst_i_1
       (.I0(a_IBUF[1]),
        .I1(a_IBUF[2]),
        .I2(a_IBUF[0]),
        .I3(b_IBUF[1]),
        .I4(b_IBUF[2]),
        .I5(b_IBUF[0]),
        .O(out_or_logical_OBUF));
endmodule
