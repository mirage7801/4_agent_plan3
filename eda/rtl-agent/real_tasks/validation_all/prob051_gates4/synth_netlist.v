// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:08:01 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_ho4os7ho/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (in,
    out_and,
    out_or,
    out_xor);
  input [3:0]in;
  output out_and;
  output out_or;
  output out_xor;

  wire [3:0]in;
  wire [3:0]in_IBUF;
  wire out_and;
  wire out_and_OBUF;
  wire out_or;
  wire out_or_OBUF;
  wire out_xor;
  wire out_xor_OBUF;

  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(in_IBUF[0]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(in_IBUF[1]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(in_IBUF[2]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(in_IBUF[3]));
  OBUF out_and_OBUF_inst
       (.I(out_and_OBUF),
        .O(out_and));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    out_and_OBUF_inst_i_1
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[0]),
        .I2(in_IBUF[3]),
        .I3(in_IBUF[2]),
        .O(out_and_OBUF));
  OBUF out_or_OBUF_inst
       (.I(out_or_OBUF),
        .O(out_or));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    out_or_OBUF_inst_i_1
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[0]),
        .I2(in_IBUF[3]),
        .I3(in_IBUF[2]),
        .O(out_or_OBUF));
  OBUF out_xor_OBUF_inst
       (.I(out_xor_OBUF),
        .O(out_xor));
  LUT4 #(
    .INIT(16'h6996)) 
    out_xor_OBUF_inst_i_1
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[0]),
        .I3(in_IBUF[1]),
        .O(out_xor_OBUF));
endmodule
