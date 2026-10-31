// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:54:07 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_ye18t26t/synth_netlist.v
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
    out);
  input a;
  input b;
  input c;
  input d;
  input e;
  output [24:0]out;

  wire \<const1> ;
  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire c;
  wire c_IBUF;
  wire d;
  wire d_IBUF;
  wire e;
  wire e_IBUF;
  wire [24:0]out;
  wire [23:1]out_OBUF;

  VCC VCC
       (.P(\<const1> ));
  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  IBUF c_IBUF_inst
       (.I(c),
        .O(c_IBUF));
  IBUF d_IBUF_inst
       (.I(d),
        .O(d_IBUF));
  IBUF e_IBUF_inst
       (.I(e),
        .O(e_IBUF));
  OBUF \out_OBUF[0]_inst 
       (.I(\<const1> ),
        .O(out[0]));
  OBUF \out_OBUF[10]_inst 
       (.I(out_OBUF[10]),
        .O(out[10]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[10]_inst_i_1 
       (.I0(e_IBUF),
        .I1(c_IBUF),
        .O(out_OBUF[10]));
  OBUF \out_OBUF[11]_inst 
       (.I(out_OBUF[11]),
        .O(out[11]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[11]_inst_i_1 
       (.I0(d_IBUF),
        .I1(c_IBUF),
        .O(out_OBUF[11]));
  OBUF \out_OBUF[12]_inst 
       (.I(\<const1> ),
        .O(out[12]));
  OBUF \out_OBUF[13]_inst 
       (.I(out_OBUF[13]),
        .O(out[13]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[13]_inst_i_1 
       (.I0(b_IBUF),
        .I1(c_IBUF),
        .O(out_OBUF[13]));
  OBUF \out_OBUF[14]_inst 
       (.I(out_OBUF[14]),
        .O(out[14]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[14]_inst_i_1 
       (.I0(a_IBUF),
        .I1(c_IBUF),
        .O(out_OBUF[14]));
  OBUF \out_OBUF[15]_inst 
       (.I(out_OBUF[15]),
        .O(out[15]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[15]_inst_i_1 
       (.I0(e_IBUF),
        .I1(b_IBUF),
        .O(out_OBUF[15]));
  OBUF \out_OBUF[16]_inst 
       (.I(out_OBUF[16]),
        .O(out[16]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[16]_inst_i_1 
       (.I0(d_IBUF),
        .I1(b_IBUF),
        .O(out_OBUF[16]));
  OBUF \out_OBUF[17]_inst 
       (.I(out_OBUF[17]),
        .O(out[17]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[17]_inst_i_1 
       (.I0(c_IBUF),
        .I1(b_IBUF),
        .O(out_OBUF[17]));
  OBUF \out_OBUF[18]_inst 
       (.I(\<const1> ),
        .O(out[18]));
  OBUF \out_OBUF[19]_inst 
       (.I(out_OBUF[19]),
        .O(out[19]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[19]_inst_i_1 
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_OBUF[19]));
  OBUF \out_OBUF[1]_inst 
       (.I(out_OBUF[1]),
        .O(out[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[1]_inst_i_1 
       (.I0(d_IBUF),
        .I1(e_IBUF),
        .O(out_OBUF[1]));
  OBUF \out_OBUF[20]_inst 
       (.I(out_OBUF[20]),
        .O(out[20]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[20]_inst_i_1 
       (.I0(e_IBUF),
        .I1(a_IBUF),
        .O(out_OBUF[20]));
  OBUF \out_OBUF[21]_inst 
       (.I(out_OBUF[21]),
        .O(out[21]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[21]_inst_i_1 
       (.I0(d_IBUF),
        .I1(a_IBUF),
        .O(out_OBUF[21]));
  OBUF \out_OBUF[22]_inst 
       (.I(out_OBUF[22]),
        .O(out[22]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[22]_inst_i_1 
       (.I0(c_IBUF),
        .I1(a_IBUF),
        .O(out_OBUF[22]));
  OBUF \out_OBUF[23]_inst 
       (.I(out_OBUF[23]),
        .O(out[23]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[23]_inst_i_1 
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .O(out_OBUF[23]));
  OBUF \out_OBUF[24]_inst 
       (.I(\<const1> ),
        .O(out[24]));
  OBUF \out_OBUF[2]_inst 
       (.I(out_OBUF[2]),
        .O(out[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[2]_inst_i_1 
       (.I0(c_IBUF),
        .I1(e_IBUF),
        .O(out_OBUF[2]));
  OBUF \out_OBUF[3]_inst 
       (.I(out_OBUF[3]),
        .O(out[3]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[3]_inst_i_1 
       (.I0(b_IBUF),
        .I1(e_IBUF),
        .O(out_OBUF[3]));
  OBUF \out_OBUF[4]_inst 
       (.I(out_OBUF[4]),
        .O(out[4]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[4]_inst_i_1 
       (.I0(a_IBUF),
        .I1(e_IBUF),
        .O(out_OBUF[4]));
  OBUF \out_OBUF[5]_inst 
       (.I(out_OBUF[5]),
        .O(out[5]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[5]_inst_i_1 
       (.I0(e_IBUF),
        .I1(d_IBUF),
        .O(out_OBUF[5]));
  OBUF \out_OBUF[6]_inst 
       (.I(\<const1> ),
        .O(out[6]));
  OBUF \out_OBUF[7]_inst 
       (.I(out_OBUF[7]),
        .O(out[7]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[7]_inst_i_1 
       (.I0(c_IBUF),
        .I1(d_IBUF),
        .O(out_OBUF[7]));
  OBUF \out_OBUF[8]_inst 
       (.I(out_OBUF[8]),
        .O(out[8]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[8]_inst_i_1 
       (.I0(b_IBUF),
        .I1(d_IBUF),
        .O(out_OBUF[8]));
  OBUF \out_OBUF[9]_inst 
       (.I(out_OBUF[9]),
        .O(out[9]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \out_OBUF[9]_inst_i_1 
       (.I0(a_IBUF),
        .I1(d_IBUF),
        .O(out_OBUF[9]));
endmodule
