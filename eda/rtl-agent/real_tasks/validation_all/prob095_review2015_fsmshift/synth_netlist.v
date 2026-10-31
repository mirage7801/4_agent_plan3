// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Oct  7 23:19:33 2026
// Host        : crf running 64-bit major release  (build 9200)
// Command     : write_verilog -force C:/Users/chenr/AppData/Local/Temp/rtl_agent_se4lfeao/synth_netlist.v
// Design      : TopModule
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* B0 = "0" *) (* B1 = "1" *) (* B2 = "2" *) 
(* B3 = "3" *) (* Done = "4" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module TopModule
   (clk,
    reset,
    shift_ena);
  input clk;
  input reset;
  output shift_ena;

  wire \<const0> ;
  wire \<const1> ;
  wire \FSM_onehot_next_reg[0]_i_1_n_0 ;
  wire \FSM_onehot_next_reg_n_0_[0] ;
  wire \FSM_onehot_next_reg_n_0_[1] ;
  wire \FSM_onehot_next_reg_n_0_[2] ;
  wire \FSM_onehot_next_reg_n_0_[3] ;
  wire \FSM_onehot_next_reg_n_0_[4] ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[1] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire \FSM_onehot_state_reg_n_0_[4] ;
  wire GND_2;
  wire VCC_2;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [0:0]next;
  wire p_0_in;
  wire reset;
  wire reset_IBUF;
  wire shift_ena;
  wire shift_ena_OBUF;

  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[0] 
       (.CLR(GND_2),
        .D(\FSM_onehot_next_reg[0]_i_1_n_0 ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[0] ));
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_onehot_next_reg[0]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\FSM_onehot_next_reg[0]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[1] 
       (.CLR(GND_2),
        .D(p_0_in),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[1] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[2] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[3] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[2] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_next_reg[3] 
       (.CLR(GND_2),
        .D(\FSM_onehot_state_reg_n_0_[4] ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[3] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b1)) 
    \FSM_onehot_next_reg[4] 
       (.CLR(GND_2),
        .D(\<const0> ),
        .G(next),
        .GE(VCC_2),
        .Q(\FSM_onehot_next_reg_n_0_[4] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \FSM_onehot_next_reg[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_state_reg_n_0_[4] ),
        .I4(p_0_in),
        .O(next));
  (* FSM_ENCODED_STATES = "B0:10000,B1:01000,B2:00100,B3:00010,Done:00001," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B0:10000,B1:01000,B2:00100,B3:00010,Done:00001," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[1] ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B0:10000,B1:01000,B2:00100,B3:00010,Done:00001," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[2] ),
        .Q(p_0_in),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B0:10000,B1:01000,B2:00100,B3:00010,Done:00001," *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[3] ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(reset_IBUF));
  (* FSM_ENCODED_STATES = "B0:10000,B1:01000,B2:00100,B3:00010,Done:00001," *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_next_reg_n_0_[4] ),
        .Q(\FSM_onehot_state_reg_n_0_[4] ),
        .S(reset_IBUF));
  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
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
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF shift_ena_OBUF_inst
       (.I(shift_ena_OBUF),
        .O(shift_ena));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    shift_ena_OBUF_inst_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_state_reg_n_0_[4] ),
        .I2(\FSM_onehot_state_reg_n_0_[3] ),
        .I3(p_0_in),
        .O(shift_ena_OBUF));
endmodule
