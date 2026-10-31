// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:39:59 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_5b2nmjha/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (y,
    w,
    Y2,
    Y4);
  input [5:0]y;
  input w;
  output Y2;
  output Y4;

  wire Y2;
  wire Y2_OBUF;
  wire Y4;
  wire Y4_OBUF;
  wire w;
  wire w_IBUF;
  wire [5:0]y;
  wire [5:0]y_IBUF;

  OBUF Y2_OBUF_inst
       (.I(Y2_OBUF),
        .O(Y2));
  LUT2 #(
    .INIT(4'h2)) 
    Y2_OBUF_inst_i_1
       (.I0(y_IBUF[0]),
        .I1(w_IBUF),
        .O(Y2_OBUF));
  OBUF Y4_OBUF_inst
       (.I(Y4_OBUF),
        .O(Y4));
  LUT5 #(
    .INIT(32'hFFFE0000)) 
    Y4_OBUF_inst_i_1
       (.I0(y_IBUF[4]),
        .I1(y_IBUF[2]),
        .I2(y_IBUF[1]),
        .I3(y_IBUF[5]),
        .I4(w_IBUF),
        .O(Y4_OBUF));
  IBUF w_IBUF_inst
       (.I(w),
        .O(w_IBUF));
  IBUF \y_IBUF[0]_inst 
       (.I(y[0]),
        .O(y_IBUF[0]));
  IBUF \y_IBUF[1]_inst 
       (.I(y[1]),
        .O(y_IBUF[1]));
  IBUF \y_IBUF[2]_inst 
       (.I(y[2]),
        .O(y_IBUF[2]));
  IBUF \y_IBUF[4]_inst 
       (.I(y[4]),
        .O(y_IBUF[4]));
  IBUF \y_IBUF[5]_inst 
       (.I(y[5]),
        .O(y_IBUF[5]));
endmodule
