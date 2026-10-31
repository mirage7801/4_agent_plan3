// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:34:57 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_dyu8xil2/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (vec,
    outv,
    o2,
    o1,
    o0);
  input [2:0]vec;
  output [2:0]outv;
  output o2;
  output o1;
  output o0;

  wire o0;
  wire o0_OBUF;
  wire o1;
  wire o1_OBUF;
  wire o2;
  wire o2_OBUF;
  wire [2:0]outv;
  wire [2:0]vec;

  OBUF o0_OBUF_inst
       (.I(o0_OBUF),
        .O(o0));
  OBUF o1_OBUF_inst
       (.I(o1_OBUF),
        .O(o1));
  OBUF o2_OBUF_inst
       (.I(o2_OBUF),
        .O(o2));
  OBUF \outv_OBUF[0]_inst 
       (.I(o0_OBUF),
        .O(outv[0]));
  OBUF \outv_OBUF[1]_inst 
       (.I(o1_OBUF),
        .O(outv[1]));
  OBUF \outv_OBUF[2]_inst 
       (.I(o2_OBUF),
        .O(outv[2]));
  IBUF \vec_IBUF[0]_inst 
       (.I(vec[0]),
        .O(o0_OBUF));
  IBUF \vec_IBUF[1]_inst 
       (.I(vec[1]),
        .O(o1_OBUF));
  IBUF \vec_IBUF[2]_inst 
       (.I(vec[2]),
        .O(o2_OBUF));
endmodule
