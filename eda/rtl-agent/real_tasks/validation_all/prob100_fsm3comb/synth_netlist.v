// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:23:41 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_u6qh86n4/synth_netlist.v
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
  input [1:0]state;
  output [1:0]next_state;
  output out;

  wire in;
  wire [1:0]next_state;
  wire [1:0]next_state_OBUF;
  wire out;
  wire out_OBUF;
  wire [1:0]state;
  wire [1:0]state_IBUF;

  IBUF in_IBUF_inst
       (.I(in),
        .O(next_state_OBUF[0]));
  OBUF \next_state_OBUF[0]_inst 
       (.I(next_state_OBUF[0]),
        .O(next_state[0]));
  OBUF \next_state_OBUF[1]_inst 
       (.I(next_state_OBUF[1]),
        .O(next_state[1]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h4A)) 
    \next_state_OBUF[1]_inst_i_1 
       (.I0(state_IBUF[0]),
        .I1(state_IBUF[1]),
        .I2(next_state_OBUF[0]),
        .O(next_state_OBUF[1]));
  OBUF out_OBUF_inst
       (.I(out_OBUF),
        .O(out));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    out_OBUF_inst_i_1
       (.I0(state_IBUF[0]),
        .I1(state_IBUF[1]),
        .O(out_OBUF));
  IBUF \state_IBUF[0]_inst 
       (.I(state[0]),
        .O(state_IBUF[0]));
  IBUF \state_IBUF[1]_inst 
       (.I(state[1]),
        .O(state_IBUF[1]));
endmodule
