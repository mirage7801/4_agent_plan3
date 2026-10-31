// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 20:35:14 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_genfxxel/synth_netlist.v
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
    out);
  input [31:0]in;
  output [31:0]out;

  wire [31:0]in;
  wire [31:0]out;
  wire [31:0]out_OBUF;

  IBUF \in_IBUF[0]_inst 
       (.I(in[0]),
        .O(out_OBUF[24]));
  IBUF \in_IBUF[10]_inst 
       (.I(in[10]),
        .O(out_OBUF[18]));
  IBUF \in_IBUF[11]_inst 
       (.I(in[11]),
        .O(out_OBUF[19]));
  IBUF \in_IBUF[12]_inst 
       (.I(in[12]),
        .O(out_OBUF[20]));
  IBUF \in_IBUF[13]_inst 
       (.I(in[13]),
        .O(out_OBUF[21]));
  IBUF \in_IBUF[14]_inst 
       (.I(in[14]),
        .O(out_OBUF[22]));
  IBUF \in_IBUF[15]_inst 
       (.I(in[15]),
        .O(out_OBUF[23]));
  IBUF \in_IBUF[16]_inst 
       (.I(in[16]),
        .O(out_OBUF[8]));
  IBUF \in_IBUF[17]_inst 
       (.I(in[17]),
        .O(out_OBUF[9]));
  IBUF \in_IBUF[18]_inst 
       (.I(in[18]),
        .O(out_OBUF[10]));
  IBUF \in_IBUF[19]_inst 
       (.I(in[19]),
        .O(out_OBUF[11]));
  IBUF \in_IBUF[1]_inst 
       (.I(in[1]),
        .O(out_OBUF[25]));
  IBUF \in_IBUF[20]_inst 
       (.I(in[20]),
        .O(out_OBUF[12]));
  IBUF \in_IBUF[21]_inst 
       (.I(in[21]),
        .O(out_OBUF[13]));
  IBUF \in_IBUF[22]_inst 
       (.I(in[22]),
        .O(out_OBUF[14]));
  IBUF \in_IBUF[23]_inst 
       (.I(in[23]),
        .O(out_OBUF[15]));
  IBUF \in_IBUF[24]_inst 
       (.I(in[24]),
        .O(out_OBUF[0]));
  IBUF \in_IBUF[25]_inst 
       (.I(in[25]),
        .O(out_OBUF[1]));
  IBUF \in_IBUF[26]_inst 
       (.I(in[26]),
        .O(out_OBUF[2]));
  IBUF \in_IBUF[27]_inst 
       (.I(in[27]),
        .O(out_OBUF[3]));
  IBUF \in_IBUF[28]_inst 
       (.I(in[28]),
        .O(out_OBUF[4]));
  IBUF \in_IBUF[29]_inst 
       (.I(in[29]),
        .O(out_OBUF[5]));
  IBUF \in_IBUF[2]_inst 
       (.I(in[2]),
        .O(out_OBUF[26]));
  IBUF \in_IBUF[30]_inst 
       (.I(in[30]),
        .O(out_OBUF[6]));
  IBUF \in_IBUF[31]_inst 
       (.I(in[31]),
        .O(out_OBUF[7]));
  IBUF \in_IBUF[3]_inst 
       (.I(in[3]),
        .O(out_OBUF[27]));
  IBUF \in_IBUF[4]_inst 
       (.I(in[4]),
        .O(out_OBUF[28]));
  IBUF \in_IBUF[5]_inst 
       (.I(in[5]),
        .O(out_OBUF[29]));
  IBUF \in_IBUF[6]_inst 
       (.I(in[6]),
        .O(out_OBUF[30]));
  IBUF \in_IBUF[7]_inst 
       (.I(in[7]),
        .O(out_OBUF[31]));
  IBUF \in_IBUF[8]_inst 
       (.I(in[8]),
        .O(out_OBUF[16]));
  IBUF \in_IBUF[9]_inst 
       (.I(in[9]),
        .O(out_OBUF[17]));
  OBUF \out_OBUF[0]_inst 
       (.I(out_OBUF[0]),
        .O(out[0]));
  OBUF \out_OBUF[10]_inst 
       (.I(out_OBUF[10]),
        .O(out[10]));
  OBUF \out_OBUF[11]_inst 
       (.I(out_OBUF[11]),
        .O(out[11]));
  OBUF \out_OBUF[12]_inst 
       (.I(out_OBUF[12]),
        .O(out[12]));
  OBUF \out_OBUF[13]_inst 
       (.I(out_OBUF[13]),
        .O(out[13]));
  OBUF \out_OBUF[14]_inst 
       (.I(out_OBUF[14]),
        .O(out[14]));
  OBUF \out_OBUF[15]_inst 
       (.I(out_OBUF[15]),
        .O(out[15]));
  OBUF \out_OBUF[16]_inst 
       (.I(out_OBUF[16]),
        .O(out[16]));
  OBUF \out_OBUF[17]_inst 
       (.I(out_OBUF[17]),
        .O(out[17]));
  OBUF \out_OBUF[18]_inst 
       (.I(out_OBUF[18]),
        .O(out[18]));
  OBUF \out_OBUF[19]_inst 
       (.I(out_OBUF[19]),
        .O(out[19]));
  OBUF \out_OBUF[1]_inst 
       (.I(out_OBUF[1]),
        .O(out[1]));
  OBUF \out_OBUF[20]_inst 
       (.I(out_OBUF[20]),
        .O(out[20]));
  OBUF \out_OBUF[21]_inst 
       (.I(out_OBUF[21]),
        .O(out[21]));
  OBUF \out_OBUF[22]_inst 
       (.I(out_OBUF[22]),
        .O(out[22]));
  OBUF \out_OBUF[23]_inst 
       (.I(out_OBUF[23]),
        .O(out[23]));
  OBUF \out_OBUF[24]_inst 
       (.I(out_OBUF[24]),
        .O(out[24]));
  OBUF \out_OBUF[25]_inst 
       (.I(out_OBUF[25]),
        .O(out[25]));
  OBUF \out_OBUF[26]_inst 
       (.I(out_OBUF[26]),
        .O(out[26]));
  OBUF \out_OBUF[27]_inst 
       (.I(out_OBUF[27]),
        .O(out[27]));
  OBUF \out_OBUF[28]_inst 
       (.I(out_OBUF[28]),
        .O(out[28]));
  OBUF \out_OBUF[29]_inst 
       (.I(out_OBUF[29]),
        .O(out[29]));
  OBUF \out_OBUF[2]_inst 
       (.I(out_OBUF[2]),
        .O(out[2]));
  OBUF \out_OBUF[30]_inst 
       (.I(out_OBUF[30]),
        .O(out[30]));
  OBUF \out_OBUF[31]_inst 
       (.I(out_OBUF[31]),
        .O(out[31]));
  OBUF \out_OBUF[3]_inst 
       (.I(out_OBUF[3]),
        .O(out[3]));
  OBUF \out_OBUF[4]_inst 
       (.I(out_OBUF[4]),
        .O(out[4]));
  OBUF \out_OBUF[5]_inst 
       (.I(out_OBUF[5]),
        .O(out[5]));
  OBUF \out_OBUF[6]_inst 
       (.I(out_OBUF[6]),
        .O(out[6]));
  OBUF \out_OBUF[7]_inst 
       (.I(out_OBUF[7]),
        .O(out[7]));
  OBUF \out_OBUF[8]_inst 
       (.I(out_OBUF[8]),
        .O(out[8]));
  OBUF \out_OBUF[9]_inst 
       (.I(out_OBUF[9]),
        .O(out[9]));
endmodule
