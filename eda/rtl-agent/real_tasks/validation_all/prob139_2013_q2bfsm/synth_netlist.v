// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct  8 00:08:20 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_esls937r/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* A = "0" *) (* B = "1" *) (* G1 = "5" *) 
(* G2 = "6" *) (* P0 = "7" *) (* P1 = "8" *) 
(* S0 = "2" *) (* S1 = "3" *) (* S10 = "4" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    resetn,
    x,
    y,
    f,
    g);
  input clk;
  input resetn;
  input x;
  input y;
  output f;
  output g;

  wire \<const0> ;
  wire \<const1> ;
  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state[4]_i_1_n_0 ;
  wire \FSM_onehot_state[5]_i_1_n_0 ;
  wire \FSM_onehot_state[6]_i_1_n_0 ;
  wire \FSM_onehot_state[8]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire \FSM_onehot_state_reg_n_0_[4] ;
  wire \FSM_onehot_state_reg_n_0_[5] ;
  wire \FSM_onehot_state_reg_n_0_[6] ;
  wire \FSM_onehot_state_reg_n_0_[8] ;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire f;
  wire f_OBUF;
  wire g;
  wire g_OBUF;
  wire p_0_in;
  wire p_1_in;
  wire resetn;
  wire resetn_IBUF;
  wire x;
  wire x_IBUF;
  wire y;
  wire y_IBUF;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFAEA)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(p_1_in),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(y_IBUF),
        .I3(p_0_in),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(y_IBUF),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[4] ),
        .I1(x_IBUF),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_state[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[6] ),
        .I1(x_IBUF),
        .O(\FSM_onehot_state[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hAFAE)) 
    \FSM_onehot_state[5]_i_1 
       (.I0(f_OBUF),
        .I1(\FSM_onehot_state_reg_n_0_[4] ),
        .I2(x_IBUF),
        .I3(\FSM_onehot_state_reg_n_0_[5] ),
        .O(\FSM_onehot_state[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hC8)) 
    \FSM_onehot_state[6]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[5] ),
        .I1(x_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[6] ),
        .O(\FSM_onehot_state[6]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_onehot_state[8]_i_1 
       (.I0(resetn_IBUF),
        .O(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(p_1_in),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[2]_i_1_n_0 ),
        .Q(p_0_in),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[3]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[4]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[4] ),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[5]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[5] ),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state[6]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[6] ),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg_n_0_[8] ),
        .Q(f_OBUF),
        .R(\FSM_onehot_state[8]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "S1:001000000,S10:000010000,S0:000100000,B:010000000,A:100000000,P0:000000010,P1:000000001,G2:000000100,G1:000001000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(\FSM_onehot_state_reg_n_0_[8] ),
        .S(\FSM_onehot_state[8]_i_1_n_0 ));
  GND GND
       (.G(\<const0> ));
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
  OBUF f_OBUF_inst
       (.I(f_OBUF),
        .O(f));
  OBUF g_OBUF_inst
       (.I(g_OBUF),
        .O(g));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    g_OBUF_inst_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(p_0_in),
        .I2(p_1_in),
        .O(g_OBUF));
  IBUF resetn_IBUF_inst
       (.I(resetn),
        .O(resetn_IBUF));
  IBUF x_IBUF_inst
       (.I(x),
        .O(x_IBUF));
  IBUF y_IBUF_inst
       (.I(y),
        .O(y_IBUF));
endmodule
