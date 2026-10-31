// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Sun Oct 25 16:39:50 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_9_a6mdob/synth_netlist.v
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
   (clk,
    resetn,
    r,
    g);
  input clk;
  input resetn;
  input [2:0]r;
  output [2:0]g;

  wire \<const1> ;
  wire \FSM_sequential_state[1]_i_1_n_0 ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [2:0]g;
  wire [2:0]g_OBUF;
  wire [1:0]next;
  wire [2:0]r;
  wire [2:0]r_IBUF;
  wire resetn;
  wire resetn_IBUF;
  wire [1:0]state;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h8888FF04)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state[0]),
        .I1(r_IBUF[2]),
        .I2(r_IBUF[1]),
        .I3(r_IBUF[0]),
        .I4(state[1]),
        .O(next[0]));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(resetn_IBUF),
        .O(\FSM_sequential_state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hC480D590)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(state[0]),
        .I1(state[1]),
        .I2(r_IBUF[2]),
        .I3(r_IBUF[1]),
        .I4(r_IBUF[0]),
        .O(next[1]));
  (* FSM_ENCODED_STATES = "B:01,C:10,A:00,D:11" *) 
  FDRE \FSM_sequential_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(next[0]),
        .Q(state[0]),
        .R(\FSM_sequential_state[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "B:01,C:10,A:00,D:11" *) 
  FDRE \FSM_sequential_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(next[1]),
        .Q(state[1]),
        .R(\FSM_sequential_state[1]_i_1_n_0 ));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_2),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  OBUF \g_OBUF[0]_inst 
       (.I(g_OBUF[0]),
        .O(g[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \g_OBUF[0]_inst_i_1 
       (.I0(state[0]),
        .I1(state[1]),
        .O(g_OBUF[0]));
  OBUF \g_OBUF[1]_inst 
       (.I(g_OBUF[1]),
        .O(g[1]));
  LUT2 #(
    .INIT(4'h2)) 
    \g_OBUF[1]_inst_i_1 
       (.I0(state[1]),
        .I1(state[0]),
        .O(g_OBUF[1]));
  OBUF \g_OBUF[2]_inst 
       (.I(g_OBUF[2]),
        .O(g[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \g_OBUF[2]_inst_i_1 
       (.I0(state[0]),
        .I1(state[1]),
        .O(g_OBUF[2]));
  IBUF \r_IBUF[0]_inst 
       (.I(r[0]),
        .O(r_IBUF[0]));
  IBUF \r_IBUF[1]_inst 
       (.I(r[1]),
        .O(r_IBUF[1]));
  IBUF \r_IBUF[2]_inst 
       (.I(r[2]),
        .O(r_IBUF[2]));
  IBUF resetn_IBUF_inst
       (.I(resetn),
        .O(resetn_IBUF));
endmodule
