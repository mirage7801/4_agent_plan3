// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:22:54 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_vvzm0z_k/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* DIGL = "4" *) (* DIGR = "5" *) (* FALLL = "2" *) 
(* FALLR = "3" *) (* WL = "0" *) (* WR = "1" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    areset,
    bump_left,
    bump_right,
    ground,
    dig,
    walk_left,
    walk_right,
    aaah,
    digging);
  input clk;
  input areset;
  input bump_left;
  input bump_right;
  input ground;
  input dig;
  output walk_left;
  output walk_right;
  output aaah;
  output digging;

  wire \<const1> ;
  wire \FSM_onehot_next_reg[0]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[1]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[2]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[3]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[4]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[4]_i_2_n_0 ;
  wire \FSM_onehot_next_reg[5]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[5]_i_3_n_0 ;
  wire \FSM_onehot_next_reg_n_0_[0] ;
  wire \FSM_onehot_next_reg_n_0_[1] ;
  wire \FSM_onehot_next_reg_n_0_[2] ;
  wire \FSM_onehot_next_reg_n_0_[3] ;
  wire \FSM_onehot_next_reg_n_0_[4] ;
  wire \FSM_onehot_next_reg_n_0_[5] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire GND_1;
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
  wire dig;
  wire dig_IBUF;
  wire digging;
  wire digging_OBUF;
  wire ground;
  wire ground_IBUF;
  wire [0:0]next;
  wire p_0_in;
  wire p_0_in2_in;
  wire walk_left;
  wire walk_left_OBUF;
  wire walk_right;
  wire walk_right_OBUF;

  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[0] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[0]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[0] ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hC888)) 
    \FSM_onehot_next_reg[0]_i_1 
       (.I0(p_0_in),
        .I1(ground_IBUF),
        .I2(dig_IBUF),
        .I3(walk_right_OBUF),
        .O(\FSM_onehot_next_reg[0]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[1] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[1]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[1] ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h0F0E)) 
    \FSM_onehot_next_reg[1]_i_1 
       (.I0(p_0_in2_in),
        .I1(p_0_in),
        .I2(ground_IBUF),
        .I3(walk_right_OBUF),
        .O(\FSM_onehot_next_reg[1]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[2] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[2]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[2] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hC888)) 
    \FSM_onehot_next_reg[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(ground_IBUF),
        .I2(dig_IBUF),
        .I3(walk_left_OBUF),
        .O(\FSM_onehot_next_reg[2]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[3] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[3]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[3] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0F0E)) 
    \FSM_onehot_next_reg[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\FSM_onehot_state_reg_n_0_[2] ),
        .I2(ground_IBUF),
        .I3(walk_left_OBUF),
        .O(\FSM_onehot_next_reg[3]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[4] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[4]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[4] ));
  LUT5 #(
    .INIT(32'hFFFF0200)) 
    \FSM_onehot_next_reg[4]_i_1 
       (.I0(ground_IBUF),
        .I1(bump_right_IBUF),
        .I2(dig_IBUF),
        .I3(walk_right_OBUF),
        .I4(\FSM_onehot_next_reg[4]_i_2_n_0 ),
        .O(\FSM_onehot_next_reg[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFF004000)) 
    \FSM_onehot_next_reg[4]_i_2 
       (.I0(dig_IBUF),
        .I1(bump_left_IBUF),
        .I2(walk_left_OBUF),
        .I3(ground_IBUF),
        .I4(p_0_in2_in),
        .O(\FSM_onehot_next_reg[4]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b1)) 
    \FSM_onehot_next_reg[5] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[5]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[5] ));
  LUT5 #(
    .INIT(32'hFFFF2000)) 
    \FSM_onehot_next_reg[5]_i_1 
       (.I0(ground_IBUF),
        .I1(dig_IBUF),
        .I2(bump_right_IBUF),
        .I3(walk_right_OBUF),
        .I4(\FSM_onehot_next_reg[5]_i_3_n_0 ),
        .O(\FSM_onehot_next_reg[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_onehot_next_reg[5]_i_2 
       (.I0(walk_left_OBUF),
        .I1(walk_right_OBUF),
        .I2(p_0_in2_in),
        .I3(p_0_in),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .I5(\FSM_onehot_state_reg_n_0_[2] ),
        .O(next));
  LUT5 #(
    .INIT(32'hFF001000)) 
    \FSM_onehot_next_reg[5]_i_3 
       (.I0(bump_left_IBUF),
        .I1(dig_IBUF),
        .I2(walk_left_OBUF),
        .I3(ground_IBUF),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\FSM_onehot_next_reg[5]_i_3_n_0 ));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[0] ),
        .Q(p_0_in));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[1] ),
        .Q(p_0_in2_in));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[2] ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[4] ),
        .Q(walk_right_OBUF));
  (* FSM_ENCODED_STATES = "WL:100000,WR:010000,FALLL:001000,DIGL:000100,FALLR:000010,DIGR:000001" *) 
  FDPE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[5] ),
        .PRE(areset_IBUF),
        .Q(walk_left_OBUF));
  GND GND
       (.G(GND_1));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  OBUF aaah_OBUF_inst
       (.I(aaah_OBUF),
        .O(aaah));
  LUT2 #(
    .INIT(4'hE)) 
    aaah_OBUF_inst_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(p_0_in2_in),
        .O(aaah_OBUF));
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
  IBUF dig_IBUF_inst
       (.I(dig),
        .O(dig_IBUF));
  OBUF digging_OBUF_inst
       (.I(digging_OBUF),
        .O(digging));
  LUT2 #(
    .INIT(4'hE)) 
    digging_OBUF_inst_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(p_0_in),
        .O(digging_OBUF));
  IBUF ground_IBUF_inst
       (.I(ground),
        .O(ground_IBUF));
  OBUF walk_left_OBUF_inst
       (.I(walk_left_OBUF),
        .O(walk_left));
  OBUF walk_right_OBUF_inst
       (.I(walk_right_OBUF),
        .O(walk_right));
endmodule
