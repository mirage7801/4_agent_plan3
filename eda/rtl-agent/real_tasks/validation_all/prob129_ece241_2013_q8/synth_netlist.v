// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:55:14 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_scy6v8yi/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* S = "0" *) (* S1 = "1" *) (* S10 = "2" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    aresetn,
    x,
    z);
  input clk;
  input aresetn;
  input x;
  output z;

  wire \<const1> ;
  wire \FSM_sequential_state[1]_i_2_n_0 ;
  wire VCC_2;
  wire aresetn;
  wire aresetn_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [1:0]next;
  wire [1:0]state;
  wire x;
  wire x_IBUF;
  wire z;
  wire z_OBUF;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h70)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state[1]),
        .I1(state[0]),
        .I2(x_IBUF),
        .O(next[0]));
  LUT3 #(
    .INIT(8'h04)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(state[1]),
        .I1(state[0]),
        .I2(x_IBUF),
        .O(next[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(aresetn_IBUF),
        .O(\FSM_sequential_state[1]_i_2_n_0 ));
  (* FSM_ENCODED_STATES = "S10:10,S:00,S1:01" *) 
  FDCE \FSM_sequential_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\FSM_sequential_state[1]_i_2_n_0 ),
        .D(next[0]),
        .Q(state[0]));
  (* FSM_ENCODED_STATES = "S10:10,S:00,S1:01" *) 
  FDCE \FSM_sequential_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\FSM_sequential_state[1]_i_2_n_0 ),
        .D(next[1]),
        .Q(state[1]));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  IBUF aresetn_IBUF_inst
       (.I(aresetn),
        .O(aresetn_IBUF));
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
  IBUF x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
  OBUF z_OBUF_inst
       (.I(z_OBUF),
        .O(z));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h40)) 
    z_OBUF_inst_i_1
       (.I0(state[0]),
        .I1(x_IBUF),
        .I2(state[1]),
        .O(z_OBUF));
endmodule
