// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:12:48 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_rosep65v/synth_netlist.v
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
    state,
    next_state,
    out1,
    out2);
  input in;
  input [9:0]state;
  output [9:0]next_state;
  output out1;
  output out2;

  wire in;
  wire in_IBUF;
  wire [9:0]next_state;
  wire [9:0]next_state_OBUF;
  wire \next_state_OBUF[0]_inst_i_2_n_0 ;
  wire out1;
  wire out1_OBUF;
  wire out2;
  wire out2_OBUF;
  wire [9:0]state;
  wire [9:0]state_IBUF;

  IBUF in_IBUF_inst
       (.I(in),
        .O(in_IBUF));
  OBUF \next_state_OBUF[0]_inst 
       (.I(next_state_OBUF[0]),
        .O(next_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h00FE)) 
    \next_state_OBUF[0]_inst_i_1 
       (.I0(\next_state_OBUF[0]_inst_i_2_n_0 ),
        .I1(state_IBUF[7]),
        .I2(state_IBUF[9]),
        .I3(in_IBUF),
        .O(next_state_OBUF[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \next_state_OBUF[0]_inst_i_2 
       (.I0(state_IBUF[2]),
        .I1(state_IBUF[1]),
        .I2(state_IBUF[4]),
        .I3(state_IBUF[3]),
        .I4(state_IBUF[0]),
        .I5(state_IBUF[8]),
        .O(\next_state_OBUF[0]_inst_i_2_n_0 ));
  OBUF \next_state_OBUF[1]_inst 
       (.I(next_state_OBUF[1]),
        .O(next_state[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hAAA8)) 
    \next_state_OBUF[1]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[0]),
        .I2(state_IBUF[8]),
        .I3(state_IBUF[9]),
        .O(next_state_OBUF[1]));
  OBUF \next_state_OBUF[2]_inst 
       (.I(next_state_OBUF[2]),
        .O(next_state[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[2]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[1]),
        .O(next_state_OBUF[2]));
  OBUF \next_state_OBUF[3]_inst 
       (.I(next_state_OBUF[3]),
        .O(next_state[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[3]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[2]),
        .O(next_state_OBUF[3]));
  OBUF \next_state_OBUF[4]_inst 
       (.I(next_state_OBUF[4]),
        .O(next_state[4]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[4]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[3]),
        .O(next_state_OBUF[4]));
  OBUF \next_state_OBUF[5]_inst 
       (.I(next_state_OBUF[5]),
        .O(next_state[5]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[5]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[4]),
        .O(next_state_OBUF[5]));
  OBUF \next_state_OBUF[6]_inst 
       (.I(next_state_OBUF[6]),
        .O(next_state[6]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[6]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[5]),
        .O(next_state_OBUF[6]));
  OBUF \next_state_OBUF[7]_inst 
       (.I(next_state_OBUF[7]),
        .O(next_state[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    \next_state_OBUF[7]_inst_i_1 
       (.I0(in_IBUF),
        .I1(state_IBUF[6]),
        .I2(state_IBUF[7]),
        .O(next_state_OBUF[7]));
  OBUF \next_state_OBUF[8]_inst 
       (.I(next_state_OBUF[8]),
        .O(next_state[8]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \next_state_OBUF[8]_inst_i_1 
       (.I0(state_IBUF[5]),
        .I1(in_IBUF),
        .O(next_state_OBUF[8]));
  OBUF \next_state_OBUF[9]_inst 
       (.I(next_state_OBUF[9]),
        .O(next_state[9]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \next_state_OBUF[9]_inst_i_1 
       (.I0(state_IBUF[6]),
        .I1(in_IBUF),
        .O(next_state_OBUF[9]));
  OBUF out1_OBUF_inst
       (.I(out1_OBUF),
        .O(out1));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    out1_OBUF_inst_i_1
       (.I0(state_IBUF[8]),
        .I1(state_IBUF[9]),
        .O(out1_OBUF));
  OBUF out2_OBUF_inst
       (.I(out2_OBUF),
        .O(out2));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'hE)) 
    out2_OBUF_inst_i_1
       (.I0(state_IBUF[7]),
        .I1(state_IBUF[9]),
        .O(out2_OBUF));
  IBUF \state_IBUF[0]_inst 
       (.I(state[0]),
        .O(state_IBUF[0]));
  IBUF \state_IBUF[1]_inst 
       (.I(state[1]),
        .O(state_IBUF[1]));
  IBUF \state_IBUF[2]_inst 
       (.I(state[2]),
        .O(state_IBUF[2]));
  IBUF \state_IBUF[3]_inst 
       (.I(state[3]),
        .O(state_IBUF[3]));
  IBUF \state_IBUF[4]_inst 
       (.I(state[4]),
        .O(state_IBUF[4]));
  IBUF \state_IBUF[5]_inst 
       (.I(state[5]),
        .O(state_IBUF[5]));
  IBUF \state_IBUF[6]_inst 
       (.I(state[6]),
        .O(state_IBUF[6]));
  IBUF \state_IBUF[7]_inst 
       (.I(state[7]),
        .O(state_IBUF[7]));
  IBUF \state_IBUF[8]_inst 
       (.I(state[8]),
        .O(state_IBUF[8]));
  IBUF \state_IBUF[9]_inst 
       (.I(state[9]),
        .O(state_IBUF[9]));
endmodule
