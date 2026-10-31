// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 21:05:04 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_eid6qc8j/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (x,
    y,
    sum);
  input [3:0]x;
  input [3:0]y;
  output [4:0]sum;

  wire [4:0]sum;
  wire [4:0]sum_OBUF;
  wire \sum_OBUF[4]_inst_i_2_n_0 ;
  wire [3:0]x;
  wire [3:0]x_IBUF;
  wire [3:0]y;
  wire [3:0]y_IBUF;

  OBUF \sum_OBUF[0]_inst 
       (.I(sum_OBUF[0]),
        .O(sum[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \sum_OBUF[0]_inst_i_1 
       (.I0(x_IBUF[0]),
        .I1(y_IBUF[0]),
        .O(sum_OBUF[0]));
  OBUF \sum_OBUF[1]_inst 
       (.I(sum_OBUF[1]),
        .O(sum[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h8778)) 
    \sum_OBUF[1]_inst_i_1 
       (.I0(x_IBUF[0]),
        .I1(y_IBUF[0]),
        .I2(y_IBUF[1]),
        .I3(x_IBUF[1]),
        .O(sum_OBUF[1]));
  OBUF \sum_OBUF[2]_inst 
       (.I(sum_OBUF[2]),
        .O(sum[2]));
  LUT6 #(
    .INIT(64'hF880077F077FF880)) 
    \sum_OBUF[2]_inst_i_1 
       (.I0(y_IBUF[0]),
        .I1(x_IBUF[0]),
        .I2(x_IBUF[1]),
        .I3(y_IBUF[1]),
        .I4(y_IBUF[2]),
        .I5(x_IBUF[2]),
        .O(sum_OBUF[2]));
  OBUF \sum_OBUF[3]_inst 
       (.I(sum_OBUF[3]),
        .O(sum[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \sum_OBUF[3]_inst_i_1 
       (.I0(\sum_OBUF[4]_inst_i_2_n_0 ),
        .I1(y_IBUF[3]),
        .I2(x_IBUF[3]),
        .O(sum_OBUF[3]));
  OBUF \sum_OBUF[4]_inst 
       (.I(sum_OBUF[4]),
        .O(sum[4]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \sum_OBUF[4]_inst_i_1 
       (.I0(y_IBUF[3]),
        .I1(x_IBUF[3]),
        .I2(\sum_OBUF[4]_inst_i_2_n_0 ),
        .O(sum_OBUF[4]));
  LUT6 #(
    .INIT(64'hEEEEE888E8888888)) 
    \sum_OBUF[4]_inst_i_2 
       (.I0(y_IBUF[2]),
        .I1(x_IBUF[2]),
        .I2(y_IBUF[0]),
        .I3(x_IBUF[0]),
        .I4(x_IBUF[1]),
        .I5(y_IBUF[1]),
        .O(\sum_OBUF[4]_inst_i_2_n_0 ));
  IBUF \x_IBUF[0]_inst 
       (.I(x[0]),
        .O(x_IBUF[0]));
  IBUF \x_IBUF[1]_inst 
       (.I(x[1]),
        .O(x_IBUF[1]));
  IBUF \x_IBUF[2]_inst 
       (.I(x[2]),
        .O(x_IBUF[2]));
  IBUF \x_IBUF[3]_inst 
       (.I(x[3]),
        .O(x_IBUF[3]));
  IBUF \y_IBUF[0]_inst 
       (.I(y[0]),
        .O(y_IBUF[0]));
  IBUF \y_IBUF[1]_inst 
       (.I(y[1]),
        .O(y_IBUF[1]));
  IBUF \y_IBUF[2]_inst 
       (.I(y[2]),
        .O(y_IBUF[2]));
  IBUF \y_IBUF[3]_inst 
       (.I(y[3]),
        .O(y_IBUF[3]));
endmodule
