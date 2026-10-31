// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:35:48 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_yvhgpxe1/synth_netlist.v
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
    pos);
  input [3:0]in;
  output [1:0]pos;

  wire [3:0]in;
  wire [3:0]in_IBUF;
  wire [1:0]pos;
  wire [1:0]pos_OBUF;

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
  OBUF \pos_OBUF[0]_inst 
       (.I(pos_OBUF[0]),
        .O(pos[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h00F4)) 
    \pos_OBUF[0]_inst_i_1 
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[1]),
        .I3(in_IBUF[0]),
        .O(pos_OBUF[0]));
  OBUF \pos_OBUF[1]_inst 
       (.I(pos_OBUF[1]),
        .O(pos[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0054)) 
    \pos_OBUF[1]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[2]),
        .I3(in_IBUF[1]),
        .O(pos_OBUF[1]));
endmodule
