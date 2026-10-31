// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:39:31 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_jmi_e3bv/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (x3,
    x2,
    x1,
    f);
  input x3;
  input x2;
  input x1;
  output f;

  wire f;
  wire f_OBUF;
  wire x1;
  wire x1_IBUF;
  wire x2;
  wire x2_IBUF;
  wire x3;
  wire x3_IBUF;

  OBUF f_OBUF_inst
       (.I(f_OBUF),
        .O(f));
  LUT3 #(
    .INIT(8'hE4)) 
    f_OBUF_inst_i_1
       (.I0(x3_IBUF),
        .I1(x2_IBUF),
        .I2(x1_IBUF),
        .O(f_OBUF));
  IBUF x1_IBUF_inst
       (.I(x1),
        .O(x1_IBUF));
  IBUF x2_IBUF_inst
       (.I(x2),
        .O(x2_IBUF));
  IBUF x3_IBUF_inst
       (.I(x3),
        .O(x3_IBUF));
endmodule
