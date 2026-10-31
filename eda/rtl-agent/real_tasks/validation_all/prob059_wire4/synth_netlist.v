// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:22:04 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_iwdoq8g3/synth_netlist.v
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
    w,
    x,
    y,
    z);
  input a;
  input b;
  input c;
  output w;
  output x;
  output y;
  output z;

  wire a;
  wire b;
  wire c;
  wire w;
  wire w_OBUF;
  wire x;
  wire y;
  wire y_OBUF;
  wire z;
  wire z_OBUF;

  IBUF a_IBUF_inst
       (.I(a),
        .O(w_OBUF));
  IBUF b_IBUF_inst
       (.I(b),
        .O(y_OBUF));
  IBUF c_IBUF_inst
       (.I(c),
        .O(z_OBUF));
  OBUF w_OBUF_inst
       (.I(w_OBUF),
        .O(w));
  OBUF x_OBUF_inst
       (.I(y_OBUF),
        .O(x));
  OBUF y_OBUF_inst
       (.I(y_OBUF),
        .O(y));
  OBUF z_OBUF_inst
       (.I(z_OBUF),
        .O(z));
endmodule
