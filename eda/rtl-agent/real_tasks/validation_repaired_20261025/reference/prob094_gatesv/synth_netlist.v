// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Sun Oct 25 16:36:47 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_8wjadz19/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (in,
    out_both,
    out_any,
    out_different);
  input [3:0]in;
  output [3:0]out_both;
  output [3:0]out_any;
  output [3:0]out_different;

  wire \<const0> ;
  wire [3:0]in;
  wire [3:0]in_IBUF;
  wire [3:0]out_any;
  wire [3:1]out_any_OBUF;
  wire [3:0]out_both;
  wire [2:0]out_both_OBUF;
  wire [3:0]out_different;
  wire [3:0]out_different_OBUF;

  GND GND
       (.G(\<const0> ));
  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(in_IBUF[0]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(in_IBUF[1]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(in_IBUF[2]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(in_IBUF[3]));
  OBUF \out_any_OBUF[0]_inst 
       (.I(\<const0> ),
        .O(out_any[0]));
  OBUF \out_any_OBUF[1]_inst 
       (.I(out_any_OBUF[1]),
        .O(out_any[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_any_OBUF[1]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[1]),
        .O(out_any_OBUF[1]));
  OBUF \out_any_OBUF[2]_inst 
       (.I(out_any_OBUF[2]),
        .O(out_any[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_any_OBUF[2]_inst_i_1 
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[2]),
        .O(out_any_OBUF[2]));
  OBUF \out_any_OBUF[3]_inst 
       (.I(out_any_OBUF[3]),
        .O(out_any[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \out_any_OBUF[3]_inst_i_1 
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .O(out_any_OBUF[3]));
  OBUF \out_both_OBUF[0]_inst 
       (.I(out_both_OBUF[0]),
        .O(out_both[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \out_both_OBUF[0]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[1]),
        .O(out_both_OBUF[0]));
  OBUF \out_both_OBUF[1]_inst 
       (.I(out_both_OBUF[1]),
        .O(out_both[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \out_both_OBUF[1]_inst_i_1 
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[2]),
        .O(out_both_OBUF[1]));
  OBUF \out_both_OBUF[2]_inst 
       (.I(out_both_OBUF[2]),
        .O(out_both[2]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \out_both_OBUF[2]_inst_i_1 
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .O(out_both_OBUF[2]));
  OBUF \out_both_OBUF[3]_inst 
       (.I(\<const0> ),
        .O(out_both[3]));
  OBUF \out_different_OBUF[0]_inst 
       (.I(out_different_OBUF[0]),
        .O(out_different[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_different_OBUF[0]_inst_i_1 
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[0]),
        .O(out_different_OBUF[0]));
  OBUF \out_different_OBUF[1]_inst 
       (.I(out_different_OBUF[1]),
        .O(out_different[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_different_OBUF[1]_inst_i_1 
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[1]),
        .O(out_different_OBUF[1]));
  OBUF \out_different_OBUF[2]_inst 
       (.I(out_different_OBUF[2]),
        .O(out_different[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_different_OBUF[2]_inst_i_1 
       (.I0(in_IBUF[3]),
        .I1(in_IBUF[2]),
        .O(out_different_OBUF[2]));
  OBUF \out_different_OBUF[3]_inst 
       (.I(out_different_OBUF[3]),
        .O(out_different[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \out_different_OBUF[3]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[3]),
        .O(out_different_OBUF[3]));
endmodule
