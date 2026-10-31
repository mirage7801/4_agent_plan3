// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:29:43 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_m36j9dc2/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (scancode,
    left,
    down,
    right,
    up);
  input [15:0]scancode;
  output left;
  output down;
  output right;
  output up;

  wire down;
  wire down_OBUF;
  wire down_OBUF_inst_i_2_n_0;
  wire left;
  wire left_OBUF;
  wire left_OBUF_inst_i_2_n_0;
  wire left_OBUF_inst_i_3_n_0;
  wire left_OBUF_inst_i_4_n_0;
  wire right;
  wire right_OBUF;
  wire right_OBUF_inst_i_2_n_0;
  wire [15:0]scancode;
  wire [15:0]scancode_IBUF;
  wire up;
  wire up_OBUF;
  wire up_OBUF_inst_i_2_n_0;

  OBUF down_OBUF_inst
       (.I(down_OBUF),
        .O(down));
  LUT6 #(
    .INIT(64'h0200000000000000)) 
    down_OBUF_inst_i_1
       (.I0(down_OBUF_inst_i_2_n_0),
        .I1(left_OBUF_inst_i_3_n_0),
        .I2(left_OBUF_inst_i_4_n_0),
        .I3(scancode_IBUF[13]),
        .I4(scancode_IBUF[14]),
        .I5(scancode_IBUF[15]),
        .O(down_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    down_OBUF_inst_i_2
       (.I0(scancode_IBUF[1]),
        .I1(scancode_IBUF[2]),
        .I2(scancode_IBUF[4]),
        .I3(scancode_IBUF[3]),
        .I4(scancode_IBUF[0]),
        .O(down_OBUF_inst_i_2_n_0));
  OBUF left_OBUF_inst
       (.I(left_OBUF),
        .O(left));
  LUT6 #(
    .INIT(64'h0200000000000000)) 
    left_OBUF_inst_i_1
       (.I0(left_OBUF_inst_i_2_n_0),
        .I1(left_OBUF_inst_i_3_n_0),
        .I2(left_OBUF_inst_i_4_n_0),
        .I3(scancode_IBUF[13]),
        .I4(scancode_IBUF[14]),
        .I5(scancode_IBUF[15]),
        .O(left_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    left_OBUF_inst_i_2
       (.I0(scancode_IBUF[2]),
        .I1(scancode_IBUF[1]),
        .I2(scancode_IBUF[0]),
        .I3(scancode_IBUF[4]),
        .I4(scancode_IBUF[3]),
        .O(left_OBUF_inst_i_2_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    left_OBUF_inst_i_3
       (.I0(scancode_IBUF[11]),
        .I1(scancode_IBUF[12]),
        .I2(scancode_IBUF[9]),
        .I3(scancode_IBUF[10]),
        .O(left_OBUF_inst_i_3_n_0));
  LUT4 #(
    .INIT(16'hEFFF)) 
    left_OBUF_inst_i_4
       (.I0(scancode_IBUF[7]),
        .I1(scancode_IBUF[8]),
        .I2(scancode_IBUF[5]),
        .I3(scancode_IBUF[6]),
        .O(left_OBUF_inst_i_4_n_0));
  OBUF right_OBUF_inst
       (.I(right_OBUF),
        .O(right));
  LUT6 #(
    .INIT(64'h0200000000000000)) 
    right_OBUF_inst_i_1
       (.I0(right_OBUF_inst_i_2_n_0),
        .I1(left_OBUF_inst_i_3_n_0),
        .I2(left_OBUF_inst_i_4_n_0),
        .I3(scancode_IBUF[13]),
        .I4(scancode_IBUF[14]),
        .I5(scancode_IBUF[15]),
        .O(right_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    right_OBUF_inst_i_2
       (.I0(scancode_IBUF[2]),
        .I1(scancode_IBUF[0]),
        .I2(scancode_IBUF[4]),
        .I3(scancode_IBUF[3]),
        .I4(scancode_IBUF[1]),
        .O(right_OBUF_inst_i_2_n_0));
  IBUF \scancode_IBUF[0]_inst 
       (.I(scancode[0]),
        .O(scancode_IBUF[0]));
  IBUF \scancode_IBUF[10]_inst 
       (.I(scancode[10]),
        .O(scancode_IBUF[10]));
  IBUF \scancode_IBUF[11]_inst 
       (.I(scancode[11]),
        .O(scancode_IBUF[11]));
  IBUF \scancode_IBUF[12]_inst 
       (.I(scancode[12]),
        .O(scancode_IBUF[12]));
  IBUF \scancode_IBUF[13]_inst 
       (.I(scancode[13]),
        .O(scancode_IBUF[13]));
  IBUF \scancode_IBUF[14]_inst 
       (.I(scancode[14]),
        .O(scancode_IBUF[14]));
  IBUF \scancode_IBUF[15]_inst 
       (.I(scancode[15]),
        .O(scancode_IBUF[15]));
  IBUF \scancode_IBUF[1]_inst 
       (.I(scancode[1]),
        .O(scancode_IBUF[1]));
  IBUF \scancode_IBUF[2]_inst 
       (.I(scancode[2]),
        .O(scancode_IBUF[2]));
  IBUF \scancode_IBUF[3]_inst 
       (.I(scancode[3]),
        .O(scancode_IBUF[3]));
  IBUF \scancode_IBUF[4]_inst 
       (.I(scancode[4]),
        .O(scancode_IBUF[4]));
  IBUF \scancode_IBUF[5]_inst 
       (.I(scancode[5]),
        .O(scancode_IBUF[5]));
  IBUF \scancode_IBUF[6]_inst 
       (.I(scancode[6]),
        .O(scancode_IBUF[6]));
  IBUF \scancode_IBUF[7]_inst 
       (.I(scancode[7]),
        .O(scancode_IBUF[7]));
  IBUF \scancode_IBUF[8]_inst 
       (.I(scancode[8]),
        .O(scancode_IBUF[8]));
  IBUF \scancode_IBUF[9]_inst 
       (.I(scancode[9]),
        .O(scancode_IBUF[9]));
  OBUF up_OBUF_inst
       (.I(up_OBUF),
        .O(up));
  LUT6 #(
    .INIT(64'h0200000000000000)) 
    up_OBUF_inst_i_1
       (.I0(up_OBUF_inst_i_2_n_0),
        .I1(left_OBUF_inst_i_3_n_0),
        .I2(left_OBUF_inst_i_4_n_0),
        .I3(scancode_IBUF[13]),
        .I4(scancode_IBUF[14]),
        .I5(scancode_IBUF[15]),
        .O(up_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00400000)) 
    up_OBUF_inst_i_2
       (.I0(scancode_IBUF[3]),
        .I1(scancode_IBUF[2]),
        .I2(scancode_IBUF[0]),
        .I3(scancode_IBUF[1]),
        .I4(scancode_IBUF[4]),
        .O(up_OBUF_inst_i_2_n_0));
endmodule
