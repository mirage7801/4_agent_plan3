// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:49:49 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_o29r9iih/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (sel,
    data0,
    data1,
    data2,
    data3,
    data4,
    data5,
    out);
  input [2:0]sel;
  input [3:0]data0;
  input [3:0]data1;
  input [3:0]data2;
  input [3:0]data3;
  input [3:0]data4;
  input [3:0]data5;
  output [3:0]out;

  wire [3:0]data0;
  wire [3:0]data0_IBUF;
  wire [3:0]data1;
  wire [3:0]data1_IBUF;
  wire [3:0]data2;
  wire [3:0]data2_IBUF;
  wire [3:0]data3;
  wire [3:0]data3_IBUF;
  wire [3:0]data4;
  wire [3:0]data4_IBUF;
  wire [3:0]data5;
  wire [3:0]data5_IBUF;
  wire [3:0]out;
  wire [3:0]out_OBUF;
  wire \out_OBUF[0]_inst_i_2_n_0 ;
  wire \out_OBUF[1]_inst_i_2_n_0 ;
  wire \out_OBUF[2]_inst_i_2_n_0 ;
  wire \out_OBUF[3]_inst_i_2_n_0 ;
  wire [2:0]sel;
  wire [2:0]sel_IBUF;

  IBUF \data0_IBUF[0]_inst 
       (.I(data0[0]),
        .O(data0_IBUF[0]));
  IBUF \data0_IBUF[1]_inst 
       (.I(data0[1]),
        .O(data0_IBUF[1]));
  IBUF \data0_IBUF[2]_inst 
       (.I(data0[2]),
        .O(data0_IBUF[2]));
  IBUF \data0_IBUF[3]_inst 
       (.I(data0[3]),
        .O(data0_IBUF[3]));
  IBUF \data1_IBUF[0]_inst 
       (.I(data1[0]),
        .O(data1_IBUF[0]));
  IBUF \data1_IBUF[1]_inst 
       (.I(data1[1]),
        .O(data1_IBUF[1]));
  IBUF \data1_IBUF[2]_inst 
       (.I(data1[2]),
        .O(data1_IBUF[2]));
  IBUF \data1_IBUF[3]_inst 
       (.I(data1[3]),
        .O(data1_IBUF[3]));
  IBUF \data2_IBUF[0]_inst 
       (.I(data2[0]),
        .O(data2_IBUF[0]));
  IBUF \data2_IBUF[1]_inst 
       (.I(data2[1]),
        .O(data2_IBUF[1]));
  IBUF \data2_IBUF[2]_inst 
       (.I(data2[2]),
        .O(data2_IBUF[2]));
  IBUF \data2_IBUF[3]_inst 
       (.I(data2[3]),
        .O(data2_IBUF[3]));
  IBUF \data3_IBUF[0]_inst 
       (.I(data3[0]),
        .O(data3_IBUF[0]));
  IBUF \data3_IBUF[1]_inst 
       (.I(data3[1]),
        .O(data3_IBUF[1]));
  IBUF \data3_IBUF[2]_inst 
       (.I(data3[2]),
        .O(data3_IBUF[2]));
  IBUF \data3_IBUF[3]_inst 
       (.I(data3[3]),
        .O(data3_IBUF[3]));
  IBUF \data4_IBUF[0]_inst 
       (.I(data4[0]),
        .O(data4_IBUF[0]));
  IBUF \data4_IBUF[1]_inst 
       (.I(data4[1]),
        .O(data4_IBUF[1]));
  IBUF \data4_IBUF[2]_inst 
       (.I(data4[2]),
        .O(data4_IBUF[2]));
  IBUF \data4_IBUF[3]_inst 
       (.I(data4[3]),
        .O(data4_IBUF[3]));
  IBUF \data5_IBUF[0]_inst 
       (.I(data5[0]),
        .O(data5_IBUF[0]));
  IBUF \data5_IBUF[1]_inst 
       (.I(data5[1]),
        .O(data5_IBUF[1]));
  IBUF \data5_IBUF[2]_inst 
       (.I(data5[2]),
        .O(data5_IBUF[2]));
  IBUF \data5_IBUF[3]_inst 
       (.I(data5[3]),
        .O(data5_IBUF[3]));
  OBUF \out_OBUF[0]_inst 
       (.I(out_OBUF[0]),
        .O(out[0]));
  LUT6 #(
    .INIT(64'h3A0A3A3A3A0A0A0A)) 
    \out_OBUF[0]_inst_i_1 
       (.I0(\out_OBUF[0]_inst_i_2_n_0 ),
        .I1(sel_IBUF[1]),
        .I2(sel_IBUF[2]),
        .I3(data5_IBUF[0]),
        .I4(sel_IBUF[0]),
        .I5(data4_IBUF[0]),
        .O(out_OBUF[0]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_OBUF[0]_inst_i_2 
       (.I0(data3_IBUF[0]),
        .I1(data2_IBUF[0]),
        .I2(sel_IBUF[1]),
        .I3(data1_IBUF[0]),
        .I4(sel_IBUF[0]),
        .I5(data0_IBUF[0]),
        .O(\out_OBUF[0]_inst_i_2_n_0 ));
  OBUF \out_OBUF[1]_inst 
       (.I(out_OBUF[1]),
        .O(out[1]));
  LUT6 #(
    .INIT(64'h3A0A3A3A3A0A0A0A)) 
    \out_OBUF[1]_inst_i_1 
       (.I0(\out_OBUF[1]_inst_i_2_n_0 ),
        .I1(sel_IBUF[1]),
        .I2(sel_IBUF[2]),
        .I3(data5_IBUF[1]),
        .I4(sel_IBUF[0]),
        .I5(data4_IBUF[1]),
        .O(out_OBUF[1]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_OBUF[1]_inst_i_2 
       (.I0(data3_IBUF[1]),
        .I1(data2_IBUF[1]),
        .I2(sel_IBUF[1]),
        .I3(data1_IBUF[1]),
        .I4(sel_IBUF[0]),
        .I5(data0_IBUF[1]),
        .O(\out_OBUF[1]_inst_i_2_n_0 ));
  OBUF \out_OBUF[2]_inst 
       (.I(out_OBUF[2]),
        .O(out[2]));
  LUT6 #(
    .INIT(64'h3A0A3A3A3A0A0A0A)) 
    \out_OBUF[2]_inst_i_1 
       (.I0(\out_OBUF[2]_inst_i_2_n_0 ),
        .I1(sel_IBUF[1]),
        .I2(sel_IBUF[2]),
        .I3(data5_IBUF[2]),
        .I4(sel_IBUF[0]),
        .I5(data4_IBUF[2]),
        .O(out_OBUF[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_OBUF[2]_inst_i_2 
       (.I0(data3_IBUF[2]),
        .I1(data2_IBUF[2]),
        .I2(sel_IBUF[1]),
        .I3(data1_IBUF[2]),
        .I4(sel_IBUF[0]),
        .I5(data0_IBUF[2]),
        .O(\out_OBUF[2]_inst_i_2_n_0 ));
  OBUF \out_OBUF[3]_inst 
       (.I(out_OBUF[3]),
        .O(out[3]));
  LUT6 #(
    .INIT(64'h3A0A3A3A3A0A0A0A)) 
    \out_OBUF[3]_inst_i_1 
       (.I0(\out_OBUF[3]_inst_i_2_n_0 ),
        .I1(sel_IBUF[1]),
        .I2(sel_IBUF[2]),
        .I3(data5_IBUF[3]),
        .I4(sel_IBUF[0]),
        .I5(data4_IBUF[3]),
        .O(out_OBUF[3]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \out_OBUF[3]_inst_i_2 
       (.I0(data3_IBUF[3]),
        .I1(data2_IBUF[3]),
        .I2(sel_IBUF[1]),
        .I3(data1_IBUF[3]),
        .I4(sel_IBUF[0]),
        .I5(data0_IBUF[3]),
        .O(\out_OBUF[3]_inst_i_2_n_0 ));
  IBUF \sel_IBUF[0]_inst 
       (.I(sel[0]),
        .O(sel_IBUF[0]));
  IBUF \sel_IBUF[1]_inst 
       (.I(sel[1]),
        .O(sel_IBUF[1]));
  IBUF \sel_IBUF[2]_inst 
       (.I(sel[2]),
        .O(sel_IBUF[2]));
endmodule
