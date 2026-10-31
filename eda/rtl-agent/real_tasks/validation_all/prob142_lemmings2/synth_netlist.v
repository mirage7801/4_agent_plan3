// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:11:40 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_cp99nuci/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* FALLL = "2" *) (* FALLR = "3" *) (* WL = "0" *) 
(* WR = "1" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    areset,
    bump_left,
    bump_right,
    ground,
    walk_left,
    walk_right,
    aaah);
  input clk;
  input areset;
  input bump_left;
  input bump_right;
  input ground;
  output walk_left;
  output walk_right;
  output aaah;

  wire \<const1> ;
  wire VCC_2;
  wire aaah;
  wire aaah_OBUF;
  wire areset;
  wire areset_IBUF;
  wire bump_left;
  wire bump_left_IBUF;
  wire bump_right;
  wire bump_right_IBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire ground;
  wire ground_IBUF;
  wire [0:0]next;
  wire [0:0]state;
  wire \state[1]_i_1_n_0 ;
  wire walk_left;
  wire walk_left_OBUF;
  wire walk_right;
  wire walk_right_OBUF;

  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  OBUF aaah_OBUF_inst
       (.I(aaah_OBUF),
        .O(aaah));
  IBUF areset_IBUF_inst
       (.I(areset),
        .O(areset_IBUF));
  IBUF bump_left_IBUF_inst
       (.I(bump_left),
        .O(bump_left_IBUF));
  IBUF bump_right_IBUF_inst
       (.I(bump_right),
        .O(bump_right_IBUF));
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
  IBUF ground_IBUF_inst
       (.I(ground),
        .O(ground_IBUF));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hCCCC74CC)) 
    \state[0]_i_1 
       (.I0(bump_right_IBUF),
        .I1(state),
        .I2(bump_left_IBUF),
        .I3(ground_IBUF),
        .I4(aaah_OBUF),
        .O(next));
  LUT1 #(
    .INIT(2'h1)) 
    \state[1]_i_1 
       (.I0(ground_IBUF),
        .O(\state[1]_i_1_n_0 ));
  FDCE \state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(next),
        .Q(state));
  FDCE \state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\state[1]_i_1_n_0 ),
        .Q(aaah_OBUF));
  OBUF walk_left_OBUF_inst
       (.I(walk_left_OBUF),
        .O(walk_left));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h1)) 
    walk_left_OBUF_inst_i_1
       (.I0(aaah_OBUF),
        .I1(state),
        .O(walk_left_OBUF));
  OBUF walk_right_OBUF_inst
       (.I(walk_right_OBUF),
        .O(walk_right));
  LUT2 #(
    .INIT(4'h2)) 
    walk_right_OBUF_inst_i_1
       (.I0(state),
        .I1(aaah_OBUF),
        .O(walk_right_OBUF));
endmodule
