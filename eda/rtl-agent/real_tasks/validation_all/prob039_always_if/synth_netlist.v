// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:47:03 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_5yv3oszh/synth_netlist.v
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
    sel_b1,
    sel_b2,
    out_assign,
    out_always);
  input a;
  input b;
  input sel_b1;
  input sel_b2;
  output out_assign;
  output out_always;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire out_always;
  wire out_always_OBUF;
  wire out_assign;
  wire sel_b1;
  wire sel_b1_IBUF;
  wire sel_b2;
  wire sel_b2_IBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  OBUF out_always_OBUF_inst
       (.I(out_always_OBUF),
        .O(out_always));
  OBUF out_assign_OBUF_inst
       (.I(out_always_OBUF),
        .O(out_assign));
  LUT4 #(
    .INIT(16'hACCC)) 
    out_assign_OBUF_inst_i_1
       (.I0(b_IBUF),
        .I1(a_IBUF),
        .I2(sel_b1_IBUF),
        .I3(sel_b2_IBUF),
        .O(out_always_OBUF));
  IBUF sel_b1_IBUF_inst
       (.I(sel_b1),
        .O(sel_b1_IBUF));
  IBUF sel_b2_IBUF_inst
       (.I(sel_b2),
        .O(sel_b2_IBUF));
endmodule
