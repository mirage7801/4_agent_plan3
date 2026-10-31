// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:13:01 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_mapkly2n/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A = "0" *) (* B = "1" *) (* C = "2" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    areset,
    x,
    z);
  input clk;
  input areset;
  input x;
  output z;

  wire \FSM_sequential_state[1]_i_1_n_0 ;
  wire VCC_1;
  wire areset;
  wire areset_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [1:0]state;
  wire [1:0]state__0;
  wire x;
  wire x_IBUF;
  wire z;
  wire z_OBUF;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h16)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state[0]),
        .I1(state[1]),
        .I2(x_IBUF),
        .O(state__0[0]));
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(state[0]),
        .I1(state[1]),
        .O(\FSM_sequential_state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h60)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(state[0]),
        .I1(state[1]),
        .I2(x_IBUF),
        .O(state__0[1]));
  (* FSM_ENCODED_STATES = "A:00,C:01,B:10" *) 
  FDCE \FSM_sequential_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_sequential_state[1]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(state__0[0]),
        .Q(state[0]));
  (* FSM_ENCODED_STATES = "A:00,C:01,B:10" *) 
  FDCE \FSM_sequential_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\FSM_sequential_state[1]_i_1_n_0 ),
        .CLR(areset_IBUF),
        .D(state__0[1]),
        .Q(state[1]));
  VCC VCC
       (.P(VCC_1));
  IBUF areset_IBUF_inst
       (.I(areset),
        .O(areset_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:CE" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC"),
    .SIM_DEVICE("ULTRASCALE_PLUS")) 
    clk_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
  OBUF z_OBUF_inst
       (.I(z_OBUF),
        .O(z));
  LUT2 #(
    .INIT(4'h2)) 
    z_OBUF_inst_i_1
       (.I0(state[0]),
        .I1(state[1]),
        .O(z_OBUF));
endmodule
