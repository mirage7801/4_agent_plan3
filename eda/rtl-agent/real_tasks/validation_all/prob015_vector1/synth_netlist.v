// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:02:26 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_6z75nsi9/synth_netlist.v
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
    out_hi,
    out_lo);
  input [15:0]in;
  output [7:0]out_hi;
  output [7:0]out_lo;

  wire [15:0]in;
  wire [7:0]out_hi;
  wire [7:0]out_hi_OBUF;
  wire [7:0]out_lo;
  wire [7:0]out_lo_OBUF;

  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(out_lo_OBUF[0]));
  IBUF \in_IBUF[10]_inst 
       (.I(in[10]),
        .O(out_hi_OBUF[2]));
  IBUF \in_IBUF[11]_inst 
       (.I(in[11]),
        .O(out_hi_OBUF[3]));
  IBUF \in_IBUF[12]_inst 
       (.I(in[12]),
        .O(out_hi_OBUF[4]));
  IBUF \in_IBUF[13]_inst 
       (.I(in[13]),
        .O(out_hi_OBUF[5]));
  IBUF \in_IBUF[14]_inst 
       (.I(in[14]),
        .O(out_hi_OBUF[6]));
  IBUF \in_IBUF[15]_inst 
       (.I(in[15]),
        .O(out_hi_OBUF[7]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(out_lo_OBUF[1]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(out_lo_OBUF[2]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(out_lo_OBUF[3]));
  IBUF \in_IBUF[4]_inst 
       (.I(in[4]),
        .O(out_lo_OBUF[4]));
  IBUF \in_IBUF[5]_inst 
       (.I(in[5]),
        .O(out_lo_OBUF[5]));
  IBUF \in_IBUF[6]_inst 
       (.I(in[6]),
        .O(out_lo_OBUF[6]));
  IBUF \in_IBUF[7]_inst 
       (.I(in[7]),
        .O(out_lo_OBUF[7]));
  IBUF \in_IBUF[8]_inst 
       (.I(in[8]),
        .O(out_hi_OBUF[0]));
  IBUF \in_IBUF[9]_inst 
       (.I(in[9]),
        .O(out_hi_OBUF[1]));
  OBUF \out_hi_OBUF[0]_inst 
       (.I(out_hi_OBUF[0]),
        .O(out_hi[0]));
  OBUF \out_hi_OBUF[1]_inst 
       (.I(out_hi_OBUF[1]),
        .O(out_hi[1]));
  OBUF \out_hi_OBUF[2]_inst 
       (.I(out_hi_OBUF[2]),
        .O(out_hi[2]));
  OBUF \out_hi_OBUF[3]_inst 
       (.I(out_hi_OBUF[3]),
        .O(out_hi[3]));
  OBUF \out_hi_OBUF[4]_inst 
       (.I(out_hi_OBUF[4]),
        .O(out_hi[4]));
  OBUF \out_hi_OBUF[5]_inst 
       (.I(out_hi_OBUF[5]),
        .O(out_hi[5]));
  OBUF \out_hi_OBUF[6]_inst 
       (.I(out_hi_OBUF[6]),
        .O(out_hi[6]));
  OBUF \out_hi_OBUF[7]_inst 
       (.I(out_hi_OBUF[7]),
        .O(out_hi[7]));
  OBUF \out_lo_OBUF[0]_inst 
       (.I(out_lo_OBUF[0]),
        .O(out_lo[0]));
  OBUF \out_lo_OBUF[1]_inst 
       (.I(out_lo_OBUF[1]),
        .O(out_lo[1]));
  OBUF \out_lo_OBUF[2]_inst 
       (.I(out_lo_OBUF[2]),
        .O(out_lo[2]));
  OBUF \out_lo_OBUF[3]_inst 
       (.I(out_lo_OBUF[3]),
        .O(out_lo[3]));
  OBUF \out_lo_OBUF[4]_inst 
       (.I(out_lo_OBUF[4]),
        .O(out_lo[4]));
  OBUF \out_lo_OBUF[5]_inst 
       (.I(out_lo_OBUF[5]),
        .O(out_lo[5]));
  OBUF \out_lo_OBUF[6]_inst 
       (.I(out_lo_OBUF[6]),
        .O(out_lo[6]));
  OBUF \out_lo_OBUF[7]_inst 
       (.I(out_lo_OBUF[7]),
        .O(out_lo[7]));
endmodule
