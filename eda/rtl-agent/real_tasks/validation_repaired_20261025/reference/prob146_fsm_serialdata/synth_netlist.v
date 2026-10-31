// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Sun Oct 25 16:38:54 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_ali172s9/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* B0 = "0" *) (* B1 = "1" *) (* B2 = "2" *) 
(* B3 = "3" *) (* B4 = "4" *) (* B5 = "5" *) 
(* B6 = "6" *) (* B7 = "7" *) (* DONE = "10" *) 
(* ERR = "11" *) (* START = "8" *) (* STOP = "9" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    in,
    reset,
    out_byte,
    done);
  input clk;
  input in;
  input reset;
  output [7:0]out_byte;
  output done;

  wire \<const0> ;
  wire \<const1> ;
  wire \FSM_onehot_next_reg[0]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[10]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[11]_i_1_n_0 ;
  wire \FSM_onehot_next_reg[11]_i_3_n_0 ;
  wire \FSM_onehot_next_reg[11]_i_4_n_0 ;
  wire \FSM_onehot_next_reg[1]_i_1_n_0 ;
  wire \FSM_onehot_next_reg_n_0_[0] ;
  wire \FSM_onehot_next_reg_n_0_[10] ;
  wire \FSM_onehot_next_reg_n_0_[11] ;
  wire \FSM_onehot_next_reg_n_0_[1] ;
  wire \FSM_onehot_next_reg_n_0_[2] ;
  wire \FSM_onehot_next_reg_n_0_[3] ;
  wire \FSM_onehot_next_reg_n_0_[4] ;
  wire \FSM_onehot_next_reg_n_0_[5] ;
  wire \FSM_onehot_next_reg_n_0_[6] ;
  wire \FSM_onehot_next_reg_n_0_[7] ;
  wire \FSM_onehot_next_reg_n_0_[8] ;
  wire \FSM_onehot_next_reg_n_0_[9] ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[11] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \FSM_onehot_state_reg_n_0_[2] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire \FSM_onehot_state_reg_n_0_[4] ;
  wire \FSM_onehot_state_reg_n_0_[5] ;
  wire \FSM_onehot_state_reg_n_0_[6] ;
  wire \FSM_onehot_state_reg_n_0_[7] ;
  wire \FSM_onehot_state_reg_n_0_[8] ;
  wire \FSM_onehot_state_reg_n_0_[9] ;
  wire GND_2;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire done;
  wire done_OBUF;
  wire in;
  wire in_IBUF;
  wire [0:0]next;
  wire [7:0]out_byte;
  wire [7:0]out_byte_OBUF;
  wire [8:8]p_0_in;
  wire reset;
  wire reset_IBUF;

  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b1)) 
    \FSM_onehot_next_reg[0] 
       (.CLR(GND_2),
        .D(\FSM_onehot_next_reg[0]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[0] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hCCC8)) 
    \FSM_onehot_next_reg[0]_i_1 
       (.I0(done_OBUF),
        .I1(in_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[11] ),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .O(\FSM_onehot_next_reg[0]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[10] 
       (.CLR(GND_2),
        .D(\FSM_onehot_next_reg[10]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[10] ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \FSM_onehot_next_reg[10]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[9] ),
        .I1(in_IBUF),
        .O(\FSM_onehot_next_reg[10]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[11] 
       (.CLR(GND_2),
        .D(\FSM_onehot_next_reg[11]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[11] ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h32)) 
    \FSM_onehot_next_reg[11]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[9] ),
        .I1(in_IBUF),
        .I2(\FSM_onehot_state_reg_n_0_[11] ),
        .O(\FSM_onehot_next_reg[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_onehot_next_reg[11]_i_2 
       (.I0(\FSM_onehot_state_reg_n_0_[9] ),
        .I1(\FSM_onehot_state_reg_n_0_[8] ),
        .I2(done_OBUF),
        .I3(\FSM_onehot_state_reg_n_0_[11] ),
        .I4(\FSM_onehot_next_reg[11]_i_3_n_0 ),
        .I5(\FSM_onehot_next_reg[11]_i_4_n_0 ),
        .O(next));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_next_reg[11]_i_3 
       (.I0(\FSM_onehot_state_reg_n_0_[2] ),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\FSM_onehot_next_reg[11]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_next_reg[11]_i_4 
       (.I0(\FSM_onehot_state_reg_n_0_[6] ),
        .I1(\FSM_onehot_state_reg_n_0_[7] ),
        .I2(\FSM_onehot_state_reg_n_0_[4] ),
        .I3(\FSM_onehot_state_reg_n_0_[5] ),
        .O(\FSM_onehot_next_reg[11]_i_4_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[1] 
       (.CLR(GND_2),
        .D(\FSM_onehot_next_reg[1]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[1] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \FSM_onehot_next_reg[1]_i_1 
       (.I0(done_OBUF),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(in_IBUF),
        .O(\FSM_onehot_next_reg[1]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[2] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[1] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[2] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[3] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[2] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[3] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[4] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[4] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[5] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[4] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[5] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[6] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[5] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[6] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[7] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[6] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[7] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[8] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[7] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[8] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[9] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[8] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[9] ));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[10] ),
        .Q(done_OBUF),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[11] ),
        .Q(\FSM_onehot_state_reg_n_0_[11] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[1] ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[2] ),
        .Q(\FSM_onehot_state_reg_n_0_[2] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[4] ),
        .Q(\FSM_onehot_state_reg_n_0_[4] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[5] ),
        .Q(\FSM_onehot_state_reg_n_0_[5] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[6] ),
        .Q(\FSM_onehot_state_reg_n_0_[6] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[7] ),
        .Q(\FSM_onehot_state_reg_n_0_[7] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[8] ),
        .Q(\FSM_onehot_state_reg_n_0_[8] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B3:000000010000,B4:000000100000,B2:000000001000,ERR:100000000000,DONE:010000000000,B1:000000000100,B0:000000000010,STOP:001000000000,B7:000100000000,B6:000010000000,START:000000000001,B5:000001000000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[9] ),
        .Q(\FSM_onehot_state_reg_n_0_[9] ),
        .R(reset_IBUF));
  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  VCC VCC_1
       (.P(VCC_2));
  FDRE \byte_r_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[1]),
        .Q(out_byte_OBUF[0]),
        .R(\<const0> ));
  FDRE \byte_r_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[2]),
        .Q(out_byte_OBUF[1]),
        .R(\<const0> ));
  FDRE \byte_r_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[3]),
        .Q(out_byte_OBUF[2]),
        .R(\<const0> ));
  FDRE \byte_r_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[4]),
        .Q(out_byte_OBUF[3]),
        .R(\<const0> ));
  FDRE \byte_r_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[5]),
        .Q(out_byte_OBUF[4]),
        .R(\<const0> ));
  FDRE \byte_r_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[6]),
        .Q(out_byte_OBUF[5]),
        .R(\<const0> ));
  FDRE \byte_r_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_byte_OBUF[7]),
        .Q(out_byte_OBUF[6]),
        .R(\<const0> ));
  FDRE \byte_r_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(p_0_in),
        .Q(out_byte_OBUF[7]),
        .R(\<const0> ));
  FDRE \byte_r_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(in_IBUF),
        .Q(p_0_in),
        .R(\<const0> ));
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
  OBUF done_OBUF_inst
       (.I(done_OBUF),
        .O(done));
  IBUF in_IBUF_inst
       (.I(in),
        .O(in_IBUF));
  OBUF \out_byte_OBUF[0]_inst 
       (.I(out_byte_OBUF[0]),
        .O(out_byte[0]));
  OBUF \out_byte_OBUF[1]_inst 
       (.I(out_byte_OBUF[1]),
        .O(out_byte[1]));
  OBUF \out_byte_OBUF[2]_inst 
       (.I(out_byte_OBUF[2]),
        .O(out_byte[2]));
  OBUF \out_byte_OBUF[3]_inst 
       (.I(out_byte_OBUF[3]),
        .O(out_byte[3]));
  OBUF \out_byte_OBUF[4]_inst 
       (.I(out_byte_OBUF[4]),
        .O(out_byte[4]));
  OBUF \out_byte_OBUF[5]_inst 
       (.I(out_byte_OBUF[5]),
        .O(out_byte[5]));
  OBUF \out_byte_OBUF[6]_inst 
       (.I(out_byte_OBUF[6]),
        .O(out_byte[6]));
  OBUF \out_byte_OBUF[7]_inst 
       (.I(out_byte_OBUF[7]),
        .O(out_byte[7]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
endmodule
