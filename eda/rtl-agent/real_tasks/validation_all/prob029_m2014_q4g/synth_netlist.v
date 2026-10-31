// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:30:25 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_hgva8tyf/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (in1,
    in2,
    in3,
    out);
  input in1;
  input in2;
  input in3;
  output out;

  wire in1;
  wire in1_IBUF;
  wire in2;
  wire in2_IBUF;
  wire in3;
  wire in3_IBUF;
  wire out;
  wire out_OBUF;

  IBUF in1_IBUF_inst
       (.I(in1),
        .O(in1_IBUF));
  IBUF in2_IBUF_inst
       (.I(in2),
        .O(in2_IBUF));
  IBUF in3_IBUF_inst
       (.I(in3),
        .O(in3_IBUF));
  OBUF out_OBUF_inst
       (.I(out_OBUF),
        .O(out));
  LUT3 #(
    .INIT(8'h69)) 
    out_OBUF_inst_i_1
       (.I0(in3_IBUF),
        .I1(in1_IBUF),
        .I2(in2_IBUF),
        .O(out_OBUF));
endmodule
