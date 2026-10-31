// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:40:39 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_vzl1iyoy/synth_netlist.v
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
    out_sop,
    out_pos);
  input a;
  input b;
  input c;
  input d;
  output out_sop;
  output out_pos;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire c;
  wire c_IBUF;
  wire d;
  wire d_IBUF;
  wire out_pos;
  wire out_pos_OBUF;
  wire out_sop;
  wire out_sop_OBUF;

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
  OBUF out_pos_OBUF_inst
       (.I(out_pos_OBUF),
        .O(out_pos));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h808A)) 
    out_pos_OBUF_inst_i_1
       (.I0(c_IBUF),
        .I1(d_IBUF),
        .I2(b_IBUF),
        .I3(a_IBUF),
        .O(out_pos_OBUF));
  OBUF out_sop_OBUF_inst
       (.I(out_sop_OBUF),
        .O(out_sop));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hA0B0)) 
    out_sop_OBUF_inst_i_1
       (.I0(d_IBUF),
        .I1(a_IBUF),
        .I2(c_IBUF),
        .I3(b_IBUF),
        .O(out_sop_OBUF));
endmodule
