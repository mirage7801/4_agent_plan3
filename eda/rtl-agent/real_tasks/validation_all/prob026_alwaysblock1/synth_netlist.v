// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:24:35 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_e6l3rpwg/synth_netlist.v
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
    out_assign,
    out_alwaysblock);
  input a;
  input b;
  output out_assign;
  output out_alwaysblock;

  wire a;
  wire a_IBUF;
  wire b;
  wire b_IBUF;
  wire out_alwaysblock;
  wire out_alwaysblock_OBUF;
  wire out_assign;

  IBUF a_IBUF_inst
       (.I(a),
        .O(a_IBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(b_IBUF));
  OBUF out_alwaysblock_OBUF_inst
       (.I(out_alwaysblock_OBUF),
        .O(out_alwaysblock));
  OBUF out_assign_OBUF_inst
       (.I(out_alwaysblock_OBUF),
        .O(out_assign));
  LUT2 #(
    .INIT(4'h8)) 
    out_assign_OBUF_inst_i_1
       (.I0(a_IBUF),
        .I1(b_IBUF),
        .O(out_alwaysblock_OBUF));
endmodule
