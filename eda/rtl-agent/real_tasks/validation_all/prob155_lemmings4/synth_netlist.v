// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:26:39 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_q131m6cs/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* DEAD = "6" *) (* DIGL = "4" *) (* DIGR = "5" *) 
(* FALLL = "2" *) (* FALLR = "3" *) (* WL = "0" *) 
(* WR = "1" *) 
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
  wire \FSM_onehot_next_reg[5]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[5]_i_2_n_0 ;
  wire \FSM_onehot_next_reg[6]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[6]_i_3_n_0 ;
  wire \FSM_onehot_next_reg_n_0_[0] ;
  wire \FSM_onehot_next_reg_n_0_[1] ;
  wire \FSM_onehot_next_reg_n_0_[2] ;
  wire \FSM_onehot_next_reg_n_0_[3] ;
  wire \FSM_onehot_next_reg_n_0_[4] ;
  wire \FSM_onehot_next_reg_n_0_[5] ;
  wire \FSM_onehot_next_reg_n_0_[6] ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire \FSM_onehot_state_reg_n_0_[4] ;
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
  wire clear;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire dig;
  wire dig_IBUF;
  wire digging;
  wire digging_OBUF;
  wire \fall_counter[4]_i_2_n_0 ;
  wire [4:2]fall_counter_reg;
  wire \fall_counter_reg_n_0_[0] ;
  wire \fall_counter_reg_n_0_[1] ;
  wire ground;
  wire ground_IBUF;
  wire [0:0]next;
  wire [4:0]p_0_in;
  wire p_1_in;
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
  LUT6 #(
    .INIT(64'hFFFFFFFFE0000000)) 
    \FSM_onehot_next_reg[0]_i_1 
       (.I0(fall_counter_reg[2]),
        .I1(fall_counter_reg[3]),
        .I2(fall_counter_reg[4]),
        .I3(ground_IBUF),
        .I4(aaah_OBUF),
        .I5(\FSM_onehot_state_reg_n_0_[0] ),
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
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hC888)) 
    \FSM_onehot_next_reg[1]_i_1 
       (.I0(p_1_in),
        .I1(ground_IBUF),
        .I2(dig_IBUF),
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
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h3332)) 
    \FSM_onehot_next_reg[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(ground_IBUF),
        .I2(p_1_in),
        .I3(walk_right_OBUF),
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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hC888)) 
    \FSM_onehot_next_reg[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(ground_IBUF),
        .I2(dig_IBUF),
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
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h3332)) 
    \FSM_onehot_next_reg[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[4] ),
        .I1(ground_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .I3(walk_left_OBUF),
        .O(\FSM_onehot_next_reg[4]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[5] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[5]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[5] ));
  LUT6 #(
    .INIT(64'hFFFFFFFF1F000000)) 
    \FSM_onehot_next_reg[5]_i_1 
       (.I0(fall_counter_reg[3]),
        .I1(fall_counter_reg[2]),
        .I2(fall_counter_reg[4]),
        .I3(ground_IBUF),
        .I4(\FSM_onehot_state_reg_n_0_[2] ),
        .I5(\FSM_onehot_next_reg[5]_i_2_n_0 ),
        .O(\FSM_onehot_next_reg[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00F0002000200020)) 
    \FSM_onehot_next_reg[5]_i_2 
       (.I0(walk_right_OBUF),
        .I1(bump_right_IBUF),
        .I2(ground_IBUF),
        .I3(dig_IBUF),
        .I4(bump_left_IBUF),
        .I5(walk_left_OBUF),
        .O(\FSM_onehot_next_reg[5]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b1)) 
    \FSM_onehot_next_reg[6] 
       (.CLR(GND_1),
        .D(\FSM_onehot_next_reg[6]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[6] ));
  LUT6 #(
    .INIT(64'hFFFFFFFF1F000000)) 
    \FSM_onehot_next_reg[6]_i_1 
       (.I0(fall_counter_reg[3]),
        .I1(fall_counter_reg[2]),
        .I2(fall_counter_reg[4]),
        .I3(ground_IBUF),
        .I4(\FSM_onehot_state_reg_n_0_[4] ),
        .I5(\FSM_onehot_next_reg[6]_i_3_n_0 ),
        .O(\FSM_onehot_next_reg[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_onehot_next_reg[6]_i_2 
       (.I0(aaah_OBUF),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .I3(walk_left_OBUF),
        .I4(p_1_in),
        .I5(walk_right_OBUF),
        .O(next));
  LUT6 #(
    .INIT(64'h0080008000F00080)) 
    \FSM_onehot_next_reg[6]_i_3 
       (.I0(bump_right_IBUF),
        .I1(walk_right_OBUF),
        .I2(ground_IBUF),
        .I3(dig_IBUF),
        .I4(walk_left_OBUF),
        .I5(bump_left_IBUF),
        .O(\FSM_onehot_next_reg[6]_i_3_n_0 ));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[1] ),
        .Q(p_1_in));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[2] ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[4] ),
        .Q(\FSM_onehot_state_reg_n_0_[4] ));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(areset_IBUF),
        .D(\FSM_onehot_next_reg_n_0_[5] ),
        .Q(walk_right_OBUF));
  (* FSM_ENCODED_STATES = "WL:1000000,WR:0100000,DEAD:0000001,FALLL:0010000,DIGL:0001000,FALLR:0000100,DIGR:0000010" *) 
  FDPE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[6] ),
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
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(\FSM_onehot_state_reg_n_0_[4] ),
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
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(p_1_in),
        .O(digging_OBUF));
  LUT1 #(
    .INIT(2'h1)) 
    \fall_counter[0]_i_1 
       (.I0(\fall_counter_reg_n_0_[0] ),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \fall_counter[1]_i_1 
       (.I0(\fall_counter_reg_n_0_[0] ),
        .I1(\fall_counter_reg_n_0_[1] ),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \fall_counter[2]_i_1 
       (.I0(\fall_counter_reg_n_0_[1] ),
        .I1(\fall_counter_reg_n_0_[0] ),
        .I2(fall_counter_reg[2]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \fall_counter[3]_i_1 
       (.I0(fall_counter_reg[2]),
        .I1(\fall_counter_reg_n_0_[0] ),
        .I2(\fall_counter_reg_n_0_[1] ),
        .I3(fall_counter_reg[3]),
        .O(p_0_in[3]));
  LUT2 #(
    .INIT(4'h1)) 
    \fall_counter[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[4] ),
        .I1(\FSM_onehot_state_reg_n_0_[2] ),
        .O(clear));
  LUT3 #(
    .INIT(8'h1F)) 
    \fall_counter[4]_i_2 
       (.I0(fall_counter_reg[3]),
        .I1(fall_counter_reg[2]),
        .I2(fall_counter_reg[4]),
        .O(\fall_counter[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \fall_counter[4]_i_3 
       (.I0(fall_counter_reg[3]),
        .I1(\fall_counter_reg_n_0_[1] ),
        .I2(\fall_counter_reg_n_0_[0] ),
        .I3(fall_counter_reg[2]),
        .I4(fall_counter_reg[4]),
        .O(p_0_in[4]));
  FDRE \fall_counter_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\fall_counter[4]_i_2_n_0 ),
        .D(p_0_in[0]),
        .Q(\fall_counter_reg_n_0_[0] ),
        .R(clear));
  FDRE \fall_counter_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\fall_counter[4]_i_2_n_0 ),
        .D(p_0_in[1]),
        .Q(\fall_counter_reg_n_0_[1] ),
        .R(clear));
  FDRE \fall_counter_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\fall_counter[4]_i_2_n_0 ),
        .D(p_0_in[2]),
        .Q(fall_counter_reg[2]),
        .R(clear));
  FDRE \fall_counter_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\fall_counter[4]_i_2_n_0 ),
        .D(p_0_in[3]),
        .Q(fall_counter_reg[3]),
        .R(clear));
  FDRE \fall_counter_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\fall_counter[4]_i_2_n_0 ),
        .D(p_0_in[4]),
        .Q(fall_counter_reg[4]),
        .R(clear));
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
