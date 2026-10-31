// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:37:43 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_fd8jbww4/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (code,
    out,
    valid);
  input [7:0]code;
  output [3:0]out;
  output valid;

  wire [7:0]code;
  wire [7:0]code_IBUF;
  wire [3:0]out;
  wire [3:0]out_OBUF;
  wire \out_OBUF[0]_inst_i_2_n_0 ;
  wire \out_OBUF[1]_inst_i_2_n_0 ;
  wire \out_OBUF[2]_inst_i_2_n_0 ;
  wire \out_OBUF[3]_inst_i_2_n_0 ;
  wire valid;
  wire valid_OBUF;
  wire valid_OBUF_inst_i_2_n_0;

  IBUF \code_IBUF[0]_inst 
       (.I(code[0]),
        .O(code_IBUF[0]));
  IBUF \code_IBUF[1]_inst 
       (.I(code[1]),
        .O(code_IBUF[1]));
  IBUF \code_IBUF[2]_inst 
       (.I(code[2]),
        .O(code_IBUF[2]));
  IBUF \code_IBUF[3]_inst 
       (.I(code[3]),
        .O(code_IBUF[3]));
  IBUF \code_IBUF[4]_inst 
       (.I(code[4]),
        .O(code_IBUF[4]));
  IBUF \code_IBUF[5]_inst 
       (.I(code[5]),
        .O(code_IBUF[5]));
  IBUF \code_IBUF[6]_inst 
       (.I(code[6]),
        .O(code_IBUF[6]));
  IBUF \code_IBUF[7]_inst 
       (.I(code[7]),
        .O(code_IBUF[7]));
  OBUF \out_OBUF[0]_inst 
       (.I(out_OBUF[0]),
        .O(out[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \out_OBUF[0]_inst_i_1 
       (.I0(code_IBUF[2]),
        .I1(\out_OBUF[0]_inst_i_2_n_0 ),
        .I2(code_IBUF[7]),
        .O(out_OBUF[0]));
  LUT6 #(
    .INIT(64'h0001000005108000)) 
    \out_OBUF[0]_inst_i_2 
       (.I0(code_IBUF[0]),
        .I1(code_IBUF[3]),
        .I2(code_IBUF[4]),
        .I3(code_IBUF[5]),
        .I4(code_IBUF[1]),
        .I5(code_IBUF[6]),
        .O(\out_OBUF[0]_inst_i_2_n_0 ));
  OBUF \out_OBUF[1]_inst 
       (.I(out_OBUF[1]),
        .O(out[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \out_OBUF[1]_inst_i_1 
       (.I0(code_IBUF[2]),
        .I1(\out_OBUF[1]_inst_i_2_n_0 ),
        .I2(code_IBUF[7]),
        .O(out_OBUF[1]));
  LUT6 #(
    .INIT(64'h0005008000400000)) 
    \out_OBUF[1]_inst_i_2 
       (.I0(code_IBUF[0]),
        .I1(code_IBUF[4]),
        .I2(code_IBUF[3]),
        .I3(code_IBUF[6]),
        .I4(code_IBUF[1]),
        .I5(code_IBUF[5]),
        .O(\out_OBUF[1]_inst_i_2_n_0 ));
  OBUF \out_OBUF[2]_inst 
       (.I(out_OBUF[2]),
        .O(out[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \out_OBUF[2]_inst_i_1 
       (.I0(code_IBUF[2]),
        .I1(\out_OBUF[2]_inst_i_2_n_0 ),
        .I2(code_IBUF[7]),
        .O(out_OBUF[2]));
  LUT6 #(
    .INIT(64'h0000108000004020)) 
    \out_OBUF[2]_inst_i_2 
       (.I0(code_IBUF[0]),
        .I1(code_IBUF[3]),
        .I2(code_IBUF[5]),
        .I3(code_IBUF[1]),
        .I4(code_IBUF[6]),
        .I5(code_IBUF[4]),
        .O(\out_OBUF[2]_inst_i_2_n_0 ));
  OBUF \out_OBUF[3]_inst 
       (.I(out_OBUF[3]),
        .O(out[3]));
  LUT3 #(
    .INIT(8'h08)) 
    \out_OBUF[3]_inst_i_1 
       (.I0(code_IBUF[2]),
        .I1(\out_OBUF[3]_inst_i_2_n_0 ),
        .I2(code_IBUF[7]),
        .O(out_OBUF[3]));
  LUT6 #(
    .INIT(64'h0000000020000040)) 
    \out_OBUF[3]_inst_i_2 
       (.I0(code_IBUF[4]),
        .I1(code_IBUF[6]),
        .I2(code_IBUF[1]),
        .I3(code_IBUF[5]),
        .I4(code_IBUF[3]),
        .I5(code_IBUF[0]),
        .O(\out_OBUF[3]_inst_i_2_n_0 ));
  OBUF valid_OBUF_inst
       (.I(valid_OBUF),
        .O(valid));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h08)) 
    valid_OBUF_inst_i_1
       (.I0(code_IBUF[2]),
        .I1(valid_OBUF_inst_i_2_n_0),
        .I2(code_IBUF[7]),
        .O(valid_OBUF));
  LUT6 #(
    .INIT(64'h0001000255508200)) 
    valid_OBUF_inst_i_2
       (.I0(code_IBUF[0]),
        .I1(code_IBUF[3]),
        .I2(code_IBUF[4]),
        .I3(code_IBUF[5]),
        .I4(code_IBUF[1]),
        .I5(code_IBUF[6]),
        .O(valid_OBUF_inst_i_2_n_0));
endmodule
