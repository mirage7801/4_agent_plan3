// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 22:55:16 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_a5ort8vw/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A = "0" *) (* B = "1" *) (* C = "2" *) 
(* D = "3" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (in,
    state,
    next_state,
    out);
  input in;
  input [3:0]state;
  output [3:0]next_state;
  output out;

  wire in;
  wire in_IBUF;
  wire [3:0]next_state;
  wire [3:0]next_state_OBUF;
  wire out;
  wire out_OBUF;
  wire [3:0]state;
  wire [2:0]state_IBUF;

  IBUF in_IBUF_inst
       (.I(in),
        .O(in_IBUF));
  OBUF \next_state_OBUF[0]_inst 
       (.I(next_state_OBUF[0]),
        .O(next_state[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \next_state_OBUF[0]_inst_i_1 
       (.I0(state_IBUF[0]),
        .I1(state_IBUF[2]),
        .I2(in_IBUF),
        .O(next_state_OBUF[0]));
  OBUF \next_state_OBUF[1]_inst 
       (.I(next_state_OBUF[1]),
        .O(next_state[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFE00)) 
    \next_state_OBUF[1]_inst_i_1 
       (.I0(state_IBUF[0]),
        .I1(state_IBUF[1]),
        .I2(out_OBUF),
        .I3(in_IBUF),
        .O(next_state_OBUF[1]));
  OBUF \next_state_OBUF[2]_inst 
       (.I(next_state_OBUF[2]),
        .O(next_state[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \next_state_OBUF[2]_inst_i_1 
       (.I0(out_OBUF),
        .I1(state_IBUF[1]),
        .I2(in_IBUF),
        .O(next_state_OBUF[2]));
  OBUF \next_state_OBUF[3]_inst 
       (.I(next_state_OBUF[3]),
        .O(next_state[3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \next_state_OBUF[3]_inst_i_1 
       (.I0(state_IBUF[2]),
        .I1(in_IBUF),
        .O(next_state_OBUF[3]));
  OBUF out_OBUF_inst
       (.I(out_OBUF),
        .O(out));
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
        .O(out_OBUF));
endmodule
