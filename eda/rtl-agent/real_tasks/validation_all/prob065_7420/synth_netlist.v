// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:32:49 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_15o7v1e5/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (p1a,
    p1b,
    p1c,
    p1d,
    p1y,
    p2a,
    p2b,
    p2c,
    p2d,
    p2y);
  input p1a;
  input p1b;
  input p1c;
  input p1d;
  output p1y;
  input p2a;
  input p2b;
  input p2c;
  input p2d;
  output p2y;

  wire p1a;
  wire p1a_IBUF;
  wire p1b;
  wire p1b_IBUF;
  wire p1c;
  wire p1c_IBUF;
  wire p1d;
  wire p1d_IBUF;
  wire p1y;
  wire p1y_OBUF;
  wire p2a;
  wire p2a_IBUF;
  wire p2b;
  wire p2b_IBUF;
  wire p2c;
  wire p2c_IBUF;
  wire p2d;
  wire p2d_IBUF;
  wire p2y;
  wire p2y_OBUF;

  IBUF p1a_IBUF_inst
       (.I(p1a),
        .O(p1a_IBUF));
  IBUF p1b_IBUF_inst
       (.I(p1b),
        .O(p1b_IBUF));
  IBUF p1c_IBUF_inst
       (.I(p1c),
        .O(p1c_IBUF));
  IBUF p1d_IBUF_inst
       (.I(p1d),
        .O(p1d_IBUF));
  OBUF p1y_OBUF_inst
       (.I(p1y_OBUF),
        .O(p1y));
  LUT4 #(
    .INIT(16'h7FFF)) 
    p1y_OBUF_inst_i_1
       (.I0(p1c_IBUF),
        .I1(p1d_IBUF),
        .I2(p1a_IBUF),
        .I3(p1b_IBUF),
        .O(p1y_OBUF));
  IBUF p2a_IBUF_inst
       (.I(p2a),
        .O(p2a_IBUF));
  IBUF p2b_IBUF_inst
       (.I(p2b),
        .O(p2b_IBUF));
  IBUF p2c_IBUF_inst
       (.I(p2c),
        .O(p2c_IBUF));
  IBUF p2d_IBUF_inst
       (.I(p2d),
        .O(p2d_IBUF));
  OBUF p2y_OBUF_inst
       (.I(p2y_OBUF),
        .O(p2y));
  LUT4 #(
    .INIT(16'h7FFF)) 
    p2y_OBUF_inst_i_1
       (.I0(p2c_IBUF),
        .I1(p2d_IBUF),
        .I2(p2a_IBUF),
        .I3(p2b_IBUF),
        .O(p2y_OBUF));
endmodule
