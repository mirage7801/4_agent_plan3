// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:41:42 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_gd7vrg7y/synth_netlist.v
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
  input [7:0]in;
  output [2:0]pos;

  wire [7:0]in;
  wire [7:0]in_IBUF;
  wire [2:0]pos;
  wire [2:0]pos_OBUF;
  wire \pos_OBUF[0]_inst_i_2_n_0 ;
  wire \pos_OBUF[1]_inst_i_2_n_0 ;
  wire \pos_OBUF[2]_inst_i_2_n_0 ;

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
  IBUF \in_IBUF[4]_inst 
       (.I(in[4]),
        .O(in_IBUF[4]));
  IBUF \in_IBUF[5]_inst 
       (.I(in[5]),
        .O(in_IBUF[5]));
  IBUF \in_IBUF[6]_inst 
       (.I(in[6]),
        .O(in_IBUF[6]));
  IBUF \in_IBUF[7]_inst 
       (.I(in[7]),
        .O(in_IBUF[7]));
  OBUF \pos_OBUF[0]_inst 
       (.I(pos_OBUF[0]),
        .O(pos[0]));
  LUT6 #(
    .INIT(64'h1111111100001101)) 
    \pos_OBUF[0]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(\pos_OBUF[0]_inst_i_2_n_0 ),
        .I2(in_IBUF[4]),
        .I3(in_IBUF[3]),
        .I4(in_IBUF[2]),
        .I5(in_IBUF[1]),
        .O(pos_OBUF[0]));
  LUT6 #(
    .INIT(64'h1101110100001101)) 
    \pos_OBUF[0]_inst_i_2 
       (.I0(in_IBUF[1]),
        .I1(in_IBUF[5]),
        .I2(in_IBUF[7]),
        .I3(in_IBUF[6]),
        .I4(in_IBUF[3]),
        .I5(in_IBUF[2]),
        .O(\pos_OBUF[0]_inst_i_2_n_0 ));
  OBUF \pos_OBUF[1]_inst 
       (.I(pos_OBUF[1]),
        .O(pos[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \pos_OBUF[1]_inst_i_1 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[1]),
        .I2(\pos_OBUF[1]_inst_i_2_n_0 ),
        .O(pos_OBUF[1]));
  LUT6 #(
    .INIT(64'hEEEFEEEFEEEFEEEE)) 
    \pos_OBUF[1]_inst_i_2 
       (.I0(in_IBUF[2]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[5]),
        .I3(in_IBUF[4]),
        .I4(in_IBUF[6]),
        .I5(in_IBUF[7]),
        .O(\pos_OBUF[1]_inst_i_2_n_0 ));
  OBUF \pos_OBUF[2]_inst 
       (.I(pos_OBUF[2]),
        .O(pos[2]));
  LUT5 #(
    .INIT(32'hFFFE0000)) 
    \pos_OBUF[2]_inst_i_1 
       (.I0(in_IBUF[5]),
        .I1(in_IBUF[4]),
        .I2(in_IBUF[6]),
        .I3(in_IBUF[7]),
        .I4(\pos_OBUF[2]_inst_i_2_n_0 ),
        .O(pos_OBUF[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \pos_OBUF[2]_inst_i_2 
       (.I0(in_IBUF[0]),
        .I1(in_IBUF[3]),
        .I2(in_IBUF[1]),
        .I3(in_IBUF[2]),
        .O(\pos_OBUF[2]_inst_i_2_n_0 ));
endmodule
